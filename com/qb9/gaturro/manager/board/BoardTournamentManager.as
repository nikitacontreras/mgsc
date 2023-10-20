package com.qb9.gaturro.manager.board
{
   import com.adobe.serialization.json.JSON;
   import com.qb9.gaturro.commons.dispose.ICheckableDisposable;
   import com.qb9.gaturro.globals.*;
   import com.qb9.gaturro.world.core.elements.NpcRoomSceneObject;
   import com.qb9.mambo.core.attributes.events.CustomAttributesEvent;
   import flash.utils.Dictionary;
   
   public class BoardTournamentManager implements ICheckableDisposable
   {
      
      private static const RANKING_AMOUNT:int = 20;
      
      private static const SLOT_AMOUNT:int = 30;
      
      private static const WEEK_VAR:String = "week";
      
      private static const WINNER_PREFIX:String = "weinner_";
       
      
      private var rankBySlot:Dictionary;
      
      private var _disposed:Boolean;
      
      private var flaged:Boolean;
      
      private var _updateCallback:Function;
      
      private var rankByUser:Dictionary;
      
      private var target:NpcRoomSceneObject;
      
      private var temp:Date;
      
      private var rank:Array;
      
      private var _flagLastDaySession:Number;
      
      private var winner:Array;
      
      public function BoardTournamentManager()
      {
         super();
         this.rank = new Array();
         this.winner = new Array();
         this.rankBySlot = new Dictionary();
         this.rankByUser = new Dictionary();
         this.temp = new Date();
      }
      
      public function getRanking() : Array
      {
         this.rank.sort(this.srot);
         return this.rank.slice(0,20);
      }
      
      private function persistWinner() : void
      {
         var _loc2_:String = null;
         var _loc3_:TournamentData = null;
         var _loc1_:int = 0;
         for each(_loc3_ in this.winner)
         {
            _loc2_ = this.encode(_loc3_);
            this.target.attributes["winner_" + _loc1_] = _loc2_;
            _loc1_++;
         }
         this.winner = this.getWinnerList();
      }
      
      public function setTarget(param1:NpcRoomSceneObject) : void
      {
         this.target = param1;
         this.parse();
         this.target.addEventListener(CustomAttributesEvent.CHANGED,this.onBoardAttrChanged);
      }
      
      public function cleanRank() : void
      {
         var _loc4_:int = 0;
         var _loc3_:Number = Number(this.target.attributes[WEEK_VAR]);
         this.temp.time = server.time;
         if(_loc3_ != this.getCurrentDay())
         {
            this.persistWinner();
            api.trackEvent("BOCA:DEBUG:TORNEO","cleanRun");
            this.target.attributes[WEEK_VAR] = this.getCurrentDay();
            _loc4_ = 0;
            while(_loc4_ < SLOT_AMOUNT)
            {
               this.target.attributes[_loc4_] = "";
               _loc4_++;
            }
         }
      }
      
      private function getCurrentDay() : Number
      {
         this.temp.time = server.time;
         return this.temp.day;
      }
      
      public function flagWinnerNotification() : void
      {
         var _loc1_:TournamentData = null;
         var _loc2_:String = null;
         for each(_loc1_ in this.winner)
         {
            if(_loc1_.user == user.username)
            {
               _loc2_ = this.encode(_loc1_,true);
               this.target.attributes["winner_" + _loc1_.slot] = _loc2_;
               return;
            }
         }
      }
      
      public function forceClean() : void
      {
         var _loc3_:int = 0;
         while(_loc3_ < SLOT_AMOUNT)
         {
            this.target.attributes[_loc3_] = "";
            _loc3_++;
         }
      }
      
      public function dispose() : void
      {
         this.target.addEventListener(CustomAttributesEvent.CHANGED,this.onBoardAttrChanged);
         this.rankByUser = null;
         this.rankBySlot = null;
         this.winner = null;
         this.rank = null;
         this._updateCallback = null;
         this._disposed = true;
      }
      
      private function parse() : void
      {
         var _loc2_:TournamentData = null;
         var _loc3_:int = 0;
         while(_loc3_ < SLOT_AMOUNT)
         {
            _loc2_ = this.buildData(_loc3_);
            this.rankBySlot[_loc3_] = _loc2_;
            if(_loc2_.user)
            {
               this.rankByUser[_loc2_.user] = _loc2_;
            }
            this.rank.push(_loc2_);
            _loc3_++;
         }
      }
      
      public function processPoint(param1:int) : Array
      {
         var _loc4_:int = 0;
         this.rank.sort(this.srot);
         var _loc2_:TournamentData = this.rank[19];
         if(param1 > _loc2_.point)
         {
            _loc4_ = Math.random() * 10 + RANKING_AMOUNT;
            if(this.rankByUser[user.username])
            {
               _loc2_ = this.rankByUser[user.username];
            }
            else
            {
               _loc2_ = this.rank[_loc4_];
               this.rankByUser[user.username] = _loc2_;
            }
            _loc2_.user = user.username;
            _loc2_.point = param1;
            this.perisit(_loc2_);
         }
         return this.getRanking();
      }
      
      public function AmIWinner() : int
      {
         var _loc1_:TournamentData = null;
         if(!this.winner || this.winner.length == 0)
         {
            this.getWinnerList();
         }
         var _loc2_:int = 0;
         while(_loc2_ < 3)
         {
            _loc1_ = this.winner[_loc2_];
            if(_loc1_.user == user.username)
            {
               return !this.flaged ? _loc2_ + 1 : -1;
            }
            _loc2_++;
         }
         return -1;
      }
      
      private function encode(param1:TournamentData, param2:Boolean = false) : String
      {
         var _loc3_:Object = new Object();
         _loc3_.user = param1.user;
         _loc3_.point = param1.point;
         _loc3_.slot = param1.slot;
         if(param2)
         {
            _loc3_.flag = true;
         }
         return com.adobe.serialization.json.JSON.encode(_loc3_);
      }
      
      public function hasWinners() : Boolean
      {
         var _loc1_:Number = Number(this.target.attributes[WEEK_VAR]);
         if(isNaN(_loc1_))
         {
            this.target.attributes[WEEK_VAR] = this.getCurrentDay();
            return false;
         }
         if(_loc1_ != this.getCurrentDay())
         {
            this.setupWinner();
            return true;
         }
         return false;
      }
      
      private function setupWinner() : void
      {
         this.cleanRank();
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            this.winner.push(this.rank[_loc1_]);
            _loc1_++;
         }
      }
      
      public function get updateCallback() : Function
      {
         return this._updateCallback;
      }
      
      private function srot(param1:TournamentData, param2:TournamentData) : int
      {
         var _loc3_:int = param1.point;
         var _loc4_:int = param2.point;
         if(_loc3_ < _loc4_)
         {
            return 1;
         }
         if(_loc3_ > _loc4_)
         {
            return -1;
         }
         return 0;
      }
      
      private function perisit(param1:TournamentData) : void
      {
         var _loc2_:String = this.encode(param1);
         this.target.attributes[param1.slot] = _loc2_;
      }
      
      public function set updateCallback(param1:Function) : void
      {
         this._updateCallback = param1;
      }
      
      private function buildData(param1:int) : TournamentData
      {
         var _loc2_:Object = this.getRankAttr(param1);
         return !!_loc2_ ? new TournamentData(_loc2_.slot,_loc2_.user,_loc2_.point) : new TournamentData(param1);
      }
      
      private function getRankAttr(param1:int) : Object
      {
         var _loc2_:String = !!this.target.attributes[param1] ? String(this.target.attributes[param1]) : "";
         var _loc3_:Object = Boolean(_loc2_) && Boolean(_loc2_.length) ? com.adobe.serialization.json.JSON.decode(_loc2_) : null;
         if(!_loc2_)
         {
            this.target.attributes[param1] = com.adobe.serialization.json.JSON.encode({
               "slot":param1,
               "user":"",
               "point":0
            });
         }
         return _loc3_;
      }
      
      public function getWinnerList() : Array
      {
         var _loc1_:String = null;
         var _loc2_:Object = null;
         var _loc3_:TournamentData = null;
         var _loc4_:int = 0;
         if(!this.winner || this.winner.length == 0)
         {
            _loc4_ = 0;
            while(_loc4_ < 3)
            {
               _loc1_ = String(this.target.attributes["winner_" + _loc4_]);
               if(!_loc1_)
               {
                  _loc3_ = new TournamentData(_loc4_,"",0);
               }
               else
               {
                  _loc2_ = com.adobe.serialization.json.JSON.decode(_loc1_);
                  _loc3_ = new TournamentData(_loc4_,_loc2_.user,_loc2_.point);
                  if(_loc3_.user == user.username)
                  {
                     this.flaged = _loc2_.flag;
                  }
               }
               this.winner.push(_loc3_);
               _loc4_++;
            }
         }
         return this.winner.concat();
      }
      
      private function onBoardAttrChanged(param1:CustomAttributesEvent) : void
      {
         var _loc2_:Object = null;
         var _loc3_:TournamentData = null;
         var _loc5_:Array = null;
         var _loc4_:int = 0;
         while(_loc4_ < SLOT_AMOUNT)
         {
            _loc2_ = this.getRankAttr(_loc4_);
            if(_loc2_)
            {
               _loc3_ = this.rankBySlot[_loc2_.slot];
               _loc3_.user = _loc2_.user;
               _loc3_.point = _loc2_.point;
               if(!this.rankByUser[_loc3_.user])
               {
                  this.rankByUser[_loc3_.user] = _loc3_;
               }
            }
            _loc4_++;
         }
         if(this._updateCallback != null)
         {
            _loc5_ = this.getRanking();
            this._updateCallback(_loc5_);
         }
      }
      
      public function get disposed() : Boolean
      {
         return this._disposed;
      }
   }
}

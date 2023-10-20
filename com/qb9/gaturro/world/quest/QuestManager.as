package com.qb9.gaturro.world.quest
{
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.globals.user;
   import flash.events.EventDispatcher;
   
   public class QuestManager extends EventDispatcher
   {
       
      
      private var ranking:Array;
      
      private var lastRankRefreshTime:Number = 4.9e-324;
      
      private var skill:int;
      
      private var respectable:int;
      
      private var friendly:int;
      
      private var votedUsers:Array;
      
      private var creative:int;
      
      private var _rankLoaded:Boolean = false;
      
      private var lastVotesRefreshTime:Number = 4.9e-324;
      
      private var _votesLoaded:Boolean = false;
      
      private var elegant:int;
      
      public function QuestManager()
      {
         this.ranking = new Array();
         this.votedUsers = new Array();
         super();
      }
      
      public function get myVotes() : Object
      {
         if(!this._votesLoaded)
         {
            return null;
         }
         return {
            "creative":this.creative,
            "skill":this.skill,
            "friendly":this.friendly,
            "elegant":this.elegant,
            "respectable":this.respectable
         };
      }
      
      public function receiveVoteForStar(param1:String = "creative") : void
      {
         if(!settings.services.quest || !settings.services.quest.enabled)
         {
            return;
         }
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(param1 == "creative")
         {
            ++this.creative;
            _loc2_ = 1;
         }
         else if(param1 == "skill")
         {
            ++this.skill;
            _loc3_ = 1;
         }
         else if(param1 == "friendly")
         {
            ++this.friendly;
            _loc4_ = 1;
         }
         else if(param1 == "elegant")
         {
            ++this.elegant;
            _loc5_ = 1;
         }
         else if(param1 == "respectable")
         {
            ++this.respectable;
            _loc6_ = 1;
         }
         var _loc7_:QuestConnection;
         (_loc7_ = new QuestConnection()).saveStarData(user.username,user.id,_loc2_,_loc3_,_loc4_,_loc5_,_loc6_);
      }
      
      public function get rankLoaded() : Boolean
      {
         return this._rankLoaded;
      }
      
      public function getStarData() : void
      {
         if(!settings.services.quest || !settings.services.quest.enabled)
         {
            return;
         }
         var _loc1_:Number = new Date().getTime();
         if(_loc1_ - this.lastVotesRefreshTime < settings.services.quest.blockRefreshPeriod)
         {
            return;
         }
         this.lastVotesRefreshTime = _loc1_;
         var _loc2_:QuestConnection = new QuestConnection(this.readVotesData,this.serviceError);
         _loc2_.getStarData(user.username,user.id);
      }
      
      public function addStar() : void
      {
         if(!settings.services.quest || !settings.services.quest.enabled)
         {
            return;
         }
         this.creative += 1;
         this.skill += 1;
         this.friendly += 1;
         this.elegant += 1;
         this.respectable += 1;
         var _loc6_:QuestConnection;
         (_loc6_ = new QuestConnection()).saveStarData(user.username,user.id,1,1,1,1,1);
      }
      
      public function getStarRank() : void
      {
         if(!settings.services.quest || !settings.services.quest.enabled)
         {
            return;
         }
         var _loc1_:Number = new Date().getTime();
         if(_loc1_ - this.lastRankRefreshTime < settings.services.quest.blockRefreshPeriod)
         {
            return;
         }
         this.lastRankRefreshTime = _loc1_;
         var _loc2_:QuestConnection = new QuestConnection(this.readRankData,this.serviceError);
         _loc2_.getStarRank(user.username);
      }
      
      private function serviceError(param1:String, param2:Object) : void
      {
         trace("serviceError");
      }
      
      public function addUser(param1:String) : void
      {
         this.votedUsers.push(param1);
      }
      
      private function readVotesData(param1:String, param2:Object) : void
      {
         this._votesLoaded = true;
         this.creative = param2.creativo;
         this.skill = param2.habil;
         this.friendly = param2.amistoso;
         this.elegant = param2.elegante;
         this.respectable = param2.respetable;
      }
      
      public function get rankingList() : Array
      {
         return this.ranking;
      }
      
      public function isVoted(param1:String) : Boolean
      {
         var _loc2_:String = null;
         for each(_loc2_ in this.votedUsers)
         {
            if(_loc2_ == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      private function readRankData(param1:String, param2:Object) : void
      {
         this._rankLoaded = true;
         this.ranking = param2.data;
      }
      
      public function get votesLoaded() : Boolean
      {
         return this._votesLoaded;
      }
   }
}

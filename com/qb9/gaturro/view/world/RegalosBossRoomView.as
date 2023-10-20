package com.qb9.gaturro.view.world
{
   import com.qb9.flashlib.tasks.TaskRunner;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.view.world.avatars.GaturroUserAvatarView;
   import com.qb9.gaturro.view.world.elements.NpcRoomSceneObjectView;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.reports.InfoReportQueue;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import com.qb9.mambo.net.mail.Mailer;
   import com.qb9.mambo.view.world.elements.RoomSceneObjectView;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class RegalosBossRoomView extends GaturroRoomView
   {
       
      
      private var _hourglass2:int;
      
      private var avatars:Array;
      
      private var _myAvatar:GaturroUserAvatarView;
      
      private var _magoNPC:Object;
      
      private var _canRecieveDmg:Boolean;
      
      private var _hourglass:int;
      
      private var result:Object;
      
      private var _trollCave:Boolean;
      
      private var _hasBoss:Boolean;
      
      private const LUCK:Number = 0.4;
      
      private var _bossNPC:NpcRoomSceneObjectView;
      
      private var _team:String;
      
      public function RegalosBossRoomView(param1:GaturroRoom, param2:TaskRunner, param3:InfoReportQueue, param4:Mailer, param5:WhiteListNode)
      {
         this.avatars = [];
         super(param1,param3,param4,param5);
      }
      
      private function hasTeam() : void
      {
         this._team = api.getAvatarAttribute("teamNavidad2018") as String;
         if(this._team == "trolls")
         {
            api.setAvatarAttribute("medal","troll");
         }
         else if(this._team == "papas")
         {
            api.setAvatarAttribute("medal","papa");
         }
         else if(this._team == "" || this._team == "empty" || this._team == null || this._team == " ")
         {
            api.showBannerModal("ascensorTrollsvsPapa");
         }
      }
      
      override protected function createOtherSceneObject(param1:RoomSceneObject) : DisplayObject
      {
         var _loc3_:RoomSceneObjectView = null;
         var _loc4_:String = null;
         var _loc2_:DisplayObject = super.createOtherSceneObject(param1);
         if(_loc2_ is RoomSceneObjectView)
         {
            _loc3_ = _loc2_ as RoomSceneObjectView;
            if((_loc4_ = _loc3_.nameMC).indexOf("navidad2018/guerra.kramp_so") != -1)
            {
               this._bossNPC = _loc3_ as NpcRoomSceneObjectView;
               this._hasBoss = true;
               this._trollCave = true;
            }
            else if(_loc4_.indexOf("navidad2018/guerra.santa_so") != -1)
            {
               this._bossNPC = _loc3_ as NpcRoomSceneObjectView;
               this._hasBoss = true;
            }
            else
            {
               _loc2_.scaleX = _loc2_.scaleY = _loc2_.scaleY * 0.6;
            }
         }
         return _loc2_;
      }
      
      private function noSeSalvo() : void
      {
         if(api.userTrapped)
         {
            api.setAvatarAttribute("special_ph","false");
            setTimeout(function():void
            {
               api.setAvatarAttribute("interaction","revivir");
               api.userTrapped = false;
               api.roomView.blockGuiFor(0);
               api.roomView.unlockGui();
               clearTimeout(_hourglass);
            },300);
         }
      }
      
      override protected function finalInit() : void
      {
         super.finalInit();
         this._canRecieveDmg = true;
         this._hourglass2 = setTimeout(this.saveThrow2,30000);
         this.hasTeam();
      }
      
      private function saveThrow2() : void
      {
         var asd:MovieClip = null;
         clearTimeout(this._hourglass2);
         this.result = api.getAvatarAttribute("effect");
         this._hourglass2 = setTimeout(this.saveThrow2,10000);
         if(!this._hasBoss)
         {
            return;
         }
         if(this.result == "ghost")
         {
            return;
         }
         if(api.userTrapped)
         {
            return;
         }
         if(!this._canRecieveDmg)
         {
            return;
         }
         if(this._trollCave && this._team == "trolls")
         {
            return;
         }
         if(!this._trollCave && this._team == "papas")
         {
            return;
         }
         if(this.LUCK <= Math.random())
         {
            asd = this._bossNPC.getChildAt(0) as MovieClip;
            asd.gotoAndPlay("attack");
            api.playSound("gatoons/monstruoAtaca");
            api.roomView.blockGuiFor(99999999);
            api.userTrapped = true;
            api.setAvatarAttribute("interaction","salvar");
            setTimeout(function():void
            {
               api.setAvatarAttribute("special_ph","navidad2018/guerra.paralized_on");
            },300);
         }
      }
      
      override public function dispose() : void
      {
         clearTimeout(this._hourglass2);
         api.setAvatarAttribute("interaction","false");
         api.userTrapped = false;
         api.roomView.blockGuiFor(0);
         api.roomView.unlockGui();
         setTimeout(function():void
         {
            api.setAvatarAttribute("special_ph","false");
         },300);
         super.dispose();
      }
   }
}

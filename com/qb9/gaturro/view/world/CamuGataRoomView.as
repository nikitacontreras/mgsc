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
   import flash.events.Event;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class CamuGataRoomView extends GaturroRoomView
   {
       
      
      private var _hourglass2:int;
      
      private var avatars:Array;
      
      private var _myAvatar:GaturroUserAvatarView;
      
      private var _magoNPC:Object;
      
      private var _canRecieveDmg:Boolean;
      
      private var _hourglass:int;
      
      private var result:Object;
      
      private const LUCK:Number = 0.4;
      
      private var _bossNPC:NpcRoomSceneObjectView;
      
      public function CamuGataRoomView(param1:GaturroRoom, param2:TaskRunner, param3:InfoReportQueue, param4:Mailer, param5:WhiteListNode)
      {
         this.avatars = [];
         super(param1,param3,param4,param5);
      }
      
      private function update(param1:Event) : void
      {
      }
      
      private function onTeamPointsChecked(param1:Array) : void
      {
         var _loc4_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(param1[_loc3_].name == "camugata")
            {
               if((_loc4_ = int(param1[_loc3_].points)) <= 0)
               {
                  this._magoNPC.visible = true;
                  api.setProfileAttribute("camugata_show_outro_hw18",true);
               }
            }
            _loc3_++;
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
            if((_loc4_ = _loc3_.nameMC).indexOf("halloween2.bruja_so") != -1)
            {
               _loc2_.scaleX = _loc2_.scaleY = _loc2_.scaleY * 0.6;
               _loc2_.visible = false;
               this._magoNPC = _loc3_;
            }
            else if(_loc4_.indexOf("halloween2018/props4.portal_so") != -1)
            {
               this._bossNPC = _loc3_ as NpcRoomSceneObjectView;
            }
            else
            {
               _loc2_.scaleX = _loc2_.scaleY = _loc2_.scaleY * 0.6;
            }
         }
         return _loc2_;
      }
      
      override public function dispose() : void
      {
         clearTimeout(this._hourglass);
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
      
      private function firstTime() : void
      {
         var _loc1_:Object = api.getProfileAttribute("camugata_show_outro_hw18");
         if(_loc1_ == null)
         {
            api.setProfileAttribute("camugata_show_outro_hw18",false);
            api.setProfileAttribute("camugata_showed_outro_hw18",false);
         }
         var _loc2_:Object = api.getProfileAttribute("camugata_show_outro_hw18");
         if(_loc2_ == true)
         {
            this._canRecieveDmg = false;
         }
      }
      
      override protected function finalInit() : void
      {
         super.finalInit();
         this._canRecieveDmg = true;
         this._hourglass = setTimeout(this.saveThrow,30000);
         this._hourglass2 = setTimeout(this.saveThrow2,10000);
         this.firstTime();
         api.getTeamPoints("boss2018",this.onTeamPointsChecked);
      }
      
      private function saveThrow2() : void
      {
         var asd:MovieClip = null;
         clearTimeout(this._hourglass2);
         this.result = api.getAvatarAttribute("effect");
         this._hourglass2 = setTimeout(this.saveThrow2,10000);
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
         if(this.LUCK <= Math.random())
         {
            asd = this._bossNPC.getChildAt(0) as MovieClip;
            asd.gotoAndPlay("attack");
            api.playSound("gatoons/monstruoAtaca");
            api.roomView.blockGuiFor(99999999);
            api.userTrapped = true;
            api.setAvatarAttribute("special_ph","halloween2018/props4.rayoFulminador_on");
            setTimeout(function():void
            {
               if(api.userTrapped)
               {
                  api.setAvatarAttribute("effect","ghost");
               }
            },1200);
            setTimeout(function():void
            {
               noSeSalvo();
            },1300);
         }
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
      
      private function hotfix() : void
      {
      }
      
      private function saveThrow() : void
      {
         clearTimeout(this._hourglass);
         this.result = api.getAvatarAttribute("effect");
         this._hourglass = setTimeout(this.saveThrow,10000);
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
         if(this.LUCK <= Math.random())
         {
            api.roomView.blockGuiFor(99999999);
            api.userTrapped = true;
            api.setAvatarAttribute("action","standBy");
            setTimeout(function():void
            {
               api.setAvatarAttribute("special_ph","halloween2018/props2.captura01_on");
            },200);
            setTimeout(function():void
            {
               api.setAvatarAttribute("special_ph","halloween2018/props2.captura02_on");
            },1500);
            setTimeout(function():void
            {
               api.setAvatarAttribute("interaction","salvar");
            },1700);
            setTimeout(function():void
            {
               if(api.userTrapped)
               {
                  api.setAvatarAttribute("special_ph","halloween2018/props2.captura04_on");
               }
            },6000);
            setTimeout(function():void
            {
               if(api.userTrapped)
               {
                  api.setAvatarAttribute("interaction","false");
               }
            },6300);
            setTimeout(function():void
            {
               if(api.userTrapped)
               {
                  api.setAvatarAttribute("special_ph","false");
               }
            },6700);
            setTimeout(function():void
            {
               if(api.userTrapped)
               {
                  api.setAvatarAttribute("effect","ghost");
               }
            },6800);
            setTimeout(function():void
            {
               noSeSalvo();
            },7100);
         }
      }
   }
}

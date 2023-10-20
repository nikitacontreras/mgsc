package com.qb9.gaturro.view.world
{
   import com.qb9.flashlib.tasks.Func;
   import com.qb9.flashlib.tasks.Sequence;
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.net.mail.GaturroMailer;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.reports.InfoReportQueue;
   import com.qb9.mambo.geom.Coord;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.KeyboardEvent;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class SurfingRoomView extends SwimmingRoomView
   {
       
      
      private var tiburonFront:MovieClip;
      
      private var tiburonBack:MovieClip;
      
      private const LUCK:Number = 0.4;
      
      private var tiburonMask:MovieClip;
      
      private var _hourglass2:uint;
      
      private var result:Object;
      
      public function SurfingRoomView(param1:GaturroRoom, param2:TaskContainer, param3:InfoReportQueue, param4:GaturroMailer, param5:WhiteListNode)
      {
         super(param1,param2,param3,param4,param5,true);
      }
      
      override protected function finalInit() : void
      {
         super.finalInit();
         setTimeout(function():void
         {
            api.setAvatarAttribute("transport"," ");
         },300);
         this._hourglass2 = setTimeout(this.saveThrow2,10000);
         api.libraries.fetch("campamento/props.monstruon_mask",this.onTiburonMask);
      }
      
      private function onEnterKeyDown(param1:KeyboardEvent) : void
      {
         var _loc2_:Sequence = new Sequence();
         _loc2_.add(new Func(api.swimmingUserView.addChildAt,this.tiburonBack,0));
         _loc2_.add(new Func(api.swimmingUserView.addChild,this.tiburonFront));
         _loc2_.add(new Func(this.tiburonFront.gotoAndPlay,2));
         _loc2_.add(new Func(this.tiburonBack.gotoAndPlay,2));
         _loc2_.add(new Func(this.tiburonMask.gotoAndPlay,2));
         tasks.add(_loc2_);
      }
      
      private function saveThrow2() : void
      {
         var asd:Object;
         clearTimeout(this._hourglass2);
         this.result = api.getProfileAttribute("kraken2019");
         asd = api.getAvatarAttribute("hats");
         this._hourglass2 = setTimeout(this.saveThrow2,5000);
         if(this.result == "true" || this.result == true)
         {
            return;
         }
         if((asd as String).indexOf("gorroMonstruo_on") != -1)
         {
            return;
         }
         if(this.LUCK <= Math.random())
         {
            api.roomView.blockGuiFor(99999999);
            api.userTrapped = true;
            api.setAvatarAttribute("action","amazed");
            setTimeout(function():void
            {
               api.setAvatarAttribute("special_ph","campamento/props.monstruon_on");
            },300);
            setTimeout(function():void
            {
               api.swimmingUserView.clip.foot1.visible = false;
               api.swimmingUserView.clip.foot2.visible = false;
               api.swimmingUserView.clip.arm1.visible = false;
               api.swimmingUserView.clip.arm2.visible = false;
               api.swimmingUserView.clip.belly.visible = false;
               api.swimmingUserView.clip.head.visible = false;
            },3200);
            setTimeout(function():void
            {
               api.roomView.unlockGui();
               api.changeRoom(51688107,new Coord(12,10));
               api.setAvatarAttribute("special_ph"," ");
            },4500);
         }
      }
      
      override public function dispose() : void
      {
         clearTimeout(this._hourglass2);
         super.dispose();
      }
      
      private function onTiburonMask(param1:DisplayObject) : void
      {
         this.tiburonMask = param1 as MovieClip;
      }
      
      private function gotoEstomago() : void
      {
      }
      
      private function onTiburonBack(param1:DisplayObject) : void
      {
         this.tiburonBack = param1 as MovieClip;
         this.tiburonBack.gotoAndStop(2);
      }
      
      private function hideAvatar(param1:String) : void
      {
      }
      
      private function onTiburonFront(param1:DisplayObject) : void
      {
         this.tiburonFront = param1 as MovieClip;
         this.tiburonFront.gotoAndStop(2);
      }
   }
}

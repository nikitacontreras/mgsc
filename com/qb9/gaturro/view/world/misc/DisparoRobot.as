package com.qb9.gaturro.view.world.misc
{
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.view.world.GaturroBossRoomView;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class DisparoRobot
   {
       
      
      private var pattern:Array;
      
      private var hideTimeoutID:int;
      
      private var pattern_mc:MovieClip;
      
      private var currentTimeout:int;
      
      private var api:GaturroRoomAPI;
      
      private var pattern_id:int;
      
      private var bossRoomView:GaturroBossRoomView;
      
      private var targetX:int;
      
      private var asset:MovieClip;
      
      private var resetTimeoutID:int;
      
      public function DisparoRobot(param1:MovieClip, param2:GaturroRoomAPI, param3:GaturroBossRoomView)
      {
         super();
         this.bossRoomView = param3;
         this.api = param2;
         this.asset = param1;
         this.targetX = param1.targetX;
         if(param1.sacar)
         {
            param1.removeChild(param1.sacar);
         }
         this.reset();
      }
      
      private function onTimeout() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.pattern_mc.numChildren)
         {
            (this.pattern_mc.getChildAt(_loc1_) as MovieClip).gotoAndPlay("fuego");
            _loc1_++;
         }
         if(!this.pattern_mc.hasEventListener(Event.ENTER_FRAME))
         {
            this.pattern_mc.addEventListener(Event.ENTER_FRAME,this.checkGaturroHit);
         }
         this.hideTimeoutID = setTimeout(this.hide,1500);
         this.resetTimeoutID = setTimeout(this.reset,3000);
      }
      
      private function hide() : void
      {
         if(this.pattern_mc)
         {
            this.pattern_mc.visible = false;
         }
         if(Boolean(this.pattern_mc) && this.pattern_mc.hasEventListener(Event.ENTER_FRAME))
         {
            this.pattern_mc.removeEventListener(Event.ENTER_FRAME,this.checkGaturroHit);
         }
      }
      
      private function reset() : void
      {
         this.pattern_id = 1 + int(Math.random() * 2);
         if(this.api)
         {
            this.api.libraries.fetch("bossFinal.fuego_patron" + this.pattern_id.toString(),this.onFetch);
         }
         this.currentTimeout = 0;
      }
      
      private function onExitFrame(param1:Event) : void
      {
         this.pattern = this.pattern_mc.pattern;
         var _loc2_:int = 0;
         while(_loc2_ < this.pattern_mc.numChildren)
         {
            (this.pattern_mc.getChildAt(_loc2_) as MovieClip).gotoAndPlay("avisa");
            _loc2_++;
         }
         this.currentTimeout = setTimeout(this.onTimeout,3000);
         this.pattern_mc.removeEventListener("exitFrame",this.onExitFrame);
      }
      
      public function removeFromRoom() : void
      {
         clearTimeout(this.hideTimeoutID);
         clearTimeout(this.resetTimeoutID);
         this.hide();
      }
      
      private function onFetch(param1:DisplayObject) : void
      {
         this.pattern_mc = param1 as MovieClip;
         var _loc2_:int = 0;
         while(_loc2_ < this.asset.numChildren)
         {
            this.asset.removeChildAt(0);
            _loc2_++;
         }
         this.asset.addChild(this.pattern_mc);
         this.pattern_mc.addEventListener("exitFrame",this.onExitFrame);
      }
      
      public function dispose() : void
      {
         if(this.currentTimeout != 0)
         {
            clearTimeout(this.currentTimeout);
         }
         clearTimeout(this.hideTimeoutID);
         clearTimeout(this.resetTimeoutID);
         this.api = null;
         this.bossRoomView = null;
         this.asset = null;
         this.pattern = null;
         this.pattern_mc = null;
      }
      
      private function checkGaturroHit(param1:Event) : void
      {
         if(!this.pattern_mc)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.pattern.length)
         {
            if(this.api.userAvatar.coord.x == this.pattern[_loc2_][0] + this.targetX && this.api.userAvatar.coord.y == this.pattern[_loc2_][1])
            {
               this.bossRoomView.gaturroHit();
               if(Boolean(this.pattern_mc) && this.pattern_mc.hasEventListener(Event.ENTER_FRAME))
               {
                  this.pattern_mc.removeEventListener(Event.ENTER_FRAME,this.checkGaturroHit);
               }
            }
            _loc2_++;
         }
      }
   }
}

package com.qb9.gaturro.view.world.misc
{
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.view.world.GaturroBossRoomView;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class CollectablesRobot
   {
       
      
      private var currentCollectable:CollectableHolder;
      
      private var collectableAsset:MovieClip;
      
      public var count:int = 0;
      
      private var toggleVisibleTimeoutID:int;
      
      private var api:GaturroRoomAPI;
      
      private var collectableHolders:Array;
      
      private var targetX:int;
      
      private var targetY:int;
      
      private var bossRoomView:GaturroBossRoomView;
      
      private var currentTimeout:int;
      
      public function CollectablesRobot(param1:GaturroRoomAPI, param2:GaturroBossRoomView)
      {
         super();
         this.bossRoomView = param2;
         this.api = param1;
      }
      
      public function removeFromRoom() : void
      {
         if(this.collectableAsset.visible)
         {
            this.toggleVisible();
         }
      }
      
      private function onFetch(param1:DisplayObject) : void
      {
         this.collectableAsset = param1 as MovieClip;
         var _loc2_:int = 0;
         while(_loc2_ < this.currentCollectable.mc.numChildren)
         {
            this.currentCollectable.mc.removeChildAt(0);
            _loc2_++;
         }
         this.currentCollectable.mc.addChild(param1);
         this.count = this.api.getProfileAttribute(this.bossRoomView.bossFinal1_KEY + "/step") as int;
         if(this.count >= 3)
         {
            this.toggleVisible();
         }
      }
      
      public function whenAllReady() : void
      {
         if(Boolean(this.currentCollectable) && this.currentCollectable.mc.hasEventListener(Event.ENTER_FRAME))
         {
            this.currentCollectable.mc.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
         this.currentCollectable = this.collectableHolders[int(Math.random() * this.collectableHolders.length)];
         if(Boolean(this.api) && !this.collectableAsset)
         {
            this.api.libraries.fetch("bossFinal.collectable",this.onFetch);
         }
         else
         {
            this.currentCollectable.mc.addChild(this.collectableAsset);
         }
         this.currentCollectable.mc.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      public function dispose() : void
      {
         this.api = null;
         this.bossRoomView = null;
         if(Boolean(this.currentCollectable) && this.currentCollectable.mc.hasEventListener(Event.ENTER_FRAME))
         {
            this.currentCollectable.mc.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
         this.collectableHolders = null;
         this.currentCollectable = null;
         this.collectableAsset = null;
      }
      
      public function addCollectableHolder(param1:MovieClip) : void
      {
         if(this.collectableHolders)
         {
            this.collectableHolders.push(new CollectableHolder(param1));
         }
         else
         {
            this.collectableHolders = [new CollectableHolder(param1)];
         }
         if(param1.sacar)
         {
            param1.removeChild(param1.sacar);
         }
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         if(Boolean(this.collectableAsset) && !this.collectableAsset.visible)
         {
            return;
         }
         if(this.currentCollectable.targetX == this.api.userAvatar.coord.x && this.currentCollectable.targetY == this.api.userAvatar.coord.y)
         {
            this.whenAllReady();
            this.toggleVisible();
            ++this.count;
            this.api.setProfileAttribute(this.bossRoomView.bossFinal1_KEY + "/step",this.count);
            if(this.count < 3)
            {
               this.toggleVisibleTimeoutID = setTimeout(this.toggleVisible,1500);
               this.bossRoomView.triggerGuiShieldHit();
            }
            else
            {
               this.bossRoomView.toggleGuiShieldVisible();
               this.api.textMessageToGUI("¡AHORA, GOLPEALO!");
            }
         }
      }
      
      public function toggleVisible() : void
      {
         if(this.toggleVisibleTimeoutID)
         {
            clearTimeout(this.toggleVisibleTimeoutID);
            this.toggleVisibleTimeoutID = 0;
         }
         if(this.collectableAsset)
         {
            this.collectableAsset.visible = !this.collectableAsset.visible;
         }
      }
   }
}

import flash.display.MovieClip;

class CollectableHolder
{
    
   
   public var mc:MovieClip;
   
   public function CollectableHolder(param1:MovieClip)
   {
      super();
      this.mc = param1;
   }
   
   public function get targetY() : int
   {
      return int(this.mc.targetY) || 0;
   }
   
   public function get targetX() : int
   {
      return int(this.mc.targetX) || 0;
   }
}

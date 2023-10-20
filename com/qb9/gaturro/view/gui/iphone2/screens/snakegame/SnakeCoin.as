package com.qb9.gaturro.view.gui.iphone2.screens.snakegame
{
   import com.qb9.gaturro.globals.api;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   
   public class SnakeCoin extends GatuCoinAsset
   {
       
      
      private var _player:com.qb9.gaturro.view.gui.iphone2.screens.snakegame.SnakeElement;
      
      private const NEW_COIN_TIME:int = 15000;
      
      private var _fadeOutTimer:Timer;
      
      private var _newCoinTimer:Timer;
      
      private var _bounds:Rectangle;
      
      public var yPos:int;
      
      private var _activeTimer:Timer;
      
      private const DURATION:int = 160;
      
      private var _active:Boolean;
      
      private const ACTIVE_TIME:int = 10000;
      
      private var _blinkCount:int;
      
      public var xPos:int;
      
      public function SnakeCoin(param1:com.qb9.gaturro.view.gui.iphone2.screens.snakegame.SnakeElement, param2:Rectangle)
      {
         super();
         width = 10;
         height = 10;
         this._active = false;
         this._bounds = param2;
         this._player = param1;
         this._activeTimer = new Timer(this.ACTIVE_TIME);
         this._newCoinTimer = new Timer(this.NEW_COIN_TIME);
         this._fadeOutTimer = new Timer(this.ACTIVE_TIME * 2 / 3);
         this._activeTimer.addEventListener(TimerEvent.TIMER,this.activeTimeOut);
         this._newCoinTimer.addEventListener(TimerEvent.TIMER,this.onNewCoinTimer);
         this._fadeOutTimer.addEventListener(TimerEvent.TIMER,this.startFadingOut);
      }
      
      public function get active() : Boolean
      {
         return this._active;
      }
      
      public function acquired() : void
      {
         this._newCoinTimer.reset();
         this._newCoinTimer.start();
         addEventListener(Event.ENTER_FRAME,this.animateCoin);
         removeEventListener(Event.ENTER_FRAME,this.blink);
         visible = true;
         this._fadeOutTimer.stop();
         this.giveCoins();
      }
      
      private function animateCoin(param1:Event) : void
      {
         width += 1;
         height += 1;
         alpha -= 0.04;
         if(alpha <= 0)
         {
            removeEventListener(Event.ENTER_FRAME,this.animateCoin);
            this._active = false;
            visible = false;
            width = 10;
            height = 10;
            alpha = 1;
         }
      }
      
      private function startFadingOut(param1:TimerEvent) : void
      {
         addEventListener(Event.ENTER_FRAME,this.blink);
         this._fadeOutTimer.stop();
      }
      
      public function reposition() : void
      {
         this._active = true;
         var _loc1_:int = Math.floor(this._bounds.width / (this._player.width + 2)) - 1;
         var _loc2_:Number = Math.floor(Math.random() * _loc1_);
         var _loc3_:int = Math.floor(this._bounds.height / (this._player.height + 2)) - 1;
         var _loc4_:Number = Math.floor(Math.random() * _loc3_);
         this.xPos = _loc2_ * (width + 2);
         this.yPos = _loc4_ * (height + 2);
         x = this.xPos + width / 2;
         y = this.yPos + height / 2;
         this._activeTimer.reset();
         this._activeTimer.start();
         this._fadeOutTimer.reset();
         this._fadeOutTimer.start();
         this._blinkCount = 0;
      }
      
      public function dispose() : void
      {
         this._activeTimer.removeEventListener(TimerEvent.TIMER,this.activeTimeOut);
         this._newCoinTimer.removeEventListener(TimerEvent.TIMER,this.onNewCoinTimer);
         this._fadeOutTimer.removeEventListener(TimerEvent.TIMER,this.startFadingOut);
         removeEventListener(Event.ENTER_FRAME,this.animateCoin);
         removeEventListener(Event.ENTER_FRAME,this.blink);
      }
      
      private function activeTimeOut(param1:TimerEvent) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.blink);
         this._active = false;
         visible = false;
         this._activeTimer.stop();
         this._newCoinTimer.reset();
         this._newCoinTimer.start();
      }
      
      public function set active(param1:Boolean) : void
      {
         this._active = param1;
      }
      
      private function giveCoins() : void
      {
         var _loc1_:int = api.getProfileAttribute("coins") + 1;
         api.setProfileAttribute("system_coins",_loc1_);
      }
      
      private function blink(param1:Event) : void
      {
         if(this._blinkCount > 10)
         {
            visible = !visible;
            this._blinkCount = 0;
         }
         ++this._blinkCount;
      }
      
      private function onNewCoinTimer(param1:TimerEvent) : void
      {
         this._active = true;
         visible = true;
         this._newCoinTimer.stop();
         this._activeTimer.reset();
         this._activeTimer.start();
         this.reposition();
      }
   }
}

package com.qb9.gaturro.user.cellPhone
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class AppShortCut extends MovieClip
   {
       
      
      public var _notificationIcon:MovieClip;
      
      protected var _rollOver:Boolean;
      
      protected var _notificationStatus:String = "none";
      
      public function AppShortCut()
      {
         super();
         this.addEventListener(Event.ADDED_TO_STAGE,this.onStage);
      }
      
      override public function get enabled() : Boolean
      {
         return super.enabled;
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         super.enabled = param1;
         this.buttonMode = this.enabled;
         if(this.enabled)
         {
            if(this._rollOver)
            {
               gotoAndStop("rollover");
            }
         }
         else
         {
            gotoAndStop("disabled");
         }
      }
      
      protected function onPress(param1:MouseEvent) : void
      {
         if(this.enabled)
         {
            gotoAndStop("press");
         }
      }
      
      protected function onRelease(param1:MouseEvent) : void
      {
         if(this.enabled)
         {
            gotoAndStop("release");
         }
      }
      
      public function set notificationStatus(param1:String) : void
      {
         if(this._notificationIcon != null)
         {
            this._notificationIcon.visible = true;
         }
         this._notificationStatus = param1;
         if(this._notificationIcon != null)
         {
            this._notificationIcon.gotoAndStop(this._notificationStatus);
         }
      }
      
      protected function dispose(param1:Event) : void
      {
         this.enabled = true;
         this.removeEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this.removeEventListener(MouseEvent.ROLL_OUT,this.onOut);
         this.removeEventListener(MouseEvent.MOUSE_DOWN,this.onPress);
         this.removeEventListener(MouseEvent.MOUSE_UP,this.onRelease);
         this.removeEventListener(Event.REMOVED_FROM_STAGE,this.dispose);
      }
      
      protected function onOut(param1:MouseEvent) : void
      {
         if(this.enabled)
         {
            this._rollOver = false;
            gotoAndStop("out");
         }
      }
      
      protected function onOver(param1:MouseEvent) : void
      {
         if(this.enabled)
         {
            this._rollOver = true;
            gotoAndStop("over");
         }
      }
      
      public function get notificationStatus() : String
      {
         return this._notificationStatus;
      }
      
      protected function onStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onStage);
         this.addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this.addEventListener(MouseEvent.ROLL_OUT,this.onOut);
         this.addEventListener(MouseEvent.MOUSE_DOWN,this.onPress);
         this.addEventListener(MouseEvent.MOUSE_UP,this.onRelease);
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.dispose);
         this._notificationIcon = this["notification_icon"];
         this._notificationIcon.gotoAndStop(this._notificationStatus);
      }
   }
}

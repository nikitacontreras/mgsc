package com.qb9.gaturro.view.gui.iphone2
{
   import com.qb9.gaturro.globals.audio;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class CellPhoneButton
   {
       
      
      private var _view:MovieClip;
      
      private var _sfx:String;
      
      private var _action:Function;
      
      private var _visible:Boolean;
      
      public function CellPhoneButton(param1:MovieClip, param2:Function, param3:String = null)
      {
         super();
         this._view = param1;
         this._view.stop();
         this._view.mouseChildren = false;
         this._view.buttonMode = true;
         this._action = param2;
         this._sfx = param3;
         if(this._sfx != null && !audio.has(this._sfx))
         {
            audio.register(this._sfx).start();
         }
         this._view.addEventListener(MouseEvent.CLICK,this.onClick);
         this._view.addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this._view.addEventListener(MouseEvent.ROLL_OUT,this.onOut);
         this._view.addEventListener(Event.REMOVED_FROM_STAGE,this.dispose);
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         this._view.gotoAndStop("over");
      }
      
      public function get view() : MovieClip
      {
         return this._view;
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(this._sfx != null)
         {
            audio.play(this._sfx);
         }
         this._action(param1);
      }
      
      public function set visible(param1:Boolean) : void
      {
         this._view.visible = param1;
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         this._view.gotoAndStop("out");
      }
      
      public function get visible() : Boolean
      {
         return this._view.visible;
      }
      
      public function changeCallback(param1:Function) : void
      {
         this._action = param1;
      }
      
      public function dispose(param1:Event) : void
      {
         this._view.removeEventListener(Event.REMOVED_FROM_STAGE,this.dispose);
         this._view.removeEventListener(MouseEvent.CLICK,this._action);
         this._view.removeEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this._view.removeEventListener(MouseEvent.ROLL_OUT,this.onOut);
         if(audio.has(this._sfx))
         {
            audio.disposeSound(this._sfx);
         }
         this._sfx = null;
         this._view = null;
         this._action = null;
      }
   }
}

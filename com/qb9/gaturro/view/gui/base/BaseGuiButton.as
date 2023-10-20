package com.qb9.gaturro.view.gui.base
{
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.gaturro.view.gui.Gui;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class BaseGuiButton implements IDisposable
   {
       
      
      protected var asset:Sprite;
      
      protected var gui:Gui;
      
      public function BaseGuiButton(param1:Gui, param2:Sprite)
      {
         super();
         this.gui = param1;
         this.asset = param2;
         param2.buttonMode = true;
         param2.addEventListener(MouseEvent.ROLL_OVER,this.rolloverSound);
         param2.addEventListener(MouseEvent.MOUSE_UP,this._action);
      }
      
      private function rolloverSound(param1:Event) : void
      {
      }
      
      protected function _action(param1:Event) : void
      {
         this.action();
      }
      
      protected function get mc() : MovieClip
      {
         return this.asset as MovieClip;
      }
      
      protected function action() : void
      {
      }
      
      public function dispose() : void
      {
         this.asset.removeEventListener(MouseEvent.CLICK,this._action);
         this.asset.removeEventListener(MouseEvent.ROLL_OVER,this.rolloverSound);
         this.gui = null;
         this.asset = null;
      }
   }
}

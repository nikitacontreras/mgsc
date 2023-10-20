package com.qb9.gaturro.view.gui.base.inventory.repeater.navigation
{
   import com.qb9.gaturro.view.components.repeater.item.BaseItemRenderer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ArrowInventoryPageItemRenderer extends BaseItemRenderer
   {
      
      public static const ARROW_CLICK:String = "arrowClick";
       
      
      private var _enabled:Boolean = true;
      
      public function ArrowInventoryPageItemRenderer(param1:Class)
      {
         super(param1);
      }
      
      public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      override protected function setupView() : void
      {
         super.setupView();
         this._enabled = true;
         buttonMode = true;
         mouseChildren = false;
         addEventListener(MouseEvent.CLICK,this.onClik);
         addEventListener(MouseEvent.MOUSE_OVER,this.onOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onOut);
      }
      
      public function enable() : void
      {
         MovieClip(view).gotoAndStop("out");
         mouseEnabled = true;
         buttonMode = true;
         this._enabled = true;
      }
      
      public function disable() : void
      {
         MovieClip(view).gotoAndStop("disable");
         mouseEnabled = false;
         buttonMode = false;
         this._enabled = false;
      }
      
      private function onClik(param1:MouseEvent) : void
      {
         var _loc2_:Event = new Event(ARROW_CLICK,true);
         dispatchEvent(_loc2_);
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         if(this._enabled)
         {
            MovieClip(view).gotoAndStop("out");
         }
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         MovieClip(view).gotoAndStop("over");
      }
      
      override public function dispose() : void
      {
         removeEventListener(MouseEvent.CLICK,this.onClik);
         removeEventListener(MouseEvent.MOUSE_OVER,this.onOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.onOut);
         super.dispose();
      }
   }
}

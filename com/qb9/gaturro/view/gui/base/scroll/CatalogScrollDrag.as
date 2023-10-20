package com.qb9.gaturro.view.gui.base.scroll
{
   import com.qb9.flashlib.interfaces.IDisposable;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   public final class CatalogScrollDrag extends Sprite implements IDisposable
   {
      
      private static const MIN_TIME:uint = 500;
      
      private static const ROUNDING:uint = 15;
      
      private static const INTERVAL:uint = 100;
       
      
      private var interval:int;
      
      private var barWidth:uint;
      
      public function CatalogScrollDrag(param1:Number, param2:Number, param3:uint)
      {
         super();
         this.barWidth = param3;
         graphics.beginFill(16373265);
         graphics.drawRoundRect(0,0,param3 / param1,param2,ROUNDING);
         graphics.endFill();
         buttonMode = true;
         this.initEvents();
      }
      
      public function get scrollingArea() : Number
      {
         return this.barWidth - width;
      }
      
      private function inform() : void
      {
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get progress() : Number
      {
         return x / this.scrollingArea;
      }
      
      public function cancelDrag() : void
      {
         stopDrag();
         if(stage)
         {
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.stopDragging,true);
         }
         clearInterval(this.interval);
      }
      
      private function initEvents() : void
      {
         addEventListener(MouseEvent.MOUSE_DOWN,this.startDragging);
      }
      
      private function startDragging(param1:Event) : void
      {
         param1.stopImmediatePropagation();
         if(!stage)
         {
            return;
         }
         startDrag(false,new Rectangle(0,0,this.scrollingArea,0));
         this.interval = setInterval(this.inform,INTERVAL);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.stopDragging,true);
      }
      
      private function stopDragging(param1:Event = null) : void
      {
         this.cancelDrag();
      }
      
      public function dispose() : void
      {
         this.cancelDrag();
         removeEventListener(MouseEvent.MOUSE_DOWN,this.startDragging);
      }
   }
}

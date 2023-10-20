package com.qb9.gaturro.util
{
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.gaturro.globals.stageData;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class RedrawForcer extends Sprite
   {
       
      
      private var frame:int = 0;
      
      public function RedrawForcer()
      {
         super();
         var _loc1_:Shape = new Shape();
         _loc1_.graphics.beginFill(0,0);
         _loc1_.graphics.drawRect(0,0,stageData.width,stageData.height);
         _loc1_.graphics.endFill();
         addChild(_loc1_);
         addEventListener(Event.ENTER_FRAME,this.remove);
      }
      
      private function remove(param1:Event) : void
      {
         ++this.frame;
         if(this.frame > 1)
         {
            removeEventListener(Event.ENTER_FRAME,this.remove);
            DisplayUtil.dispose(this);
         }
      }
   }
}

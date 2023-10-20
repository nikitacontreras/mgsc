package com.qb9.gaturro.commons.view.component.canvas.switcher
{
   import com.qb9.gaturro.commons.view.component.canvas.display.Canvas;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.view.components.canvas.FrameCanvas;
   import flash.display.FrameLabel;
   import flash.display.MovieClip;
   
   public class FrameCanvasSwitcher extends CanvasSwitcher
   {
       
      
      public function FrameCanvasSwitcher(param1:MovieClip)
      {
         super(param1);
      }
      
      override protected function showNextCanvas(param1:Canvas, param2:Object = null) : void
      {
         logger.debug(this,"showNextCanvas");
         var _loc3_:String = FrameCanvas(param1).label;
         MovieClip(container).gotoAndPlay(_loc3_);
         super.showNextCanvas(param1,param2);
      }
      
      override public function addCanvas(param1:Canvas) : void
      {
         var _loc2_:FrameCanvas = param1 as FrameCanvas;
         if(!_loc2_)
         {
            logger.debug("This instance should be an AbstractFrameCanvas subclass. Target: [" + param1 + "]");
            throw new Error("This instance should be an AbstractFrameCanvas subclass. Target: [" + param1 + "]");
         }
         var _loc3_:Boolean = this.hasLabel(_loc2_.label,MovieClip(container));
         if(!_loc3_)
         {
            logger.debug("The view hasn\'t the label: [" + _loc2_.label + "]");
            throw new Error("The view hasn\'t the label: [" + _loc2_.label + "]");
         }
         super.addCanvas(param1);
      }
      
      private function hasLabel(param1:String, param2:MovieClip) : Boolean
      {
         var _loc3_:FrameLabel = null;
         for each(_loc3_ in param2.currentLabels)
         {
            if(_loc3_.name == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      override protected function hideCurentCanvas() : void
      {
         if(_currentCanvas)
         {
            super.hideCurentCanvas();
         }
      }
   }
}

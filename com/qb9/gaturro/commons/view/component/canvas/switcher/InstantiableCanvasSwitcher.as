package com.qb9.gaturro.commons.view.component.canvas.switcher
{
   import com.qb9.gaturro.commons.view.component.canvas.display.Canvas;
   import com.qb9.gaturro.view.components.canvas.InstatiableCanvas;
   import flash.display.DisplayObjectContainer;
   
   public class InstantiableCanvasSwitcher extends CanvasSwitcher
   {
       
      
      public function InstantiableCanvasSwitcher(param1:DisplayObjectContainer)
      {
         super(param1);
      }
      
      override protected function showNextCanvas(param1:Canvas, param2:Object = null) : void
      {
         var _loc3_:InstatiableCanvas = param1 as InstatiableCanvas;
         container.addChild(_loc3_.view);
         super.showNextCanvas(param1,param2);
      }
      
      override protected function hideCurentCanvas() : void
      {
         var _loc1_:InstatiableCanvas = null;
         if(_currentCanvas)
         {
            _loc1_ = _currentCanvas as InstatiableCanvas;
            container.removeChild(_loc1_.view);
            super.hideCurentCanvas();
         }
      }
   }
}

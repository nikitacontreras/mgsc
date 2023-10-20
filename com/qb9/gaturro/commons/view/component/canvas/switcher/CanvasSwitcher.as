package com.qb9.gaturro.commons.view.component.canvas.switcher
{
   import com.qb9.gaturro.commons.dispose.ICheckableDisposable;
   import com.qb9.gaturro.commons.view.component.canvas.display.*;
   import com.qb9.gaturro.globals.logger;
   import flash.display.DisplayObjectContainer;
   import flash.utils.Dictionary;
   
   public class CanvasSwitcher implements ICheckableDisposable
   {
       
      
      protected var container:DisplayObjectContainer;
      
      private var _disposed:Boolean;
      
      protected var _currentCanvas:Canvas;
      
      private var canvasList:Dictionary;
      
      public function CanvasSwitcher(param1:DisplayObjectContainer)
      {
         super();
         this.container = param1;
         this.canvasList = new Dictionary();
      }
      
      public function get disposed() : Boolean
      {
         return this._disposed;
      }
      
      protected function showNextCanvas(param1:Canvas, param2:Object = null) : void
      {
         param1.show(param2);
         this._currentCanvas = param1;
      }
      
      public function get currentCanvas() : Canvas
      {
         return this._currentCanvas;
      }
      
      public function addCanvas(param1:Canvas) : void
      {
         this.canvasList[param1.id] = param1;
      }
      
      public function switchCanvas(param1:String, param2:Object = null) : void
      {
         var _loc3_:Canvas = this.canvasList[param1];
         if(!_loc3_)
         {
            logger.debug("Doesn\'t exist a canvas with the ID = " + param1);
            throw new Error("Doesn\'t exist a canvas with the ID = " + param1);
         }
         trace("AbstractCanvasSwitcher :: switchCanvas :: _currentCanvas = " + this._currentCanvas);
         this.hideCurentCanvas();
         this.showNextCanvas(_loc3_,param2);
         trace("AbstractCanvasSwitcher :: switchCanvas :: NEW --> _currentCanvas = " + this._currentCanvas);
         trace("............");
      }
      
      protected function hideCurentCanvas() : void
      {
         if(this._currentCanvas)
         {
            this._currentCanvas.hide();
            this._currentCanvas = null;
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:Canvas = null;
         for each(_loc1_ in this.canvasList)
         {
            _loc1_.dispose();
         }
         this.canvasList = null;
         this._disposed = true;
      }
   }
}

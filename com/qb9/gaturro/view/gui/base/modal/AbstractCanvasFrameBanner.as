package com.qb9.gaturro.view.gui.base.modal
{
   import com.qb9.gaturro.commons.view.component.canvas.display.Canvas;
   import com.qb9.gaturro.commons.view.component.canvas.switcher.FrameCanvasSwitcher;
   import flash.display.MovieClip;
   import flash.errors.IllegalOperationError;
   
   public class AbstractCanvasFrameBanner extends InstantiableGuiModal
   {
       
      
      private var _canvasContainer:MovieClip;
      
      private var _initialCanvasName:String;
      
      private var canvasSwitcher:FrameCanvasSwitcher;
      
      protected var canvasContainerName:String = "canvasContainer";
      
      public function AbstractCanvasFrameBanner(param1:String = "", param2:String = "")
      {
         super(param1,param2);
      }
      
      protected function addCanvas(param1:Canvas) : void
      {
         this.canvasSwitcher.addCanvas(param1);
      }
      
      override protected function ready() : void
      {
         super.ready();
         this.setupCanvasSwitcher();
         this.setupCanvas();
         this.setInitialCanvasName();
         this.setupInitialCanvas();
      }
      
      protected function setInitialCanvasName() : void
      {
         throw new IllegalOperationError("This method is an abstract method and should be implemented by the subclass. In it has to set \'initialCanvasName\'");
      }
      
      final protected function set initialCanvasName(param1:String) : void
      {
         this._initialCanvasName = param1;
      }
      
      final protected function get initialCanvasName() : String
      {
         return this._initialCanvasName;
      }
      
      protected function getCurrentCanvasName() : String
      {
         return this.canvasSwitcher.currentCanvas.id;
      }
      
      private function setupInitialCanvas() : void
      {
         this.switchTo(this._initialCanvasName);
      }
      
      final protected function get currentCanvas() : String
      {
         return this.canvasSwitcher.currentCanvas.id;
      }
      
      protected function setupCanvas() : void
      {
         throw new IllegalOperationError("This method is an abstract method and should be implemented by the subclass.");
      }
      
      protected function switchTo(param1:String, param2:Object = null) : void
      {
         this.canvasSwitcher.switchCanvas(param1,param2);
      }
      
      public function get canvasContainer() : MovieClip
      {
         return this._canvasContainer;
      }
      
      private function setupCanvasSwitcher() : void
      {
         this._canvasContainer = view.getChildByName(this.canvasContainerName) as MovieClip;
         this.canvasSwitcher = new FrameCanvasSwitcher(this._canvasContainer);
      }
      
      override public function dispose() : void
      {
         this.canvasSwitcher.dispose();
         this.canvasSwitcher = null;
         super.dispose();
      }
   }
}

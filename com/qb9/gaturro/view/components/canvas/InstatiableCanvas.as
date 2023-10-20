package com.qb9.gaturro.view.components.canvas
{
   import com.qb9.gaturro.commons.view.component.canvas.display.Canvas;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import flash.display.DisplayObjectContainer;
   
   public class InstatiableCanvas extends Canvas
   {
       
      
      protected var viewClassName:String;
      
      public function InstatiableCanvas(param1:String, param2:InstantiableGuiModal, param3:String)
      {
         logger.debug(this,"viewClassName = [" + param3 + "]");
         this.viewClassName = param3;
         this._owner = param2;
         super(param1);
      }
      
      override protected function setupView() : void
      {
         _view = (_owner as InstantiableGuiModal).getInstanceByName(this.viewClassName) as DisplayObjectContainer;
      }
   }
}

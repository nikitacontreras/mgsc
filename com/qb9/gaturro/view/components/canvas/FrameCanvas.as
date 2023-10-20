package com.qb9.gaturro.view.components.canvas
{
   import com.qb9.gaturro.commons.view.component.canvas.display.Canvas;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   
   public class FrameCanvas extends Canvas
   {
       
      
      private var i:int = 0;
      
      protected var _label:String;
      
      public function FrameCanvas(param1:String, param2:String, param3:DisplayObjectContainer, param4:InstantiableGuiModal)
      {
         _owner = param4;
         _view = param3;
         this._label = param2;
         super(param1);
      }
      
      override public function hide() : void
      {
         view.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         super.hide();
      }
      
      protected function setupShowView() : void
      {
      }
      
      protected function onEnterFrame(param1:Event) : void
      {
         ++this.i;
         if(this.i == 2)
         {
            view.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            this.setupShowView();
            this.i = 0;
         }
      }
      
      public function get label() : String
      {
         return this._label;
      }
      
      override public function show(param1:Object = null) : void
      {
         super.show(param1);
         view.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      override public function dispose() : void
      {
         view.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         super.dispose();
      }
   }
}

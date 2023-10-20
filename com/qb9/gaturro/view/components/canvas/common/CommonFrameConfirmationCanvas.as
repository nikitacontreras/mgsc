package com.qb9.gaturro.view.components.canvas.common
{
   import com.qb9.gaturro.view.components.canvas.FrameCanvas;
   import com.qb9.gaturro.view.gui.base.modal.AbstractInstantiableConfirmatorModal;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class CommonFrameConfirmationCanvas extends FrameCanvas
   {
       
      
      private var button:Sprite;
      
      public function CommonFrameConfirmationCanvas(param1:String, param2:String, param3:DisplayObjectContainer, param4:AbstractInstantiableConfirmatorModal)
      {
         super(param1,param2,param3,param4);
      }
      
      private function onViewChanged(param1:Event) : void
      {
         if(view.getChildByName("acceptBtn"))
         {
            view.removeEventListener(Event.ENTER_FRAME,this.onViewChanged);
            this.setupShowView();
         }
      }
      
      override public function dispose() : void
      {
         view.removeEventListener(Event.ENTER_FRAME,this.onViewChanged);
         this.button.removeEventListener(MouseEvent.CLICK,this.onClick);
         super.dispose();
      }
      
      protected function setupButton() : void
      {
         this.button = view.getChildByName("acceptBtn") as Sprite;
         this.button.addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         this.getOwner().confirm();
      }
      
      override public function hide() : void
      {
         view.removeEventListener(Event.ENTER_FRAME,this.onViewChanged);
         this.button.removeEventListener(MouseEvent.CLICK,this.onClick);
         super.hide();
      }
      
      protected function getOwner() : AbstractInstantiableConfirmatorModal
      {
         return owner as AbstractInstantiableConfirmatorModal;
      }
      
      override public function show(param1:Object = null) : void
      {
         view.addEventListener(Event.ENTER_FRAME,this.onViewChanged);
         super.show(param1);
      }
      
      override protected function setupShowView() : void
      {
         this.setupButton();
      }
   }
}

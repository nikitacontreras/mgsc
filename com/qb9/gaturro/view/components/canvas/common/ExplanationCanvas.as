package com.qb9.gaturro.view.components.canvas.common
{
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.view.components.canvas.FrameCanvas;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class ExplanationCanvas extends FrameCanvas
   {
       
      
      private var acceptBtn:Sprite;
      
      public function ExplanationCanvas(param1:String, param2:String, param3:DisplayObjectContainer, param4:InstantiableGuiModal)
      {
         super(param1,param2,param3,param4);
         if(!(param4 is ISwitchPostExplanation))
         {
            throw new Error("The owner parameter should implements ISwitchPostExplanation interface");
         }
      }
      
      private function onClickAccept(param1:MouseEvent) : void
      {
         ISwitchPostExplanation(owner).switchToPostExplanation();
      }
      
      override public function hide() : void
      {
         if(this.acceptBtn)
         {
            this.acceptBtn.removeEventListener(MouseEvent.CLICK,this.onClickAccept);
         }
         super.hide();
      }
      
      private function setupButton() : void
      {
         this.acceptBtn = view.getChildByName("acceptBtn") as Sprite;
         this.acceptBtn.buttonMode = true;
         this.acceptBtn.addEventListener(MouseEvent.CLICK,this.onClickAccept);
         var _loc1_:TextField = this.acceptBtn.getChildByName("field") as TextField;
         _loc1_.text = api.getText("LISTO");
      }
      
      override public function show(param1:Object = null) : void
      {
         super.show(param1);
      }
      
      override public function dispose() : void
      {
         if(this.acceptBtn)
         {
            this.acceptBtn.removeEventListener(MouseEvent.CLICK,this.onClickAccept);
         }
         super.dispose();
      }
      
      override protected function setupShowView() : void
      {
         this.setupButton();
      }
   }
}

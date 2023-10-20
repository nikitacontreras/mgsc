package com.qb9.gaturro.view.components.canvas.impl.codeBurner
{
   import com.qb9.gaturro.view.components.banner.codeBurner.CodeBurnerBanner;
   import com.qb9.gaturro.view.components.canvas.FrameCanvas;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class CodeBurnerInputCanvas extends FrameCanvas
   {
       
      
      private var sendButton:MovieClip;
      
      private var inputField:TextField;
      
      private var helpButton:MovieClip;
      
      public function CodeBurnerInputCanvas(param1:String, param2:String, param3:DisplayObjectContainer, param4:InstantiableGuiModal)
      {
         super(param1,param2,param3,param4);
      }
      
      override public function hide() : void
      {
         this.sendButton.removeEventListener(MouseEvent.CLICK,this.onClick);
         super.hide();
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         CodeBurnerBanner(owner).sendCode(this.inputField.text);
      }
      
      private function onClickHelp(param1:MouseEvent) : void
      {
         CodeBurnerBanner(owner).gotoHelp();
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
      
      private function setupButton() : void
      {
         this.setupSendButton();
      }
      
      private function setupHelpButton() : void
      {
         this.helpButton = getChildByName("helpButton") as MovieClip;
         this.helpButton.addEventListener(MouseEvent.CLICK,this.onClickHelp);
      }
      
      private function setupSendButton() : void
      {
         this.sendButton = getChildByName("button") as MovieClip;
         this.sendButton.addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      override protected function setupShowView() : void
      {
         this.inputField = getChildByName("inputField") as TextField;
         this.setupButton();
      }
   }
}

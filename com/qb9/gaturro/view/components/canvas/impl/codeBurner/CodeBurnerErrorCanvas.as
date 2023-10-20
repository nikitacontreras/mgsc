package com.qb9.gaturro.view.components.canvas.impl.codeBurner
{
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.view.components.banner.codeBurner.CodeBurnerBanner;
   import com.qb9.gaturro.view.components.canvas.FrameCanvas;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class CodeBurnerErrorCanvas extends FrameCanvas
   {
       
      
      private var field:TextField;
      
      private var errorType:String;
      
      private var button:MovieClip;
      
      private var helpButton:MovieClip;
      
      public function CodeBurnerErrorCanvas(param1:String, param2:String, param3:DisplayObjectContainer, param4:InstantiableGuiModal)
      {
         super(param1,param2,param3,param4);
      }
      
      override public function hide() : void
      {
         this.button.removeEventListener(MouseEvent.CLICK,this.onClick);
         super.hide();
      }
      
      private function onClickHelp(param1:MouseEvent) : void
      {
         CodeBurnerBanner(owner).gotoHelp();
      }
      
      private function setupReturnButton() : void
      {
         this.button = getChildByName("button") as MovieClip;
         var _loc1_:TextField = this.button.getChildByName("label") as TextField;
         api.setText(_loc1_,"REINTENTAR");
         this.button.addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function setupButton() : void
      {
         this.setupReturnButton();
      }
      
      private function setupHelpButton() : void
      {
         this.helpButton = getChildByName("helpButton") as MovieClip;
         this.helpButton.addEventListener(MouseEvent.CLICK,this.onClickHelp);
      }
      
      private function setupFeedback() : void
      {
         this.field = getChildByName("field") as TextField;
         api.setText(this.field,this.getMessage());
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         CodeBurnerBanner(owner).returnToInput();
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
      
      private function getMessage() : String
      {
         var _loc1_:String = null;
         switch(this.errorType)
         {
            case "<error>":
               _loc1_ = "CÓDIGO INVÁLIDO.";
               api.trackEvent("FEATURES:SERENITO2017:bannerCodigos:Invalido","true");
               break;
            case "<usedcode>":
               _loc1_ = "CÓDIGO YA UTILIZADO.";
               api.trackEvent("FEATURES:SERENITO2017:bannerCodigos:Usado","true");
               break;
            case "<time out>":
               _loc1_ = "HA OCURRIDO UN ERROR.";
               api.trackEvent("FEATURES:SERENITO2017:bannerCodigos:TimeOut","true");
               break;
            default:
               _loc1_ = "HA OCURRIDO UN ERROR";
               api.trackEvent("FEATURES:SERENITO2017:bannerCodigos:Error","true");
         }
         return _loc1_;
      }
      
      override public function show(param1:Object = null) : void
      {
         this.errorType = param1.toString();
         super.show(param1);
      }
      
      override protected function setupShowView() : void
      {
         this.setupFeedback();
         this.setupButton();
      }
   }
}

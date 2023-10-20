package com.qb9.gaturro.view.components.canvas.impl.codeBurner
{
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.view.components.banner.codeBurner.CodeBurnerBanner;
   import com.qb9.gaturro.view.components.canvas.FrameCanvas;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.text.TextField;
   
   public class CodeBurnerHelpCanvas extends FrameCanvas
   {
       
      
      private var moreInfoButton:MovieClip;
      
      private var button:MovieClip;
      
      public function CodeBurnerHelpCanvas(param1:String, param2:String, param3:DisplayObjectContainer, param4:InstantiableGuiModal)
      {
         super(param1,param2,param3,param4);
      }
      
      override public function hide() : void
      {
         this.button.removeEventListener(MouseEvent.CLICK,this.onClick);
         super.hide();
      }
      
      override protected function setupShowView() : void
      {
         this.setupButton();
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         CodeBurnerBanner(owner).returnToInput();
      }
      
      private function onClickMoreInfo(param1:MouseEvent) : void
      {
         navigateToURL(new URLRequest("http://blog.mundogaturro.com/llego-el-nuevo-album-de-figuritas-de-mundo-gaturro-gatoons/"),"_blank");
      }
      
      override public function dispose() : void
      {
         this.button.removeEventListener(MouseEvent.CLICK,this.onClick);
         super.dispose();
      }
      
      private function setupButton() : void
      {
         this.setupReturnButton();
         this.setupMoreInfoButton();
      }
      
      private function setupMoreInfoButton() : void
      {
         this.moreInfoButton = getChildByName("moreInfoButton") as MovieClip;
         this.moreInfoButton.addEventListener(MouseEvent.CLICK,this.onClickMoreInfo);
         var _loc1_:TextField = this.moreInfoButton.getChildByName("label") as TextField;
         api.setText(_loc1_,"MÁS INFORMACIÓN");
      }
      
      private function setupReturnButton() : void
      {
         this.button = getChildByName("button") as MovieClip;
         this.button.addEventListener(MouseEvent.CLICK,this.onClick);
         var _loc1_:TextField = this.button.getChildByName("label") as TextField;
         api.setText(_loc1_,"VOLVER");
      }
   }
}

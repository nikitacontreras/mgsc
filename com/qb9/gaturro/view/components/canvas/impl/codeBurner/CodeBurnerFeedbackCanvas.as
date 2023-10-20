package com.qb9.gaturro.view.components.canvas.impl.codeBurner
{
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.view.components.banner.codeBurner.CodeBurnerBanner;
   import com.qb9.gaturro.view.components.canvas.FrameCanvas;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import com.qb9.gaturro.view.gui.util.GuiUtil;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class CodeBurnerFeedbackCanvas extends FrameCanvas
   {
       
      
      private var button:MovieClip;
      
      private var ph:DisplayObjectContainer;
      
      private var giftName:String;
      
      public function CodeBurnerFeedbackCanvas(param1:String, param2:String, param3:DisplayObjectContainer, param4:InstantiableGuiModal)
      {
         super(param1,param2,param3,param4);
      }
      
      override public function hide() : void
      {
         if(this.button)
         {
            this.button.removeEventListener(MouseEvent.CLICK,this.onClick);
         }
         super.hide();
      }
      
      private function loadGift(param1:String) : void
      {
         api.libraries.fetch(param1,this.showGift);
         api.playSound("serenito2017/premios");
      }
      
      override public function dispose() : void
      {
         this.button.removeEventListener(MouseEvent.CLICK,this.onClick);
         super.dispose();
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         CodeBurnerBanner(owner).goout();
      }
      
      private function sign(param1:Number) : int
      {
         return param1 > 0 ? 1 : (param1 < 0 ? -1 : 0);
      }
      
      private function showGift(param1:DisplayObject) : void
      {
         GuiUtil.fit(param1,this.ph.width,this.ph.height);
         this.ph.addChild(param1);
      }
      
      private function setupButton() : void
      {
         this.button = getChildByName("button") as MovieClip;
         this.button.addEventListener(MouseEvent.CLICK,this.onClick);
         var _loc1_:TextField = this.button.getChildByName("label") as TextField;
         api.setText(_loc1_,"SALIR");
      }
      
      override public function show(param1:Object = null) : void
      {
         this.giftName = param1.toString();
         super.show(param1);
      }
      
      override protected function setupShowView() : void
      {
         this.ph = getChildByName("ph") as DisplayObjectContainer;
         this.setupButton();
         this.loadGift(this.giftName);
      }
   }
}

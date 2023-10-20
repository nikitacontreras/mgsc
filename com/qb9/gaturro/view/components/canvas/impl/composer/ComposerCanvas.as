package com.qb9.gaturro.view.components.canvas.impl.composer
{
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.service.composer.ObjectComposer;
   import com.qb9.gaturro.view.components.canvas.FrameCanvas;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class ComposerCanvas extends FrameCanvas
   {
       
      
      private var composer:ObjectComposer;
      
      private var button:Sprite;
      
      public function ComposerCanvas(param1:String, param2:String, param3:DisplayObjectContainer, param4:InstantiableGuiModal)
      {
         super(param1,param2,param3,param4);
         if(!(param4 is IComposerClient))
         {
            throw new Error("The provided owner has to be an IComposerClient instance");
         }
      }
      
      private function setupButton() : void
      {
         this.button = view.getChildByName("acceptBtn") as Sprite;
         this.button.addEventListener(MouseEvent.CLICK,this.onClick);
         this.button.buttonMode = true;
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         var _loc2_:Array = this.composer.getResult();
         IComposerClient(owner).setResult(_loc2_);
         api.playSound("clickFusion");
      }
      
      private function setupComposer() : void
      {
         this.composer = new ObjectComposer(view);
      }
      
      override protected function setupShowView() : void
      {
         super.setupView();
         this.setupComposer();
         this.setupButton();
      }
      
      override public function dispose() : void
      {
         if(this.button)
         {
            this.button.removeEventListener(MouseEvent.CLICK,this.onClick);
            this.button = null;
         }
         super.dispose();
      }
   }
}

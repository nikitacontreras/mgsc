package com.qb9.gaturro.view.components.canvas.impl.composer
{
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.service.composer.ObjectComposerDisplay;
   import com.qb9.gaturro.view.components.canvas.FrameCanvas;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class ComposerDisplayCanvas extends FrameCanvas
   {
       
      
      private var composerDisplay:ObjectComposerDisplay;
      
      private var partHolder:DisplayObjectContainer;
      
      private var partResult:Array;
      
      private var acceptBtn:MovieClip;
      
      public function ComposerDisplayCanvas(param1:String, param2:String, param3:DisplayObjectContainer, param4:InstantiableGuiModal)
      {
         super(param1,param2,param3,param4);
      }
      
      private function setupDisplay() : void
      {
         this.composerDisplay = new ObjectComposerDisplay(this.partHolder);
         var _loc1_:int = 0;
         while(_loc1_ < this.partResult.length)
         {
            this.composerDisplay.goto(_loc1_,this.partResult[_loc1_]);
            _loc1_++;
         }
      }
      
      private function onAccept(param1:MouseEvent) : void
      {
         api.playSound("win");
         IComposerClient(owner).complete();
      }
      
      private function setupButton() : void
      {
         this.acceptBtn = view.getChildByName("acceptBtn") as MovieClip;
         this.acceptBtn.buttonMode = true;
         this.acceptBtn.addEventListener(MouseEvent.CLICK,this.onAccept);
      }
      
      override public function show(param1:Object = null) : void
      {
         super.show(param1);
         this.partResult = param1 as Array;
      }
      
      override protected function setupShowView() : void
      {
         super.setupShowView();
         var _loc1_:DisplayObjectContainer = view.getChildByName("target") as DisplayObjectContainer;
         this.partHolder = _loc1_.getChildByName("partHolder") as DisplayObjectContainer;
         this.setupButton();
         this.setupDisplay();
      }
   }
}

package com.qb9.gaturro.view.components.canvas.impl.itemConsumer
{
   import com.qb9.gaturro.view.components.banner.itemConsumer.ItemConsumerBanner;
   import com.qb9.gaturro.view.components.canvas.FrameCanvas;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class RewardCanvas extends FrameCanvas
   {
       
      
      private var acceptBtn:MovieClip;
      
      private var amountText:TextField;
      
      private var muerdagos:int;
      
      public function RewardCanvas(param1:String, param2:String, param3:DisplayObjectContainer, param4:InstantiableGuiModal)
      {
         super(param1,param2,param3,param4);
      }
      
      private function onAccept(param1:MouseEvent) : void
      {
         ItemConsumerBanner(_owner).close();
      }
      
      override public function show(param1:Object = null) : void
      {
         this.muerdagos = param1 as int;
         super.show(param1);
      }
      
      override protected function setupShowView() : void
      {
         this.amountText = view.getChildByName("amount") as TextField;
         this.amountText.text = this.muerdagos.toString();
         this.acceptBtn = view.getChildByName("acceptBtn") as MovieClip;
         this.acceptBtn.addEventListener(MouseEvent.CLICK,this.onAccept);
      }
   }
}

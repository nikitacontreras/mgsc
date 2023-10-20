package com.qb9.gaturro.view.components.repeater.item.implementation.partyElite
{
   import com.qb9.gaturro.view.components.repeater.item.BaseItemRenderer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class ElitePartyAwardItemRenderer extends BaseItemRenderer
   {
       
      
      private var amountField:TextField;
      
      private var bg:MovieClip;
      
      public function ElitePartyAwardItemRenderer(param1:Class)
      {
         super(param1);
      }
      
      override public function dispose() : void
      {
         removeEventListener(MouseEvent.CLICK,this.onClick);
         super.dispose();
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         innerSelect();
         this.bg.gotoAndStop("selected");
      }
      
      private function setupIcon() : void
      {
         MovieClip(view).gotoAndStop(data.name);
      }
      
      private function setupButton() : void
      {
         mouseChildren = false;
         buttonMode = data.available;
         if(buttonMode && !hasEventListener(MouseEvent.CLICK))
         {
            addEventListener(MouseEvent.CLICK,this.onClick);
         }
      }
      
      override public function deselect() : void
      {
         super.deselect();
         if(buttonMode)
         {
            this.bg.gotoAndStop("enable");
         }
      }
      
      private function setup() : void
      {
         this.setupButton();
         this.setupIcon();
         this.setupActivation();
         this.setupAmount();
      }
      
      override protected function dataReady() : void
      {
         super.dataReady();
         this.setup();
      }
      
      private function setupActivation() : void
      {
         this.bg = view.getChildByName("background") as MovieClip;
         if(!buttonMode)
         {
            this.bg.gotoAndStop("disable");
         }
      }
      
      private function setupAmount() : void
      {
         this.amountField = view.getChildByName("amountField") as TextField;
         var _loc1_:String = !!data.amount ? String(data.amount) : "0";
         this.amountField.text = "x" + _loc1_;
      }
      
      override public function refresh(param1:Object = null) : void
      {
         super.refresh(param1);
         this.setup();
      }
   }
}

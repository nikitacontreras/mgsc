package com.qb9.gaturro.view.components.banner.gatubers
{
   import com.qb9.gaturro.globals.logger;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class Billing extends BannerState
   {
       
      
      public function Billing(param1:GatubersLiveBanner)
      {
         super(param1);
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         (param1.currentTarget as MovieClip).gotoAndStop("over");
      }
      
      private function showAction() : void
      {
         banner.action.visible = true;
         banner.action.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         banner.action.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         banner.action.addEventListener(MouseEvent.CLICK,this.onAction);
         banner.action.label.text = banner.settings.bill.action;
      }
      
      private function onAction(param1:MouseEvent) : void
      {
         this.removeListeners();
         logger.debug(this,banner.result.asJSONString());
         banner.switchState(banner.createVideo);
      }
      
      override public function enter() : void
      {
         banner.hideAll();
         banner.information.visible = true;
         banner.information.text = banner.settings.bill.information;
         banner.billMenu.visible = true;
         this.setup();
      }
      
      private function removeListeners() : void
      {
         banner.action.removeEventListener(MouseEvent.CLICK,this.onAction);
         banner.action.removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         banner.action.removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
      }
      
      private function setup() : void
      {
         banner.billMenu.total_txt.text = banner.totalPrice.value.toString();
         banner.action.addEventListener(MouseEvent.CLICK,this.onAction);
         banner.action.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         banner.action.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         this.showAction();
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         (param1.currentTarget as MovieClip).gotoAndStop("out");
      }
   }
}

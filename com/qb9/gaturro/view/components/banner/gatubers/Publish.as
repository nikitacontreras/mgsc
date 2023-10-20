package com.qb9.gaturro.view.components.banner.gatubers
{
   import com.qb9.gaturro.globals.logger;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class Publish extends BannerState
   {
       
      
      private var publishEnabled:String = "1";
      
      public function Publish(param1:GatubersLiveBanner)
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
         banner.action.label.text = banner.settings.publish.action;
      }
      
      private function onAction(param1:MouseEvent) : void
      {
         this.removeListeners();
         banner.result.isPublic = this.publishEnabled == "1" ? true : false;
         logger.debug(this,banner.result.asJSONString());
         banner.switchState(banner.billing);
      }
      
      override public function enter() : void
      {
         banner.hideAll();
         banner.information.visible = true;
         banner.information.text = banner.settings.publish.information;
         this.setup();
      }
      
      private function onClick(param1:Event) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         if(_loc2_.currentLabel == "off")
         {
            (param1.currentTarget as MovieClip).gotoAndStop("on");
            this.publishEnabled = "1";
         }
         else
         {
            (param1.currentTarget as MovieClip).gotoAndStop("off");
            this.publishEnabled = "0";
         }
      }
      
      private function removeListeners() : void
      {
         banner.publishMenu.check.removeEventListener(MouseEvent.CLICK,this.onClick);
         banner.action.removeEventListener(MouseEvent.CLICK,this.onAction);
         banner.action.removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         banner.action.removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
      }
      
      private function setup() : void
      {
         banner.publishMenu.visible = true;
         banner.publishMenu.title = banner.settings.publish.field;
         banner.publishMenu.check.visible = true;
         banner.publishMenu.blocked.visible = banner.settings.publish.blocked;
         banner.publishMenu.check.gotoAndStop("on");
         banner.publishMenu.check.addEventListener(MouseEvent.CLICK,this.onClick);
         this.showAction();
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         (param1.currentTarget as MovieClip).gotoAndStop("out");
      }
   }
}

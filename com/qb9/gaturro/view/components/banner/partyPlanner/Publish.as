package com.qb9.gaturro.view.components.banner.partyPlanner
{
   import com.qb9.gaturro.globals.api;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class Publish extends BannerState
   {
       
      
      private var publishEnabled:String = "1";
      
      public function Publish(param1:PartyPlanner)
      {
         super(param1);
      }
      
      private function onAction(param1:MouseEvent) : void
      {
         this.removeListeners();
         banner.result.isPublic = this.publishEnabled == "1";
         banner.switchState(banner.billing);
      }
      
      override public function enter() : void
      {
         banner.hideAll();
         banner.information.visible = true;
         banner.information.gotoAndStop("publish");
         api.trackEvent("FIESTAS:PLANNER_BANNER","publish");
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
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         (param1.currentTarget as MovieClip).gotoAndStop("over");
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
         banner.publishMenu.title = banner.settings.publishMenu["publish"];
         banner.publishMenu.check.visible = true;
         banner.publishMenu.blocked.visible = false;
         banner.publishMenu.check.gotoAndStop("on");
         banner.publishMenu.check.addEventListener(MouseEvent.CLICK,this.onClick);
         banner.action.visible = true;
         banner.action.label.text = "SIGUIENTE";
         banner.action.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         banner.action.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         banner.action.addEventListener(MouseEvent.CLICK,this.onAction);
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         (param1.currentTarget as MovieClip).gotoAndStop("out");
      }
   }
}

package com.qb9.gaturro.view.components.banner.partyPlanner
{
   import com.qb9.gaturro.globals.api;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class Billing extends BannerState
   {
       
      
      public function Billing(param1:PartyPlanner)
      {
         super(param1);
      }
      
      private function onAction(param1:MouseEvent) : void
      {
         this.removeListeners();
         banner.switchState(banner.createParty);
      }
      
      override public function enter() : void
      {
         banner.hideAll();
         banner.information.visible = false;
         banner.billMenu.visible = true;
         banner.action.visible = true;
         banner.action.label.text = "SIGUIENTE";
         api.trackEvent("FIESTAS:PLANNER_BANNER","billing");
         this.setup();
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         (param1.currentTarget as MovieClip).gotoAndStop("over");
      }
      
      private function removeListeners() : void
      {
         banner.action.removeEventListener(MouseEvent.CLICK,this.onAction);
         banner.action.removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         banner.action.removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
      }
      
      private function getPartyTypeName() : String
      {
         var _loc2_:Object = null;
         var _loc1_:Object = banner.settings.typeMenu;
         for each(_loc2_ in _loc1_)
         {
            if(_loc2_.hasOwnProperty("id") && _loc2_["id"] == banner.result.type)
            {
               return _loc2_.title;
            }
         }
         return "";
      }
      
      private function setup() : void
      {
         banner.billMenu.type_txt.text = this.getPartyTypeName();
         banner.billMenu.type_price_txt.text = banner.typePrice;
         banner.billMenu.duration_price_txt.text = banner.durationPrice;
         banner.billMenu.services_price_txt.text = banner.featuresPrice + banner.prizesPrice;
         banner.billMenu.total_txt.text = banner.total();
         banner.action.addEventListener(MouseEvent.CLICK,this.onAction);
         banner.action.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         banner.action.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         (param1.currentTarget as MovieClip).gotoAndStop("out");
      }
   }
}

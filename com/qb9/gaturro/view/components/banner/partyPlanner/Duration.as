package com.qb9.gaturro.view.components.banner.partyPlanner
{
   import com.qb9.flashlib.tasks.Timeout;
   import com.qb9.gaturro.globals.api;
   import flash.events.MouseEvent;
   
   public class Duration extends BannerState
   {
       
      
      private var btnsLabels:Array;
      
      public function Duration(param1:PartyPlanner)
      {
         this.btnsLabels = ["btn_0","btn_1","btn_2"];
         super(param1);
      }
      
      private function gotoFeatures() : void
      {
         banner.switchState(banner.features);
      }
      
      override public function enter() : void
      {
         banner.hideAll();
         api.trackEvent("FIESTAS:PLANNER_BANNER","duration");
         if(banner.result.type == "mate")
         {
            banner.result.duration = 15 * 60000;
            banner.durationPrice = 0;
            banner.taskRunner.add(new Timeout(this.gotoFeatures,1));
            return;
         }
         if(banner.result.type == "carnaval")
         {
            banner.result.duration = 15 * 60000;
            banner.durationPrice = 0;
            banner.taskRunner.add(new Timeout(this.gotoFeatures,1));
            return;
         }
         banner.information.visible = true;
         banner.information.gotoAndStop("duration");
         banner.durationsMenu.visible = true;
         this.setup();
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         this.removeListeners();
         var _loc2_:String = String(param1.currentTarget.name);
         banner.result.duration = banner.settings.durationsMenu[_loc2_].value * 60000;
         banner.durationPrice = banner.settings.durationsMenu[_loc2_].price;
         banner.taskRunner.add(new Timeout(this.gotoFeatures,100));
      }
      
      private function removeListeners() : void
      {
         var _loc1_:String = null;
         for each(_loc1_ in this.btnsLabels)
         {
            banner.typeMenu[_loc1_].removeEventListener(MouseEvent.CLICK,this.onClick);
         }
      }
      
      private function setup() : void
      {
         var _loc2_:String = null;
         var _loc1_:Array = banner.settings.durationsMenu.buttons;
         for each(_loc2_ in this.btnsLabels)
         {
            if(_loc1_.indexOf(_loc2_) != -1)
            {
               banner.durationsMenu[_loc2_].blocked.visible = false;
               banner.durationsMenu[_loc2_].btn.field.text = banner.settings.durationsMenu[_loc2_].label;
               banner.durationsMenu[_loc2_].price.text = banner.settings.durationsMenu[_loc2_].price;
               if(Boolean(banner.settings.durationsMenu[_loc2_].needPassport) && !api.user.isCitizen)
               {
                  banner.durationsMenu[_loc2_].blocked.visible = true;
                  banner.durationsMenu[_loc2_].btn.endButton.mouseEnabled = false;
               }
               else
               {
                  banner.durationsMenu[_loc2_].addEventListener(MouseEvent.CLICK,this.onClick);
               }
            }
            else
            {
               banner.durationsMenu[_loc2_].visible = false;
            }
         }
      }
   }
}

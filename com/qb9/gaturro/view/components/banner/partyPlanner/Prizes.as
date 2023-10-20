package com.qb9.gaturro.view.components.banner.partyPlanner
{
   import com.qb9.flashlib.tasks.Timeout;
   import com.qb9.gaturro.globals.api;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class Prizes extends BannerState
   {
       
      
      private var currentSelection:int = -1;
      
      private var btnsLabels:Array;
      
      public function Prizes(param1:PartyPlanner)
      {
         this.btnsLabels = ["prizes_0","prizes_1","prizes_2"];
         super(param1);
      }
      
      private function deselectAll() : void
      {
         var _loc1_:String = null;
         for each(_loc1_ in this.btnsLabels)
         {
            (banner.prizesMenu[_loc1_] as MovieClip).gotoAndStop("out");
         }
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         var _loc2_:String = String(param1.currentTarget.name);
         if(this.btnsLabels.indexOf(_loc2_) == this.currentSelection)
         {
            return;
         }
         (param1.currentTarget as MovieClip).gotoAndStop("out");
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         this.deselectAll();
         this.removeListeners();
         (param1.currentTarget as MovieClip).gotoAndStop("on");
         var _loc2_:String = String(param1.currentTarget.name);
         this.currentSelection = this.btnsLabels.indexOf(_loc2_);
         banner.prizesPrice = int(param1.currentTarget.price.text);
         banner.givingPrizes = this.currentSelection;
         banner.taskRunner.add(new Timeout(this.gotoPublish,2000));
      }
      
      private function gotoPublish() : void
      {
         banner.switchState(banner.publish);
      }
      
      override public function enter() : void
      {
         banner.hideAll();
         banner.information.visible = true;
         banner.information.gotoAndStop("prizes");
         banner.prizesMenu.visible = true;
         api.trackEvent("FIESTAS:PLANNER_BANNER","prizes");
         this.setup();
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:String = String(param1.currentTarget.name);
         if(this.btnsLabels.indexOf(_loc2_) == this.currentSelection)
         {
            return;
         }
         (param1.currentTarget as MovieClip).gotoAndStop("over");
      }
      
      private function removeListeners() : void
      {
         var _loc1_:String = null;
         for each(_loc1_ in this.btnsLabels)
         {
            banner.prizesMenu[_loc1_].removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
            banner.prizesMenu[_loc1_].removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
            banner.prizesMenu[_loc1_].removeEventListener(MouseEvent.CLICK,this.onClick);
         }
      }
      
      private function setup() : void
      {
         var _loc1_:String = null;
         for each(_loc1_ in this.btnsLabels)
         {
            if(this.btnsLabels.indexOf(_loc1_) != -1)
            {
               banner.prizesMenu[_loc1_].price.text = banner.settings.prizesMenu[_loc1_].price;
               banner.prizesMenu[_loc1_].title.text = banner.settings.prizesMenu[_loc1_].title;
               banner.prizesMenu[_loc1_].gold.qty.text = banner.settings.prizesMenu[_loc1_].qty[0];
               banner.prizesMenu[_loc1_].silver.qty.text = banner.settings.prizesMenu[_loc1_].qty[1];
               banner.prizesMenu[_loc1_].bronze.qty.text = banner.settings.prizesMenu[_loc1_].qty[2];
               banner.prizesMenu[_loc1_].blocked.visible = false;
               if(Boolean(banner.settings.prizesMenu[_loc1_].needPassport) && !api.user.isCitizen)
               {
                  banner.prizesMenu[_loc1_].blocked.visible = true;
                  banner.prizesMenu[_loc1_].mouseEnabled = false;
                  banner.prizesMenu[_loc1_].mouseChildren = false;
               }
               else
               {
                  banner.prizesMenu[_loc1_].addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
                  banner.prizesMenu[_loc1_].addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
                  banner.prizesMenu[_loc1_].addEventListener(MouseEvent.CLICK,this.onClick);
               }
            }
            else
            {
               banner.prizesMenu[_loc1_].visible = false;
            }
         }
      }
      
      override public function exit() : void
      {
         banner.hideAll();
         banner.information.visible = true;
         banner.prizesMenu.visible = false;
      }
   }
}

package com.qb9.gaturro.view.components.banner.partyPlanner
{
   import com.qb9.flashlib.tasks.Timeout;
   import com.qb9.gaturro.globals.api;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class Mateada extends BannerState
   {
       
      
      private var currentSelection:int = -1;
      
      private var btnsLabels:Array;
      
      public function Mateada(param1:PartyPlanner)
      {
         this.btnsLabels = ["bkg_0","bkg_1"];
         super(param1);
      }
      
      private function deselectAll() : void
      {
         var _loc1_:String = null;
         for each(_loc1_ in this.btnsLabels)
         {
            (banner.mateadaBackground[_loc1_] as MovieClip).gotoAndStop("out");
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
         banner.mateBackgroundPrice = int(param1.currentTarget.price.text);
         banner.mateBackground = this.currentSelection;
         banner.taskRunner.add(new Timeout(this.gotoBilling,2000));
      }
      
      override public function enter() : void
      {
         banner.hideAll();
         banner.information.visible = true;
         banner.information.gotoAndStop("mateada");
         banner.mateadaBackground.visible = true;
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
            banner.mateadaBackground[_loc1_].removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
            banner.mateadaBackground[_loc1_].removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
            banner.mateadaBackground[_loc1_].removeEventListener(MouseEvent.CLICK,this.onClick);
         }
      }
      
      private function setup() : void
      {
         var _loc1_:String = null;
         for each(_loc1_ in this.btnsLabels)
         {
            if(this.btnsLabels.indexOf(_loc1_) != -1)
            {
               banner.mateadaBackground[_loc1_].price.text = banner.settings.mateadaBackground[_loc1_].price;
               banner.mateadaBackground[_loc1_].title.text = banner.settings.mateadaBackground[_loc1_].title;
               banner.mateadaBackground[_loc1_].blocked.visible = false;
               banner.mateadaBackground[_loc1_].icon.gotoAndStop(banner.settings.mateadaBackground[_loc1_].id);
               if(Boolean(banner.settings.mateadaBackground[_loc1_].needPassport) && !api.user.isCitizen)
               {
                  banner.mateadaBackground[_loc1_].blocked.visible = true;
                  banner.mateadaBackground[_loc1_].mouseEnabled = false;
                  banner.mateadaBackground[_loc1_].mouseChildren = false;
               }
               else
               {
                  banner.mateadaBackground[_loc1_].addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
                  banner.mateadaBackground[_loc1_].addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
                  banner.mateadaBackground[_loc1_].addEventListener(MouseEvent.CLICK,this.onClick);
               }
            }
            else
            {
               banner.mateadaBackground[_loc1_].visible = false;
            }
         }
      }
      
      override public function exit() : void
      {
         banner.hideAll();
         banner.information.visible = true;
         banner.mateadaBackground.visible = false;
      }
      
      private function gotoBilling() : void
      {
         banner.switchState(banner.billing);
      }
   }
}

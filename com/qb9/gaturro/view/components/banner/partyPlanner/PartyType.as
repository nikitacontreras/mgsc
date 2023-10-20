package com.qb9.gaturro.view.components.banner.partyPlanner
{
   import com.qb9.flashlib.tasks.Timeout;
   import com.qb9.gaturro.globals.api;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class PartyType extends BannerState
   {
       
      
      private var currentSelection:int = -1;
      
      private var btnsLabels:Array;
      
      public function PartyType(param1:PartyPlanner)
      {
         this.btnsLabels = ["btn_0","btn_1","btn_2","btn_3","btn_4","btn_5"];
         super(param1);
      }
      
      private function deselectAll() : void
      {
         var _loc1_:String = null;
         for each(_loc1_ in this.btnsLabels)
         {
            (banner.typeMenu[_loc1_] as MovieClip).gotoAndStop("out");
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
         banner.result.type = banner.settings.typeMenu[_loc2_].id;
         banner.typePrice = banner.settings.typeMenu[_loc2_].price;
         banner.taskRunner.add(new Timeout(this.gotoDurations,1000));
      }
      
      override public function enter() : void
      {
         banner.hideAll();
         banner.information.visible = true;
         banner.information.gotoAndStop("type");
         banner.typeMenu.visible = true;
         api.trackEvent("FIESTAS:PLANNER_BANNER","type");
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
            banner.typeMenu[_loc1_].removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
            banner.typeMenu[_loc1_].removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
            banner.typeMenu[_loc1_].removeEventListener(MouseEvent.CLICK,this.onClick);
         }
      }
      
      private function gotoDurations() : void
      {
         banner.switchState(banner.duration);
      }
      
      private function setup() : void
      {
         var _loc2_:String = null;
         var _loc1_:Array = banner.settings.typeMenu.buttons;
         for each(_loc2_ in this.btnsLabels)
         {
            if(_loc1_.indexOf(_loc2_) != -1)
            {
               banner.typeMenu[_loc2_].price.text = banner.settings.typeMenu[_loc2_].price;
               banner.typeMenu[_loc2_].field.text = banner.settings.typeMenu[_loc2_].title;
               banner.typeMenu[_loc2_].icon.gotoAndStop(banner.settings.typeMenu[_loc2_].id);
               banner.typeMenu[_loc2_].blocked.visible = false;
               if(!banner.settings.typeMenu[_loc2_].available)
               {
                  banner.typeMenu[_loc2_].blocked.visible = true;
               }
               else
               {
                  banner.typeMenu[_loc2_].addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
                  banner.typeMenu[_loc2_].addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
                  banner.typeMenu[_loc2_].addEventListener(MouseEvent.CLICK,this.onClick);
               }
            }
            else
            {
               banner.typeMenu[_loc2_].visible = false;
            }
         }
      }
      
      override public function exit() : void
      {
         banner.typeMenu.visible = false;
      }
   }
}

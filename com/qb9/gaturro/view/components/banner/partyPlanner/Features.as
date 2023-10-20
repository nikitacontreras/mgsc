package com.qb9.gaturro.view.components.banner.partyPlanner
{
   import com.qb9.flashlib.tasks.Timeout;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.service.events.EventsAttributeEnum;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class Features extends BannerState
   {
       
      
      private var btnsLabels:Array;
      
      private var btnsDetails:Object;
      
      public function Features(param1:PartyPlanner)
      {
         this.btnsLabels = ["btn_0","btn_1","btn_2","btn_3","btn_4"];
         super(param1);
      }
      
      private function gotoPublish() : void
      {
         banner.switchState(banner.publish);
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         (param1.currentTarget as MovieClip).gotoAndStop("out");
      }
      
      private function onClick(param1:Event) : void
      {
         var _loc4_:String = null;
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         if(_loc2_.data["type"] == "select")
         {
            for each(_loc4_ in this.btnsLabels)
            {
               banner.featuresMenu[_loc4_].check.gotoAndStop("off");
            }
         }
         if(_loc2_.currentLabel == "off")
         {
            (param1.currentTarget as MovieClip).gotoAndStop("on");
         }
         else
         {
            (param1.currentTarget as MovieClip).gotoAndStop("off");
         }
         var _loc3_:int = this.btnsLabels.indexOf(_loc2_.parent.name);
      }
      
      private function gotoMateada() : void
      {
         banner.switchState(banner.matesBck);
      }
      
      private function setupActionBtn(param1:String) : void
      {
         banner.action.visible = true;
         banner.action.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         banner.action.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         banner.action.addEventListener(MouseEvent.CLICK,this.onAction);
         banner.action.label.text = param1;
      }
      
      private function setCharAt(param1:String, param2:String, param3:int) : String
      {
         return param1.substr(0,param3) + param2 + param1.substr(param3 + 1);
      }
      
      private function onAction(param1:MouseEvent) : void
      {
         this.removeListeners();
         var _loc2_:String = "00000";
         var _loc3_:Number = 0;
         var _loc4_:int = 0;
         while(_loc4_ < this.btnsLabels.length)
         {
            if((banner.featuresMenu[this.btnsLabels[_loc4_]].check as MovieClip).currentLabel == "on")
            {
               _loc2_ = this.setCharAt(_loc2_,"1",_loc4_);
               _loc3_ += this.btnsDetails[this.btnsLabels[_loc4_]].price;
            }
            _loc4_++;
         }
         (param1.currentTarget as MovieClip).gotoAndStop("out");
         banner.result.features = _loc2_;
         banner.featuresPrice = _loc3_;
         if(banner.result.type == EventsAttributeEnum.ELITE_PARTY)
         {
            banner.taskRunner.add(new Timeout(this.gotoPrizes,100));
         }
         else if(banner.result.type == EventsAttributeEnum.MATEADA_PARTY)
         {
            _loc2_ = _loc2_ == "00000" ? this.setCharAt(_loc2_,"1",0) : _loc2_;
            banner.result.features = _loc2_;
            banner.taskRunner.add(new Timeout(this.gotoMateada,100));
         }
         else
         {
            banner.taskRunner.add(new Timeout(this.gotoPublish,100));
         }
      }
      
      override public function enter() : void
      {
         banner.hideAll();
         banner.information.visible = true;
         banner.information.gotoAndStop("features");
         if(banner.result.type == EventsAttributeEnum.MATEADA_PARTY)
         {
            banner.result.features = "00000";
            banner.featuresPrice = 0;
            this.gotoMateada();
            return;
         }
         banner.featuresMenu.visible = true;
         api.trackEvent("FIESTAS:PLANNER_BANNER","features");
         this.setup();
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         (param1.currentTarget as MovieClip).gotoAndStop("over");
      }
      
      private function removeListeners() : void
      {
         var _loc1_:String = null;
         for each(_loc1_ in this.btnsLabels)
         {
            banner.featuresMenu[_loc1_].check.removeEventListener(MouseEvent.CLICK,this.onClick);
         }
         banner.action.removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         banner.action.removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         banner.action.removeEventListener(MouseEvent.CLICK,this.onAction);
      }
      
      private function gotoPrizes() : void
      {
         banner.switchState(banner.prizes);
      }
      
      private function setup() : void
      {
         var _loc2_:String = null;
         this.btnsDetails = banner.settings.featuresMenu[banner.result.type];
         if(!this.btnsDetails)
         {
            banner.result.features = "00000";
            banner.featuresPrice = 0;
            this.gotoPublish();
            return;
         }
         var _loc1_:Array = this.btnsDetails.buttons;
         this.setupActionBtn(this.btnsDetails.action);
         for each(_loc2_ in this.btnsLabels)
         {
            if(_loc1_.indexOf(_loc2_) != -1)
            {
               banner.featuresMenu[_loc2_].title.text = this.btnsDetails[_loc2_].title;
               banner.featuresMenu[_loc2_].price.text = this.btnsDetails[_loc2_].price;
               banner.featuresMenu[_loc2_].check.visible = true;
               banner.featuresMenu[_loc2_].blocked.visible = false;
               if(Boolean(this.btnsDetails[_loc2_].needPassport) && !api.user.isCitizen)
               {
                  banner.featuresMenu[_loc2_].blocked.visible = true;
                  banner.featuresMenu[_loc2_].check.visible = false;
                  banner.featuresMenu[_loc2_].mouseEnabled = false;
                  banner.featuresMenu[_loc2_].mouseChildren = false;
               }
               else
               {
                  banner.featuresMenu[_loc2_].check.addEventListener(MouseEvent.CLICK,this.onClick);
                  banner.featuresMenu[_loc2_].check.data = {"type":this.btnsDetails[_loc2_].type};
               }
            }
            else
            {
               banner.featuresMenu[_loc2_].visible = false;
            }
         }
      }
   }
}

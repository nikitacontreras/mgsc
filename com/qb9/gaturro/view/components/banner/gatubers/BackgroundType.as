package com.qb9.gaturro.view.components.banner.gatubers
{
   import com.qb9.flashlib.tasks.Timeout;
   import com.qb9.flashlib.utils.ArrayUtil;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.service.events.EventsAttributeEnum;
   import com.qb9.gaturro.service.events.roomviews.EventsRoomsEnum;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class BackgroundType extends BannerState
   {
       
      
      private var currentSelection:int = -1;
      
      private var btnsLabels:Array;
      
      public function BackgroundType(param1:GatubersLiveBanner)
      {
         this.btnsLabels = ["btn_0","btn_1","btn_2","btn_3"];
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
         (param1.currentTarget as MovieClip).gotoAndStop("on");
         var _loc2_:String = String(param1.currentTarget.name);
         this.currentSelection = this.btnsLabels.indexOf(_loc2_);
         this.removeListeners();
         banner.addExpense(param1.currentTarget.data.price);
         logger.debug(this,param1.currentTarget.data.room);
         var _loc3_:Array = EventsRoomsEnum[param1.currentTarget.data.room] as Array;
         banner.result.roomID = int(ArrayUtil.choice(_loc3_));
         banner.result.type = EventsAttributeEnum.GATUBERS_LIVE;
         banner.taskRunner.add(new Timeout(this.gotoDurations,1000));
         logger.info(this,banner.result.asJSONString());
      }
      
      private function configureBtn(param1:MovieClip, param2:Object) : void
      {
         param1.price.text = param2.price;
         param1.field.text = param2.field;
         param1.icon.gotoAndStop(param2.icon);
         param1.blocked.visible = param2.blocked;
         param1.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         param1.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         param1.addEventListener(MouseEvent.CLICK,this.onClick);
         param1.data = param2;
      }
      
      override public function enter() : void
      {
         banner.hideAll();
         banner.information.visible = true;
         banner.information.text = banner.settings.type.information;
         banner.typeMenu.visible = true;
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
         var _loc1_:Array = banner.settings.type.buttons;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            this.configureBtn(banner.typeMenu[this.btnsLabels[_loc2_]],_loc1_[_loc2_]);
            _loc2_++;
         }
      }
      
      override public function exit() : void
      {
         banner.hideAll();
         banner.information.visible = true;
         banner.typeMenu.visible = false;
      }
   }
}

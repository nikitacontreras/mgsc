package com.qb9.gaturro.view.components.banner.gatubers
{
   import com.qb9.flashlib.tasks.Timeout;
   import com.qb9.gaturro.globals.logger;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class Duration extends BannerState
   {
       
      
      private var value:int;
      
      private var btnsLabels:Array;
      
      public function Duration(param1:GatubersLiveBanner)
      {
         this.btnsLabels = ["btn_0","btn_1","btn_2"];
         super(param1);
      }
      
      private function gotoPublish() : void
      {
         banner.switchState(banner.publish);
      }
      
      override public function enter() : void
      {
         banner.hideAll();
         banner.information.visible = true;
         banner.information.text = banner.settings.duration.information;
         banner.durationsMenu.visible = true;
         this.setup();
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         this.removeListeners();
         var _loc2_:String = String(param1.currentTarget.name);
         banner.result.duration = param1.currentTarget.data.value * 60000;
         banner.addExpense(param1.currentTarget.data.price);
         banner.taskRunner.add(new Timeout(this.gotoPublish,100));
         logger.info(this,banner.result.asJSONString());
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
         var _loc1_:Array = banner.settings.duration.buttons;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            this.configureButton(banner.durationsMenu[this.btnsLabels[_loc2_]],_loc1_[_loc2_]);
            _loc2_++;
         }
      }
      
      private function configureButton(param1:MovieClip, param2:Object) : void
      {
         param1.blocked.visible = param2.blocked;
         param1.btn.field.text = param2.field;
         param1.price.text = param2.price;
         param1.addEventListener(MouseEvent.CLICK,this.onClick);
         param1.data = param2;
      }
   }
}

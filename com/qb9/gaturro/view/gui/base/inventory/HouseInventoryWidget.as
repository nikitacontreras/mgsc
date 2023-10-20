package com.qb9.gaturro.view.gui.base.inventory
{
   import com.qb9.gaturro.view.components.repeater.config.NavegableRepeaterConfig;
   
   public class HouseInventoryWidget extends InventoryWidget
   {
       
      
      public function HouseInventoryWidget(param1:uint, param2:uint, param3:Boolean, param4:Function = null, param5:Object = null, param6:String = null)
      {
         super(param1,param2,param3,param4,param5,param6);
      }
      
      override protected function getRepeaterConfig() : NavegableRepeaterConfig
      {
         return super.getRepeaterConfig();
      }
      
      override protected function drawBackground() : void
      {
      }
      
      public function get repeaterConfig() : NavegableRepeaterConfig
      {
         return this.getRepeaterConfig();
      }
      
      override protected function outerMarginX() : int
      {
         return 0;
      }
   }
}

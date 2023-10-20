package com.qb9.gaturro.view.gui.base.inventory
{
   public class OwnedNpcInventoryWidget extends HouseInventoryWidget
   {
       
      
      public function OwnedNpcInventoryWidget(param1:uint, param2:uint, param3:Boolean, param4:Function = null, param5:Object = null)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override protected function drawBackground() : void
      {
      }
      
      override protected function outerMarginX() : int
      {
         return 0;
      }
   }
}

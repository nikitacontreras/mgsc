package com.qb9.gaturro.view.gui.sell
{
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.view.gui.base.itemList.BaseItemListGuiModalConfirmation;
   
   public final class SellItemGuiModalConfirmation extends BaseItemListGuiModalConfirmation
   {
       
      
      public function SellItemGuiModalConfirmation()
      {
         super(false);
         this.init();
      }
      
      private function init() : void
      {
         region.setText(buy.text,"VENDER");
         region.setText(description,"¿SEGURO QUE QUERÉS VENDER ESTO?");
      }
   }
}

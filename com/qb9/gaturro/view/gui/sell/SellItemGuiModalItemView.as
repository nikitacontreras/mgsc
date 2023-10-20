package com.qb9.gaturro.view.gui.sell
{
   import com.qb9.gaturro.view.gui.base.itemList.items.BaseItemListItemView;
   
   public final class SellItemGuiModalItemView extends BaseItemListItemView
   {
       
      
      public function SellItemGuiModalItemView(param1:Object)
      {
         super(param1);
         this.init();
      }
      
      private function init() : void
      {
         buy_txt.text = "VENDER";
      }
      
      override public function get itemPrice() : Number
      {
         return item.resellPrice;
      }
   }
}

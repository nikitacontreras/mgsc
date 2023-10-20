package com.qb9.gaturro.view.gui.gift
{
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.view.gui.base.itemList.items.BaseItemListItemView;
   
   public final class GiftGuiModalItemView extends BaseItemListItemView
   {
       
      
      public function GiftGuiModalItemView(param1:Object)
      {
         super(param1);
         this.init();
      }
      
      private function init() : void
      {
         region.setText(buy_txt,"REGALAR");
      }
      
      override public function get itemPrice() : Number
      {
         return _item.price;
      }
   }
}

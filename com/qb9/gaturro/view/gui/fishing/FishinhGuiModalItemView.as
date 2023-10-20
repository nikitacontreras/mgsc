package com.qb9.gaturro.view.gui.fishing
{
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.view.gui.base.itemList.items.BaseItemListItemView;
   
   public class FishinhGuiModalItemView extends BaseItemListItemView
   {
       
      
      public function FishinhGuiModalItemView(param1:Object, param2:int)
      {
         super(param1);
         this.init(param2);
      }
      
      private function init(param1:int) : void
      {
         region.setText(buy_txt,"ELEGIR");
         price.visible = true;
         price.text = param1.toString();
         money_txt.visible = false;
      }
   }
}

package com.qb9.gaturro.view.gui.gift
{
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.view.gui.base.itemList.BaseItemListGuiModalConfirmation;
   
   public final class GiftGuiModalConfirmation extends BaseItemListGuiModalConfirmation
   {
       
      
      public function GiftGuiModalConfirmation(param1:String, param2:Boolean)
      {
         super(param2);
         this.init(param1);
      }
      
      private function init(param1:String) : void
      {
         region.setText(buy.text,"REGALAR");
         price.visible = true;
         money_txt.visible = true;
         region.setText(description,"¿SEGURO QUE QUERÉS REGALARLE ESTO A :");
         description.text = description.text + " " + param1.toUpperCase() + "?";
      }
   }
}

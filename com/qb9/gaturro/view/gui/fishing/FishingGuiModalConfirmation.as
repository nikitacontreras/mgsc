package com.qb9.gaturro.view.gui.fishing
{
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.view.gui.base.itemList.BaseItemListGuiModalConfirmation;
   
   public class FishingGuiModalConfirmation extends BaseItemListGuiModalConfirmation
   {
       
      
      public function FishingGuiModalConfirmation()
      {
         super(false);
         this.init();
      }
      
      private function init() : void
      {
         region.setText(buy.text,"OK");
         price.visible = false;
         money_txt.visible = false;
         region.setText(description,"¿ESTÁS SEGURO DE QUE QUIERES ELEGIR ESTA CARNADA?");
      }
   }
}

package com.qb9.gaturro.view.gui.catalog.screens
{
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.util.TextFieldUtil;
   import com.qb9.gaturro.world.catalog.CatalogItem;
   import flash.events.MouseEvent;
   
   public final class CatalogModalErrorScreen extends BaseCatalogModalScreen
   {
       
      
      public function CatalogModalErrorScreen()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         gotoAndStop("invalid");
         region.setText(cancel.text,"OK");
         cancel.addEventListener(MouseEvent.CLICK,hide);
      }
      
      public function showMessage(param1:CatalogItem, param2:String, param3:int, param4:String = "", param5:String = "") : void
      {
         show(param1);
         image.gotoAndStop(1);
         var _loc6_:* = "<a href=\"" + region.getText(settings.info.url_pasaporte) + "\" target=\"_blank\">" + region.key("vip_item_link_text") + "</a>";
         TextFieldUtil.linkContainer(description);
         description.htmlText = TextFieldUtil.htmlUpperCase(param2 + _loc6_);
         region.setText(subtitle,param5.toUpperCase());
         region.setText(title,param4.toUpperCase());
      }
      
      override public function dispose() : void
      {
         cancel.removeEventListener(MouseEvent.CLICK,hide);
         super.dispose();
      }
   }
}

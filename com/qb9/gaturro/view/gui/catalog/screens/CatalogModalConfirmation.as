package com.qb9.gaturro.view.gui.catalog.screens
{
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.world.catalog.CatalogItem;
   import config.PassportControl;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public final class CatalogModalConfirmation extends BaseCatalogModalScreen
   {
       
      
      public function CatalogModalConfirmation()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         region.setText(buy.text,"COMPRAR");
         buy.addEventListener(MouseEvent.CLICK,this.accept);
         region.setText(cancel.text,"CANCELAR");
         cancel.addEventListener(MouseEvent.CLICK,this.hide);
      }
      
      override protected function hide(param1:Event = null) : void
      {
         super.hide(param1);
         dispatchEvent(new Event(Event.CANCEL));
      }
      
      private function accept(param1:Event) : void
      {
         param1.stopImmediatePropagation();
         dispatchEvent(new Event(Event.SELECT));
         this.hide();
      }
      
      override public function show(param1:CatalogItem) : void
      {
         if(PassportControl.isVipPack(param1.name))
         {
            region.setText(subtitle,"ESTAS ADQUIRIENDO UN ITEM QUE SOLO PUEDE USARSE MIENTRAS TENGAS PASAPORTE ACTIVO.\n\nCONFIRMAS LA COMPRA DE:");
         }
         region.setText(description,param1.description);
         price.text = param1.price.toString();
         description.text = description.text.toUpperCase();
         super.show(param1);
      }
      
      override public function dispose() : void
      {
         buy.removeEventListener(MouseEvent.CLICK,this.accept);
         cancel.removeEventListener(MouseEvent.CLICK,this.hide);
         this.hide();
         super.dispose();
      }
   }
}

package com.qb9.gaturro.world.catalog
{
   import flash.events.Event;
   
   public final class CurrencyCatalogEvent extends Event
   {
      
      public static const OPEN:String = "OpenCurrencyCatalog";
       
      
      private var _currency:String;
      
      private var _catalog:com.qb9.gaturro.world.catalog.Catalog;
      
      public function CurrencyCatalogEvent(param1:String, param2:com.qb9.gaturro.world.catalog.Catalog, param3:String)
      {
         super(param1);
         this._currency = param3;
         this._catalog = param2;
      }
      
      public function get currency() : String
      {
         return this._currency;
      }
      
      public function get catalog() : com.qb9.gaturro.world.catalog.Catalog
      {
         return this._catalog;
      }
      
      override public function clone() : Event
      {
         return new CatalogEvent(type,this.catalog);
      }
   }
}

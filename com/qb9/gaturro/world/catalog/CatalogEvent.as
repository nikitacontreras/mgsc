package com.qb9.gaturro.world.catalog
{
   import flash.events.Event;
   
   public final class CatalogEvent extends Event
   {
      
      public static const OPEN:String = "ceOpenCatalog";
       
      
      private var _catalog:com.qb9.gaturro.world.catalog.Catalog;
      
      public function CatalogEvent(param1:String, param2:com.qb9.gaturro.world.catalog.Catalog)
      {
         super(param1);
         this._catalog = param2;
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

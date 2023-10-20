package com.qb9.gaturro.world.catalog
{
   import flash.events.Event;
   
   public final class PetCatalogEvent extends Event
   {
      
      public static const OPEN_PET_CATALOG:String = "ceOpenPetCatalog";
       
      
      private var _catalog:com.qb9.gaturro.world.catalog.Catalog;
      
      private var _petType:String;
      
      public function PetCatalogEvent(param1:String, param2:com.qb9.gaturro.world.catalog.Catalog, param3:String)
      {
         super(param1);
         this._catalog = param2;
         this._petType = param3;
      }
      
      public function get petType() : String
      {
         return this._petType;
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

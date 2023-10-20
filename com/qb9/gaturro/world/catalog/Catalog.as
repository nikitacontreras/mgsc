package com.qb9.gaturro.world.catalog
{
   import com.qb9.flashlib.lang.map;
   import com.qb9.mambo.net.mobject.MobjectBuildable;
   import com.qb9.mines.mobject.Mobject;
   
   public final class Catalog implements MobjectBuildable
   {
       
      
      private var _items:Array;
      
      private var _name:String;
      
      public function Catalog()
      {
         super();
      }
      
      public function get items() : Array
      {
         return this._items.concat();
      }
      
      private function makeItem(param1:Mobject) : CatalogItem
      {
         var _loc2_:CatalogItem = new CatalogItem();
         _loc2_.buildFromMobject(param1);
         return _loc2_;
      }
      
      public function buildFromMobject(param1:Mobject) : void
      {
         this._name = param1.getString("name");
         this._items = map(param1.getMobjectArray("items") || [],this.makeItem);
      }
      
      public function get name() : String
      {
         return this._name;
      }
   }
}

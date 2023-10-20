package com.qb9.gaturro.user.inventory
{
   import com.qb9.gaturro.globals.server;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.mambo.core.attributes.CustomAttributes;
   import com.qb9.mambo.user.inventory.InventorySceneObject;
   
   public class GaturroInventorySceneObject extends InventorySceneObject
   {
       
      
      private var _data:Object;
      
      private const ITEM_DATA_SEPARATOR:String = " @DATA@ ";
      
      public function GaturroInventorySceneObject(param1:CustomAttributes)
      {
         super(param1);
      }
      
      public function get hasData() : Boolean
      {
         return super.name.indexOf(this.ITEM_DATA_SEPARATOR) > -1;
      }
      
      protected function getAttributesWithPreffix(param1:String) : Object
      {
         var _loc5_:String = null;
         var _loc6_:Object = null;
         var _loc2_:Object = {};
         var _loc3_:String = String(this.name.split(".")[0]);
         var _loc4_:int = param1.length;
         for(_loc5_ in attributes)
         {
            if(_loc5_.slice(0,_loc4_) === param1)
            {
               _loc6_ = attributes[_loc5_];
               _loc2_[_loc5_.slice(_loc4_)] = this.parsePreffixAttribute(_loc6_,_loc5_);
            }
         }
         return _loc2_;
      }
      
      public function get resellPrice() : uint
      {
         var _loc1_:uint = Math.floor(this.price * server.resellPriceRatio);
         if(_loc1_ < settings.price.minResellPrice)
         {
            _loc1_ = uint(settings.price.minResellPrice);
         }
         return _loc1_;
      }
      
      public function get price() : uint
      {
         return attributes.price;
      }
      
      override public function get name() : String
      {
         var _loc1_:int = super.name.indexOf(this.ITEM_DATA_SEPARATOR);
         if(_loc1_ > -1)
         {
            return super.name.substr(0,_loc1_);
         }
         return super.name;
      }
      
      public function get questItem() : Boolean
      {
         return attributes.questItem;
      }
      
      protected function parsePreffixAttribute(param1:Object, param2:String) : Object
      {
         return param1;
      }
      
      public function dataByKey(param1:String) : String
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         if(!this._data && this.hasData)
         {
            _loc2_ = super.name.indexOf(this.ITEM_DATA_SEPARATOR);
            _loc3_ = super.name.substr(_loc2_ + this.ITEM_DATA_SEPARATOR.length);
            if(_loc4_ = _loc3_.split(","))
            {
               this._data = {};
               _loc5_ = 0;
               while(_loc5_ < _loc4_.length)
               {
                  _loc6_ = _loc4_[_loc5_].split(":");
                  this._data[_loc6_[0]] = _loc6_[1];
                  _loc5_++;
               }
            }
         }
         if(Boolean(this._data) && param1 in this._data)
         {
            return this._data[param1];
         }
         return "";
      }
      
      public function get stackBy() : int
      {
         return int(attributes.stackBy) || 1;
      }
   }
}

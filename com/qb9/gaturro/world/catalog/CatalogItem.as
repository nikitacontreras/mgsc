package com.qb9.gaturro.world.catalog
{
   import com.adobe.serialization.json.JSON;
   import com.qb9.mambo.net.mobject.MobjectBuildable;
   import com.qb9.mines.mobject.Mobject;
   
   public final class CatalogItem implements MobjectBuildable
   {
       
      
      private var _oldPrice:Number;
      
      private var _data:Object;
      
      private var _price:Number;
      
      private var _promo:String;
      
      private var _newItem:Boolean;
      
      private var _limited:Boolean;
      
      private var _buildTime:int;
      
      private var _category:String;
      
      private var _vip:Boolean;
      
      private var _name:String;
      
      private const ITEM_DATA_SEPARATOR:String = " @DATA@ ";
      
      private var _countries:String;
      
      private var _description:String;
      
      private var _tags:Array;
      
      public function CatalogItem()
      {
         super();
      }
      
      public function get description() : String
      {
         return this._description;
      }
      
      public function get category() : String
      {
         return this._category;
      }
      
      public function get buildTime() : int
      {
         return this._buildTime;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function buildFromMobject(param1:Mobject) : void
      {
         var _loc3_:Object = null;
         var _loc2_:String = param1.getString("datajs");
         if(Boolean(_loc2_) && _loc2_.length > 1)
         {
            _loc3_ = com.adobe.serialization.json.JSON.decode(param1.getString("datajs"));
            this._newItem = !!_loc3_.newItem ? Boolean(_loc3_.newItem) : false;
            this._category = !!_loc3_.category ? String(_loc3_.category) : "";
            this._tags = !!_loc3_.tags ? _loc3_.tags : null;
         }
         this.processName(param1.getString("name"));
         this._description = param1.getString("description");
         this._price = param1.getFloat("price");
         this._vip = param1.getBoolean("vip");
         this._promo = param1.getString("promo");
         this._oldPrice = param1.getFloat("oldPrice");
         this._buildTime = param1.getInteger("buildTime");
         this._limited = param1.getBoolean("limited");
         this._countries = param1.getString("countries");
      }
      
      public function get promo() : String
      {
         return this._promo;
      }
      
      public function get newItem() : Boolean
      {
         return this._newItem;
      }
      
      public function get price() : Number
      {
         return this._price;
      }
      
      private function processName(param1:String) : void
      {
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         var _loc2_:int = param1.indexOf(this.ITEM_DATA_SEPARATOR);
         if(_loc2_ > -1)
         {
            this._name = param1.substr(0,_loc2_);
            _loc3_ = param1.substr(_loc2_ + this.ITEM_DATA_SEPARATOR.length);
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
         else
         {
            this._name = param1;
         }
      }
      
      private function dataString() : String
      {
         var _loc2_:String = null;
         var _loc1_:String = "";
         for(_loc2_ in this._data)
         {
            _loc1_ += _loc2_ + ":" + this.dataByKey(_loc2_);
         }
         return _loc1_;
      }
      
      public function get vip() : Boolean
      {
         return this._vip;
      }
      
      public function get fullName() : String
      {
         if(this._data)
         {
            return this._name + this.ITEM_DATA_SEPARATOR + this.dataString();
         }
         return this.name;
      }
      
      public function get oldPrice() : Number
      {
         return this._oldPrice;
      }
      
      public function get limited() : Boolean
      {
         return this._limited;
      }
      
      public function get countries() : String
      {
         return this._countries;
      }
      
      public function get tags() : Array
      {
         return !!this.tags ? this.tags : new Array();
      }
      
      public function dataByKey(param1:String) : String
      {
         if(Boolean(this._data) && param1 in this._data)
         {
            return this._data[param1];
         }
         return "";
      }
   }
}

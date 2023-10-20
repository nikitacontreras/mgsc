package com.qb9.gaturro.model.config.crafting.definition
{
   public class CraftingBannerDefinition
   {
       
      
      private var _name:String;
      
      private var _banner:String;
      
      private var _code:int;
      
      private var _asset:String;
      
      private var _itemrendererAsset:String;
      
      public function CraftingBannerDefinition(param1:String, param2:int, param3:String, param4:String, param5:String)
      {
         super();
         this._name = param1;
         this._code = param2;
         this._banner = param3;
         this._asset = param4;
         this._itemrendererAsset = param5;
      }
      
      public function get banner() : String
      {
         return this._banner;
      }
      
      public function get code() : int
      {
         return this._code;
      }
      
      public function get asset() : String
      {
         return this._asset;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get itemrendererAsset() : String
      {
         return this._itemrendererAsset;
      }
   }
}

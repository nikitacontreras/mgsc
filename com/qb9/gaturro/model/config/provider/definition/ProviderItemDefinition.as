package com.qb9.gaturro.model.config.provider.definition
{
   public class ProviderItemDefinition
   {
       
      
      private var _data:Object;
      
      private var _amount:int;
      
      private var _modelItemId:String;
      
      private var _item;
      
      private var _id:Object;
      
      public function ProviderItemDefinition(param1:*, param2:*, param3:int, param4:String = "ProviderItemModel", param5:Object = null)
      {
         super();
         this._id = param1;
         this._item = param2;
         this._amount = param3;
         this._data = param5;
         this._modelItemId = param4;
      }
      
      public function get item() : *
      {
         return this._item;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function get id() : Object
      {
         return this._id;
      }
      
      public function get modelItemId() : String
      {
         return this._modelItemId;
      }
      
      public function get amount() : int
      {
         return this._amount;
      }
   }
}

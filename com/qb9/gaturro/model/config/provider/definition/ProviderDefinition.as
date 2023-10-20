package com.qb9.gaturro.model.config.provider.definition
{
   public class ProviderDefinition
   {
       
      
      private var _modelClassId:String;
      
      private var _name:String;
      
      private var _hasNextConstraint:Object;
      
      private var _itemList:Array;
      
      private var _data:Object;
      
      private var _strategy:String;
      
      public function ProviderDefinition(param1:String, param2:Array, param3:String, param4:Object, param5:String = "ProviderModel", param6:Object = null)
      {
         super();
         this._hasNextConstraint = param4;
         this._modelClassId = param5;
         this._name = param1;
         this._itemList = param2;
         this._strategy = param3;
         this._data = param6;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get modelClassId() : String
      {
         return this._modelClassId;
      }
      
      public function get itemList() : Array
      {
         return this._itemList;
      }
      
      public function get hasNextConstraint() : Object
      {
         return this._hasNextConstraint;
      }
      
      public function get strategy() : String
      {
         return this._strategy;
      }
   }
}

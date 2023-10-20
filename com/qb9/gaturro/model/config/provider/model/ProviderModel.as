package com.qb9.gaturro.model.config.provider.model
{
   import com.qb9.gaturro.commons.iterator.IIterator;
   import com.qb9.gaturro.commons.iterator.Iterator;
   import com.qb9.gaturro.model.config.provider.definition.ProviderDefinition;
   import flash.utils.Dictionary;
   
   public class ProviderModel
   {
       
      
      private var itemList:Dictionary;
      
      private var _definition:ProviderDefinition;
      
      public function ProviderModel(param1:ProviderDefinition)
      {
         super();
         this._definition = param1;
         this.setup();
      }
      
      public function recordDelivery(param1:*, param2:int = 1) : void
      {
         var _loc3_:ProviderItemModel = this.itemList[param1];
         if(!_loc3_)
         {
            throw new Error("There is no ProviderItemModel instance stored with id= " + param1);
         }
         _loc3_.recordDelivery(param2);
      }
      
      public function addModel(param1:ProviderItemModel) : void
      {
         this.itemList[param1.id] = param1;
      }
      
      public function get definition() : ProviderDefinition
      {
         return this._definition;
      }
      
      private function setup() : void
      {
         this.itemList = new Dictionary();
      }
      
      public function get iterator() : IIterator
      {
         var _loc1_:IIterator = new Iterator();
         _loc1_.setupIterable(this.itemList);
         return _loc1_;
      }
   }
}

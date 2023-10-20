package com.qb9.gaturro.model.config.provider.model
{
   import com.qb9.gaturro.model.config.provider.definition.ProviderDefinition;
   import com.qb9.gaturro.model.config.provider.definition.ProviderItemDefinition;
   import com.qb9.gaturro.model.config.provider.model.impl.SerenitoProviderItemModel;
   import com.qb9.gaturro.model.config.provider.model.impl.SerenitoProviderModel;
   import flash.utils.Dictionary;
   
   public class ProviderModelFactory
   {
       
      
      private var map:Dictionary;
      
      public function ProviderModelFactory()
      {
         super();
         this.setup();
      }
      
      private function setup() : void
      {
         this.map = new Dictionary();
         this.map["ProviderModel"] = ProviderModel;
         this.map["ProviderItemModel"] = ProviderItemModel;
         this.map["SerenitoProviderModel"] = SerenitoProviderModel;
         this.map["SerenitoProviderItemModel"] = SerenitoProviderItemModel;
      }
      
      public function build(param1:ProviderDefinition) : ProviderModel
      {
         var _loc2_:Class = this.map[param1.modelClassId];
         var _loc3_:ProviderModel = new _loc2_(param1) as ProviderModel;
         this.buildItemModel(param1,_loc3_);
         return _loc3_;
      }
      
      private function buildItemModel(param1:ProviderDefinition, param2:ProviderModel) : void
      {
         var _loc3_:Class = null;
         var _loc4_:ProviderItemModel = null;
         var _loc5_:ProviderItemDefinition = null;
         for each(_loc5_ in param1.itemList)
         {
            _loc3_ = this.map[_loc5_.modelItemId];
            _loc4_ = new _loc3_(_loc5_) as ProviderItemModel;
            param2.addModel(_loc4_);
         }
      }
   }
}

package com.qb9.gaturro.model.config.provider
{
   import com.qb9.gaturro.commons.model.config.BaseSettingsConfig;
   import com.qb9.gaturro.model.config.provider.definition.ProviderDefinition;
   import com.qb9.gaturro.model.config.provider.definition.ProviderItemDefinition;
   import flash.utils.Dictionary;
   
   public class ProviderConfig extends BaseSettingsConfig
   {
       
      
      private var map:Dictionary;
      
      public function ProviderConfig()
      {
         super();
      }
      
      public function getProviderDefinition(param1:String) : ProviderDefinition
      {
         return this.map[param1];
      }
      
      override public function set settings(param1:Object) : void
      {
         super.settings = param1;
         this.setup();
      }
      
      private function getBuildedDefinition(param1:Object) : ProviderDefinition
      {
         var _loc3_:ProviderItemDefinition = null;
         var _loc4_:Object = null;
         var _loc5_:ProviderDefinition = null;
         var _loc2_:Array = new Array();
         for each(_loc4_ in param1.items)
         {
            _loc3_ = new ProviderItemDefinition(_loc4_.id,_loc4_.item,_loc4_.amount,_loc4_.modelItemId,_loc4_.data);
            _loc2_.push(_loc3_);
         }
         return new ProviderDefinition(param1.name,_loc2_,param1.strategy,param1.hasNextConstraint,param1.modelClassId,param1.data);
      }
      
      private function setup() : void
      {
         var _loc1_:ProviderDefinition = null;
         var _loc2_:Object = null;
         this.map = new Dictionary();
         for each(_loc2_ in _settings.definition)
         {
            _loc1_ = this.getBuildedDefinition(_loc2_);
            this.map[_loc1_.name] = _loc1_;
         }
      }
   }
}

package com.qb9.gaturro.model.config.provider.model.impl
{
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.model.item.ItemConfig;
   import com.qb9.gaturro.commons.model.item.ItemDefinition;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.model.config.provider.definition.ProviderItemDefinition;
   import com.qb9.gaturro.model.config.provider.model.ProviderItemModel;
   
   public class SerenitoProviderItemModel extends ProviderItemModel
   {
       
      
      private var itemConfig:ItemConfig;
      
      public function SerenitoProviderItemModel(param1:ProviderItemDefinition)
      {
         super(param1);
         this.setupItemConfig();
      }
      
      public function get item() : int
      {
         return definition.item;
      }
      
      public function get probability() : int
      {
         return definition.data.probability;
      }
      
      public function get amount() : int
      {
         return definition.amount;
      }
      
      private function setupItemConfig() : void
      {
         this.itemConfig = Context.instance.getByType(ItemConfig) as ItemConfig;
      }
      
      override public function get deliveredCount() : int
      {
         var _loc1_:ItemDefinition = this.itemConfig.getDefinitionByCode(definition.item as int);
         return int(user.bag.byType(_loc1_.path).length);
      }
   }
}

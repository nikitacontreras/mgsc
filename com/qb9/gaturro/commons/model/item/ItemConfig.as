package com.qb9.gaturro.commons.model.item
{
   import com.qb9.gaturro.commons.model.config.BaseSettingsConfig;
   import flash.utils.Dictionary;
   
   public class ItemConfig extends BaseSettingsConfig
   {
       
      
      private var mapByCode:Dictionary;
      
      private var mapByPath:Dictionary;
      
      public function ItemConfig()
      {
         super();
         this.mapByCode = new Dictionary();
         this.mapByPath = new Dictionary();
      }
      
      public function getDefinitionByPath(param1:int) : ItemDefinition
      {
         return this.mapByPath[param1];
      }
      
      override public function set settings(param1:Object) : void
      {
         super.settings = param1;
         this.setupMap();
      }
      
      public function hasDefByPath(param1:int) : Boolean
      {
         return Boolean(this.mapByPath[param1]);
      }
      
      public function getDefinitionByCode(param1:int) : ItemDefinition
      {
         return this.mapByCode[param1];
      }
      
      public function hasDefByCode(param1:int) : Boolean
      {
         return Boolean(this.mapByCode[param1]);
      }
      
      private function getItemDefinition(param1:Object) : ItemDefinition
      {
         var _loc2_:ItemDefinition = new ItemDefinition();
         _loc2_.name = param1.name;
         _loc2_.path = param1.path;
         _loc2_.code = param1.code;
         _loc2_.icon = param1.icon;
         return _loc2_;
      }
      
      private function setupMap() : void
      {
         var _loc1_:ItemDefinition = null;
         var _loc2_:Object = null;
         for each(_loc2_ in _settings.definition)
         {
            _loc1_ = this.getItemDefinition(_loc2_);
            this.mapByCode[_loc1_.code] = _loc1_;
            this.mapByPath[_loc1_.path] = _loc1_;
         }
      }
   }
}

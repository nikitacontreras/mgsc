package com.qb9.gaturro.commons.model.config
{
   public class BaseClassAndSettingsConfig extends BaseSettingsConfig implements IConfigAndClassMap
   {
       
      
      public function BaseClassAndSettingsConfig()
      {
         super();
      }
      
      public function getClassDefinition(param1:String) : String
      {
         var _loc2_:Object = _settings.classMap[param1];
         return _loc2_.toString();
      }
   }
}

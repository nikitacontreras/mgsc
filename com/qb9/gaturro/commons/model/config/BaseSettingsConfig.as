package com.qb9.gaturro.commons.model.config
{
   import com.qb9.flashlib.config.Settings;
   import com.qb9.gaturro.commons.iterator.IIterator;
   import com.qb9.gaturro.commons.iterator.Iterator;
   
   public class BaseSettingsConfig implements IConfigSettings
   {
       
      
      protected var _settings:Settings;
      
      public function BaseSettingsConfig()
      {
         super();
      }
      
      public function getDefinition(param1:String) : Object
      {
         return this._settings.definition[param1];
      }
      
      public function set settings(param1:Object) : void
      {
         this._settings = param1 as Settings;
      }
      
      public function getIterator() : IIterator
      {
         var _loc1_:IIterator = new Iterator();
         _loc1_.setupIterable(this._settings.definition);
         _loc1_.sort("code");
         return _loc1_;
      }
   }
}

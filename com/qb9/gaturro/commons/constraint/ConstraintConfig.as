package com.qb9.gaturro.commons.constraint
{
   import com.qb9.flashlib.config.Settings;
   import com.qb9.flashlib.tasks.*;
   import com.qb9.gaturro.commons.iterator.IIterator;
   import com.qb9.gaturro.commons.model.config.IConfigSettings;
   import flash.utils.Dictionary;
   
   public class ConstraintConfig implements IConfigSettings
   {
      
      public static const CONSTRAINT_CONFIG_URI:String = "cfgs/constraint.json";
       
      
      private var constraintSettings:Settings;
      
      private var config:Dictionary;
      
      public function ConstraintConfig()
      {
         super();
         this.config = new Dictionary();
      }
      
      public function getClassDefinition(param1:String) : String
      {
         var _loc2_:Object = this.constraintSettings.classMap[param1];
         return _loc2_.toString();
      }
      
      public function set settings(param1:Object) : void
      {
         this.constraintSettings = param1 as Settings;
      }
      
      public function getDefinition(param1:String) : Object
      {
         return this.constraintSettings.definition[param1];
      }
      
      public function getIterator() : IIterator
      {
         return null;
      }
   }
}

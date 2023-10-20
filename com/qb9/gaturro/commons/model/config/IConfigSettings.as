package com.qb9.gaturro.commons.model.config
{
   public interface IConfigSettings extends IConfig
   {
       
      
      function getDefinition(param1:String) : Object;
      
      function set settings(param1:Object) : void;
   }
}

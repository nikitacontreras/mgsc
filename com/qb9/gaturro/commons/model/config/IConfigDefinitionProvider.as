package com.qb9.gaturro.commons.model.config
{
   import com.qb9.gaturro.commons.model.definition.IDefinition;
   
   public interface IConfigDefinitionProvider extends IConfig
   {
       
      
      function getDefinitionByName(param1:String) : IDefinition;
      
      function getDefinitionByCode(param1:int) : IDefinition;
   }
}

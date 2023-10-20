package com.qb9.gaturro.commons.model.config
{
   import com.qb9.gaturro.commons.model.definition.IDefinition;
   
   public interface IConfigDefinition extends IConfigDefinitionProvider
   {
       
      
      function addDefinition(param1:IDefinition, param2:String) : void;
   }
}

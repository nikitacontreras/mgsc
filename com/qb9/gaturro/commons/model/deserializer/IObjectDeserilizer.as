package com.qb9.gaturro.commons.model.deserializer
{
   import com.qb9.gaturro.commons.model.definition.IDefinition;
   
   public interface IObjectDeserilizer extends IDeserializer
   {
       
      
      function deserialize(param1:Object, param2:String) : IDefinition;
   }
}

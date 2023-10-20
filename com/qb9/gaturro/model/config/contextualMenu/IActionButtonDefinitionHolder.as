package com.qb9.gaturro.model.config.contextualMenu
{
   import com.qb9.gaturro.commons.iterator.IIterator;
   
   public interface IActionButtonDefinitionHolder
   {
       
      
      function getAction(param1:String) : ContextualMenuActionDefinition;
      
      function get actions() : IIterator;
      
      function addAction(param1:ContextualMenuActionDefinition) : void;
   }
}

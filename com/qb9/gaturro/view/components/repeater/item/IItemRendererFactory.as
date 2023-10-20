package com.qb9.gaturro.view.components.repeater.item
{
   public interface IItemRendererFactory
   {
       
      
      function refreshItemRenderer(param1:AbstractItemRenderer, param2:Object = null) : AbstractItemRenderer;
      
      function buildItemRenderer(param1:Object) : AbstractItemRenderer;
   }
}

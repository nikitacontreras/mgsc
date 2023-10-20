package com.qb9.gaturro.view.gui.base.inventory.repeater.inventory
{
   import com.qb9.gaturro.view.components.repeater.item.AbstractItemRenderer;
   import com.qb9.gaturro.view.components.repeater.item.IItemRendererFactory;
   
   public class InventoryWidgetItemRendererFactory implements IItemRendererFactory
   {
       
      
      public function InventoryWidgetItemRendererFactory()
      {
         super();
      }
      
      public function refreshItemRenderer(param1:AbstractItemRenderer, param2:Object = null) : AbstractItemRenderer
      {
         if(Boolean(param1) && param2 != null)
         {
            param1.refresh(param2);
         }
         else if(Boolean(param1) && param2 == null)
         {
            param1 = null;
         }
         else if(!param1 && param2 != null)
         {
            param1 = this.buildItemRenderer(param2);
         }
         return param1;
      }
      
      public function buildItemRenderer(param1:Object) : AbstractItemRenderer
      {
         var _loc2_:InventoryWidgetItemRenderer = null;
         _loc2_ = new InventoryWidgetItemRenderer();
         _loc2_.data = param1;
         return _loc2_;
      }
   }
}

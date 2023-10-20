package com.qb9.gaturro.view.components.repeater.item.factory
{
   import com.qb9.gaturro.view.components.repeater.item.AbstractItemRenderer;
   import com.qb9.gaturro.view.components.repeater.item.IItemRendererFactory;
   
   public class GenericItemRendererFactory implements IItemRendererFactory
   {
       
      
      private var itemRendererClass:Class;
      
      private var contentViewClass:Class;
      
      public function GenericItemRendererFactory(param1:Class, param2:Class)
      {
         super();
         this.itemRendererClass = param1;
         this.contentViewClass = param2;
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
         var _loc2_:AbstractItemRenderer = new this.itemRendererClass(this.contentViewClass);
         _loc2_.data = param1;
         return _loc2_;
      }
   }
}

package com.qb9.gaturro.view.components.repeater.item.implementation.catalog
{
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.view.components.repeater.item.AbstractItemRenderer;
   import com.qb9.gaturro.view.components.repeater.item.IItemRendererFactory;
   
   public class BaseCatalogItemRendererFactory implements IItemRendererFactory
   {
       
      
      private var api:GaturroRoomAPI;
      
      private var itemRendererClass:Class;
      
      private var contentViewClass:Class;
      
      public function BaseCatalogItemRendererFactory(param1:GaturroRoomAPI, param2:Class, param3:Class = null)
      {
         super();
         this.itemRendererClass = param3 || BaseCatalogItemRenderer;
         this.contentViewClass = param2;
         this.api = param1;
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
         var _loc2_:BaseCatalogItemRenderer = new this.itemRendererClass(this.api,this.contentViewClass);
         _loc2_.data = param1;
         return _loc2_;
      }
   }
}

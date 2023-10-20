package com.qb9.gaturro.view.gui.contextual.implementation.hospital
{
   import com.qb9.gaturro.commons.loader.SWFLoaderWrapper;
   import com.qb9.gaturro.model.config.contextualMenu.ContextualMenuActionDefinition;
   import com.qb9.gaturro.view.components.repeater.item.AbstractItemRenderer;
   import com.qb9.gaturro.view.components.repeater.item.IItemRendererFactory;
   
   public class HospitalContextualMenuItemRendererFactory implements IItemRendererFactory
   {
       
      
      private var loaderWarpper:SWFLoaderWrapper;
      
      private var assetClass:Class;
      
      public function HospitalContextualMenuItemRendererFactory(param1:SWFLoaderWrapper, param2:Class)
      {
         super();
         this.assetClass = param2;
         this.loaderWarpper = param1;
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
         var _loc2_:ContextualMenuActionDefinition = param1 as ContextualMenuActionDefinition;
         var _loc3_:AbstractItemRenderer = new HospitalContextualMenuItemRenderer(this.assetClass,this.loaderWarpper);
         _loc3_.data = param1;
         return _loc3_;
      }
   }
}

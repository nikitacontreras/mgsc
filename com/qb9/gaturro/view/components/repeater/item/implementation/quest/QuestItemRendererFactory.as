package com.qb9.gaturro.view.components.repeater.item.implementation.quest
{
   import com.qb9.gaturro.commons.asset.IAssetProvider;
   import com.qb9.gaturro.view.components.repeater.item.AbstractItemRenderer;
   import com.qb9.gaturro.view.components.repeater.item.IItemRendererFactory;
   
   public class QuestItemRendererFactory implements IItemRendererFactory
   {
       
      
      private var assetProvider:IAssetProvider;
      
      private var contentViewClass:Class;
      
      public function QuestItemRendererFactory(param1:Class, param2:IAssetProvider)
      {
         super();
         this.assetProvider = param2;
         this.contentViewClass = param1;
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
         var _loc2_:QuestItemRenderer = new QuestItemRenderer(this.contentViewClass,this.assetProvider);
         _loc2_.data = param1;
         return _loc2_;
      }
   }
}

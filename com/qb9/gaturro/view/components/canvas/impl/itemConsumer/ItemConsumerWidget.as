package com.qb9.gaturro.view.components.canvas.impl.itemConsumer
{
   import com.qb9.gaturro.commons.event.ItemRendererEvent;
   import com.qb9.gaturro.commons.event.RepeaterEvent;
   import com.qb9.gaturro.commons.paginator.PaginatorFactory;
   import com.qb9.gaturro.view.components.repeater.Repeater;
   import com.qb9.gaturro.view.components.repeater.config.NavegableRepeaterConfig;
   import com.qb9.gaturro.view.gui.base.inventory.InventoryWidget;
   import com.qb9.gaturro.view.gui.base.inventory.InventoryWidgetEvent;
   import com.qb9.gaturro.view.gui.base.inventory.repeater.inventory.InventoryWidgetItemRenderer;
   import com.qb9.gaturro.view.gui.base.inventory.repeater.inventory.InventoryWidgetItemRendererFactory;
   import flash.utils.Dictionary;
   
   public class ItemConsumerWidget extends InventoryWidget
   {
       
      
      private var items:Array;
      
      private var selectedItems:Dictionary;
      
      public function ItemConsumerWidget(param1:uint, param2:uint, param3:Boolean, param4:Function = null, param5:Object = null, param6:String = null)
      {
         super(param1,param2,param3,param4,param5,param6);
         this.selectedItems = new Dictionary();
      }
      
      private function removeSelected(param1:InventoryWidgetItemRenderer) : void
      {
         var _loc2_:Dictionary = this.selectedItems[repeater.paginator.currentPage];
         delete _loc2_[param1.itemId];
      }
      
      override public function dispose() : void
      {
         if(repeater)
         {
            repeater.repeater.removeEventListener(RepeaterEvent.CREATION_COMPLETE,this.onCreationComplete);
         }
         this.selectedItems = null;
         super.dispose();
      }
      
      override protected function setupRepeater() : void
      {
         super.setupRepeater();
         repeater.repeater.addEventListener(RepeaterEvent.CREATION_COMPLETE,this.onCreationComplete);
      }
      
      override protected function onItemSelected(param1:ItemRendererEvent) : void
      {
         var _loc2_:InventoryWidgetItemRenderer = param1.itemRenderer as InventoryWidgetItemRenderer;
         if(_loc2_)
         {
            this.addSelectedItem(_loc2_);
         }
         dispatchEvent(new InventoryWidgetEvent(InventoryWidgetEvent.SELECTED,InventoryWidgetItemRenderer(param1.itemRenderer).cell));
      }
      
      override protected function onItemDeselected(param1:ItemRendererEvent) : void
      {
         var _loc2_:InventoryWidgetItemRenderer = param1.itemRenderer as InventoryWidgetItemRenderer;
         if(_loc2_)
         {
            this.removeSelected(_loc2_);
         }
         dispatchEvent(new InventoryWidgetEvent(InventoryWidgetEvent.UNSELECTED,InventoryWidgetItemRenderer(param1.itemRenderer).cell));
      }
      
      override protected function getRepeaterConfig() : NavegableRepeaterConfig
      {
         var _loc1_:NavegableRepeaterConfig = new NavegableRepeaterConfig(PaginatorFactory.SIMPLE_TYPE,getItems(),this,null,20);
         _loc1_.itemRendererFactory = new InventoryWidgetItemRendererFactory();
         _loc1_.columns = 10;
         _loc1_.selectable = Repeater.MULTI_SELECTABLE;
         return _loc1_;
      }
      
      override protected function drawBackground() : void
      {
      }
      
      override protected function outerMarginX() : int
      {
         return 0;
      }
      
      private function onCreationComplete(param1:RepeaterEvent) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Dictionary = this.selectedItems[repeater.paginator.currentPage];
         for each(_loc3_ in _loc2_)
         {
            repeater.repeater.addSelectedIndex(_loc3_);
         }
      }
      
      private function addSelectedItem(param1:InventoryWidgetItemRenderer) : void
      {
         var _loc2_:Dictionary = null;
         if(!this.selectedItems[repeater.paginator.currentPage])
         {
            _loc2_ = new Dictionary();
            this.selectedItems[repeater.paginator.currentPage] = _loc2_;
         }
         else
         {
            _loc2_ = this.selectedItems[repeater.paginator.currentPage];
         }
         _loc2_[param1.itemId] = param1.itemId;
      }
   }
}

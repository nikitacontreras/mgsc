package com.qb9.gaturro.view.gui.base.inventory.repeater.navigation
{
   import com.qb9.gaturro.commons.event.PaginatorEvent;
   import com.qb9.gaturro.view.components.repeater.DisplaceableRepeaterPaginatedFacade;
   import com.qb9.gaturro.view.components.repeater.config.RepeaterConfig;
   import com.qb9.gaturro.view.components.repeater.item.AbstractItemRenderer;
   
   public class InventoryPageMenuRepeaterFacade extends DisplaceableRepeaterPaginatedFacade
   {
       
      
      private var nextButton:com.qb9.gaturro.view.gui.base.inventory.repeater.navigation.ArrowInventoryPageItemRenderer;
      
      private var prevButton:com.qb9.gaturro.view.gui.base.inventory.repeater.navigation.ArrowInventoryPageItemRenderer;
      
      public function InventoryPageMenuRepeaterFacade(param1:RepeaterConfig)
      {
         super(param1);
      }
      
      private function processButtonState(param1:int) : void
      {
         if(_paginator.currentPage == 0 && param1 == 1 && Boolean(this.prevButton))
         {
            this.prevButton.disable();
         }
         else if(Boolean(this.prevButton) && !this.prevButton.enabled)
         {
            this.prevButton.enable();
         }
         if(_paginator.currentPage == _paginator.pagesAmount - 1 && param1 == _repeater.itemAmount - 2 && Boolean(this.nextButton))
         {
            this.nextButton.disable();
         }
         else if(Boolean(this.nextButton) && !this.nextButton.enabled)
         {
            this.nextButton.enable();
         }
      }
      
      override protected function setupPaginator() : void
      {
         _paginator = new InventoryPageMenuPaginator(dataProvider,config.itemsPerPage);
         _paginator.init();
         _paginator.addEventListener(PaginatorEvent.PAGE_CHANGED,onPageChanged);
      }
      
      override public function changeDataProveider(param1:Object) : void
      {
         super.changeDataProveider(param1);
         if(_paginator.getCurrentPage().length > 1 && _repeater.selectedIndex.length < 1)
         {
            this.prevButton = _repeater.itemList[0];
            this.nextButton = _repeater.itemList[_repeater.itemAmount - 1];
         }
      }
      
      override protected function setupRepeater() : void
      {
         super.setupRepeater();
         if(_paginator.getCurrentPage().length > 1)
         {
            _repeater.addSelectedIndex(1);
            this.prevButton = _repeater.itemList[0];
            this.nextButton = _repeater.itemList[_repeater.itemAmount - 1];
         }
      }
      
      override public function selectItem(param1:AbstractItemRenderer) : void
      {
         this.processButtonState(param1.itemId);
         super.selectItem(param1);
      }
   }
}

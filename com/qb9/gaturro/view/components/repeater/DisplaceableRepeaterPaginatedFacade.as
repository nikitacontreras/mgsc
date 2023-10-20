package com.qb9.gaturro.view.components.repeater
{
   import com.qb9.gaturro.commons.event.PaginatorEvent;
   import com.qb9.gaturro.commons.iterator.iterable.IIterable;
   import com.qb9.gaturro.commons.iterator.iterable.IterableFactory;
   import com.qb9.gaturro.commons.navigation.INavigation;
   import com.qb9.gaturro.commons.paginator.IPaginator;
   import com.qb9.gaturro.commons.paginator.SmartPaginator;
   import com.qb9.gaturro.view.components.repeater.config.RepeaterConfig;
   import com.qb9.gaturro.view.components.repeater.item.AbstractItemRenderer;
   import flash.events.EventDispatcher;
   
   public class DisplaceableRepeaterPaginatedFacade extends EventDispatcher implements INavigation
   {
       
      
      protected var config:RepeaterConfig;
      
      protected var _disposed:Boolean = false;
      
      protected var _paginator:SmartPaginator;
      
      protected var _repeater:com.qb9.gaturro.view.components.repeater.Repeater;
      
      protected var dataProvider:IIterable;
      
      public function DisplaceableRepeaterPaginatedFacade(param1:RepeaterConfig)
      {
         super();
         this.config = param1;
         this.dataProvider = param1.dataSource is IIterable ? param1.dataSource as IIterable : this.processData(param1.dataSource);
         this.setupPaginator();
         this.setupRepeater();
      }
      
      public function gotoBeginning() : void
      {
         var _loc1_:IIterable = this._paginator.gotoToPage(0);
         this.changePage(_loc1_);
      }
      
      final protected function onPageChanged(param1:PaginatorEvent) : void
      {
         dispatchEvent(param1.clone() as PaginatorEvent);
      }
      
      public function gotoEnd() : void
      {
         var _loc1_:IIterable = this._paginator.gotoToPage(this._paginator.pagesAmount);
         this.changePage(_loc1_);
      }
      
      public function changeDataProveider(param1:Object) : void
      {
         this.dataProvider = param1 is IIterable ? param1 as IIterable : this.processData(param1);
         this._paginator.dataProvider = this.dataProvider;
         this.reset();
      }
      
      public function reset() : void
      {
         this._paginator.resetPaginator();
         this._repeater.dataProvider = this._paginator.getCurrentPage();
         this._repeater.refresh();
      }
      
      public function displaceElements(param1:int) : void
      {
         var _loc2_:IIterable = this._paginator.displaceModule(param1);
         this.changePage(_loc2_);
      }
      
      public function get paginator() : IPaginator
      {
         return this._paginator;
      }
      
      protected function setupPaginator() : void
      {
         this._paginator = new SmartPaginator(this.dataProvider,this.config.itemsPerPage);
         this._paginator.init();
         this._paginator.addEventListener(PaginatorEvent.PAGE_CHANGED,this.onPageChanged);
      }
      
      public function addSelectIndex(param1:int) : void
      {
         this._repeater.addSelectedIndex(param1);
      }
      
      public function get repeater() : com.qb9.gaturro.view.components.repeater.Repeater
      {
         return this._repeater;
      }
      
      public function refresh() : void
      {
         var _loc1_:IIterable = this._paginator.getCurrentPage();
         this.changePage(_loc1_);
      }
      
      public function get diposed() : Boolean
      {
         return this._disposed;
      }
      
      protected function setupRepeater() : void
      {
         var _loc1_:IIterable = this._paginator.getCurrentPage();
         this._repeater = new com.qb9.gaturro.view.components.repeater.Repeater(_loc1_,this.config.itemRendererClass,this.config.selectable);
         if(this.config.itemRendererFactory)
         {
            this._repeater.itemRendererFactory = this.config.itemRendererFactory;
         }
         if(this.config.rows)
         {
            this._repeater.rows = this.config.rows;
         }
         if(this.config.columns)
         {
            this._repeater.columns = this.config.columns;
         }
         this.config.itemContainer.addChild(this._repeater);
         this._repeater.build();
      }
      
      public function dispose() : void
      {
         this._paginator.removeEventListener(PaginatorEvent.PAGE_CHANGED,this.onPageChanged);
         this._repeater.dispose();
         this._paginator.dispose();
         this._repeater = null;
         this._paginator = null;
         this._disposed = true;
      }
      
      public function gotoPage(param1:uint = 0) : void
      {
         var _loc2_:IIterable = this._paginator.gotoToPage(param1);
         this.changePage(_loc2_);
      }
      
      public function gotoNextPage() : void
      {
         var _loc1_:IIterable = this._paginator.getNextPage();
         this.changePage(_loc1_);
      }
      
      private function changePage(param1:IIterable) : void
      {
         this._repeater.dataProvider = param1;
         this._repeater.refresh();
      }
      
      public function selectItem(param1:AbstractItemRenderer) : void
      {
         this._repeater.addSelectedItem(param1);
      }
      
      public function gotoPrevPage() : void
      {
         var _loc1_:IIterable = this._paginator.getPrevPage();
         this.changePage(_loc1_);
      }
      
      private function processData(param1:Object) : IIterable
      {
         return IterableFactory.build(param1);
      }
      
      public function gotoStart() : void
      {
         var _loc1_:IIterable = this._paginator.gotoToPage(0);
         this.changePage(_loc1_);
      }
   }
}

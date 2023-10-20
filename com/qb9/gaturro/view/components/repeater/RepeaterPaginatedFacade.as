package com.qb9.gaturro.view.components.repeater
{
   import com.qb9.gaturro.commons.event.PaginatorEvent;
   import com.qb9.gaturro.commons.iterator.iterable.IIterable;
   import com.qb9.gaturro.commons.iterator.iterable.IterableFactory;
   import com.qb9.gaturro.commons.navigation.INavigation;
   import com.qb9.gaturro.commons.paginator.IPaginator;
   import com.qb9.gaturro.commons.paginator.Paginator;
   import com.qb9.gaturro.view.components.repeater.config.RepeaterConfig;
   import flash.events.EventDispatcher;
   
   public class RepeaterPaginatedFacade extends EventDispatcher implements INavigation
   {
       
      
      protected var config:RepeaterConfig;
      
      private var _disposed:Boolean = false;
      
      protected var _paginator:IPaginator;
      
      protected var _repeater:com.qb9.gaturro.view.components.repeater.Repeater;
      
      protected var dataProvider:IIterable;
      
      public function RepeaterPaginatedFacade(param1:RepeaterConfig)
      {
         super();
         this.config = param1;
         if(param1.dataSource)
         {
            this.dataProvider = param1.dataSource is IIterable ? param1.dataSource as IIterable : this.processData(param1.dataSource);
         }
         this.setupPaginator();
         this.setupRepeater();
      }
      
      public function gotoBeginning() : void
      {
         var _loc1_:IIterable = this._paginator.gotoToPage(0);
         this.changePage(_loc1_);
      }
      
      public function gotoStart() : void
      {
         var _loc1_:IIterable = this._paginator.gotoToPage(0);
         this.changePage(_loc1_);
      }
      
      protected function setupRepeater() : void
      {
         this._repeater = new com.qb9.gaturro.view.components.repeater.Repeater(this._paginator.getCurrentPage(),this.config.itemRendererClass,this.config.selectable);
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
      
      protected function onPageChanged(param1:PaginatorEvent) : void
      {
         dispatchEvent(param1.clone() as PaginatorEvent);
      }
      
      public function reset() : void
      {
         this._paginator.resetPaginator();
         this._repeater.dataProvider = this._paginator.getCurrentPage();
         this._repeater.build();
      }
      
      public function init() : void
      {
      }
      
      public function get paginator() : IPaginator
      {
         return this._paginator;
      }
      
      public function chnageDataProveider(param1:Object) : void
      {
         this._paginator.dataProvider = this.processData(param1);
         var _loc2_:IIterable = this._paginator.getCurrentPage();
         this.changePage(_loc2_);
      }
      
      protected function setupPaginator() : void
      {
         this._paginator = new Paginator(this.config.paginatorType,this.dataProvider,this.config.itemsPerPage);
         this._paginator.initialPage = this.config.initialPage;
         this._paginator.init();
         this._paginator.addEventListener(PaginatorEvent.PAGE_CHANGED,this.onPageChanged);
      }
      
      public function get diposed() : Boolean
      {
         return this._disposed;
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
         this.dataProvider = param1;
         this._repeater.dataProvider = param1;
         this._repeater.clearSelection();
         this._repeater.refresh();
      }
      
      public function gotoPrevPage() : void
      {
         var _loc1_:IIterable = this._paginator.getPrevPage();
         this.changePage(_loc1_);
      }
      
      public function gotoEnd() : void
      {
         var _loc1_:IIterable = this._paginator.gotoToPage(this._paginator.pagesAmount);
         this.changePage(_loc1_);
      }
      
      private function processData(param1:Object) : IIterable
      {
         return IterableFactory.build(param1);
      }
   }
}

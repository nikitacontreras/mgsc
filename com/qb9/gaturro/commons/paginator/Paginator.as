package com.qb9.gaturro.commons.paginator
{
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.event.PaginatorEvent;
   import com.qb9.gaturro.commons.iterator.iterable.IIterable;
   import flash.events.EventDispatcher;
   
   public class Paginator extends EventDispatcher implements com.qb9.gaturro.commons.paginator.IPaginator
   {
       
      
      private var _disposed:Boolean;
      
      private var selectedPaginator:com.qb9.gaturro.commons.paginator.IPaginator;
      
      private var paginatorFactory:com.qb9.gaturro.commons.paginator.PaginatorFactory;
      
      public function Paginator(param1:String, param2:IIterable, param3:int)
      {
         super();
         this.setup(param1,param2,param3);
      }
      
      public function getCurrentPage() : IIterable
      {
         return this.selectedPaginator.getCurrentPage();
      }
      
      public function resetPaginator() : void
      {
         this.selectedPaginator.resetPaginator();
      }
      
      public function getPrevPage() : IIterable
      {
         return this.selectedPaginator.getPrevPage();
      }
      
      private function onPageChanged(param1:PaginatorEvent) : void
      {
         dispatchEvent(param1.clone());
      }
      
      public function set dataProvider(param1:IIterable) : void
      {
         this.selectedPaginator.dataProvider = param1;
      }
      
      public function init() : void
      {
         this.selectedPaginator.init();
      }
      
      public function get itemsPerPage() : int
      {
         return this.selectedPaginator.itemsPerPage;
      }
      
      public function get disposed() : Boolean
      {
         return this._disposed;
      }
      
      public function dispose() : void
      {
         this.selectedPaginator.dispose();
         this._disposed = true;
      }
      
      public function get currentPage() : int
      {
         return this.selectedPaginator.currentPage;
      }
      
      public function gotoToPage(param1:int) : IIterable
      {
         return this.selectedPaginator.gotoToPage(param1);
      }
      
      public function set itemsPerPage(param1:int) : void
      {
         this.selectedPaginator.itemsPerPage = param1;
      }
      
      public function set initialPage(param1:int) : void
      {
         this.selectedPaginator.initialPage = param1;
      }
      
      public function get itemsAmount() : int
      {
         return this.selectedPaginator.itemsAmount;
      }
      
      public function getNextPage() : IIterable
      {
         return this.selectedPaginator.getNextPage();
      }
      
      public function get dataProvider() : IIterable
      {
         return this.selectedPaginator.dataProvider;
      }
      
      public function get pagesAmount() : int
      {
         return this.selectedPaginator.pagesAmount;
      }
      
      private function setup(param1:String, param2:IIterable, param3:int) : void
      {
         this.paginatorFactory = Context.instance.getByType(com.qb9.gaturro.commons.paginator.PaginatorFactory) as com.qb9.gaturro.commons.paginator.PaginatorFactory;
         this.selectedPaginator = this.paginatorFactory.build(param1,param2,param3);
         this.selectedPaginator.addEventListener(PaginatorEvent.PAGE_CHANGED,this.onPageChanged);
      }
   }
}

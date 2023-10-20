package com.qb9.gaturro.commons.paginator
{
   import com.qb9.gaturro.commons.dispose.ICheckableDisposable;
   import com.qb9.gaturro.commons.iterator.iterable.IIterable;
   import flash.events.IEventDispatcher;
   
   public interface IPaginator extends ICheckableDisposable, IEventDispatcher
   {
       
      
      function resetPaginator() : void;
      
      function set initialPage(param1:int) : void;
      
      function getPrevPage() : IIterable;
      
      function get currentPage() : int;
      
      function get itemsPerPage() : int;
      
      function gotoToPage(param1:int) : IIterable;
      
      function init() : void;
      
      function getCurrentPage() : IIterable;
      
      function set dataProvider(param1:IIterable) : void;
      
      function set itemsPerPage(param1:int) : void;
      
      function getNextPage() : IIterable;
      
      function get dataProvider() : IIterable;
      
      function get pagesAmount() : int;
      
      function get itemsAmount() : int;
   }
}

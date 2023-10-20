package com.qb9.gaturro.commons.paginator
{
   import com.qb9.gaturro.commons.iterator.iterable.IIterable;
   import com.qb9.gaturro.globals.logger;
   import flash.errors.IllegalOperationError;
   import flash.events.EventDispatcher;
   
   public class AbstractPaginator extends EventDispatcher implements IPaginator
   {
       
      
      protected var _itemsAmount:int;
      
      private var _disposed:Boolean;
      
      protected var _pagesAmount:int;
      
      protected var _dataProvider:IIterable;
      
      protected var _itemsPerPage:int;
      
      protected var _initialPage:int;
      
      protected var _currentPage:int;
      
      public function AbstractPaginator(param1:IIterable, param2:int)
      {
         super();
         this._itemsPerPage = param2;
         this._dataProvider = param1;
      }
      
      public function resetPaginator() : void
      {
         if(!this._dataProvider)
         {
            logger.debug("The dataProvider property is unseted");
            throw new Error("The dataProvider property is unseted");
         }
         if(isNaN(this._itemsPerPage))
         {
            logger.debug("ERROR: The itemsPerPage property is unseted");
            throw new Error("ERROR: The itemsPerPage property is unseted");
         }
         this.updateValues();
         this.setCurrentPage(this._initialPage);
      }
      
      public function init() : void
      {
         this.resetPaginator();
      }
      
      protected function isValidPage(param1:int) : Boolean
      {
         if(param1 < 0 || param1 > this._pagesAmount)
         {
            return false;
         }
         return true;
      }
      
      public function get disposed() : Boolean
      {
         return this._disposed;
      }
      
      public function dispose() : void
      {
         this._disposed = true;
      }
      
      public function getNextPage() : IIterable
      {
         logger.debug("This is an abstract method. Should be implemented");
         throw new IllegalOperationError("This is an abstract method. Should be implemented");
      }
      
      public function get currentPage() : int
      {
         return this._currentPage;
      }
      
      public function get itemsAmount() : int
      {
         return this._itemsAmount;
      }
      
      public function get dataProvider() : IIterable
      {
         return this._dataProvider;
      }
      
      public function get pagesAmount() : int
      {
         return this._pagesAmount;
      }
      
      protected function throwOutOfBounsError(param1:int) : void
      {
         logger.error("This page is out of bounds. Required " + param1 + " when the limits are: 0/" + this._pagesAmount);
         throw new Error("This page is out of bounds. Required " + param1 + " when the limits are: 0/" + this._pagesAmount);
      }
      
      public function set itemsPerPage(param1:int) : void
      {
         this._itemsPerPage = param1;
         this.updateValues();
      }
      
      protected function updateValues() : void
      {
         this._itemsAmount = this.dataProvider.length;
         this._pagesAmount = Math.ceil(this._itemsAmount / this._itemsPerPage);
      }
      
      public function getPrevPage() : IIterable
      {
         logger.debug("This is an abstract method. Should be implemented");
         throw new IllegalOperationError("This is an abstract method. Should be implemented");
      }
      
      public function gotoToPage(param1:int) : IIterable
      {
         if(this.isValidPage(param1))
         {
            this.setCurrentPage(param1);
         }
         return this.getCurrentPage();
      }
      
      public function getCurrentPage() : IIterable
      {
         logger.debug("This is an abstract method. Should be implemented");
         throw new IllegalOperationError("This is an abstract method. Should be implemented");
      }
      
      public function get itemsPerPage() : int
      {
         return this._itemsPerPage;
      }
      
      protected function setCurrentPage(param1:int) : void
      {
         if(this.isValidPage(param1))
         {
            this._currentPage = param1;
         }
         else
         {
            this._currentPage = 0;
            this.throwOutOfBounsError(param1);
         }
      }
      
      public function set dataProvider(param1:IIterable) : void
      {
         this._dataProvider = param1;
         this.updateValues();
      }
      
      public function set initialPage(param1:int) : void
      {
         this._initialPage = param1;
      }
   }
}

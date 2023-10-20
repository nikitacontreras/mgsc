package com.qb9.gaturro.commons.paginator
{
   import com.qb9.gaturro.commons.event.PaginatorEvent;
   import com.qb9.gaturro.commons.iterator.iterable.IIterable;
   import com.qb9.gaturro.globals.logger;
   
   public class LoopPaginator extends AbstractPaginator
   {
       
      
      private var _currentPageEndItemId:int;
      
      private var _currentPageStartItemId:int;
      
      private var displacement:int;
      
      public function LoopPaginator(param1:IIterable, param2:int)
      {
         super(param1,param2);
      }
      
      public function get currentPageEndItemId() : int
      {
         return this._currentPageEndItemId;
      }
      
      override public function getPrevPage() : IIterable
      {
         this.processRange(-_itemsPerPage);
         var _loc1_:int = _currentPage - 1 >= 0 ? _currentPage - 1 : _pagesAmount - 1;
         this.setCurrentPage(_loc1_);
         return this.getCurrentPage();
      }
      
      override protected function setCurrentPage(param1:int) : void
      {
         super.setCurrentPage(param1);
         var _loc2_:int = _itemsPerPage * _currentPage;
         this._currentPageStartItemId = _loc2_;
         var _loc3_:int = _loc2_ + _itemsPerPage;
         this._currentPageEndItemId = _loc3_ <= _itemsAmount ? _loc3_ : int(Math.abs(_itemsAmount - _loc3_));
         dispatchEvent(new PaginatorEvent(PaginatorEvent.PAGE_CHANGED,_currentPage,_pagesAmount,this._currentPageStartItemId,this._currentPageEndItemId,_dataProvider.length,_itemsPerPage));
      }
      
      public function get currentPageStartItemId() : int
      {
         return this._currentPageStartItemId;
      }
      
      override public function getCurrentPage() : IIterable
      {
         var _loc1_:IIterable = null;
         var _loc2_:IIterable = null;
         var _loc3_:IIterable = null;
         if(this._currentPageStartItemId > this._currentPageEndItemId)
         {
            _loc2_ = _dataProvider.slice(0,this._currentPageEndItemId);
            _loc3_ = _dataProvider.slice(this._currentPageStartItemId,_itemsAmount);
            _loc3_.concat(_loc2_);
            _loc1_ = _loc3_;
         }
         else
         {
            _loc1_ = _dataProvider.slice(this._currentPageStartItemId,this._currentPageEndItemId);
         }
         if(_loc1_.length > _itemsPerPage)
         {
            logger.debug("Range Issue. Therre are more items han should be");
            throw new Error("Range Issue. Therre are more items han should be");
         }
         return _loc1_;
      }
      
      override public function getNextPage() : IIterable
      {
         this.processRange(_itemsPerPage);
         var _loc1_:int = _currentPage + 1 < _pagesAmount ? _currentPage + 1 : 0;
         this.setCurrentPage(_loc1_);
         return this.getCurrentPage();
      }
      
      private function processRange(param1:int) : void
      {
         if(this._currentPageStartItemId + param1 < 0)
         {
            this._currentPageStartItemId = this._currentPageStartItemId + param1 + _itemsAmount;
         }
         else if(this._currentPageStartItemId + param1 >= _itemsAmount)
         {
            this._currentPageStartItemId = this._currentPageStartItemId + param1 - _itemsAmount;
         }
         else
         {
            this._currentPageStartItemId += param1;
         }
         if(this._currentPageEndItemId + param1 > _itemsAmount)
         {
            this._currentPageEndItemId = Math.abs(_itemsAmount - (this._currentPageEndItemId + param1));
         }
         else if(this._currentPageEndItemId + param1 <= 0)
         {
            this._currentPageEndItemId = _itemsAmount + (this._currentPageEndItemId + param1);
         }
         else
         {
            this._currentPageEndItemId += param1;
         }
      }
      
      override public function init() : void
      {
         super.init();
         if(_itemsPerPage > _itemsAmount)
         {
            logger.debug("Items per page quantity couldn\'t be greater than items amount.");
            throw new Error("Items per page quantity couldn\'t be greater than items amount.");
         }
      }
   }
}

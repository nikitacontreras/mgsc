package com.qb9.gaturro.commons.paginator
{
   import com.qb9.gaturro.commons.event.PaginatorEvent;
   import com.qb9.gaturro.commons.iterator.iterable.IIterable;
   
   public class SmartPaginator extends AbstractPaginator
   {
       
      
      protected var _currentPageEndItemId:int;
      
      protected var _currentPageStartItemId:int;
      
      protected var displacement:int;
      
      public function SmartPaginator(param1:IIterable, param2:int)
      {
         super(param1,param2);
      }
      
      public function get currentPageEndItemId() : int
      {
         return this._currentPageEndItemId;
      }
      
      override public function getPrevPage() : IIterable
      {
         _currentPage = _currentPage - 1 >= 0 ? _currentPage - 1 : _currentPage;
         var _loc1_:IIterable = this.displaceModule(-_itemsPerPage);
         dispatchEvent(new PaginatorEvent(PaginatorEvent.PAGE_CHANGED,_currentPage,_pagesAmount,this.currentPageStartItemId,this.currentPageEndItemId,_dataProvider.length,_itemsPerPage));
         return _loc1_;
      }
      
      override protected function setCurrentPage(param1:int) : void
      {
         super.setCurrentPage(param1);
         var _loc2_:int = _itemsPerPage * _currentPage;
         this._currentPageStartItemId = _loc2_;
         var _loc3_:int = _loc2_ + _itemsPerPage;
         this._currentPageEndItemId = _loc3_ <= _itemsAmount ? _loc3_ : _itemsAmount;
         this.setCurrentPageRange();
      }
      
      public function get currentPageStartItemId() : int
      {
         return this._currentPageStartItemId;
      }
      
      public function displaceModule(param1:int) : IIterable
      {
         this.displacement = this.processDisplacemet(param1);
         this.setCurrentPageRange();
         return this.getCurrentPage();
      }
      
      override public function getCurrentPage() : IIterable
      {
         return _dataProvider.slice(this._currentPageStartItemId,this._currentPageEndItemId);
      }
      
      private function processDisplacemet(param1:int) : int
      {
         if(param1 + this._currentPageEndItemId >= _itemsAmount)
         {
            param1 = _itemsAmount - this._currentPageEndItemId;
         }
         else if(param1 + this._currentPageStartItemId < 0)
         {
            param1 = 0 - this._currentPageStartItemId;
         }
         return param1;
      }
      
      override public function getNextPage() : IIterable
      {
         _currentPage = _currentPage + 1 < _pagesAmount ? _currentPage + 1 : _currentPage;
         var _loc1_:IIterable = this.displaceModule(_itemsPerPage);
         dispatchEvent(new PaginatorEvent(PaginatorEvent.PAGE_CHANGED,_currentPage,_pagesAmount,this.currentPageStartItemId,this.currentPageEndItemId,_dataProvider.length,_itemsPerPage));
         return _loc1_;
      }
      
      private function setCurrentPageRange() : void
      {
         this._currentPageStartItemId += this.displacement;
         this._currentPageEndItemId += this.displacement;
         dispatchEvent(new PaginatorEvent(PaginatorEvent.PAGE_CHANGED,_currentPage,_pagesAmount,this._currentPageStartItemId,this._currentPageEndItemId,_dataProvider.length,_itemsPerPage));
      }
      
      override public function init() : void
      {
         super.init();
         this.setCurrentPage(_initialPage);
      }
   }
}

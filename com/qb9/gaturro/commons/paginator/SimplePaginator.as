package com.qb9.gaturro.commons.paginator
{
   import com.qb9.gaturro.commons.event.PaginatorEvent;
   import com.qb9.gaturro.commons.iterator.iterable.IIterable;
   
   public class SimplePaginator extends AbstractPaginator
   {
       
      
      private var currentPageEndItemId:int;
      
      private var currentPageStartItemId:int;
      
      public function SimplePaginator(param1:IIterable, param2:int)
      {
         super(param1,param2);
      }
      
      override public function getPrevPage() : IIterable
      {
         var _loc1_:* = _currentPage - 1 >= 0;
         if(_loc1_)
         {
            --_currentPage;
         }
         var _loc2_:IIterable = this.getCurrentPage();
         if(_loc1_)
         {
            dispatchEvent(new PaginatorEvent(PaginatorEvent.PAGE_CHANGED,_currentPage,_pagesAmount,this.currentPageStartItemId,this.currentPageEndItemId,_dataProvider.length,_itemsPerPage));
         }
         trace("SimplePaginator > getPrevPage > _currentPage = [" + _currentPage + "]");
         return _loc2_;
      }
      
      override public function getCurrentPage() : IIterable
      {
         this.currentPageStartItemId = _currentPage * _itemsPerPage;
         this.currentPageEndItemId = this.currentPageStartItemId + _itemsPerPage < _itemsAmount ? this.currentPageStartItemId + _itemsPerPage : _itemsAmount;
         return this._dataProvider.slice(this.currentPageStartItemId,this.currentPageEndItemId);
      }
      
      override public function gotoToPage(param1:int) : IIterable
      {
         var _loc2_:int = _currentPage;
         var _loc3_:IIterable = super.gotoToPage(param1);
         if(_loc2_ != param1 && param1 > -1 && param1 < _pagesAmount)
         {
            dispatchEvent(new PaginatorEvent(PaginatorEvent.PAGE_CHANGED,_currentPage,_pagesAmount,this.currentPageStartItemId,this.currentPageEndItemId,_dataProvider.length,_itemsPerPage));
         }
         return _loc3_;
      }
      
      override public function getNextPage() : IIterable
      {
         var _loc1_:* = _currentPage + 1 < _pagesAmount;
         if(_loc1_)
         {
            ++_currentPage;
         }
         var _loc2_:IIterable = this.getCurrentPage();
         if(_loc1_)
         {
            dispatchEvent(new PaginatorEvent(PaginatorEvent.PAGE_CHANGED,_currentPage,_pagesAmount,this.currentPageStartItemId,this.currentPageEndItemId,_dataProvider.length,_itemsPerPage));
         }
         trace("SimplePaginator > getNextPage > _currentPage = [" + _currentPage + "]");
         return _loc2_;
      }
   }
}

package com.qb9.gaturro.view.gui.base.inventory.repeater.navigation
{
   import com.qb9.gaturro.commons.iterator.iterable.IIterable;
   import com.qb9.gaturro.commons.paginator.SmartPaginator;
   
   public class InventoryPageMenuPaginator extends SmartPaginator
   {
       
      
      public function InventoryPageMenuPaginator(param1:IIterable, param2:int)
      {
         super(param1,param2);
      }
      
      override public function getCurrentPage() : IIterable
      {
         this.setPageIds();
         return this.getProcessedPage();
      }
      
      private function getProcessedPage() : IIterable
      {
         var _loc1_:IIterable = _dataProvider.slice(currentPageStartItemId,currentPageEndItemId);
         if(_loc1_.length > 1)
         {
            (_loc1_.source as Array).unshift("prev");
            (_loc1_.source as Array).push("next");
            _loc1_.reset();
         }
         return _loc1_;
      }
      
      private function setPageIds() : void
      {
         if(Boolean(_dataProvider.length) && _currentPageEndItemId - _currentPageStartItemId == _itemsPerPage)
         {
            _currentPageEndItemId -= 2;
         }
      }
   }
}

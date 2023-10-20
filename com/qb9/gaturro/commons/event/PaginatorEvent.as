package com.qb9.gaturro.commons.event
{
   import flash.events.Event;
   
   public class PaginatorEvent extends Event
   {
      
      public static const PAGE_CHANGED:String = "pageChange";
       
      
      private var _currentPage:uint;
      
      private var _endItemId:uint;
      
      private var _itemsPerPage:uint;
      
      private var _startItemId:uint;
      
      private var _totalPage:uint;
      
      private var _totalItem:uint;
      
      public function PaginatorEvent(param1:String, param2:uint, param3:uint, param4:uint, param5:uint, param6:uint, param7:uint)
      {
         super(param1,true);
         this._currentPage = param2;
         this._totalPage = param3;
         this._startItemId = param4;
         this._endItemId = param5;
         this._totalItem = param6;
         this._itemsPerPage = param7;
      }
      
      public function get endItemId() : uint
      {
         return this._endItemId;
      }
      
      public function get itemsPerPage() : uint
      {
         return this._itemsPerPage;
      }
      
      public function get currentPage() : uint
      {
         return this._currentPage;
      }
      
      public function get startItemId() : uint
      {
         return this._startItemId;
      }
      
      public function get totalPage() : uint
      {
         return this._totalPage;
      }
      
      override public function clone() : Event
      {
         return new PaginatorEvent(type,this.currentPage,this.totalPage,this.startItemId,this.endItemId,this.totalItem,this.itemsPerPage);
      }
      
      public function get totalItem() : uint
      {
         return this._totalItem;
      }
   }
}

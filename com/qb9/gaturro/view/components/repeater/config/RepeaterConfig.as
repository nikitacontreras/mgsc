package com.qb9.gaturro.view.components.repeater.config
{
   import com.qb9.gaturro.view.components.repeater.item.BaseItemRenderer;
   import com.qb9.gaturro.view.components.repeater.item.IItemRendererFactory;
   import flash.display.Sprite;
   
   public class RepeaterConfig
   {
       
      
      private var _dataSource:Object;
      
      private var _itemsPerPage:int;
      
      private var _columns:int;
      
      private var _itemRendererClass:Class;
      
      private var _paginatorType:String;
      
      private var _usingSmartPaginator:Boolean;
      
      private var _itemContainer:Sprite;
      
      private var _initialPage:int = 0;
      
      private var _itemRendererFactory:IItemRendererFactory;
      
      private var _rows:int = 0;
      
      private var _selectable:int;
      
      public function RepeaterConfig(param1:String, param2:Object, param3:Sprite, param4:int)
      {
         this._itemRendererClass = BaseItemRenderer;
         super();
         this._paginatorType = param1;
         this._itemsPerPage = param4;
         this._itemContainer = param3;
         this._dataSource = param2;
      }
      
      public function set selectable(param1:int) : void
      {
         this._selectable = param1;
      }
      
      public function get initialPage() : int
      {
         return this._initialPage;
      }
      
      public function get itemsPerPage() : int
      {
         return this._itemsPerPage;
      }
      
      public function get selectable() : int
      {
         return this._selectable;
      }
      
      public function set itemRendererClass(param1:Class) : void
      {
         this._itemRendererClass = param1;
      }
      
      public function get rows() : int
      {
         return this._rows;
      }
      
      public function set paginatorType(param1:String) : void
      {
         this._paginatorType = param1;
      }
      
      public function get columns() : int
      {
         return this._columns;
      }
      
      public function set itemsPerPage(param1:int) : void
      {
         this._itemsPerPage = param1;
      }
      
      public function get itemRendererClass() : Class
      {
         return this._itemRendererClass;
      }
      
      public function get dataSource() : Object
      {
         return this._dataSource;
      }
      
      public function set initialPage(param1:int) : void
      {
         this._initialPage = param1;
      }
      
      public function get paginatorType() : String
      {
         return this._paginatorType;
      }
      
      public function get itemContainer() : Sprite
      {
         return this._itemContainer;
      }
      
      public function set rows(param1:int) : void
      {
         this._rows = param1;
      }
      
      public function set itemRendererFactory(param1:IItemRendererFactory) : void
      {
         this._itemRendererFactory = param1;
         this._itemRendererClass = null;
      }
      
      public function set columns(param1:int) : void
      {
         this._columns = param1;
      }
      
      public function get itemRendererFactory() : IItemRendererFactory
      {
         return this._itemRendererFactory;
      }
   }
}

package com.qb9.gaturro.view.components.repeater
{
   import com.qb9.gaturro.commons.event.ItemRendererEvent;
   import com.qb9.gaturro.commons.event.RepeaterEvent;
   import com.qb9.gaturro.commons.iterator.iterable.IIterable;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.view.components.repeater.item.AbstractItemRenderer;
   import com.qb9.gaturro.view.components.repeater.item.IItemRendererFactory;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   
   public class Repeater extends Sprite implements IRepeater
   {
      
      public static const NOT_SELECTABLE:int = 0;
      
      public static const VERTICAL:int = 1;
      
      public static const HORIZONTAL:int = 0;
      
      public static const MULTI_SELECTABLE:int = 2;
      
      public static const SINGLE_SELECTABLE:int = 1;
       
      
      protected var _indexByItemShowed:Dictionary;
      
      private var _disposed:Boolean = false;
      
      protected var offset:Point;
      
      protected var _dataProvider:IIterable;
      
      protected var _columns:int = 0;
      
      public var itemContainer_spr:Sprite;
      
      protected var maxItemHeight:Number;
      
      protected var _selectedItem:Array;
      
      protected var _itemList:Array;
      
      private var _selectedId:Array;
      
      protected var _rows:int = 0;
      
      protected var _indexByItem:Dictionary;
      
      protected var _layout:int = 0;
      
      protected var _selectedData:Array;
      
      protected var _showedItemList:Array;
      
      protected var maxItemWidth:Number;
      
      protected var _selectable:int;
      
      protected var _itemRendererFactory:IItemRendererFactory;
      
      public function Repeater(param1:IIterable, param2:Class = null, param3:int = 0)
      {
         this.offset = new Point();
         super();
         this._dataProvider = param1;
         this.setupItemRenderer(param2);
         this.setupSelection(param3);
         this._itemList = new Array();
         this._showedItemList = new Array();
      }
      
      protected function hasLabel(param1:MovieClip, param2:String) : Boolean
      {
         var _loc3_:String = null;
         for each(_loc3_ in param1.currentLabels)
         {
            if(param2 == _loc3_)
            {
               return true;
            }
         }
         return false;
      }
      
      public function get selectedData() : Array
      {
         return this._selectedData.concat();
      }
      
      private function setupSelection(param1:int) : void
      {
         this._selectable = param1;
         if(this._selectable != NOT_SELECTABLE)
         {
            if(!this._selectedId)
            {
               this._selectedId = new Array();
            }
            if(!this._selectedItem)
            {
               this._selectedItem = new Array();
            }
            if(!this._selectedData)
            {
               this._selectedData = new Array();
            }
         }
      }
      
      protected function onItemClick(param1:ItemRendererEvent) : void
      {
         this.addSelectedIndex(AbstractItemRenderer(param1.currentTarget).itemId);
      }
      
      protected function removeItems() : void
      {
         var _loc1_:AbstractItemRenderer = null;
         if(this._itemList)
         {
            while(this._itemList.length > 0)
            {
               _loc1_ = this._itemList.pop();
               this.removeItemEvents(_loc1_);
               _loc1_.dispose();
               if(contains(_loc1_))
               {
                  removeChild(_loc1_);
               }
            }
         }
      }
      
      public function dispose() : void
      {
         this.resetItems();
         this._itemList = null;
         this._showedItemList = null;
         this._indexByItem = null;
         this._indexByItemShowed = null;
         if(this._dataProvider)
         {
            this._dataProvider.dispose();
         }
         this._dataProvider = null;
         this._disposed = true;
      }
      
      private function removeFromShowedList(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = undefined;
         if(param1)
         {
            _loc2_ = int(this._indexByItemShowed[param1]);
            delete this._indexByItemShowed[param1];
            for(_loc3_ in this._indexByItemShowed)
            {
               if(this._indexByItemShowed[_loc3_] > _loc2_)
               {
                  --this._indexByItemShowed[_loc3_];
               }
            }
            this._showedItemList.splice(_loc2_,1);
         }
      }
      
      private function setupItemRenderer(param1:Class) : void
      {
         if(param1)
         {
            this._itemRendererFactory = new DefaultItemRedererFactory(param1);
         }
      }
      
      public function addSelectedItem(param1:AbstractItemRenderer) : void
      {
         var _loc2_:int = 0;
         if(this._selectable != NOT_SELECTABLE)
         {
            if(this._selectable == SINGLE_SELECTABLE)
            {
               this.applyDeselection();
            }
            _loc2_ = int(this._indexByItem[param1]);
            _loc2_ = Boolean(param1) && _loc2_ >= 0 ? _loc2_ : -1;
            this.applySelection(_loc2_,param1);
         }
      }
      
      public function get layout() : int
      {
         return this._layout;
      }
      
      public function get disposed() : Boolean
      {
         return this._disposed;
      }
      
      protected function createItem(param1:int) : AbstractItemRenderer
      {
         var _loc2_:AbstractItemRenderer = this._itemRendererFactory.buildItemRenderer(this._dataProvider.getValue(param1));
         _loc2_.itemId = param1;
         this.setupItemEvents(_loc2_);
         return _loc2_;
      }
      
      protected function resetItems() : void
      {
         this.removeItems();
         this.resetShowedList();
         this.cleanDisplayList();
      }
      
      public function set rows(param1:int) : void
      {
         if(param1 < 0)
         {
            logger.debug("Neither columns nor rows properties are setted");
            throw new Error("ERROR: Invalid value. The value has to be positive");
         }
         this._rows = param1;
      }
      
      public function refreshContent() : void
      {
         var _loc1_:AbstractItemRenderer = null;
         for each(_loc1_ in this._itemList)
         {
            _loc1_.refresh();
         }
      }
      
      protected function calculateLayout() : void
      {
         if(!this._rows && !this._columns || !this._dataProvider)
         {
            return;
         }
         if(this._columns)
         {
            this._rows = Math.ceil(this._dataProvider.length / this._columns);
         }
         else if(this._rows)
         {
            this._columns = Math.ceil(this._dataProvider.length / this._rows);
         }
      }
      
      protected function placeItem(param1:AbstractItemRenderer, param2:int) : void
      {
         param1.x = this.offset.x;
         param1.y = this.offset.y;
         if(Boolean(this._rows) || Boolean(this.layout))
         {
            if((param2 + 1) % this._rows == 0)
            {
               this.offset.x = param1.width + param1.x;
               this.offset.y = 0;
            }
            else
            {
               this.offset.y = param1.height + param1.y;
            }
         }
         else if((param2 + 1) % this._columns == 0)
         {
            this.offset.x = 0;
            this.offset.y = param1.height + param1.y;
         }
         else
         {
            this.offset.x = param1.width + param1.x;
         }
      }
      
      public function get itemRendererFactory() : IItemRendererFactory
      {
         return this._itemRendererFactory;
      }
      
      private function onShowItem(param1:ItemRendererEvent) : void
      {
         var _loc2_:AbstractItemRenderer = param1.itemRenderer as AbstractItemRenderer;
         var _loc3_:int = int(this._indexByItem[_loc2_]);
         addChild(_loc2_);
         this._showedItemList.splice(_loc3_,0,_loc2_);
         this.arrangeItems(this._showedItemList);
      }
      
      private function removeItemEvents(param1:Sprite) : void
      {
         param1.removeEventListener(ItemRendererEvent.ITEM_SELECTED,this.onItemClick);
         param1.removeEventListener(ItemRendererEvent.REMOVE,this.onItemAutoRemove);
         param1.removeEventListener(ItemRendererEvent.SHOW,this.onShowItem);
         param1.removeEventListener(ItemRendererEvent.HIDE,this.onHideItem);
      }
      
      public function set columns(param1:int) : void
      {
         if(param1 < 0)
         {
            throw new Error("ERROR: Invalid value. The value has to be positive");
         }
         this._columns = param1;
      }
      
      public function get dataProvider() : IIterable
      {
         return this._dataProvider;
      }
      
      private function getItemFromItemList(param1:int) : AbstractItemRenderer
      {
         var _loc2_:AbstractItemRenderer = null;
         if(param1 < this._itemList.length)
         {
            _loc2_ = this._itemList[param1];
         }
         return _loc2_;
      }
      
      private function getDataFromDataProvider(param1:int) : Object
      {
         var _loc2_:Object = null;
         if(param1 < this._dataProvider.length)
         {
            _loc2_ = this._dataProvider.getValue(param1);
         }
         return _loc2_;
      }
      
      private function removeItem(param1:AbstractItemRenderer) : void
      {
         this.removeFromMainList(param1);
         this.removeFromShowedList(param1);
         removeChild(param1);
         param1.dispose();
      }
      
      private function onItemAutoRemove(param1:ItemRendererEvent) : void
      {
         this.removeItem(param1.itemRenderer as AbstractItemRenderer);
         this.arrangeItems(this._itemList);
      }
      
      private function applySelection(param1:int, param2:AbstractItemRenderer) : void
      {
         if(param1 >= 0 && this._selectable != NOT_SELECTABLE)
         {
            this._selectedId.push(param1);
            this._selectedItem.push(param2);
            this._selectedData.push(this._dataProvider.getValue(param1));
            if(Boolean(param2) && !param2.isSelected)
            {
               param2.select();
            }
         }
      }
      
      public function get selectedItem() : Array
      {
         return this._selectedItem;
      }
      
      private function resetShowedList() : void
      {
         if(Boolean(this._showedItemList) && Boolean(this._showedItemList.length))
         {
            this._showedItemList.length = 0;
         }
         if(Boolean(this._indexByItemShowed) && Boolean(this._indexByItemShowed.length))
         {
            this._indexByItemShowed.length = 0;
         }
      }
      
      public function get itemList() : Array
      {
         return this._itemList;
      }
      
      public function set layout(param1:int) : void
      {
         if(param1 < 0 || param1 > 1)
         {
            logger.debug("ERROR: The value is invalid");
            throw new Error("ERROR: The value is invalid");
         }
         this._layout = param1;
      }
      
      public function addSelectedIndex(param1:int) : void
      {
         if(this._selectable != NOT_SELECTABLE && param1 >= 0)
         {
            if(this._selectable == SINGLE_SELECTABLE)
            {
               this.applyDeselection();
            }
            this.applySelection(param1,this.itemList[param1]);
         }
      }
      
      public function clearSelection() : void
      {
         if(this._selectable != NOT_SELECTABLE)
         {
            this.applyDeselection();
         }
      }
      
      public function get rows() : int
      {
         return this._rows;
      }
      
      public function refresh() : void
      {
         var _loc1_:AbstractItemRenderer = null;
         var _loc2_:AbstractItemRenderer = null;
         var _loc3_:Object = null;
         var _loc9_:AbstractItemRenderer = null;
         this.offset = new Point();
         this.maxItemHeight = this.maxItemWidth = 0;
         var _loc4_:int = Math.max(this._dataProvider.length,this._itemList.length);
         var _loc5_:Array = new Array();
         var _loc6_:Array = new Array();
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         while(_loc8_ < _loc4_)
         {
            _loc2_ = this.getItemFromItemList(_loc8_);
            _loc3_ = this.getDataFromDataProvider(_loc8_);
            _loc1_ = this._itemRendererFactory.refreshItemRenderer(_loc2_,_loc3_);
            if(!_loc1_)
            {
               _loc6_.push(_loc2_);
            }
            else
            {
               if(!_loc2_)
               {
                  this.setupItemEvents(_loc1_);
               }
               _loc1_.itemId = _loc7_;
               _loc5_.push(_loc1_);
               this._indexByItem[_loc1_] = _loc7_;
               this._indexByItemShowed[_loc1_] = _loc7_;
               if(!_loc2_)
               {
                  addChildAt(_loc1_,_loc7_);
               }
               else if(_loc2_ != _loc1_)
               {
                  _loc6_.push(_loc2_);
                  addChildAt(_loc1_,_loc7_);
               }
               this.placeItem(_loc1_,_loc8_);
               _loc7_++;
            }
            _loc8_++;
         }
         for each(_loc9_ in _loc6_)
         {
            this.removeItem(_loc9_);
         }
         this._itemList = _loc5_;
         dispatchEvent(new RepeaterEvent(RepeaterEvent.CREATION_COMPLETE));
      }
      
      private function applyDeselection() : void
      {
         var _loc1_:AbstractItemRenderer = null;
         for each(_loc1_ in this._selectedItem)
         {
            _loc1_.deselect();
         }
         this._selectedId.length = 0;
         this._selectedItem.length = 0;
         this._selectedData.length = 0;
      }
      
      protected function buildItemList() : void
      {
         var _loc2_:AbstractItemRenderer = null;
         this.offset = new Point();
         this.maxItemWidth = 0;
         this.maxItemHeight = 0;
         var _loc1_:uint = uint(this._dataProvider.length);
         this._indexByItem = new Dictionary();
         this._indexByItemShowed = new Dictionary();
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_)
         {
            _loc2_ = this.createItem(_loc3_);
            if(_loc2_)
            {
               addChild(_loc2_);
               this._itemList.push(_loc2_);
               this._showedItemList.push(_loc2_);
               this._indexByItem[_loc2_] = _loc3_;
               this._indexByItemShowed[_loc2_] = _loc3_;
               this.placeItem(_loc2_,_loc3_);
            }
            _loc3_++;
         }
      }
      
      public function get columns() : int
      {
         return this._columns;
      }
      
      private function removeFromMainList(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = undefined;
         if(param1)
         {
            _loc2_ = int(this._indexByItem[param1]);
            delete this._indexByItem[param1];
            for(_loc3_ in this._indexByItem)
            {
               if(this._indexByItem[_loc3_] > _loc2_)
               {
                  --this._indexByItem[_loc3_];
               }
            }
            this._itemList.splice(_loc2_,1);
            if(_loc2_ <= this._dataProvider.length)
            {
               this._dataProvider.remove(_loc2_,1);
            }
         }
      }
      
      public function set itemRendererFactory(param1:IItemRendererFactory) : void
      {
         this._itemRendererFactory = param1;
      }
      
      protected function setupItemEvents(param1:Sprite) : void
      {
         if(this._selectable)
         {
            param1.addEventListener(ItemRendererEvent.ITEM_SELECTED,this.onItemClick);
         }
         param1.addEventListener(ItemRendererEvent.REMOVE,this.onItemAutoRemove);
         param1.addEventListener(ItemRendererEvent.SHOW,this.onShowItem);
         param1.addEventListener(ItemRendererEvent.HIDE,this.onHideItem);
      }
      
      public function get itemAmount() : int
      {
         return this._itemList.length;
      }
      
      public function build() : void
      {
         if(!this._dataProvider)
         {
            logger.debug("There isn\'t any dataProvider setted");
            throw new Error("There isn\'t any dataProvider setted");
         }
         if(!this._columns && !this._rows)
         {
            logger.debug("Neither columns nor rows properties are setted");
            throw new Error("Neither columns nor rows properties are setted");
         }
         this.resetItems();
         this.buildItemList();
         dispatchEvent(new RepeaterEvent(RepeaterEvent.CREATION_COMPLETE));
      }
      
      private function onHideItem(param1:ItemRendererEvent) : void
      {
         var _loc2_:AbstractItemRenderer = param1.itemRenderer as AbstractItemRenderer;
         var _loc3_:int = int(this._indexByItemShowed[_loc2_]);
         removeChild(_loc2_);
         this._showedItemList.splice(_loc3_,1);
         delete this._indexByItemShowed[_loc2_];
         this.arrangeItems(this._showedItemList);
      }
      
      public function set dataProvider(param1:IIterable) : void
      {
         this._dataProvider = param1;
      }
      
      private function cleanDisplayList() : void
      {
         while(numChildren)
         {
            removeChildAt(0);
         }
      }
      
      private function arrangeItems(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:AbstractItemRenderer = null;
         this.offset = new Point();
         this.maxItemHeight = this.maxItemWidth = 0;
         for each(_loc3_ in param1)
         {
            this._indexByItemShowed[_loc3_] = _loc2_;
            this.placeItem(_loc3_,_loc2_);
            _loc2_++;
         }
      }
      
      public function get selectedIndex() : Array
      {
         return this._selectedId.concat();
      }
   }
}

import com.qb9.gaturro.view.components.repeater.item.AbstractItemRenderer;
import com.qb9.gaturro.view.components.repeater.item.IItemRendererFactory;

class DefaultItemRedererFactory implements IItemRendererFactory
{
    
   
   private var itemRendererClass:Class;
   
   public function DefaultItemRedererFactory(param1:Class)
   {
      super();
      this.itemRendererClass = param1;
   }
   
   public function refreshItemRenderer(param1:AbstractItemRenderer, param2:Object = null) : AbstractItemRenderer
   {
      if(Boolean(param1) && Boolean(param2))
      {
         param1.refresh(param2);
      }
      else if(Boolean(param1) && !param2)
      {
         param1 = null;
      }
      else if(!param1 && Boolean(param2))
      {
         param1 = this.buildItemRenderer(param2);
      }
      return param1;
   }
   
   public function buildItemRenderer(param1:Object) : AbstractItemRenderer
   {
      var _loc2_:AbstractItemRenderer = new this.itemRendererClass();
      _loc2_.data = param1;
      return _loc2_;
   }
}

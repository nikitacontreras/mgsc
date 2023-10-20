package com.qb9.gaturro.view.components.repeater.item
{
   import com.qb9.gaturro.commons.error.AbstractMethodError;
   import com.qb9.gaturro.commons.event.ItemRendererEvent;
   import flash.display.Sprite;
   
   public class AbstractItemRenderer extends Sprite implements IDataItemRenderer
   {
       
      
      protected var _selected:Boolean;
      
      private var _disposed:Boolean;
      
      protected var _data:Object;
      
      protected var _itemId:int;
      
      public function AbstractItemRenderer()
      {
         super();
      }
      
      protected function hide() : void
      {
         dispatchEvent(new ItemRendererEvent(ItemRendererEvent.HIDE,this));
      }
      
      public function select() : void
      {
         this._selected = true;
      }
      
      public function get disposed() : Boolean
      {
         return this._disposed;
      }
      
      protected function show() : void
      {
         dispatchEvent(new ItemRendererEvent(ItemRendererEvent.SHOW,this));
      }
      
      public function get itemId() : int
      {
         return this._itemId;
      }
      
      protected function autoRemove() : void
      {
         dispatchEvent(new ItemRendererEvent(ItemRendererEvent.REMOVE,this));
      }
      
      public function set data(param1:Object) : void
      {
         this._data = param1;
         this.dataReady();
      }
      
      public function deselect() : void
      {
         this._selected = false;
      }
      
      protected function dataReady() : void
      {
         dispatchEvent(new ItemRendererEvent(ItemRendererEvent.DATA_READY,this));
      }
      
      public function refresh(param1:Object = null) : void
      {
         throw new AbstractMethodError();
      }
      
      public function set itemId(param1:int) : void
      {
         this._itemId = param1;
      }
      
      public function get isSelected() : Boolean
      {
         return this._selected;
      }
      
      public function dispose() : void
      {
         this._disposed = true;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      protected function innerSelect() : void
      {
         this.select();
         var _loc1_:ItemRendererEvent = new ItemRendererEvent(ItemRendererEvent.ITEM_SELECTED,this);
         dispatchEvent(_loc1_);
      }
      
      protected function innerDeselect() : void
      {
         this.deselect();
         dispatchEvent(new ItemRendererEvent(ItemRendererEvent.ITEM_DESELECTED,this));
      }
   }
}

package com.qb9.gaturro.commons.event
{
   import com.qb9.gaturro.view.components.repeater.item.IDataItemRenderer;
   import flash.events.Event;
   
   public class ItemRendererEvent extends Event
   {
      
      public static const REMOVE:String = "remove";
      
      public static const ITEM_SELECTED:String = "itemSelected";
      
      public static const ITEM_DESELECTED:String = "itemDeselected";
      
      public static const HIDE:String = "hide";
      
      public static const DATA_READY:String = "dataReady";
      
      public static const CREATION_COMPLETE:String = "creationComplete";
      
      public static const SHOW:String = "show";
       
      
      private var _itemRenderer:IDataItemRenderer;
      
      private var _isItemHighlighted:Boolean;
      
      public function ItemRendererEvent(param1:String, param2:IDataItemRenderer)
      {
         super(param1,true);
         this._itemRenderer = param2;
      }
      
      public function get itemId() : int
      {
         return this._itemRenderer.itemId;
      }
      
      public function get itemRenderer() : IDataItemRenderer
      {
         return this._itemRenderer;
      }
      
      public function get isItemHighlighted() : Boolean
      {
         return this._isItemHighlighted;
      }
      
      public function set isItemHighlighted(param1:Boolean) : void
      {
         this._isItemHighlighted = param1;
      }
      
      override public function toString() : String
      {
         return formatToString("ItemRendererEvent","type","itemRenderer","bubbles","cancelable","eventPhase");
      }
      
      override public function clone() : Event
      {
         return new ItemRendererEvent(type,this.itemRenderer);
      }
   }
}

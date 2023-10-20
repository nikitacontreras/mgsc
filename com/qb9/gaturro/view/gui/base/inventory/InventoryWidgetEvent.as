package com.qb9.gaturro.view.gui.base.inventory
{
   import com.qb9.gaturro.view.gui.base.inventory.repeater.inventory.InventoryWidgetCell;
   import com.qb9.mambo.core.objects.SceneObject;
   import flash.events.Event;
   
   public final class InventoryWidgetEvent extends Event
   {
      
      public static const SELECTED:String = "iweItemSelected";
      
      public static const UNSELECTED:String = "iweItemUnselected";
       
      
      private var _cell:InventoryWidgetCell;
      
      public function InventoryWidgetEvent(param1:String, param2:InventoryWidgetCell = null)
      {
         super(param1,true,true);
         this._cell = param2;
      }
      
      public function get cell() : InventoryWidgetCell
      {
         return this._cell;
      }
      
      public function get item() : SceneObject
      {
         return !!this.cell ? this.cell.item : null;
      }
      
      override public function clone() : Event
      {
         return new InventoryWidgetEvent(type,this.cell);
      }
   }
}

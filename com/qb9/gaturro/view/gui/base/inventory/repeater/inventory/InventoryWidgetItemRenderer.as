package com.qb9.gaturro.view.gui.base.inventory.repeater.inventory
{
   import com.qb9.gaturro.view.components.repeater.item.BaseItemRenderer;
   import flash.events.MouseEvent;
   
   public class InventoryWidgetItemRenderer extends BaseItemRenderer
   {
       
      
      public function InventoryWidgetItemRenderer()
      {
         super(InventoryWidgetCell);
      }
      
      public function get cell() : InventoryWidgetCell
      {
         return InventoryWidgetCell(view);
      }
      
      override public function deselect() : void
      {
         super.deselect();
         this.cell.selected = false;
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(this.cell.selected)
         {
            innerDeselect();
         }
         else
         {
            innerSelect();
         }
      }
      
      override protected function setupView() : void
      {
         super.setupView();
         addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function setItem(param1:Array) : void
      {
         this.cell.setItems(param1);
      }
      
      override protected function dataReady() : void
      {
         super.dataReady();
         this.setItem(data as Array);
      }
      
      override public function refresh(param1:Object = null) : void
      {
         super.refresh(param1);
         this.setItem(data as Array);
      }
      
      override public function select() : void
      {
         super.select();
         this.cell.selected = true;
      }
   }
}

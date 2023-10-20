package com.qb9.gaturro.view.gui.base.inventory.repeater.navigation
{
   import com.qb9.gaturro.commons.event.ItemRendererEvent;
   import com.qb9.gaturro.view.components.repeater.item.AbstractItemRenderer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class InventoryPageItemRenderer extends AbstractItemRenderer
   {
       
      
      private var view:PageInventoryItemRendererAsset;
      
      private var label:TextField;
      
      public function InventoryPageItemRenderer()
      {
         super();
         this.setupView();
      }
      
      private function setupView() : void
      {
         this.view = new PageInventoryItemRendererAsset();
         buttonMode = true;
         mouseChildren = false;
         addChild(this.view);
         addEventListener(MouseEvent.CLICK,this.onClik);
         addEventListener(MouseEvent.MOUSE_OVER,this.onOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onOut);
      }
      
      override public function deselect() : void
      {
         super.deselect();
         MovieClip(this.view).gotoAndStop("deselect");
         mouseEnabled = true;
         buttonMode = true;
      }
      
      private function onClik(param1:MouseEvent) : void
      {
         this.innerSelect();
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         if(!_selected)
         {
            MovieClip(this.view).gotoAndStop("deselect");
         }
      }
      
      private function setupTextfield() : void
      {
         this.label = this.view.getChildByName("label") as TextField;
         this.setText();
      }
      
      override protected function innerSelect() : void
      {
         var _loc1_:ItemRendererEvent = new ItemRendererEvent(ItemRendererEvent.ITEM_SELECTED,this);
         dispatchEvent(_loc1_);
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         MovieClip(this.view).gotoAndStop("over");
      }
      
      private function setText() : void
      {
         this.label.text = data.toString();
      }
      
      override protected function dataReady() : void
      {
         super.dataReady();
         this.setupTextfield();
      }
      
      override public function select() : void
      {
         _selected = true;
         MovieClip(this.view).gotoAndStop("selected");
         mouseEnabled = false;
         buttonMode = false;
      }
      
      override public function refresh(param1:Object = null) : void
      {
         if(param1 != null)
         {
            data = param1;
         }
         this.setText();
      }
      
      override public function dispose() : void
      {
         removeEventListener(MouseEvent.CLICK,this.onClik);
         removeEventListener(MouseEvent.MOUSE_OVER,this.onOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.onOut);
         super.dispose();
      }
   }
}

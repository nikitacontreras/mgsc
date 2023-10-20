package com.qb9.gaturro.view.components.banner.emoting
{
   import com.qb9.gaturro.commons.event.ItemRendererEvent;
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.view.components.canvas.impl.itemConsumer.ItemConsumerWidget;
   import com.qb9.gaturro.view.gui.banner.properties.IHasRoomAPI;
   import com.qb9.gaturro.view.gui.base.inventory.repeater.inventory.InventoryWidgetItemRenderer;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class EmotingConfigurationBanner extends InstantiableGuiModal implements IHasRoomAPI
   {
       
      
      private var _roomAPI:GaturroRoomAPI;
      
      private var widget:ItemConsumerWidget;
      
      private var items:MovieClip;
      
      private var actions:MovieClip;
      
      public function EmotingConfigurationBanner()
      {
         super("EmotingConfigurationBanner","Asset");
         this.setup();
      }
      
      override protected function ready() : void
      {
         this.items = view.getChildByName("items") as MovieClip;
         this.actions = view.getChildByName("actions") as MovieClip;
         this.widget.elements = this._roomAPI.user.allItemsGrouped;
         this.items.addChild(this.widget);
      }
      
      private function onWidgetClick(param1:MouseEvent) : void
      {
         trace(param1);
         var _loc2_:Sprite = param1.target.parent as Sprite;
         var _loc3_:BitmapData = new BitmapData(_loc2_.width,_loc2_.height);
         _loc3_.draw(_loc2_);
         var _loc4_:Bitmap = new Bitmap(_loc3_);
         var _loc5_:Sprite;
         (_loc5_ = new Sprite()).addChild(_loc4_);
         this.actions.addChild(_loc5_);
      }
      
      private function setup() : void
      {
         this.widget = new ItemConsumerWidget(6,4,true);
         this.widget.addEventListener(MouseEvent.MOUSE_DOWN,this.onWidgetClick);
         this.widget.addEventListener(ItemRendererEvent.ITEM_SELECTED,this.onItemSelected);
      }
      
      private function onItemSelected(param1:ItemRendererEvent) : void
      {
         var _loc2_:InventoryWidgetItemRenderer = param1.target as InventoryWidgetItemRenderer;
         trace(_loc2_.cell.item);
      }
      
      public function set roomAPI(param1:GaturroRoomAPI) : void
      {
         this._roomAPI = param1;
      }
   }
}

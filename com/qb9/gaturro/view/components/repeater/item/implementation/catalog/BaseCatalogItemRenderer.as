package com.qb9.gaturro.view.components.repeater.item.implementation.catalog
{
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.view.components.repeater.item.BaseItemRenderer;
   import com.qb9.gaturro.world.catalog.CatalogItem;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class BaseCatalogItemRenderer extends BaseItemRenderer
   {
       
      
      protected var imageContainer:Sprite;
      
      protected var catalogItemName:String;
      
      protected var api:GaturroRoomAPI;
      
      protected var image:DisplayObject;
      
      public function BaseCatalogItemRenderer(param1:GaturroRoomAPI, param2:Class)
      {
         super(param2);
         this.api = param1;
      }
      
      override public function refresh(param1:Object = null) : void
      {
         if(param1 != null)
         {
            this.imageContainer.removeChild(this.image);
         }
         super.refresh(param1);
      }
      
      protected function onFetchCompleted(param1:DisplayObject) : void
      {
         this.image = param1;
         this.imageContainer.addChild(this.image);
         dispatchEvent(new Event(Event.COMPLETE,true));
      }
      
      override protected function dataReady() : void
      {
         super.dataReady();
         this.catalogItemName = !!(data as CatalogItem) ? CatalogItem(data).name : String(data.toString());
         this.imageContainer = view.getChildByName("imageContainer") as Sprite;
         this.api.libraries.fetch(this.catalogItemName,this.onFetchCompleted);
      }
      
      override public function dispose() : void
      {
         this.api = null;
         this.imageContainer = null;
         super.dispose();
      }
   }
}

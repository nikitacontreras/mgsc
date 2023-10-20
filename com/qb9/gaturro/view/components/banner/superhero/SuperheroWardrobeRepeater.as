package com.qb9.gaturro.view.components.banner.superhero
{
   import com.qb9.gaturro.commons.dispose.ICheckableDisposable;
   import com.qb9.gaturro.commons.paginator.PaginatorFactory;
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.view.components.repeater.NavegableRepeater;
   import com.qb9.gaturro.view.components.repeater.config.NavegableRepeaterConfig;
   import com.qb9.gaturro.view.components.repeater.item.implementation.catalog.BaseCatalogItemRendererFactory;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import com.qb9.gaturro.world.catalog.CatalogItem;
   import flash.display.Sprite;
   
   public class SuperheroWardrobeRepeater implements ICheckableDisposable
   {
      
      private static const ITEM_RENDERER_ASSET:String = "costumeSuperheroItemRendererAsset";
      
      private static const ITEM_CONTAINER_NAME:String = "itemContainer";
       
      
      private var container:Sprite;
      
      private var catalogName:String;
      
      private var repeater:NavegableRepeater;
      
      private var _disposed:Boolean;
      
      private var owner:InstantiableGuiModal;
      
      private var api:GaturroRoomAPI;
      
      public function SuperheroWardrobeRepeater(param1:InstantiableGuiModal, param2:GaturroRoomAPI, param3:Sprite, param4:String)
      {
         super();
         this.owner = param1;
         this.catalogName = param4;
         this.container = param3;
         this.api = param2;
         this.setup();
      }
      
      private function getRepeaterConfig(param1:Object) : NavegableRepeaterConfig
      {
         var _loc2_:Sprite = this.container.getChildByName(ITEM_CONTAINER_NAME) as Sprite;
         var _loc3_:NavegableRepeaterConfig = new NavegableRepeaterConfig(PaginatorFactory.LOOP_TYPE,param1.items,_loc2_,this.container,1);
         _loc3_.rows = 1;
         _loc3_.columns = 1;
         _loc3_.itemRendererFactory = new BaseCatalogItemRendererFactory(this.api,this.owner.getDefinition("costumeSuperheroItemRendererAsset"));
         return _loc3_;
      }
      
      public function get disposed() : Boolean
      {
         return this._disposed;
      }
      
      public function getCurrentItem() : CatalogItem
      {
         return this.repeater.dataProvider.getValue(this.repeater.currentPage);
      }
      
      private function setup() : void
      {
         this.api.room.getCatalogData(this.catalogName,this.onCatalogGetted);
      }
      
      private function onCatalogGetted(param1:Object, param2:Object = null) : void
      {
         var _loc3_:NavegableRepeaterConfig = this.getRepeaterConfig(param1);
         this.repeater = new NavegableRepeater(_loc3_);
         this.repeater.init();
      }
      
      public function dispose() : void
      {
         this.owner = null;
         this.container = null;
         this.api = null;
         this.repeater.dispose();
         this.repeater = null;
         this._disposed = true;
      }
   }
}

package com.qb9.gaturro.view.gui.catalog.items
{
   import assets.CatalogItemMC;
   import assets.MissingAssetMC;
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.flashlib.utils.StringUtil;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.view.gui.util.GuiUtil;
   import com.qb9.gaturro.world.catalog.CatalogItem;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public final class CatalogModalItemView extends CatalogItemMC implements IDisposable
   {
       
      
      private var _asset:MovieClip;
      
      private var _item:CatalogItem;
      
      public function CatalogModalItemView(param1:CatalogItem)
      {
         super();
         this._item = param1;
         this.init();
      }
      
      public function add(param1:DisplayObject) : void
      {
         this._asset = param1 as MovieClip;
         if(this.asset)
         {
            this.resize(this.asset);
         }
         else
         {
            param1 = new MissingAssetMC();
         }
         DisplayUtil.disableMouse(ph);
         ph.addChild(param1);
      }
      
      private function init() : void
      {
         this.unselect();
         price.price.text = StringUtil.numberSeparator(this.item.price);
         free.visible = !this.item.vip;
         if(Boolean(this.item.promo) && region.country == "AR")
         {
            promo.visible = true;
         }
         else
         {
            promo.visible = false;
         }
         if(this.item.limited)
         {
            limited.visible = true;
         }
         else
         {
            limited.visible = false;
         }
         if(this.item.newItem)
         {
            newItem.visible = true;
         }
         else
         {
            newItem.visible = false;
         }
         if(this.item.oldPrice)
         {
            oldPrice.price.price.text = StringUtil.numberSeparator(this.item.oldPrice);
            oldPrice.visible = true;
         }
         else
         {
            oldPrice.visible = false;
         }
         if(this.item.dataByKey("emblema"))
         {
            api.libraries.fetch(this.item.dataByKey("emblema"),this.addToEmblem);
         }
         else
         {
            emblem.visible = false;
         }
         addEventListener(MouseEvent.ROLL_OVER,this.roll);
         addEventListener(MouseEvent.ROLL_OUT,this.roll);
      }
      
      private function resize(param1:DisplayObject) : void
      {
         ph.scaleY = 1;
         ph.scaleX = 1;
         GuiUtil.fit(param1,110,80,25,20);
      }
      
      public function unselect() : void
      {
         gotoAndStop(1);
         buttonMode = true;
      }
      
      private function addToEmblem(param1:DisplayObject) : void
      {
         GuiUtil.fit(param1,40,40);
         emblem.addChild(param1);
      }
      
      public function get asset() : MovieClip
      {
         return this._asset;
      }
      
      public function get item() : CatalogItem
      {
         return this._item;
      }
      
      private function get selected() : Boolean
      {
         return currentFrame === 3;
      }
      
      public function select() : void
      {
         gotoAndStop(3);
         buttonMode = false;
      }
      
      private function roll(param1:Event) : void
      {
         if(!this.selected)
         {
            gotoAndStop(param1.type === MouseEvent.ROLL_OVER ? 2 : 1);
         }
      }
      
      public function dispose() : void
      {
         removeEventListener(MouseEvent.ROLL_OVER,this.roll);
         removeEventListener(MouseEvent.ROLL_OUT,this.roll);
      }
   }
}

package com.qb9.gaturro.view.gui.base.itemList.items
{
   import assets.ItemButtonMC;
   import assets.MissingAssetMC;
   import com.qb9.flashlib.utils.StringUtil;
   import com.qb9.gaturro.user.inventory.GaturroInventorySceneObject;
   import com.qb9.gaturro.view.gui.util.GuiUtil;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.utils.setTimeout;
   
   public class BaseItemListItemView extends ItemButtonMC
   {
       
      
      protected var _asset:MovieClip;
      
      protected var _item:Object;
      
      public function BaseItemListItemView(param1:Object)
      {
         super();
         this._item = param1;
         this.init();
      }
      
      public function add(param1:DisplayObject) : void
      {
         setTimeout(this._add,100,param1);
      }
      
      private function _add(param1:DisplayObject) : void
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
         ph.addChild(param1);
      }
      
      private function init() : void
      {
         buy_txt.mouseEnabled = false;
         price.text = StringUtil.numberSeparator(this.itemPrice);
      }
      
      private function resize(param1:DisplayObject) : void
      {
         ph.scaleY = 1;
         ph.scaleX = 1;
         GuiUtil.fit(param1,90,75,20,12);
      }
      
      public function get itemPrice() : Number
      {
         return 0;
      }
      
      public function get asset() : MovieClip
      {
         return this._asset;
      }
      
      public function get item() : GaturroInventorySceneObject
      {
         if(this._item is GaturroInventorySceneObject)
         {
            return GaturroInventorySceneObject(this._item);
         }
         return null;
      }
      
      public function get itemName() : String
      {
         return this._item.name;
      }
   }
}

package com.qb9.gaturro.view.components.banner.alert
{
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.view.gui.banner.properties.IHasData;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import com.qb9.gaturro.view.gui.util.GuiUtil;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.text.TextField;
   
   public class SkinableAlertBanner extends InstantiableGuiModal implements IHasData
   {
       
      
      private var _data:Object;
      
      public function SkinableAlertBanner()
      {
         super();
      }
      
      private function setupTextfield(param1:String, param2:String) : void
      {
         var _loc3_:TextField = view.getChildByName(param2) as TextField;
         _loc3_.text = param1;
      }
      
      private function onImageLoaded(param1:DisplayObject) : void
      {
         var _loc2_:DisplayObjectContainer = view.getChildByName("imageHolder") as DisplayObjectContainer;
         var _loc3_:DisplayObject = view.getChildByName("sizeRef");
         _loc2_.addChild(param1);
         GuiUtil.fit(param1,_loc3_.width,_loc3_.height);
      }
      
      override protected function ready() : void
      {
         if(this._data.text)
         {
            this.setupTextfield(this._data.text,"textTF");
         }
         if(this._data.title)
         {
            this.setupTextfield(this._data.title,"titleTF");
         }
         if(this._data.image)
         {
            this.setupImage(this._data.image);
         }
      }
      
      public function set data(param1:Object) : void
      {
         this._data = param1;
      }
      
      override public function propertySetted() : void
      {
         super.propertySetted();
         loadAsset(this._data.skin,this._data.skin + "Asset");
      }
      
      private function setupImage(param1:String) : void
      {
         api.fetch(param1,this.onImageLoaded);
      }
   }
}

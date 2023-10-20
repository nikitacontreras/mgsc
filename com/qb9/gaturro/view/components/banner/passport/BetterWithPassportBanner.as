package com.qb9.gaturro.view.components.banner.passport
{
   import com.qb9.gaturro.commons.date.DateFormator;
   import com.qb9.gaturro.commons.util.DateUtil;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.model.config.passport.BetterWithPassportDefinition;
   import com.qb9.gaturro.view.gui.banner.properties.IHasData;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.text.TextField;
   
   public class BetterWithPassportBanner extends InstantiableGuiModal implements IHasData
   {
       
      
      private var imageHolder:DisplayObjectContainer;
      
      private var _data:BetterWithPassportDefinition;
      
      private var maskDo:DisplayObjectContainer;
      
      public function BetterWithPassportBanner(param1:String = "", param2:String = "")
      {
         super("BetterWithPassaportBanner","BetterWithPassaportBannerAsset");
      }
      
      private function onButtonBuyClik(param1:MouseEvent) : void
      {
         var _loc2_:URLRequest = new URLRequest(api.config.info.url_pasaporte);
         navigateToURL(_loc2_,"_blank");
      }
      
      private function setupView() : void
      {
         this.setupDay();
         this.setupButton();
         this.setupImage();
         this.setupMask();
      }
      
      override protected function ready() : void
      {
         this.setupView();
      }
      
      private function setupMask() : void
      {
         this.maskDo = view.getChildByName("maskDo") as DisplayObjectContainer;
         this.imageHolder.mask = this.maskDo;
      }
      
      private function setupButton() : void
      {
         var _loc1_:MovieClip = view.getChildByName("btnBuy") as MovieClip;
         _loc1_.addEventListener(MouseEvent.CLICK,this.onButtonBuyClik);
      }
      
      public function set data(param1:Object) : void
      {
         this._data = param1 as BetterWithPassportDefinition;
      }
      
      private function getRemaining() : String
      {
         var _loc1_:Date = new Date(Date.parse(this._data.date));
         var _loc2_:Date = new Date();
         var _loc3_:Number = _loc1_.time - _loc2_.time;
         var _loc4_:DateFormator;
         return (_loc4_ = DateUtil.getFormatorFromMilliseconds(_loc3_)).hours > 0 || _loc4_.minutes > 0 ? String(_loc4_.days + 1) : _loc4_.days.toString();
      }
      
      private function setupImage() : void
      {
         this.imageHolder = view.getChildByName("imageHolder") as DisplayObjectContainer;
         var _loc1_:DisplayObject = getInstanceByName(this._data.image);
         this.imageHolder.addChild(_loc1_);
      }
      
      private function setupDay() : void
      {
         var _loc1_:TextField = view.getChildByName("remainingDays") as TextField;
         _loc1_.text = this.getRemaining();
         var _loc2_:TextField = view.getChildByName("days") as TextField;
         _loc2_.text = api.getText(_loc1_.text == "1" ? "DIA" : "DIAS");
      }
   }
}

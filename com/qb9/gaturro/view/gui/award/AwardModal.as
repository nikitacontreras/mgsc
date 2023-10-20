package com.qb9.gaturro.view.gui.award
{
   import assets.AwardModalMC;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.libs;
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.view.gui.base.BaseGuiModal;
   import com.qb9.gaturro.view.gui.util.GuiUtil;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
   public class AwardModal extends BaseGuiModal
   {
       
      
      private var _qtyField:TextField;
      
      private var _areaTitulo:Rectangle;
      
      private var _message:String;
      
      private var npcName:String;
      
      private var _messageField:TextField;
      
      private var _defaultTitleSize:Number;
      
      private var _title:String;
      
      private var _itemName:String;
      
      private var _messageFormat:TextFormat;
      
      private var _titleField:TextField;
      
      private var _itemQty:int;
      
      private var _tituloFormat:TextFormat;
      
      private var _defaultTextSize:Number;
      
      private var _asset:AwardModalMC;
      
      private var _areaMessage:Rectangle;
      
      private var _areaImagen:MovieClip;
      
      public function AwardModal(param1:String, param2:String, param3:String, param4:int = 1, param5:String = null)
      {
         super();
         this.npcName = param1;
         this._message = region.getText(param2).toUpperCase();
         this._itemName = param3;
         this._itemQty = param4;
         this._title = param5;
         api.trackEvent("MODAL_AWARD:" + param1,param3);
         this.init();
      }
      
      override protected function keyboardSubmit() : void
      {
         close();
      }
      
      private function init() : void
      {
         this._asset = new AwardModalMC();
         this._titleField = this._asset.tf_title;
         this._messageField = this._asset.field;
         this._qtyField = this._asset.field_qty;
         this._areaImagen = this._asset.area_imagen;
         this._areaMessage = new Rectangle(this._messageField.x,this._messageField.y,this._messageField.width,this._messageField.height);
         this._areaTitulo = new Rectangle(this._titleField.x,this._titleField.y,this._titleField.width,this._titleField.height);
         this._messageField.text = this._message;
         this._qtyField.text = "x" + this._itemQty.toString();
         this._qtyField.visible = this._itemQty > 1;
         this._messageFormat = this._messageField.getTextFormat();
         this._messageField.autoSize = TextFieldAutoSize.CENTER;
         this._messageField.wordWrap = true;
         this._defaultTextSize = Number(this._messageFormat.size);
         libs.fetch(this._itemName,this.addToPopup);
         this._asset.loading.visible = true;
         this._asset.close.addEventListener(MouseEvent.CLICK,_close);
         addChild(this._asset);
         this.adaptTexts();
      }
      
      override public function dispose() : void
      {
         this._asset.close.removeEventListener(MouseEvent.CLICK,_close);
         this._asset = null;
         super.dispose();
      }
      
      private function adaptTexts() : void
      {
         if(this._messageField.height > this._areaMessage.height)
         {
            while(this._messageField.height > this._areaMessage.height)
            {
               --this._defaultTextSize;
               this._messageFormat.size = this._defaultTextSize;
               this._messageField.setTextFormat(this._messageFormat,0,this._messageField.text.length);
               this._messageField.defaultTextFormat = this._messageFormat;
            }
         }
         if(this._title != null && this._title != "")
         {
            this._titleField.text = this._title.toUpperCase();
            this._tituloFormat = this._titleField.getTextFormat();
            this._titleField.multiline = false;
            this._defaultTitleSize = Number(this._tituloFormat.size);
            this._titleField.autoSize = TextFieldAutoSize.CENTER;
            while(this._titleField.height > this._areaTitulo.height || this._titleField.width > this._areaTitulo.width)
            {
               --this._defaultTitleSize;
               this._tituloFormat.size = this._defaultTitleSize;
               this._titleField.setTextFormat(this._tituloFormat,0,this._titleField.text.length);
               this._titleField.x = this._areaTitulo.x;
               this._titleField.y = this._areaTitulo.y;
            }
         }
         else
         {
            this._titleField.visible = false;
            this._areaImagen.visible = false;
         }
      }
      
      private function addToPopup(param1:DisplayObject) : void
      {
         var _loc2_:Rectangle = param1.getBounds(this._asset);
         var _loc3_:int = this._areaImagen.x + this._areaImagen.width / 2 - param1.width / 2 + (param1.x - _loc2_.x);
         var _loc4_:int = this._areaImagen.y + this._areaImagen.height / 2 - param1.height / 2 + (param1.y - _loc2_.y);
         GuiUtil.fit(param1,this._areaImagen.width,this._areaImagen.height,_loc3_,_loc4_);
         this._asset.addChild(param1);
         param1.x = _loc3_;
         param1.y = _loc4_;
         this._asset.loading.visible = false;
         api.giveUser(this._itemName,this._itemQty);
      }
   }
}

package com.qb9.gaturro.view.gui.info
{
   import assets.ModalMC;
   import com.qb9.gaturro.globals.libs;
   import com.qb9.gaturro.view.gui.base.BaseGuiModal;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.Timer;
   
   public final class InformationModal extends BaseGuiModal
   {
      
      private static const CHARS:Array = [75,320];
       
      
      private var _areaTitulo:Rectangle;
      
      private var _timer:Timer;
      
      private var _imageName:String;
      
      private var _message:String;
      
      private var _timeOut:int;
      
      private var _messageField:TextField;
      
      private var _defaultTitleSize:Number;
      
      private var _title:String;
      
      private var _messageFormat:TextFormat;
      
      private var _titleField:TextField;
      
      private var _tituloFormat:TextFormat;
      
      private var _defaultTextSize:Number;
      
      private var _asset:ModalMC;
      
      private var _areaMessage:Rectangle;
      
      private var _areaImagen:MovieClip;
      
      public function InformationModal(param1:String, param2:String = null, param3:String = null, param4:String = null)
      {
         super();
         this._message = param1;
         this._imageName = param2;
         this._title = param3;
         this._timeOut = Number(param4);
         this.init();
      }
      
      protected function setIcon(param1:String) : void
      {
         if(param1.indexOf(".") > 0)
         {
            libs.fetch(param1,this.addToPopup);
            this._asset.image.gotoAndStop("loading");
         }
         else
         {
            this._asset.image.gotoAndStop(param1);
         }
      }
      
      override protected function keyboardSubmit() : void
      {
         close();
      }
      
      private function init() : void
      {
         if(this._timeOut > 0)
         {
            this._timer = new Timer(this._timeOut,1);
            this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,_close);
         }
         this._asset = new ModalMC();
         this._asset.addFrameScript(1,this.frameInitialization);
         this._asset.gotoAndStop(2);
      }
      
      private function frameInitialization() : void
      {
         this._titleField = this._asset.title_field;
         this._messageField = this._asset.field;
         this._areaImagen = this._asset.area_imagen;
         this._areaMessage = new Rectangle(this._messageField.x,this._messageField.y,this._messageField.width,this._messageField.height);
         this._areaTitulo = new Rectangle(this._titleField.x,this._titleField.y,this._titleField.width,this._titleField.height);
         if(this._imageName != null)
         {
            this.setIcon(this._imageName);
         }
         this._messageField.text = this._message.toUpperCase();
         this._messageFormat = this._messageField.getTextFormat();
         this._messageField.autoSize = TextFieldAutoSize.CENTER;
         this._messageField.wordWrap = true;
         this._defaultTextSize = Number(this._messageFormat.size);
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
         this._messageField.x = this._areaMessage.x;
         this._messageField.y = this._areaMessage.y + this._areaMessage.height / 2 - this._messageField.textHeight / 2;
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
         }
         this._areaImagen.visible = false;
         this._asset.close.addEventListener(MouseEvent.CLICK,_close);
         addChild(this._asset);
         if(this._timeOut > 0)
         {
            this._timer.start();
         }
      }
      
      override public function dispose() : void
      {
         this._asset.close.removeEventListener(MouseEvent.CLICK,_close);
         this._asset = null;
         super.dispose();
      }
      
      private function addToPopup(param1:DisplayObject) : void
      {
         var _loc2_:Number = Math.min(this._areaImagen.width / param1.width,this._areaImagen.height / param1.height);
         param1.scaleX = _loc2_;
         param1.scaleY = _loc2_;
         var _loc3_:Rectangle = param1.getBounds(this._asset);
         var _loc4_:int = this._areaImagen.x + this._areaImagen.width / 2 - param1.width / 2 + (param1.x - _loc3_.x);
         var _loc5_:int = this._areaImagen.y + this._areaImagen.height / 2 - param1.height / 2 + (param1.y - _loc3_.y);
         this._asset.addChild(param1);
         param1.x = _loc4_;
         param1.y = _loc5_;
         this._asset.image.gotoAndStop(1);
      }
   }
}

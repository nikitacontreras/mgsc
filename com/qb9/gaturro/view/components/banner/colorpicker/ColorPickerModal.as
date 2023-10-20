package com.qb9.gaturro.view.components.banner.colorpicker
{
   import com.qb9.flashlib.color.Color;
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.view.gui.banner.properties.IHasRoomAPI;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import com.qb9.gaturro.view.world.avatars.Gaturro;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.utils.setTimeout;
   
   public class ColorPickerModal extends InstantiableGuiModal implements IHasRoomAPI
   {
       
      
      private var _roomAPI:GaturroRoomAPI;
      
      private var _canChangeBrightness1:Boolean;
      
      private var _canChangeBrightness2:Boolean;
      
      private var _canChangeBrightness3:Boolean;
      
      private var _auxTransport;
      
      private var character:Gaturro;
      
      private var holder:Holder;
      
      private var _color1captureMouseEvent:MouseEvent;
      
      private var _canChangeColor1:Boolean;
      
      private var _canChangeColor2:Boolean;
      
      private var _canChangeColor3:Boolean;
      
      private var _assetView:MovieClip;
      
      private var _color1Selected_1:Color;
      
      private var _color1Selected_2:Color;
      
      private var _color1Selected_3:Color;
      
      private var _color2captureMouseEvent:MouseEvent;
      
      private var _color3captureMouseEvent:MouseEvent;
      
      public function ColorPickerModal()
      {
         super("ColorPickerBanner","ColorPickerBanner");
      }
      
      private function colorIntToRealHex(param1:uint) : String
      {
         var _loc2_:* = param1 >> 16 & 255;
         var _loc3_:* = param1 >> 8 & 255;
         var _loc4_:* = param1 & 255;
         var _loc5_:*;
         var _loc6_:String = (_loc5_ = _loc2_ << 16 | _loc3_ << 8 | _loc4_).toString(16);
         return "#" + (_loc6_.length < 6 ? "0" + _loc6_ : _loc6_);
      }
      
      private function onColorClick2(param1:MouseEvent) : void
      {
         this._canChangeColor2 = true;
      }
      
      private function onColorClick3(param1:MouseEvent) : void
      {
         this._canChangeColor3 = true;
      }
      
      private function onMoveMouse2(param1:MouseEvent) : void
      {
         this._color2captureMouseEvent = param1;
      }
      
      private function onMoveMouse3(param1:MouseEvent) : void
      {
         this._color3captureMouseEvent = param1;
      }
      
      override protected function ready() : void
      {
         super.ready();
         this._assetView = view as MovieClip;
         this._auxTransport = this._roomAPI.userAvatar.attributes["transport"];
         this.holder = new Holder(this._roomAPI.userAvatar);
         this.character = new Gaturro(this.holder);
         this._assetView.ph_avatar.addChild(this.character);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.disableWhenUp);
         this._assetView.color_1.addEventListener(MouseEvent.MOUSE_DOWN,this.onColorClick);
         this._assetView.color_1.addEventListener(MouseEvent.MOUSE_MOVE,this.onMoveMouse);
         this._assetView.arrow_1.addEventListener(MouseEvent.MOUSE_DOWN,this.getBrightness);
         this._assetView.arrow_1.addEventListener(Event.ENTER_FRAME,this.updateBrightness);
         this._assetView.color_1.addEventListener(Event.ENTER_FRAME,this.getColorSample);
         this._assetView.color_2.addEventListener(MouseEvent.MOUSE_DOWN,this.onColorClick2);
         this._assetView.color_2.addEventListener(MouseEvent.MOUSE_MOVE,this.onMoveMouse2);
         this._assetView.arrow_2.addEventListener(MouseEvent.MOUSE_DOWN,this.getBrightness2);
         this._assetView.arrow_2.addEventListener(Event.ENTER_FRAME,this.updateBrightness2);
         this._assetView.color_2.addEventListener(Event.ENTER_FRAME,this.getColorSample2);
         this._assetView.color_3.addEventListener(MouseEvent.MOUSE_DOWN,this.onColorClick3);
         this._assetView.color_3.addEventListener(MouseEvent.MOUSE_MOVE,this.onMoveMouse3);
         this._assetView.arrow_3.addEventListener(MouseEvent.MOUSE_DOWN,this.getBrightness3);
         this._assetView.arrow_3.addEventListener(Event.ENTER_FRAME,this.updateBrightness3);
         this._assetView.color_3.addEventListener(Event.ENTER_FRAME,this.getColorSample3);
         this._assetView.close.addEventListener(MouseEvent.MOUSE_DOWN,this.onClose);
         this._assetView.accept.addEventListener(MouseEvent.MOUSE_DOWN,this.onConfirm);
         this._assetView.reset.addEventListener(MouseEvent.MOUSE_DOWN,this.onReset);
      }
      
      private function ojosBlancosReset() : void
      {
         var _loc1_:ColorTransform = new ColorTransform();
         _loc1_.color = 16777215;
         (this.character.head.eye2.colorEye as MovieClip).transform.colorTransform = _loc1_;
         (this.character.head.eye1.colorEye as MovieClip).transform.colorTransform = _loc1_;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this._assetView.color_1.removeEventListener(MouseEvent.MOUSE_DOWN,this.onColorClick);
         this._assetView.color_1.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMoveMouse);
         this._assetView.arrow_1.removeEventListener(MouseEvent.MOUSE_DOWN,this.getBrightness);
         this._assetView.arrow_1.removeEventListener(Event.ENTER_FRAME,this.updateBrightness);
         this._assetView.color_1.removeEventListener(Event.ENTER_FRAME,this.getColorSample);
         this._assetView.color_2.removeEventListener(MouseEvent.MOUSE_DOWN,this.onColorClick2);
         this._assetView.color_2.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMoveMouse2);
         this._assetView.arrow_2.removeEventListener(MouseEvent.MOUSE_DOWN,this.getBrightness2);
         this._assetView.arrow_2.removeEventListener(Event.ENTER_FRAME,this.updateBrightness2);
         this._assetView.color_2.removeEventListener(Event.ENTER_FRAME,this.getColorSample2);
         this._assetView.color_3.removeEventListener(MouseEvent.MOUSE_DOWN,this.onColorClick2);
         this._assetView.color_3.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMoveMouse2);
         this._assetView.arrow_3.removeEventListener(MouseEvent.MOUSE_DOWN,this.getBrightness2);
         this._assetView.arrow_3.removeEventListener(Event.ENTER_FRAME,this.updateBrightness2);
         this._assetView.color_3.removeEventListener(Event.ENTER_FRAME,this.getColorSample2);
         this._assetView.close.removeEventListener(MouseEvent.MOUSE_DOWN,this.onClose);
         this._assetView.accept.removeEventListener(MouseEvent.MOUSE_DOWN,this.onConfirm);
         this._assetView.reset.removeEventListener(MouseEvent.MOUSE_DOWN,this.onReset);
      }
      
      private function changeBrightness(param1:Number, param2:Color, param3:String) : void
      {
         var _loc4_:Number = NaN;
         var _loc8_:ColorTransform = null;
         var _loc5_:Number = param1 * 2 - 1;
         var _loc6_:uint = parseInt(this.shadeColor1(param2.hex,_loc5_ * -100),16);
         var _loc7_:Color = new Color(_loc6_);
         if(param3 == "1" || param3 == "2")
         {
            this.character.attrs["color" + param3] = _loc7_.hex;
         }
         if(param3 == "3")
         {
            (_loc8_ = new ColorTransform()).color = _loc7_.hex;
            this.character.attrs["color3"] = _loc7_.hex;
            (this.character.head.eye2.colorEye as MovieClip).transform.colorTransform = _loc8_;
            (this.character.head.eye1.colorEye as MovieClip).transform.colorTransform = _loc8_;
         }
         trace("HEX + BRIGHT: " + this.colorIntToRealHex(_loc7_.hex) + " *************" + _loc5_);
      }
      
      private function onColorClick(param1:MouseEvent) : void
      {
         this._canChangeColor1 = true;
      }
      
      private function onMoveMouse(param1:MouseEvent) : void
      {
         this._color1captureMouseEvent = param1;
      }
      
      private function onReset(param1:MouseEvent) : void
      {
         this.character.attrs["color2"] = parseInt("0xDDB42D",16);
         this.character.attrs["color1"] = parseInt("0xFFF200",16);
         this.character.attrs["color3"] = parseInt("0xFFFFFF",16);
         this.ojosBlancosReset();
      }
      
      private function getColorSample(param1:Event) : void
      {
         if(!this._canChangeColor1)
         {
            return;
         }
         var _loc2_:BitmapData = new BitmapData(this._assetView.color_1.width,this._assetView.color_1.height);
         _loc2_.draw(this._assetView.color_1);
         var _loc3_:Bitmap = new Bitmap(_loc2_);
         var _loc4_:* = _loc3_.bitmapData.getPixel(this._color1captureMouseEvent.localX,this._color1captureMouseEvent.localY);
         this._assetView.cursor_1.x = this._color1captureMouseEvent.stageX;
         this._assetView.cursor_1.y = this._color1captureMouseEvent.stageY;
         var _loc5_:* = _loc4_ >> 16 & 255;
         var _loc6_:* = _loc4_ >> 8 & 255;
         var _loc7_:* = _loc4_ & 255;
         var _loc8_:*;
         var _loc9_:String = (_loc8_ = _loc5_ << 16 | _loc6_ << 8 | _loc7_).toString(16);
         _loc9_ = "#" + (_loc9_.length < 6 ? "0" + _loc9_ : _loc9_);
         this._color1Selected_1 = new Color(_loc4_);
         this.character.attrs["color1"] = this._color1Selected_1.hex;
         var _loc10_:ColorTransform;
         (_loc10_ = new ColorTransform()).color = this._color1Selected_1.hex;
         (this._assetView.brillo_1.selectedColor as MovieClip).transform.colorTransform = _loc10_;
      }
      
      private function getBrightness(param1:MouseEvent) : void
      {
         this._canChangeBrightness1 = true;
      }
      
      private function shadeColor1(param1:uint, param2:Number) : String
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:uint = param1;
         _loc6_ = Math.round(2.55 * param2);
         _loc3_ = (_loc7_ >> 16) + _loc6_;
         _loc4_ = (_loc7_ >> 8 & 255) + _loc6_;
         _loc5_ = (_loc7_ & 255) + _loc6_;
         return (16777216 + (_loc3_ < 255 ? (_loc3_ < 1 ? 0 : _loc3_) : 255) * 65536 + (_loc4_ < 255 ? (_loc4_ < 1 ? 0 : _loc4_) : 255) * 256 + (_loc5_ < 255 ? (_loc5_ < 1 ? 0 : _loc5_) : 255)).toString(16).slice(1);
      }
      
      private function getBrightness2(param1:MouseEvent) : void
      {
         this._canChangeBrightness2 = true;
      }
      
      private function getBrightness3(param1:MouseEvent) : void
      {
         this._canChangeBrightness3 = true;
      }
      
      private function onClose(param1:MouseEvent = null) : void
      {
         this.dispose();
      }
      
      private function getColorSample2(param1:Event) : void
      {
         if(!this._canChangeColor2)
         {
            return;
         }
         var _loc2_:BitmapData = new BitmapData(this._assetView.color_2.width,this._assetView.color_2.height);
         _loc2_.draw(this._assetView.color_2);
         var _loc3_:Bitmap = new Bitmap(_loc2_);
         var _loc4_:* = _loc3_.bitmapData.getPixel(this._color2captureMouseEvent.localX,this._color2captureMouseEvent.localY);
         this._assetView.cursor_2.x = this._color2captureMouseEvent.stageX;
         this._assetView.cursor_2.y = this._color2captureMouseEvent.stageY;
         var _loc5_:* = _loc4_ >> 16 & 255;
         var _loc6_:* = _loc4_ >> 8 & 255;
         var _loc7_:* = _loc4_ & 255;
         var _loc8_:*;
         var _loc9_:String = (_loc8_ = _loc5_ << 16 | _loc6_ << 8 | _loc7_).toString(16);
         _loc9_ = "#" + (_loc9_.length < 6 ? "0" + _loc9_ : _loc9_);
         this._color1Selected_2 = new Color(_loc4_);
         this.character.attrs["color2"] = this._color1Selected_2.hex;
         var _loc10_:ColorTransform;
         (_loc10_ = new ColorTransform()).color = this._color1Selected_2.hex;
         (this._assetView.brillo_2.selectedColor as MovieClip).transform.colorTransform = _loc10_;
      }
      
      private function onConfirm(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         if(!api.isCitizen)
         {
            api.showBannerModal("pasaporte2");
            close();
            return;
         }
         this.character.attrs["transport"] = this._auxTransport;
         setTimeout(api.setAvatarAttribute,200,"action","amazed");
         setTimeout(function():void
         {
            api.userAvatar.attributes.merge(character.attrs);
         },1300);
         api.roomView.blockGuiFor(1500);
         close();
      }
      
      private function getColorSample3(param1:Event) : void
      {
         if(!this._canChangeColor3)
         {
            return;
         }
         var _loc2_:BitmapData = new BitmapData(this._assetView.color_3.width,this._assetView.color_3.height);
         _loc2_.draw(this._assetView.color_3);
         var _loc3_:Bitmap = new Bitmap(_loc2_);
         var _loc4_:* = _loc3_.bitmapData.getPixel(this._color3captureMouseEvent.localX,this._color3captureMouseEvent.localY);
         this._assetView.cursor_3.x = this._color3captureMouseEvent.stageX;
         this._assetView.cursor_3.y = this._color3captureMouseEvent.stageY;
         var _loc5_:* = _loc4_ >> 16 & 255;
         var _loc6_:* = _loc4_ >> 8 & 255;
         var _loc7_:* = _loc4_ & 255;
         var _loc8_:*;
         var _loc9_:String = (_loc8_ = _loc5_ << 16 | _loc6_ << 8 | _loc7_).toString(16);
         _loc9_ = "#" + (_loc9_.length < 6 ? "0" + _loc9_ : _loc9_);
         this._color1Selected_3 = new Color(_loc4_);
         this.character.attrs["color3"] = this._color1Selected_3.hex;
         var _loc10_:ColorTransform;
         (_loc10_ = new ColorTransform()).color = this._color1Selected_3.hex;
         (this._assetView.brillo_3.selectedColor as MovieClip).transform.colorTransform = _loc10_;
         (this.character.head.eye2.colorEye as MovieClip).transform.colorTransform = _loc10_;
         (this.character.head.eye1.colorEye as MovieClip).transform.colorTransform = _loc10_;
      }
      
      private function valueToPercent(param1:Number, param2:Number, param3:Number) : Number
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = param3 - param2;
         return (param1 - param2) / _loc5_;
      }
      
      private function updateBrightness2(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(!this._canChangeBrightness2)
         {
            return;
         }
         if(!this._color1Selected_2)
         {
            return;
         }
         this._assetView.arrow_2.y = mouseY;
         _loc3_ = this._assetView.arrow_2.y + this._assetView.arrow_2.height / 2;
         if(_loc3_ > this._assetView.brillo_2.y + this._assetView.brillo_2.height)
         {
            this._assetView.arrow_2.y = this._assetView.brillo_2.y + this._assetView.brillo_2.height - this._assetView.arrow_2.height / 2;
         }
         if(_loc3_ < this._assetView.brillo_2.y)
         {
            this._assetView.arrow_2.y = this._assetView.brillo_2.y - this._assetView.arrow_2.height / 2;
         }
         var _loc4_:Number = this._assetView.brillo_2.y + this._assetView.brillo_2.height - this._assetView.arrow_2.height / 2;
         var _loc5_:Number = this._assetView.brillo_2.y - this._assetView.arrow_2.height / 2;
         _loc2_ = this.valueToPercent(this._assetView.arrow_2.y,_loc5_,_loc4_);
         this.changeBrightness(_loc2_,this._color1Selected_2,"2");
      }
      
      private function updateBrightness3(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(!this._canChangeBrightness3)
         {
            return;
         }
         if(!this._color1Selected_3)
         {
            return;
         }
         this._assetView.arrow_3.y = mouseY;
         _loc3_ = this._assetView.arrow_3.y + this._assetView.arrow_3.height / 2;
         if(_loc3_ > this._assetView.brillo_3.y + this._assetView.brillo_3.height)
         {
            this._assetView.arrow_3.y = this._assetView.brillo_3.y + this._assetView.brillo_3.height - this._assetView.arrow_3.height / 2;
         }
         if(_loc3_ < this._assetView.brillo_3.y)
         {
            this._assetView.arrow_3.y = this._assetView.brillo_3.y - this._assetView.arrow_3.height / 2;
         }
         var _loc4_:Number = this._assetView.brillo_3.y + this._assetView.brillo_3.height - this._assetView.arrow_3.height / 2;
         var _loc5_:Number = this._assetView.brillo_3.y - this._assetView.arrow_3.height / 2;
         _loc2_ = this.valueToPercent(this._assetView.arrow_3.y,_loc5_,_loc4_);
         this.changeBrightness(_loc2_,this._color1Selected_3,"3");
      }
      
      private function updateBrightness(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(!this._canChangeBrightness1)
         {
            return;
         }
         if(!this._color1Selected_1)
         {
            return;
         }
         this._assetView.arrow_1.y = mouseY;
         _loc3_ = this._assetView.arrow_1.y + this._assetView.arrow_1.height / 2;
         if(_loc3_ > this._assetView.brillo_1.y + this._assetView.brillo_1.height)
         {
            this._assetView.arrow_1.y = this._assetView.brillo_1.y + this._assetView.brillo_1.height - this._assetView.arrow_1.height / 2;
         }
         if(_loc3_ < this._assetView.brillo_1.y)
         {
            this._assetView.arrow_1.y = this._assetView.brillo_1.y - this._assetView.arrow_1.height / 2;
         }
         var _loc4_:Number = this._assetView.brillo_1.y + this._assetView.brillo_1.height - this._assetView.arrow_1.height / 2;
         var _loc5_:Number = this._assetView.brillo_1.y - this._assetView.arrow_1.height / 2;
         _loc2_ = this.valueToPercent(this._assetView.arrow_1.y,_loc5_,_loc4_);
         this.changeBrightness(_loc2_,this._color1Selected_1,"1");
      }
      
      private function disableWhenUp(param1:MouseEvent) : void
      {
         this._canChangeBrightness1 = false;
         this._canChangeColor1 = false;
         this._canChangeBrightness2 = false;
         this._canChangeBrightness3 = false;
         this._canChangeColor2 = false;
         this._canChangeColor3 = false;
      }
      
      public function set roomAPI(param1:GaturroRoomAPI) : void
      {
         this._roomAPI = param1;
      }
   }
}

import com.qb9.mambo.core.objects.BaseCustomAttributeDispatcher;
import com.qb9.mambo.world.avatars.Avatar;

class Holder extends BaseCustomAttributeDispatcher
{
    
   
   public function Holder(param1:Avatar)
   {
      super();
      param1.attributes.transport = " ";
      _attributes = param1.attributes.clone(this);
   }
}

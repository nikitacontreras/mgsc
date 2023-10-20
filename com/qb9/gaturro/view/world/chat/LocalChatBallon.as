package com.qb9.gaturro.view.world.chat
{
   import assets.ChatTriangleMC;
   import com.qb9.flashlib.color.Color;
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.util.TimingUtil;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class LocalChatBallon
   {
      
      protected static const TEXT_FIX:uint = 5;
      
      protected static const FIELD_MAX_WIDTH:uint = 150;
      
      protected static const MARGIN:uint = 5;
      
      protected static const ROUNDING:uint = 20;
      
      protected static const WIDTH:uint = 80;
      
      protected static const FIELD_HEIGHT:uint = 18;
      
      protected static const ALPHA:Number = 0.8;
       
      
      private var container:Sprite;
      
      private var _disposed:Boolean;
      
      private var timeId:uint;
      
      protected var tri:ChatTriangleMC;
      
      protected var text:String;
      
      protected var asset:Sprite;
      
      protected var field:TextField;
      
      public function LocalChatBallon(param1:DisplayObject)
      {
         super();
         this.container = Sprite(param1).getChildByName("chat_ph") as Sprite;
      }
      
      protected function getTextFormat() : TextFormat
      {
         var _loc1_:TextFormat = new TextFormat("Cooper",12,Color.WHITE);
         _loc1_.align = TextFormatAlign.CENTER;
         _loc1_.leading = -2;
         return _loc1_;
      }
      
      protected function calculateTime(param1:String) : uint
      {
         return TimingUtil.getReadDelay(param1);
      }
      
      protected function createAsset() : void
      {
         this.asset = new Sprite();
      }
      
      private function onTextRemove() : void
      {
         this.container.removeChild(this.asset);
         clearTimeout(this.timeId);
      }
      
      protected function locateTextField(param1:int) : void
      {
         this.field.width = Math.min(FIELD_MAX_WIDTH,this.field.textWidth + TEXT_FIX);
         this.field.x = -this.field.textWidth / 2;
         this.field.y = param1 - MARGIN - this.field.textHeight;
      }
      
      private function reset() : void
      {
         this.asset.graphics.clear();
         this.asset.removeChild(this.field);
         this.field = null;
         clearTimeout(this.timeId);
      }
      
      public function dispose() : void
      {
         if(this.asset)
         {
            DisplayUtil.remove(this.asset);
         }
         this.asset = null;
         this.tri = null;
         this.field = null;
         this.container = null;
         this._disposed = true;
         clearTimeout(this.timeId);
      }
      
      protected function getAutosize() : String
      {
         return TextFieldAutoSize.CENTER;
      }
      
      public function say(param1:String) : void
      {
         this.text = region.getText(param1);
         if(!this.asset)
         {
            this.setup();
         }
         else
         {
            this.reset();
            this.setupContent();
            this.setBackground();
         }
         this.container.addChild(this.asset);
         var _loc2_:uint = this.calculateTime(this.text);
         this.timeId = setTimeout(this.onTextRemove,_loc2_);
      }
      
      protected function getTextfield() : TextField
      {
         var _loc1_:TextField = new TextField();
         _loc1_.multiline = true;
         _loc1_.wordWrap = true;
         _loc1_.width = FIELD_MAX_WIDTH;
         _loc1_.height = FIELD_HEIGHT;
         _loc1_.autoSize = this.getAutosize();
         _loc1_.embedFonts = true;
         _loc1_.selectable = false;
         return _loc1_;
      }
      
      public function get chatAsset() : Sprite
      {
         return this.asset;
      }
      
      protected function setupContent() : void
      {
         this.tri = this.getTriangle();
         var _loc1_:int = -this.tri.height - TEXT_FIX;
         this.asset.addChild(this.tri);
         this.field = this.getTextfield();
         var _loc2_:TextFormat = this.getTextFormat();
         this.field.defaultTextFormat = _loc2_;
         this.field.text = this.text.toUpperCase();
         this.locateTextField(_loc1_);
         this.asset.addChild(this.field);
      }
      
      protected function setup() : void
      {
         this.createAsset();
         this.setupContent();
         this.setBackground();
      }
      
      protected function getTriangle() : ChatTriangleMC
      {
         var _loc1_:ChatTriangleMC = new ChatTriangleMC();
         _loc1_.alpha = ALPHA;
         return _loc1_;
      }
      
      protected function setBackground() : void
      {
         this.asset.graphics.beginFill(0,ALPHA);
         this.asset.graphics.drawRoundRect(this.field.x - MARGIN,this.field.y - MARGIN,this.field.textWidth + TEXT_FIX + MARGIN * 2,this.field.textHeight + TEXT_FIX + MARGIN * 2,ROUNDING);
      }
   }
}

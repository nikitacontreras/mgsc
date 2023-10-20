package com.qb9.gaturro.view.world.chat
{
   import assets.ChatCircleMC;
   import assets.ChatTriangleMC;
   import com.qb9.flashlib.color.Color;
   import com.qb9.flashlib.tasks.Func;
   import com.qb9.flashlib.tasks.Sequence;
   import com.qb9.flashlib.tasks.TimeBasedTask;
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.util.TimingUtil;
   import com.qb9.gaturro.view.world.avatars.GaturroAvatarView;
   import com.qb9.gaturro.view.world.elements.NpcRoomSceneObjectView;
   import com.qb9.mambo.world.avatars.Avatar;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.ColorTransform;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class ChatBalloon extends Sequence implements IChatBallon
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
      
      protected var cir:ChatCircleMC;
      
      protected var tri:ChatTriangleMC;
      
      protected var text:String;
      
      protected var asset:Sprite;
      
      protected var field:TextField;
      
      private var _owner:DisplayObject;
      
      public function ChatBalloon(param1:DisplayObject, param2:Sprite, param3:String)
      {
         this._owner = param1;
         this.container = param2;
         this.text = region.getText(param3);
         this.setup();
         var _loc4_:uint = this.calculateTime(this.text);
         super(new TimeBasedTask(_loc4_),new Func(this.alert));
      }
      
      private function get validBlueText() : Boolean
      {
         var _loc1_:Boolean = this._owner is GaturroAvatarView && ((this._owner as Object).avatar as Avatar).isCitizen;
         if(_loc1_ && Boolean((this._owner as Object).avatar.attributes.thehand))
         {
            return true;
         }
         if(this._owner is NpcRoomSceneObjectView && (this._owner as NpcRoomSceneObjectView).object.name.indexOf("alien2") != -1)
         {
            return true;
         }
         return false;
      }
      
      protected function getCircle() : ChatCircleMC
      {
         var _loc3_:ColorTransform = null;
         var _loc1_:ChatCircleMC = new ChatCircleMC();
         _loc1_.alpha = ALPHA;
         _loc1_.scaleX = this.guide.scaleX;
         var _loc2_:Boolean = this._owner is GaturroAvatarView && ((this._owner as Object).avatar as Avatar).isCitizen;
         if(_loc2_)
         {
            if((this._owner as Object).avatar.attributes.backLetterColor != null)
            {
               _loc3_ = new ColorTransform();
               _loc3_.color = (this._owner as Object).avatar.attributes.backLetterColor;
               _loc3_.alphaMultiplier = ALPHA;
               this.tri.transform.colorTransform = _loc3_;
            }
            else if((this._owner as Object).avatar.attributes.passportType == "boca")
            {
               _loc3_ = new ColorTransform();
               _loc3_.color = 16777215;
               _loc3_.alphaMultiplier = ALPHA;
               _loc1_.transform.colorTransform = _loc3_;
            }
         }
         return _loc1_;
      }
      
      private function place() : void
      {
         var _loc1_:DisplayObject = this.guide;
         this.asset.x = DisplayUtil.offsetX(_loc1_,this.container);
         this.asset.y = DisplayUtil.offsetY(_loc1_,this.container);
      }
      
      override public function update(param1:uint) : void
      {
         this.place();
         super.update(param1);
      }
      
      private function get guide() : DisplayObject
      {
         var _loc1_:DisplayObject = this.owner;
         if(this.owner is Sprite)
         {
            _loc1_ = DisplayUtil.getByName(this.owner as Sprite,"chat_ph") || _loc1_;
         }
         return _loc1_;
      }
      
      public function removeBalloon() : void
      {
      }
      
      protected function calculateTime(param1:String) : uint
      {
         return TimingUtil.getReadDelay(param1);
      }
      
      protected function createAsset() : void
      {
         this.asset = new Sprite();
      }
      
      private function removeNumbersFromText(param1:String) : String
      {
         var _loc2_:RegExp = /[0-9]/g;
         if(param1.match(_loc2_).length > 0)
         {
            return "";
         }
         return param1;
      }
      
      protected function locateTextField(param1:int) : void
      {
         this.field.width = Math.min(FIELD_MAX_WIDTH,this.field.textWidth + TEXT_FIX);
         this.field.x = -this.field.textWidth / 2;
         this.field.y = param1 - MARGIN - this.field.textHeight;
      }
      
      private function alert() : void
      {
         this.owner.dispatchEvent(new ChatViewEvent(ChatViewEvent.FINISHED));
      }
      
      private function colorizeText(param1:String, param2:String, param3:String) : String
      {
         var _loc6_:String = null;
         var _loc4_:String = "<span class=\'textcenter\'>";
         var _loc5_:int = 0;
         while(_loc5_ < param1.length)
         {
            _loc6_ = _loc5_ % 2 == 0 ? param2 : param3;
            _loc4_ += "<font color=\'" + _loc6_ + "\'>" + param1.charAt(_loc5_) + "</font>";
            _loc5_++;
         }
         return _loc4_ + "</span>";
      }
      
      override public function dispose() : void
      {
         if(this.asset)
         {
            DisplayUtil.remove(this.asset);
         }
         this.asset = null;
         this.tri = null;
         this.field = null;
         this.container = null;
         this._owner = null;
         this._disposed = true;
         super.dispose();
      }
      
      protected function decorateText(param1:String, param2:TextField) : void
      {
         var _loc3_:Boolean = false;
         if(param1 != "")
         {
            param2.defaultTextFormat = new TextFormat("Cooper",12,Color.WHITE,null,null,null,null,null,TextFormatAlign.CENTER);
            param2.htmlText = param1;
            _loc3_ = this._owner is GaturroAvatarView && ((this._owner as Object).avatar as Avatar).isCitizen;
            if(_loc3_)
            {
               if((this._owner as Object).avatar.attributes.letterColor != null)
               {
                  param2.defaultTextFormat = new TextFormat("Cooper",12,(this._owner as Object).avatar.attributes.letterColor as uint,null,null,null,null,null,TextFormatAlign.CENTER);
                  param2.htmlText = param1;
               }
               else if((this._owner as Object).avatar.attributes.passportType == "boca")
               {
                  param2.defaultTextFormat = new TextFormat("Cooper",12,Color.WHITE,null,null,null,null,null,TextFormatAlign.CENTER);
                  param2.htmlText = this.colorizeText(param1,"#0169B0","#FFB300");
               }
               else if((this._owner as Object).avatar.attributes.thejalouween2018)
               {
                  param2.defaultTextFormat = new TextFormat("Cooper",12,65280,null,null,null,null,null,TextFormatAlign.CENTER);
                  param2.htmlText = param1;
               }
               else if((this._owner as Object).avatar.attributes.thehuevo)
               {
                  param2.defaultTextFormat = new TextFormat("Cooper",12,5644800,null,null,null,null,null,TextFormatAlign.CENTER);
                  param2.htmlText = param1;
               }
               else if((this._owner as Object).avatar.attributes.passportType == "river")
               {
                  param2.defaultTextFormat = new TextFormat("Cooper",12,Color.WHITE,null,null,null,null,null,TextFormatAlign.CENTER);
                  param2.htmlText = this.colorizeText(param1,"#ED1C30","#ffffff");
               }
               else if((this._owner as Object).avatar.attributes.thehand)
               {
                  param2.defaultTextFormat = new TextFormat("Commodore",12,Color.CYAN,null,null,null,null,null,TextFormatAlign.CENTER);
                  param2.htmlText = param1;
               }
            }
            else if(this._owner is NpcRoomSceneObjectView)
            {
               if((this._owner as NpcRoomSceneObjectView).object.name.indexOf("alien2") != -1)
               {
                  param2.defaultTextFormat = new TextFormat("Commodore",12,Color.CYAN,null,null,null,null,null,TextFormatAlign.CENTER);
                  param2.htmlText = param1;
               }
               else if(this.isNPCPascuas(this._owner as NpcRoomSceneObjectView))
               {
                  param2.defaultTextFormat = new TextFormat("Cooper",12,5644800,null,null,null,null,null,TextFormatAlign.CENTER);
                  param2.htmlText = param1;
               }
            }
         }
      }
      
      override public function start() : void
      {
         this.container.addChild(this.asset);
         this.place();
         super.start();
      }
      
      protected function getAutosize() : String
      {
         return TextFieldAutoSize.CENTER;
      }
      
      public function get owner() : DisplayObject
      {
         return this._owner;
      }
      
      private function isNPCPascuas(param1:NpcRoomSceneObjectView) : Boolean
      {
         switch(param1.object.name)
         {
            case "havanna.marqu_so":
            case "easter2016.conejoArtista_so":
            case "easter.coneja_so":
            case "easter.manekiSushi_so":
            case "pascuas2018/props.conejoRompehuevos_so":
               return true;
            default:
               return false;
         }
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
         if(this._owner is GaturroAvatarView)
         {
            this.text = this.removeNumbersFromText(this.text);
         }
         this.decorateText(this.text.toUpperCase(),this.field);
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
         var _loc2_:ColorTransform = null;
         var _loc1_:ChatTriangleMC = new ChatTriangleMC();
         _loc1_.alpha = ALPHA;
         _loc1_.scaleX = this.guide.scaleX;
         var _loc3_:Boolean = this._owner is GaturroAvatarView && ((this._owner as Object).avatar as Avatar).isCitizen;
         if(_loc3_)
         {
            if((this._owner as Object).avatar.attributes.backLetterColor != null)
            {
               _loc2_ = new ColorTransform();
               _loc2_.color = (this._owner as Object).avatar.attributes.backLetterColor;
               _loc2_.alphaMultiplier = ALPHA;
               _loc1_.transform.colorTransform = _loc2_;
            }
            else if((this._owner as Object).avatar.attributes.passportType == "boca")
            {
               _loc2_ = new ColorTransform();
               _loc2_.color = 16777215;
               _loc2_.alphaMultiplier = ALPHA;
               _loc1_.transform.colorTransform = _loc2_;
            }
            else if((this._owner as Object).avatar.attributes.thehuevo)
            {
               _loc2_ = new ColorTransform();
               _loc2_.color = 16757760;
               _loc2_.alphaMultiplier = ALPHA;
               _loc1_.transform.colorTransform = _loc2_;
            }
            else if((this._owner as Object).avatar.attributes.thejalouween2018)
            {
               _loc2_ = new ColorTransform();
               _loc2_.color = 6684876;
               _loc2_.alphaMultiplier = ALPHA;
               _loc1_.transform.colorTransform = _loc2_;
            }
         }
         if(this._owner is NpcRoomSceneObjectView && this.isNPCPascuas(this._owner as NpcRoomSceneObjectView))
         {
            _loc2_ = new ColorTransform();
            _loc2_.color = 16757760;
            _loc2_.alphaMultiplier = ALPHA;
            _loc1_.transform.colorTransform = _loc2_;
         }
         return _loc1_;
      }
      
      protected function setBackground() : void
      {
         var _loc1_:Boolean = this._owner is GaturroAvatarView && ((this._owner as Object).avatar as Avatar).isCitizen;
         this.asset.graphics.beginFill(0,ALPHA);
         if(_loc1_)
         {
            if((this._owner as Object).avatar.attributes.backLetterColor != null)
            {
               this.asset.graphics.beginFill((this._owner as Object).avatar.attributes.backLetterColor as uint,ALPHA);
            }
            else if((this._owner as Object).avatar.attributes.passportType == "boca")
            {
               this.asset.graphics.beginFill(16777215,ALPHA);
            }
            else if((this._owner as Object).avatar.attributes.thehuevo)
            {
               this.asset.graphics.beginFill(16757760,ALPHA);
            }
            else if((this._owner as Object).avatar.attributes.thejalouween2018)
            {
               this.asset.graphics.beginFill(6684876,ALPHA);
            }
         }
         if(this._owner is NpcRoomSceneObjectView && this.isNPCPascuas(this._owner as NpcRoomSceneObjectView))
         {
            this.asset.graphics.beginFill(16757760,ALPHA);
         }
         this.asset.graphics.drawRoundRect(this.field.x - MARGIN,this.field.y - MARGIN,this.field.textWidth + TEXT_FIX + MARGIN * 2,this.field.textHeight + TEXT_FIX + MARGIN * 2,ROUNDING);
      }
   }
}

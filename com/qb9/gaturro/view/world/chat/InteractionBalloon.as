package com.qb9.gaturro.view.world.chat
{
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.user.inventory.GaturroInventory;
   import com.qb9.gaturro.user.inventory.TransportInventorySceneObject;
   import com.qb9.mambo.user.inventory.InventorySceneObject;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class InteractionBalloon extends ChatBalloon
   {
      
      public static const RESPONSE_YES:String = "RESPONSE_YES";
      
      public static const RESPONSE_NO:String = "RESPONSE_NO";
       
      
      public var mustReplyNoWhenDie:Boolean = true;
      
      private var _interactionPrefix:String;
      
      private var firstTransport:InventorySceneObject;
      
      private var _interactionUtils:com.qb9.gaturro.view.world.chat.InteractionUtils;
      
      private var firstVarita:InventorySceneObject;
      
      public function InteractionBalloon(param1:String, param2:DisplayObject, param3:Sprite)
      {
         this._interactionPrefix = param1;
         super(param2,param3,"...");
      }
      
      private function wearsVarita() : Boolean
      {
         var _loc1_:String = api.getAvatarAttribute("gripFore") as String;
         return Boolean(_loc1_) && _loc1_.indexOf("halloween2017") != -1 && _loc1_.indexOf("varita") != -1;
      }
      
      private function hasVarita() : Boolean
      {
         var _loc2_:InventorySceneObject = null;
         var _loc1_:GaturroInventory = api.user.inventory(GaturroInventory.VISUALIZER) as GaturroInventory;
         for each(_loc2_ in _loc1_.items)
         {
            if(_loc2_.name.indexOf("halloween2017") != -1 && _loc2_.name.indexOf("varita") != -1)
            {
               this.firstVarita = _loc2_;
               return true;
            }
         }
         return false;
      }
      
      public function get interactionPrefix() : String
      {
         return this._interactionPrefix;
      }
      
      override protected function calculateTime(param1:String) : uint
      {
         return super.calculateTime(param1) * 6;
      }
      
      override protected function createAsset() : void
      {
         var _loc8_:Rectangle = null;
         asset = this._interactionUtils.hasSpecialAsset(this._interactionPrefix);
         var _loc1_:DisplayObject = MovieClip(asset).background;
         var _loc2_:TextField = MovieClip(asset).field;
         _loc2_.wordWrap = false;
         var _loc3_:int = _loc1_.width - _loc2_.width;
         _loc2_.autoSize = TextFieldAutoSize.CENTER;
         _loc2_.text = this.getQuestionText();
         var _loc4_:int = _loc1_.width - _loc2_.width;
         var _loc6_:TextField;
         var _loc5_:MovieClip;
         (_loc6_ = (_loc5_ = asset.getChildByName("yes") as MovieClip).getChildByName("label") as TextField).text = api.getText("SI");
         var _loc7_:MovieClip;
         (_loc6_ = (_loc7_ = asset.getChildByName("no") as MovieClip).getChildByName("label") as TextField).text = api.getText("NO");
         if(asset is InteractionRequestMC && _loc4_ < _loc3_)
         {
            _loc1_.width += _loc3_ - _loc4_ + 10;
            _loc8_ = _loc1_.getBounds(MovieClip(asset));
            _loc2_.x = _loc8_.left + 5;
            _loc7_.x = _loc8_.right - _loc7_.width - 5;
            _loc5_.x = _loc7_.x - _loc5_.width - 5;
         }
         if(_loc5_)
         {
            _loc5_.addEventListener(MouseEvent.MOUSE_UP,this.pressYes);
         }
         if(_loc7_)
         {
            _loc7_.addEventListener(MouseEvent.MOUSE_UP,this.pressNo);
         }
      }
      
      override public function removeBalloon() : void
      {
         this.removeListeners();
      }
      
      protected function removeListeners() : void
      {
         var _loc1_:DisplayObject = asset.getChildByName("yes");
         if(_loc1_)
         {
            _loc1_.removeEventListener(MouseEvent.MOUSE_UP,this.pressYes);
         }
         var _loc2_:DisplayObject = asset.getChildByName("no");
         if(_loc2_)
         {
            _loc2_.removeEventListener(MouseEvent.MOUSE_UP,this.pressNo);
         }
      }
      
      protected function pressYes(param1:Event) : void
      {
         if(this._interactionPrefix == "PM")
         {
            if(this.hasVarita())
            {
               if(!this.wearsVarita())
               {
                  api.setAvatarAttribute("gripFore",this.firstVarita.name + "_on");
               }
            }
            else
            {
               api.setAvatarAttribute("gripFore","halloween2017/wears.varitaFuego_on");
            }
         }
         if(this._interactionPrefix == "CC")
         {
            if(!this.hasTransport())
            {
               this.pressNo(param1);
               api.openIphoneNews("carrerasEstelares2017");
               api.textMessageToGUI("¡NECESITAS UN TRANSPORTE!");
               return;
            }
            if(!this.wearsTransport())
            {
               api.setAvatarAttribute("transport",this.firstTransport.name + "_on");
            }
         }
         param1.stopPropagation();
         this.removeListeners();
         this.asset.visible = false;
         this.mustReplyNoWhenDie = false;
         this.dispatch(InteractionBalloon.RESPONSE_YES);
      }
      
      override public function dispose() : void
      {
         this.removeListeners();
         if(this.mustReplyNoWhenDie)
         {
            this.dispatch(InteractionBalloon.RESPONSE_NO);
         }
         super.dispose();
      }
      
      private function getQuestionText() : String
      {
         var _loc1_:String = null;
         for(_loc1_ in settings.interactions)
         {
            if(settings.interactions[_loc1_].prefix == this._interactionPrefix)
            {
               return region.getText(settings.interactions[_loc1_].questionText);
            }
         }
         return "";
      }
      
      protected function pressNo(param1:Event) : void
      {
         param1.stopPropagation();
         this.removeListeners();
         this.asset.visible = false;
         this.mustReplyNoWhenDie = false;
         this.dispatch(InteractionBalloon.RESPONSE_NO);
      }
      
      private function hasTransport() : Boolean
      {
         var _loc2_:InventorySceneObject = null;
         var _loc1_:GaturroInventory = api.user.inventory(GaturroInventory.VISUALIZER) as GaturroInventory;
         for each(_loc2_ in _loc1_.items)
         {
            if(_loc2_ is TransportInventorySceneObject)
            {
               this.firstTransport = _loc2_;
               return true;
            }
         }
         return false;
      }
      
      private function wearsTransport() : Boolean
      {
         var _loc1_:String = api.getAvatarAttribute("transport") as String;
         return Boolean(_loc1_) && _loc1_ != "";
      }
      
      override protected function setup() : void
      {
         this._interactionUtils = new com.qb9.gaturro.view.world.chat.InteractionUtils();
         super.setup();
      }
   }
}

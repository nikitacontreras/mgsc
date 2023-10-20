package com.qb9.gaturro.view.components.banner.goblin
{
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.manager.notificator.Notification;
   import com.qb9.gaturro.commons.manager.notificator.NotificationManager;
   import com.qb9.gaturro.commons.view.component.canvas.switcher.FrameCanvasSwitcher;
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.notifier.GaturroNotificationType;
   import com.qb9.gaturro.user.inventory.GaturroInventory;
   import com.qb9.gaturro.view.gui.banner.properties.IHasRoomAPI;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import com.qb9.gaturro.world.catalog.Catalog;
   import com.qb9.gaturro.world.catalog.CatalogItem;
   import com.qb9.mambo.core.attributes.CustomAttributes;
   import com.qb9.mambo.core.objects.SceneObject;
   import com.qb9.mambo.world.avatars.AvatarBodyEnum;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   
   public class GoblinWardrobeBanner extends InstantiableGuiModal implements IHasRoomAPI
   {
      
      public static const SUIT_SELECTOR:String = "suitSelector";
      
      public static const EXPLANATION:String = "explanation";
      
      public static const SUIT_SHOWCASE:String = "suitShowcase";
       
      
      private var _roomAPI:GaturroRoomAPI;
      
      private var notificationManager:NotificationManager;
      
      private var closeBtn:SimpleButton;
      
      private var canvasSwitcher:FrameCanvasSwitcher;
      
      private var _selectedSuitAttributes:CustomAttributes;
      
      public function GoblinWardrobeBanner()
      {
         super("goblinWardrobeBanner","GoblinWardrobeBannerAsset");
         this.setupNotification();
      }
      
      private function serializeSuit(param1:Array) : void
      {
         if(!this._selectedSuitAttributes)
         {
            this._selectedSuitAttributes = new CustomAttributes();
         }
         this._selectedSuitAttributes[AvatarBodyEnum.HATS] = param1[0].name;
         this.exploydTorso(param1[1],this._selectedSuitAttributes);
         this._selectedSuitAttributes[AvatarBodyEnum.LEG] = String(param1[2].name).replace("pantalones","pantalon");
         this._selectedSuitAttributes[AvatarBodyEnum.FOOT] = String(param1[3].name).replace("zapatos","bota");
      }
      
      public function storeSuit() : void
      {
         var _loc5_:SceneObject = null;
         var _loc1_:GaturroInventory = this._roomAPI.user.inventory("visualizer") as GaturroInventory;
         var _loc2_:Array = _loc1_.byType("goblinTrajes.trajeGenerico");
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc5_ = _loc2_[_loc3_];
            _loc1_.remove(_loc5_.id);
            _loc3_++;
         }
         var _loc4_:Object = this.getSuitObject();
         this._roomAPI.giveUser("goblinTrajes.trajeGenerico",1,null,_loc4_);
         this.close();
      }
      
      private function exploydTorso(param1:CatalogItem, param2:CustomAttributes) : void
      {
         var _loc3_:String = this.extractName(param1,this._selectedSuitAttributes);
         this._roomAPI.room.getCatalogData(_loc3_,this.onCatalogGetted);
      }
      
      private function setupNotification() : void
      {
         this.notificationManager = Context.instance.getByType(NotificationManager) as NotificationManager;
      }
      
      public function toShowcase(param1:Array) : void
      {
         this.serializeSuit(param1);
         this.canvasSwitcher.switchCanvas(SUIT_SHOWCASE);
      }
      
      public function start() : void
      {
         this.canvasSwitcher.switchCanvas(SUIT_SELECTOR);
      }
      
      override protected function ready() : void
      {
         super.ready();
         this.setupCanvas();
      }
      
      override public function dispose() : void
      {
         this.canvasSwitcher.dispose();
         this.canvasSwitcher = null;
         super.dispose();
      }
      
      private function getSuitObject() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_.hats = this._selectedSuitAttributes[AvatarBodyEnum.HATS];
         _loc1_.leg = this._selectedSuitAttributes[AvatarBodyEnum.LEG];
         _loc1_.foot = this._selectedSuitAttributes[AvatarBodyEnum.FOOT];
         _loc1_.cloth = this._selectedSuitAttributes[AvatarBodyEnum.CLOTH];
         _loc1_.arm = this._selectedSuitAttributes[AvatarBodyEnum.ARM];
         return _loc1_;
      }
      
      private function extractName(param1:CatalogItem, param2:CustomAttributes) : String
      {
         var _loc3_:RegExp = /\b(?:(?!goblinTrajes.)[a-zA-Z0-9]+)/;
         var _loc4_:Object;
         return (_loc4_ = _loc3_.exec(param1.name)).toString();
      }
      
      private function onCatalogGetted(param1:Object, param2:Object = null) : void
      {
         var _loc3_:Array = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:CatalogItem = null;
         for each(_loc6_ in Catalog(param1).items)
         {
            _loc3_ = _loc6_.name.split(":");
            _loc4_ = String(_loc3_[0]);
            _loc5_ = String(_loc3_[1]);
            if(!AvatarBodyEnum.validate(_loc5_))
            {
               logger.warning("The category configured not corresponding to any validate body avatar part");
            }
            this._selectedSuitAttributes[_loc5_] = _loc4_;
         }
      }
      
      private function setupCanvas() : void
      {
         var _loc1_:MovieClip = view.getChildByName("canvasContainer") as MovieClip;
         this.canvasSwitcher = new FrameCanvasSwitcher(_loc1_);
         this.canvasSwitcher.addCanvas(new GoblinSuitSelectorCanvas(SUIT_SELECTOR,"selector",_loc1_,this));
         this.canvasSwitcher.addCanvas(new ShowcaseCanvas(SUIT_SHOWCASE,"showcase",_loc1_,this));
         this.canvasSwitcher.addCanvas(new ExplanationCanvas(EXPLANATION,"explanation",_loc1_,this));
         this.canvasSwitcher.switchCanvas(EXPLANATION);
      }
      
      override public function close() : void
      {
         super.close();
         this.notificationManager.brodcast(new com.qb9.gaturro.commons.manager.notificator.Notification(GaturroNotificationType.CUSTOM,{"key":"usaMaquina"}));
      }
      
      public function toSelector() : void
      {
         this.canvasSwitcher.switchCanvas(SUIT_SELECTOR);
      }
      
      public function set roomAPI(param1:GaturroRoomAPI) : void
      {
         this._roomAPI = param1;
      }
      
      public function get selectedSuitAttributes() : CustomAttributes
      {
         return this._selectedSuitAttributes;
      }
   }
}

import com.qb9.flashlib.utils.DisplayUtil;
import com.qb9.gaturro.globals.api;
import com.qb9.gaturro.view.components.banner.goblin.GoblinWardrobeBanner;
import com.qb9.gaturro.view.components.canvas.FrameCanvas;
import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
import com.qb9.gaturro.view.world.avatars.Gaturro;
import com.qb9.mambo.core.attributes.CustomAttributes;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;

class ShowcaseCanvas extends FrameCanvas
{
    
   
   private var acceptBtn:Sprite;
   
   private var retrytBtn:Sprite;
   
   private var gaturro:Gaturro;
   
   private var duende:MovieClip;
   
   public function ShowcaseCanvas(param1:String, param2:String, param3:DisplayObjectContainer, param4:InstantiableGuiModal)
   {
      super(param1,param2,param3,param4);
   }
   
   private static function gatherPlaceholders(param1:Sprite) : Array
   {
      var _loc3_:DisplayObject = null;
      var _loc2_:Array = [];
      for each(_loc3_ in DisplayUtil.children(param1,true))
      {
         if(_loc3_.name && _loc3_ is MovieClip && MovieClip(_loc3_).numChildren === 0)
         {
            _loc2_.push(_loc3_);
         }
      }
      return _loc2_;
   }
   
   private function onIndividualFetch(param1:DisplayObject, param2:Object) : void
   {
      param2.addChild(param1);
   }
   
   private function onFetchDuende(param1:DisplayObject) : void
   {
      this.duende = param1 as MovieClip;
      this.setupButton();
      this.setupAvatar();
   }
   
   private function onClickRetry(param1:MouseEvent) : void
   {
      GoblinWardrobeBanner(owner).toSelector();
   }
   
   private function seupButtonAccept() : void
   {
      this.acceptBtn = view.getChildByName("acceptBtn") as Sprite;
      this.acceptBtn.addEventListener(MouseEvent.CLICK,this.onClickAccept);
      var _loc1_:TextField = this.acceptBtn.getChildByName("field") as TextField;
      _loc1_.text = api.getText("HECHO");
   }
   
   override public function dispose() : void
   {
      if(this.acceptBtn)
      {
         this.acceptBtn.removeEventListener(MouseEvent.CLICK,this.onClickAccept);
      }
      super.dispose();
   }
   
   private function onClickAccept(param1:MouseEvent) : void
   {
      GoblinWardrobeBanner(owner).storeSuit();
   }
   
   private function setupAvatar() : void
   {
      var _loc5_:String = null;
      var _loc1_:CustomAttributes = GoblinWardrobeBanner(owner).selectedSuitAttributes;
      var _loc2_:MovieClip = view.getChildByName("avatarHolder") as MovieClip;
      var _loc3_:Array = gatherPlaceholders(this.duende);
      var _loc4_:int = 0;
      while(_loc4_ < _loc3_.length)
      {
         if((_loc5_ = String(_loc3_[_loc4_].name)) == "armFore" || _loc5_ == "armBack")
         {
            _loc5_ = "arm";
         }
         if(_loc5_ in _loc1_)
         {
            api.libraries.fetch(_loc1_[_loc5_],this.onIndividualFetch,_loc3_[_loc4_]);
         }
         _loc4_++;
      }
      _loc2_.addChild(this.duende);
   }
   
   private function setupButtonRetry() : void
   {
      this.retrytBtn = view.getChildByName("retrytBtn") as Sprite;
      this.retrytBtn.addEventListener(MouseEvent.CLICK,this.onClickRetry);
      var _loc1_:TextField = this.retrytBtn.getChildByName("field") as TextField;
      _loc1_.text = api.getText("ARMA OTRO");
   }
   
   private function fixClothes(param1:Object) : void
   {
      if(param1.arm)
      {
         param1.armFore = param1.arm;
         param1.armBack = param1.arm;
      }
      if(param1.gloves)
      {
         param1.gloveFore = param1.gloves;
         param1.gloveBack = param1.gloves;
      }
      if(param1.grip)
      {
         param1.grip = param1.gripFore;
         param1.grip = param1.gripBack;
      }
   }
   
   private function setupButton() : void
   {
      this.seupButtonAccept();
      this.setupButtonRetry();
   }
   
   override protected function setupShowView() : void
   {
      api.libraries.fetch("navidad2016/props.goblinBot",this.onFetchDuende);
   }
}

import com.qb9.gaturro.globals.api;
import com.qb9.gaturro.view.components.banner.goblin.GoblinWardrobeBanner;
import com.qb9.gaturro.view.components.canvas.FrameCanvas;
import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
import com.qb9.gaturro.view.world.avatars.Gaturro;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;

class ExplanationCanvas extends FrameCanvas
{
    
   
   private var gaturro:Gaturro;
   
   private var retrytBtn:Sprite;
   
   private var acceptBtn:Sprite;
   
   public function ExplanationCanvas(param1:String, param2:String, param3:DisplayObjectContainer, param4:InstantiableGuiModal)
   {
      super(param1,param2,param3,param4);
   }
   
   private function onClickAccept(param1:MouseEvent) : void
   {
      GoblinWardrobeBanner(owner).start();
   }
   
   override protected function setupShowView() : void
   {
      this.setupButton();
   }
   
   override public function dispose() : void
   {
      if(this.acceptBtn)
      {
         this.acceptBtn.removeEventListener(MouseEvent.CLICK,this.onClickAccept);
      }
      super.dispose();
   }
   
   private function setupButton() : void
   {
      this.acceptBtn = view.getChildByName("acceptBtn") as Sprite;
      this.acceptBtn.addEventListener(MouseEvent.CLICK,this.onClickAccept);
      var _loc1_:TextField = this.acceptBtn.getChildByName("field") as TextField;
      _loc1_.text = api.getText("LISTO");
   }
}

import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
import com.qb9.gaturro.globals.api;
import com.qb9.gaturro.view.components.banner.goblin.GoblinWardrobeBanner;
import com.qb9.gaturro.view.components.banner.goblin.GoblinWardrobeRepeater;
import com.qb9.gaturro.view.components.canvas.FrameCanvas;
import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
import com.qb9.gaturro.world.catalog.CatalogItem;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;

class GoblinSuitSelectorCanvas extends FrameCanvas
{
   
   public static const NAVIGATION_CONTAINER_NAME:String = "navigationContainerName";
   
   public static const ITEM_CONTAINER_NAME:String = "itemContainer";
   
   private static const REPEATER_CONTAINER_PREFIX:String = "repeaterContainer";
   
   private static const CATALOG_KEY:String = "catalog";
   
   private static const REPEATER_SET_CONTAINER_NAME:String = "repeaterSetContainer";
    
   
   private var repeaterSetContainer:DisplayObjectContainer;
   
   private var repeaterList:Array;
   
   private var toShowcaseBtn:Sprite;
   
   private var catalogList:Array;
   
   private var roomAPI:GaturroRoomAPI;
   
   public function GoblinSuitSelectorCanvas(param1:String, param2:String, param3:DisplayObjectContainer, param4:InstantiableGuiModal)
   {
      this.catalogList = new Array("goblinSuit_head","goblinSuit_cloth","goblinSuit_leg","goblinSuit_foot");
      super(param1,param2,param3,param4);
   }
   
   override public function dispose() : void
   {
      var _loc1_:GoblinWardrobeRepeater = null;
      for each(_loc1_ in this.repeaterList)
      {
         _loc1_.dispose();
      }
      _loc1_ = null;
      if(this.toShowcaseBtn)
      {
         this.toShowcaseBtn.removeEventListener(MouseEvent.CLICK,this.onClick);
      }
      super.dispose();
   }
   
   override protected function setupShowView() : void
   {
      this.repeaterSetContainer = view.getChildByName(REPEATER_SET_CONTAINER_NAME) as DisplayObjectContainer;
      this.setupButton();
      this.setupCatalogs();
   }
   
   private function onClick(param1:MouseEvent) : void
   {
      var _loc3_:CatalogItem = null;
      var _loc4_:GoblinWardrobeRepeater = null;
      var _loc2_:Array = new Array();
      for each(_loc4_ in this.repeaterList)
      {
         _loc3_ = _loc4_.getCurrentItem();
         _loc2_.push(_loc3_);
      }
      GoblinWardrobeBanner(owner).toShowcase(_loc2_);
   }
   
   private function setupCatalogs() : void
   {
      var _loc1_:GoblinWardrobeRepeater = null;
      var _loc3_:String = null;
      this.repeaterList = new Array();
      var _loc2_:int = 0;
      for each(_loc3_ in this.catalogList)
      {
         _loc1_ = new GoblinWardrobeRepeater(owner as GoblinWardrobeBanner,api,this.repeaterSetContainer.getChildAt(_loc2_) as Sprite,_loc3_);
         this.repeaterList.push(_loc1_);
         _loc2_++;
      }
   }
   
   private function setupButton() : void
   {
      this.toShowcaseBtn = view.getChildByName("toShowcaseBtn") as Sprite;
      this.toShowcaseBtn.addEventListener(MouseEvent.CLICK,this.onClick);
      var _loc1_:TextField = this.toShowcaseBtn.getChildByName("field") as TextField;
      _loc1_.text = api.getText("¡BUENO!");
   }
}

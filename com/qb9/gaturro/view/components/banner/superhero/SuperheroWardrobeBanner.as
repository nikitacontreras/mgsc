package com.qb9.gaturro.view.components.banner.superhero
{
   import com.qb9.gaturro.commons.view.component.canvas.switcher.InstantiableCanvasSwitcher;
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.user.inventory.GaturroInventory;
   import com.qb9.gaturro.view.gui.banner.properties.IHasRoomAPI;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import com.qb9.gaturro.world.catalog.Catalog;
   import com.qb9.gaturro.world.catalog.CatalogItem;
   import com.qb9.mambo.core.attributes.CustomAttributes;
   import com.qb9.mambo.core.objects.SceneObject;
   import com.qb9.mambo.world.avatars.AvatarBodyEnum;
   import flash.display.DisplayObjectContainer;
   import flash.display.SimpleButton;
   
   public class SuperheroWardrobeBanner extends InstantiableGuiModal implements IHasRoomAPI
   {
      
      public static const SUIT_SELECTOR:String = "suitSelector";
      
      public static const SUIT_SHOWCASE:String = "suitShowcase";
       
      
      private var _roomAPI:GaturroRoomAPI;
      
      private var closeBtn:SimpleButton;
      
      private var canvasSwitcher:InstantiableCanvasSwitcher;
      
      private var _selectedSuitAttributes:CustomAttributes;
      
      public function SuperheroWardrobeBanner()
      {
         super("superheroWardrobeBanner","SuperheroWardrobeBannerAsset");
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
         _loc1_.wear_hats = this._selectedSuitAttributes[AvatarBodyEnum.HATS];
         _loc1_.wear_leg = this._selectedSuitAttributes[AvatarBodyEnum.LEG];
         _loc1_.wear_foot = this._selectedSuitAttributes[AvatarBodyEnum.FOOT];
         _loc1_.wear_cloth = this._selectedSuitAttributes[AvatarBodyEnum.CLOTH];
         _loc1_.wear_arm = this._selectedSuitAttributes[AvatarBodyEnum.ARM];
         return _loc1_;
      }
      
      override protected function ready() : void
      {
         super.ready();
         this.setupCanvas();
      }
      
      public function set roomAPI(param1:GaturroRoomAPI) : void
      {
         this._roomAPI = param1;
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
      
      private function extractName(param1:CatalogItem, param2:CustomAttributes) : String
      {
         var _loc3_:RegExp = /\b(?:(?!superHeroesTrajes.)[a-zA-Z0-9]+)/;
         var _loc4_:Object = _loc3_.exec(param1.name);
         trace(_loc4_);
         return _loc4_.toString();
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
         var _loc7_:SceneObject = null;
         var _loc1_:GaturroInventory = this._roomAPI.user.inventory("visualizer") as GaturroInventory;
         var _loc2_:Array = _loc1_.byType("superHeroesTrajes.trajeGenerico");
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc7_ = _loc2_[_loc3_];
            _loc1_.remove(_loc7_.id);
            _loc3_++;
         }
         var _loc4_:Object = this.getSuitObject();
         this._roomAPI.giveUser("superHeroesTrajes.trajeGenerico",1,null,_loc4_);
         var _loc5_:String = this._roomAPI.getProfileAttribute("cuest/sh/status") as String;
         var _loc6_:String = this._roomAPI.getProfileAttribute("cuest/sh/status2") as String;
         if(_loc5_ == "device")
         {
            _loc5_ = "traje";
            this._roomAPI.setProfileAttribute("cuest/sh/status",_loc5_);
         }
         if(_loc6_ == "super")
         {
            if(_loc5_ != "boss" || _loc5_ != "end")
            {
               this._roomAPI.setProfileAttribute("cuest/sh/status","defeat");
            }
         }
         close();
      }
      
      public function toShowcase(param1:Array) : void
      {
         this.serializeSuit(param1);
         this.canvasSwitcher.switchCanvas(SUIT_SHOWCASE);
      }
      
      private function setupCanvas() : void
      {
         var _loc1_:DisplayObjectContainer = view.getChildByName("canvasContainer") as DisplayObjectContainer;
         this.canvasSwitcher = new InstantiableCanvasSwitcher(_loc1_);
         this.canvasSwitcher.addCanvas(new SuitSuperheroSelectorCanvas(SUIT_SELECTOR,this,"RepeaterSetContainer",this._roomAPI));
         this.canvasSwitcher.addCanvas(new ShowcaseCanvas(SUIT_SHOWCASE,this,"ShowcaseAsset",this._roomAPI));
         this.canvasSwitcher.switchCanvas(SUIT_SELECTOR);
      }
      
      private function exploydTorso(param1:CatalogItem, param2:CustomAttributes) : void
      {
         var _loc3_:String = this.extractName(param1,this._selectedSuitAttributes);
         this._roomAPI.room.getCatalogData(_loc3_,this.onCatalogGetted);
      }
      
      public function toSelector() : void
      {
         this.canvasSwitcher.switchCanvas(SUIT_SELECTOR);
      }
      
      public function get selectedSuitAttributes() : CustomAttributes
      {
         return this._selectedSuitAttributes;
      }
   }
}

import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
import com.qb9.gaturro.view.components.banner.superhero.SuperheroWardrobeBanner;
import com.qb9.gaturro.view.components.banner.superhero.SuperheroWardrobeRepeater;
import com.qb9.gaturro.view.components.canvas.InstatiableCanvas;
import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
import com.qb9.gaturro.world.catalog.CatalogItem;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;

class SuitSuperheroSelectorCanvas extends InstatiableCanvas
{
   
   public static const NAVIGATION_CONTAINER_NAME:String = "navigationContainerName";
   
   public static const ITEM_CONTAINER_NAME:String = "itemContainer";
   
   private static const REPEATER_CONTAINER_PREFIX:String = "repeaterContainer";
   
   private static const CATALOG_KEY:String = "catalog";
   
   private static const REPEATER_SET_CONTAINER_NAME:String = "RepeaterSetContainer";
    
   
   private var repeaterList:Array;
   
   private var repeaterSetContainer:DisplayObjectContainer;
   
   private var catalogList:Array;
   
   private var toShowcaseBtn:Sprite;
   
   private var roomAPI:GaturroRoomAPI;
   
   public function SuitSuperheroSelectorCanvas(param1:String, param2:InstantiableGuiModal, param3:String, param4:GaturroRoomAPI)
   {
      this.catalogList = new Array("superheroSuit_head","superheroSuit_cloth","superheroSuit_leg","superheroSuit_foot");
      super(param1,param2,param3);
      this.roomAPI = param4;
      this.repeaterSetContainer = view.getChildByName(REPEATER_SET_CONTAINER_NAME) as DisplayObjectContainer;
      this.setupButton();
      this.setupCatalogs();
   }
   
   override public function dispose() : void
   {
      var _loc1_:SuperheroWardrobeRepeater = null;
      for each(_loc1_ in this.repeaterList)
      {
         _loc1_.dispose();
      }
      _loc1_ = null;
      this.toShowcaseBtn.removeEventListener(MouseEvent.CLICK,this.onClick);
      super.dispose();
   }
   
   private function onClick(param1:MouseEvent) : void
   {
      var _loc3_:CatalogItem = null;
      var _loc4_:SuperheroWardrobeRepeater = null;
      var _loc2_:Array = new Array();
      for each(_loc4_ in this.repeaterList)
      {
         _loc3_ = _loc4_.getCurrentItem();
         _loc2_.push(_loc3_);
      }
      SuperheroWardrobeBanner(owner).toShowcase(_loc2_);
   }
   
   private function setupButton() : void
   {
      this.toShowcaseBtn = view.getChildByName("toShowcaseBtn") as Sprite;
      this.toShowcaseBtn.addEventListener(MouseEvent.CLICK,this.onClick);
      var _loc1_:TextField = this.toShowcaseBtn.getChildByName("field") as TextField;
      _loc1_.text = this.roomAPI.getText("¡BUENO!");
   }
   
   private function setupCatalogs() : void
   {
      var _loc1_:SuperheroWardrobeRepeater = null;
      var _loc3_:String = null;
      this.repeaterList = new Array();
      var _loc2_:int = 0;
      for each(_loc3_ in this.catalogList)
      {
         _loc1_ = new SuperheroWardrobeRepeater(owner as SuperheroWardrobeBanner,this.roomAPI,view.getChildAt(_loc2_) as Sprite,_loc3_);
         this.repeaterList.push(_loc1_);
         _loc2_++;
      }
   }
}

import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
import com.qb9.gaturro.util.StubAttributeHolder;
import com.qb9.gaturro.view.components.banner.superhero.SuperheroWardrobeBanner;
import com.qb9.gaturro.view.components.canvas.InstatiableCanvas;
import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
import com.qb9.gaturro.view.world.avatars.Gaturro;
import com.qb9.mambo.core.attributes.CustomAttributes;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;

class ShowcaseCanvas extends InstatiableCanvas
{
    
   
   private var retrytBtn:Sprite;
   
   private var gaturro:Gaturro;
   
   private var acceptBtn:Sprite;
   
   private var roomAPI:GaturroRoomAPI;
   
   public function ShowcaseCanvas(param1:String, param2:InstantiableGuiModal, param3:String, param4:GaturroRoomAPI)
   {
      super(param1,param2,param3);
      this.roomAPI = param4;
      this.setupButton();
   }
   
   private function onClickRetry(param1:MouseEvent) : void
   {
      SuperheroWardrobeBanner(owner).toSelector();
   }
   
   private function seupButtonAccept() : void
   {
      this.acceptBtn = view.getChildByName("acceptBtn") as Sprite;
      this.acceptBtn.addEventListener(MouseEvent.CLICK,this.onClickAccept);
      var _loc1_:TextField = this.acceptBtn.getChildByName("field") as TextField;
      _loc1_.text = this.roomAPI.getText("HECHO");
   }
   
   override public function dispose() : void
   {
      this.acceptBtn.removeEventListener(MouseEvent.CLICK,this.onClickAccept);
      super.dispose();
   }
   
   private function setupButton() : void
   {
      this.seupButtonAccept();
      this.setupButtonRetry();
   }
   
   private function onClickAccept(param1:MouseEvent) : void
   {
      SuperheroWardrobeBanner(owner).storeSuit();
   }
   
   private function setupAvatar() : void
   {
      var _loc1_:CustomAttributes = null;
      var _loc2_:MovieClip = null;
      if(!this.gaturro)
      {
         _loc1_ = SuperheroWardrobeBanner(owner).selectedSuitAttributes;
         _loc2_ = view.getChildByName("avatarHolder") as MovieClip;
         this.gaturro = new Gaturro(new StubAttributeHolder(_loc1_));
         _loc2_.addChild(this.gaturro);
      }
   }
   
   private function setupButtonRetry() : void
   {
      this.retrytBtn = view.getChildByName("retrytBtn") as Sprite;
      this.retrytBtn.addEventListener(MouseEvent.CLICK,this.onClickRetry);
      var _loc1_:TextField = this.retrytBtn.getChildByName("field") as TextField;
      _loc1_.text = this.roomAPI.getText("ARMA OTRO");
   }
   
   override public function show(param1:Object = null) : void
   {
      super.show(param1);
      this.setupAvatar();
   }
}

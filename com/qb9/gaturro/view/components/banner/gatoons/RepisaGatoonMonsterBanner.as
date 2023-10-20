package com.qb9.gaturro.view.components.banner.gatoons
{
   import com.qb9.gaturro.commons.asset.IAssetProvider;
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.external.roomObjects.GaturroSceneObjectAPI;
   import com.qb9.gaturro.user.inventory.GaturroInventory;
   import com.qb9.gaturro.view.gui.banner.properties.IHasRoomAPI;
   import com.qb9.gaturro.view.gui.banner.properties.IHasSceneAPI;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class RepisaGatoonMonsterBanner extends InstantiableGuiModal implements IHasRoomAPI, IHasSceneAPI, IAssetProvider
   {
      
      private static const MONSTER_NAME_KEY:String = "gatoons.estatuaMonster_";
      
      private static const CANT_PAGINAS:int = 8;
      
      private static const UNIQUE_IDS_KEY:String = "uniqueIDs";
      
      private static const CANT_HOLDERS:int = 1;
      
      private static const DELAY_LOADING:int = 2200;
       
      
      private var _roomAPI:GaturroRoomAPI;
      
      private var pagina:MovieClip;
      
      private var _sceneObjectAPI:GaturroSceneObjectAPI;
      
      private var uniqueIDs:Array;
      
      private var houseInventory:GaturroInventory;
      
      private var sceneObjects:Array;
      
      private var paginas:Array;
      
      private var currentPage:int;
      
      private var tracking:TrackingAPI;
      
      private var assetCount:int = 0;
      
      public function RepisaGatoonMonsterBanner()
      {
         super("repisaGatoonMonsterBanner","repisaGatoonMonsterBannerAsset");
      }
      
      private function setupTracking() : void
      {
         this.tracking = new TrackingAPI(this._roomAPI);
         this.tracking.setupTracking();
      }
      
      private function registerComponents() : void
      {
         this.pagina = view.getChildByName("pagina") as MovieClip;
      }
      
      private function searchForStatues(param1:Array, param2:Array) : void
      {
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         while(_loc5_ < param1.length)
         {
            _loc4_ = String(param1[_loc5_].name);
            if(this.uniqueIDs.length != CANT_HOLDERS * CANT_PAGINAS && _loc4_.indexOf(MONSTER_NAME_KEY) != -1)
            {
               _loc3_ = this.getIDFromName(_loc4_);
               if(!this.checkIDAdded(_loc3_,param2))
               {
                  param2.push(_loc3_);
               }
            }
            _loc5_++;
         }
      }
      
      private function setupData() : void
      {
         this.houseInventory = this._roomAPI.user.inventory(GaturroInventory.HOUSE) as GaturroInventory;
         this.sceneObjects = this._roomAPI.room.sceneObjects;
         this.uniqueIDs = [];
         this.searchForStatues(this.houseInventory.items,this.uniqueIDs);
         this.searchForStatues(this.sceneObjects,this.uniqueIDs);
      }
      
      private function onPageClick(param1:MouseEvent) : void
      {
         var _loc2_:String = String(param1.target.name);
         if(_loc2_.indexOf("boton") == -1)
         {
            return;
         }
         this.pagina.removeChild(this.paginas[this.currentPage]);
         this.currentPage = int(_loc2_.substr(5,1));
         this.pagina.addChild(this.paginas[this.currentPage]);
      }
      
      override protected function ready() : void
      {
         super.ready();
         this.setupTracking();
         this.setupData();
         this.registerComponents();
         this.buildPages();
         this.setupPageButtons();
         this.tracking.abreBanner();
      }
      
      private function checkIDAdded(param1:int, param2:Array) : Boolean
      {
         if(!param2 || param2.length == 0)
         {
            return false;
         }
         var _loc3_:int = 0;
         while(_loc3_ < param2.length)
         {
            if(param1 == param2[_loc3_])
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      private function updatePageViews() : void
      {
         var _loc2_:Pagina = null;
         var _loc3_:int = 0;
         var _loc4_:EstatuaHolder = null;
         var _loc5_:int = 0;
         var _loc1_:int = 0;
         while(_loc1_ < this.paginas.length)
         {
            _loc2_ = this.paginas[_loc1_];
            _loc3_ = 0;
            while(_loc3_ < _loc2_.holders.length)
            {
               _loc4_ = _loc2_.holders[_loc3_];
               _loc5_ = _loc1_ + 1;
               _loc4_.setView(this.checkIDAdded(_loc5_,this.uniqueIDs));
               _loc3_++;
            }
            _loc1_++;
         }
      }
      
      private function getIDFromName(param1:String) : int
      {
         return int(param1.substr(MONSTER_NAME_KEY.length,1));
      }
      
      public function set sceneAPI(param1:GaturroSceneObjectAPI) : void
      {
         this._sceneObjectAPI = param1;
      }
      
      private function returnStatueNameByID(param1:int) : String
      {
         var _loc2_:String = param1.toString();
         return MONSTER_NAME_KEY + _loc2_;
      }
      
      private function estatuaAssetLoaded(param1:Event) : void
      {
         ++this.assetCount;
         if(this.assetCount >= CANT_HOLDERS * CANT_PAGINAS)
         {
            this.updatePageViews();
         }
      }
      
      private function setupPageButtons() : void
      {
         var _loc2_:SimpleButton = null;
         var _loc1_:int = 0;
         while(_loc1_ < CANT_PAGINAS)
         {
            _loc2_ = view.getChildByName("boton" + _loc1_.toString()) as SimpleButton;
            _loc2_.addEventListener(MouseEvent.CLICK,this.onPageClick);
            _loc1_++;
         }
      }
      
      private function buildPages() : void
      {
         var _loc2_:Pagina = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:EstatuaHolder = null;
         if(!this.paginas)
         {
            this.paginas = [];
         }
         var _loc1_:int = 0;
         while(_loc1_ < CANT_PAGINAS)
         {
            _loc2_ = new Pagina(_loc1_);
            _loc3_ = 1;
            while(_loc3_ <= CANT_HOLDERS)
            {
               _loc4_ = _loc1_ + 1;
               (_loc5_ = new EstatuaHolder(getInstanceByName,this.returnStatueNameByID(_loc4_),_loc4_,this._roomAPI)).addEventListener(EstatuaHolder.ASSET_READY,this.estatuaAssetLoaded);
               _loc2_.addHolder(_loc5_,0);
               _loc3_++;
            }
            this.paginas.push(_loc2_);
            _loc1_++;
         }
         this.currentPage = 0;
         this.pagina.addChild(this.paginas[this.currentPage]);
      }
      
      public function set roomAPI(param1:GaturroRoomAPI) : void
      {
         this._roomAPI = param1;
      }
   }
}

import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.events.Event;

class EstatuaHolder extends MovieClip
{
   
   public static const ASSET_READY:String = "asset_ready";
    
   
   public var assetEstatuaName:String;
   
   private var returnToInventory:Function;
   
   public var assetEstatua:MovieClip;
   
   private var api:GaturroRoomAPI;
   
   private var id:int;
   
   public var assetHolder:MovieClip;
   
   public function EstatuaHolder(param1:Function, param2:String, param3:int, param4:GaturroRoomAPI)
   {
      super();
      this.assetEstatuaName = param2;
      this.api = param4;
      this.id = param3;
      this.returnToInventory = this.returnToInventory;
      this.assetHolder = param1("estatuaHolder") as MovieClip;
      param4.libraries.fetch(param2,this.fetchEstatua);
   }
   
   private function fetchEstatua(param1:DisplayObject) : void
   {
      this.assetHolder.view.addChild(param1);
      var _loc2_:MovieClip = param1 as MovieClip;
      if(Boolean(_loc2_) && Boolean(_loc2_.attributes))
      {
         if(_loc2_.attributes.gameName)
         {
            this.assetHolder.itemName.text = _loc2_.attributes.gameName;
         }
         if(_loc2_.attributes.bio)
         {
            this.assetHolder.bio.text = _loc2_.attributes.bio;
         }
         this.assetHolder.powerAnimation.gotoAndStop(this.id);
      }
      dispatchEvent(new Event(ASSET_READY));
   }
   
   public function setView(param1:Boolean) : void
   {
      if(param1)
      {
         this.assetHolder.gotoAndStop(2);
      }
      else
      {
         this.assetHolder.gotoAndStop(1);
      }
   }
}

import flash.display.MovieClip;

class Pagina extends MovieClip
{
    
   
   public var holders:Array;
   
   public var pageId:int;
   
   private const OFFSET_X:int = 30;
   
   private const ANCHO:int = 220;
   
   public function Pagina(param1:int)
   {
      super();
      this.holders = [];
   }
   
   public function addHolder(param1:EstatuaHolder, param2:int) : void
   {
      addChild(param1.assetHolder);
      param1.assetHolder.x = this.ANCHO * param2 + this.OFFSET_X * param2;
      this.holders.push(param1);
   }
}

import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;

class TrackingAPI
{
    
   
   private const TRACKING_KEY:String = "trackingGatoons";
   
   private var tracking:Object;
   
   private var roomAPI:GaturroRoomAPI;
   
   public function TrackingAPI(param1:GaturroRoomAPI)
   {
      super();
      this.roomAPI = param1;
   }
   
   public function abreBanner() : void
   {
      if(this.tracking && this.tracking.repisa2 && Boolean(this.tracking.repisa2.open))
      {
         return;
      }
      this.roomAPI.trackEvent("FEATURES:GATOONS:cabinet_monster_popup_first","true");
      this.roomAPI.setProfileAttribute(this.TRACKING_KEY + "/repisa2/open",1);
   }
   
   public function setupTracking() : void
   {
      var _loc1_:String = this.roomAPI.getProfileAttribute(this.TRACKING_KEY) as String;
      this.tracking = this.roomAPI.JSONDecode(_loc1_);
      trace(_loc1_,this.tracking);
   }
}

package com.qb9.gaturro.view.components.banner.gatoons
{
   import com.qb9.gaturro.commons.asset.IAssetProvider;
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.external.roomObjects.GaturroSceneObjectAPI;
   import com.qb9.gaturro.globals.net;
   import com.qb9.gaturro.user.inventory.GaturroInventory;
   import com.qb9.gaturro.view.gui.banner.properties.IHasRoomAPI;
   import com.qb9.gaturro.view.gui.banner.properties.IHasSceneAPI;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import com.qb9.gaturro.world.core.elements.GaturroRoomSceneObject;
   import com.qb9.mambo.net.requests.room.DestroyRoomObjectActionRequest;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   
   public class RepisaGatoonsBanner extends InstantiableGuiModal implements IHasRoomAPI, IHasSceneAPI, IAssetProvider
   {
      
      private static const DELAY_LOADING:int = 2200;
      
      private static const CANT_PAGINAS:int = 10;
      
      private static const UNIQUE_IDS_KEY:String = "uniqueIDs";
      
      private static const GATOONS_NAME:String = "gatoonsEstatuas.estatua";
      
      private static const CANT_HOLDERS:int = 4;
       
      
      private var _roomAPI:GaturroRoomAPI;
      
      private var pagina:MovieClip;
      
      private var uploadButton:MovieClip;
      
      private var houseInventory:GaturroInventory;
      
      private var currentPage:int;
      
      private var areNew:Boolean;
      
      private var toAdd:Array;
      
      private var returning:Boolean = false;
      
      private var paginas:Array;
      
      private var tracking:TrackingAPI;
      
      private var loading:MovieClip;
      
      private var uniqueIDs:Array;
      
      private var _sceneObjectAPI:GaturroSceneObjectAPI;
      
      private var sceneObjects:Array;
      
      private var assetCount:int = 0;
      
      public function RepisaGatoonsBanner()
      {
         super("repisaGatoonsBanner","repisaGatoonsBannerAsset");
      }
      
      private function onAddNewDelayed() : void
      {
         this.uniqueIDs = this.uniqueIDs.concat(this.toAdd);
         this.uniqueIDs.sort(Array.NUMERIC);
         var _loc1_:int = 0;
         while(_loc1_ < this.toAdd.length)
         {
            this.removeOneFromInventoryOrRoom(this.toAdd[_loc1_]);
            _loc1_++;
         }
         this.toAdd = [];
         this.areNew = false;
         this._sceneObjectAPI.setAttributePersist(UNIQUE_IDS_KEY,this.uniqueIDsToString());
         this.tracking.agregaEstatuas();
         this.updatePageViews();
         this.uploadButton.visible = false;
         this.loading.visible = false;
      }
      
      private function setEstatuaView(param1:int) : void
      {
         var _loc2_:int = (param1 - 1) / 4;
         var _loc3_:EstatuaHolder = this.paginas[_loc2_];
         _loc3_.setView(true);
      }
      
      private function setupChangingButtons() : void
      {
         if(!this._roomAPI.roomOwnedByUser)
         {
            this.uploadButton.visible = false;
            return;
         }
         if(!this.areNew)
         {
            this.uploadButton.visible = false;
         }
      }
      
      private function registerComponents() : void
      {
         this.uploadButton = view.getChildByName("update") as MovieClip;
         this.uploadButton.addEventListener(MouseEvent.CLICK,this.onUpLoad);
         this.loading = view.getChildByName("loading") as MovieClip;
         this.loading.visible = false;
         this.pagina = view.getChildByName("pagina") as MovieClip;
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
      
      override protected function ready() : void
      {
         super.ready();
         this.setupTracking();
         this.setupData();
         this.registerComponents();
         this.buildPages();
         this.setupPageButtons();
         this.setupChangingButtons();
         this.tracking.abreBanner();
      }
      
      private function removeOneFromInventoryOrRoom(param1:int) : void
      {
         var _loc2_:String = null;
         var _loc4_:GaturroRoomSceneObject = null;
         var _loc3_:int = 0;
         while(_loc3_ < this.houseInventory.items.length)
         {
            _loc2_ = String(this.houseInventory.items[_loc3_].name);
            if(_loc2_ == this.returnStatueNameByID(param1))
            {
               this.houseInventory.remove(this.houseInventory.items[_loc3_].id);
               return;
            }
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < this.sceneObjects.length)
         {
            _loc2_ = String(this.sceneObjects[_loc3_].name);
            if(_loc2_ == this.returnStatueNameByID(param1))
            {
               _loc4_ = this.sceneObjects[_loc3_] as GaturroRoomSceneObject;
               net.sendAction(new DestroyRoomObjectActionRequest(_loc4_.id));
               return;
            }
            _loc3_++;
         }
      }
      
      private function returnStatueNameByID(param1:int) : String
      {
         var _loc2_:String = param1.toString();
         if(_loc2_.length == 1)
         {
            _loc2_ = "0" + _loc2_;
         }
         return GATOONS_NAME + _loc2_;
      }
      
      private function setupPageButtons() : void
      {
         var _loc2_:SimpleButton = null;
         var _loc1_:int = 0;
         while(_loc1_ < 10)
         {
            _loc2_ = view.getChildByName("boton" + _loc1_.toString()) as SimpleButton;
            _loc2_.addEventListener(MouseEvent.CLICK,this.onPageClick);
            _loc1_++;
         }
      }
      
      private function returnToInventory(param1:int) : void
      {
         if(this.returning)
         {
            return;
         }
         this.loading.visible = true;
         var _loc2_:int = 0;
         while(_loc2_ < this.uniqueIDs.length)
         {
            if(param1 == this.uniqueIDs[_loc2_])
            {
               this.uniqueIDs.splice(_loc2_,1);
            }
            _loc2_++;
         }
         this.toAdd.push(param1);
         this.returning = true;
         setTimeout(this.returnToInventoryDelayed,DELAY_LOADING,param1);
      }
      
      private function uniqueIDsToString() : String
      {
         var _loc1_:String = "";
         if(Boolean(this.uniqueIDs) && this.uniqueIDs.length > 0)
         {
            _loc1_ += this.uniqueIDs[0].toString();
         }
         var _loc2_:int = 1;
         while(_loc2_ < this.uniqueIDs.length)
         {
            _loc1_ += "," + this.uniqueIDs[_loc2_].toString();
            _loc2_++;
         }
         return _loc1_;
      }
      
      private function setupTracking() : void
      {
         this.tracking = new TrackingAPI(this._roomAPI);
         this.tracking.setupTracking();
      }
      
      private function searchForStatues(param1:Array, param2:Array) : void
      {
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         while(_loc5_ < param1.length)
         {
            _loc4_ = String(param1[_loc5_].name);
            if(this.uniqueIDs.length != 40 && _loc4_.indexOf(GATOONS_NAME) != -1)
            {
               _loc3_ = this.getIDFromName(_loc4_);
               if(!this.checkIDAdded(_loc3_,this.uniqueIDs) && !this.checkIDAdded(_loc3_,this.toAdd))
               {
                  param2.push(_loc3_);
               }
            }
            _loc5_++;
         }
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
               _loc5_ = _loc1_ * 4 + (_loc3_ + 1);
               _loc4_.setView(this.checkIDAdded(_loc5_,this.uniqueIDs));
               _loc3_++;
            }
            _loc1_++;
         }
      }
      
      public function set sceneAPI(param1:GaturroSceneObjectAPI) : void
      {
         this._sceneObjectAPI = param1;
      }
      
      private function setupData() : void
      {
         this.houseInventory = this._roomAPI.user.inventory(GaturroInventory.HOUSE) as GaturroInventory;
         this.sceneObjects = this._roomAPI.room.sceneObjects;
         this.uniqueIDs = [];
         this.toAdd = [];
         var _loc1_:Object = this._sceneObjectAPI.getAttribute(UNIQUE_IDS_KEY);
         var _loc2_:Array = [];
         if(_loc1_ is int)
         {
            _loc2_ = [int(_loc1_)];
         }
         else if(_loc1_ is String)
         {
            if(_loc1_ != "null" && _loc1_ != " ")
            {
               _loc2_ = _loc1_.split(",");
            }
         }
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(!this.checkIDAdded(_loc2_[_loc3_],this.uniqueIDs))
            {
               this.uniqueIDs.push(int(_loc2_[_loc3_]));
            }
            _loc3_++;
         }
         this.searchForStatues(this.houseInventory.items,this.toAdd);
         this.searchForStatues(this.sceneObjects,this.toAdd);
         this.areNew = this.toAdd.length > 0;
      }
      
      private function onUpLoad(param1:MouseEvent) : void
      {
         this.loading.visible = true;
         setTimeout(this.onUpLoadDelayed,DELAY_LOADING);
      }
      
      private function onUpLoadDelayed() : void
      {
         this.onAddNewDelayed();
         this.loading.visible = false;
      }
      
      private function getIDFromName(param1:String) : int
      {
         return int(param1.substr(GATOONS_NAME.length,2));
      }
      
      private function returnToInventoryDelayed(param1:int) : void
      {
         this.updatePageViews();
         this._roomAPI.giveUser(this.returnStatueNameByID(param1));
         this._sceneObjectAPI.setAttributePersist(UNIQUE_IDS_KEY,this.uniqueIDsToString());
         this.tracking.descargaEstatuas();
         this.uploadButton.visible = true;
         this.loading.visible = false;
         this.returning = false;
      }
      
      private function estatuaAssetLoaded(param1:Event) : void
      {
         ++this.assetCount;
         if(this.assetCount >= 40)
         {
            this.updatePageViews();
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
               _loc4_ = _loc1_ * 4 + _loc3_;
               (_loc5_ = new EstatuaHolder(getInstanceByName,this.returnStatueNameByID(_loc4_),_loc4_,this._roomAPI,this.returnToInventory)).addEventListener(EstatuaHolder.ASSET_READY,this.estatuaAssetLoaded);
               _loc2_.addHolder(_loc5_,_loc3_ - 1);
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
import flash.events.MouseEvent;

class EstatuaHolder extends MovieClip
{
   
   public static const ASSET_READY:String = "asset_ready";
    
   
   public var assetEstatuaName:String;
   
   private var returnToInventory:Function;
   
   public var assetEstatua:MovieClip;
   
   private var api:GaturroRoomAPI;
   
   private var id:int;
   
   public var assetHolder:MovieClip;
   
   public function EstatuaHolder(param1:Function, param2:String, param3:int, param4:GaturroRoomAPI, param5:Function)
   {
      super();
      this.assetEstatuaName = param2;
      this.api = param4;
      this.id = param3;
      this.returnToInventory = param5;
      this.assetHolder = param1("estatuaHolder") as MovieClip;
      param4.libraries.fetch(param2,this.fetchEstatua);
      this.assetHolder.toInventory.addEventListener(MouseEvent.CLICK,this.onRemove);
   }
   
   private function onRemove(param1:MouseEvent) : void
   {
      this.returnToInventory(this.id);
   }
   
   private function fetchEstatua(param1:DisplayObject) : void
   {
      this.assetHolder.view.addChild(param1);
      var _loc2_:MovieClip = param1 as MovieClip;
      if(_loc2_ && _loc2_.attributes && Boolean(_loc2_.attributes.gameName))
      {
         this.assetHolder.itemName.text = _loc2_.attributes.gameName;
      }
      dispatchEvent(new Event(ASSET_READY));
   }
   
   public function setView(param1:Boolean) : void
   {
      if(param1)
      {
         this.assetHolder.gotoAndStop(2);
         this.assetHolder.toInventory.visible = true;
      }
      else
      {
         this.assetHolder.gotoAndStop(1);
         this.assetHolder.toInventory.visible = false;
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
      if(this.tracking && this.tracking.repisa && Boolean(this.tracking.repisa.open))
      {
         return;
      }
      this.roomAPI.trackEvent("FEATURES:GATOONS:cabinet_popup_first","true");
      this.roomAPI.setProfileAttribute(this.TRACKING_KEY + "/repisa/open",1);
   }
   
   public function agregaEstatuas() : void
   {
      if(this.tracking && this.tracking.repisa && Boolean(this.tracking.repisa.load))
      {
         this.roomAPI.trackEvent("FEATURES:GATOONS:cabinet_load","true");
      }
      else
      {
         this.roomAPI.trackEvent("FEATURES:GATOONS:cabinet_load_first","true");
         if(Boolean(this.tracking) && Boolean(this.tracking.repisa))
         {
            this.tracking.repisa.load = true;
         }
         else if(this.tracking)
         {
            this.tracking.repisa = {"load":true};
         }
         else
         {
            this.tracking = {"repisa":{"load":true}};
         }
         this.roomAPI.setProfileAttribute(this.TRACKING_KEY + "/repisa/load",1);
      }
   }
   
   public function setupTracking() : void
   {
      var _loc1_:String = this.roomAPI.getProfileAttribute(this.TRACKING_KEY) as String;
      this.tracking = this.roomAPI.JSONDecode(_loc1_);
      trace(_loc1_,this.tracking);
   }
   
   public function descargaEstatuas() : void
   {
      if(this.tracking && this.tracking.repisa && Boolean(this.tracking.repisa.unload))
      {
         this.roomAPI.trackEvent("FEATURES:GATOONS:cabinet_unload","true");
      }
      else
      {
         this.roomAPI.trackEvent("FEATURES:GATOONS:cabinet_unload_first","true");
         if(Boolean(this.tracking) && Boolean(this.tracking.repisa))
         {
            this.tracking.repisa.unload = true;
         }
         else if(this.tracking)
         {
            this.tracking.repisa = {"unload":true};
         }
         else
         {
            this.tracking = {"repisa":{"unload":true}};
         }
         this.roomAPI.setProfileAttribute(this.TRACKING_KEY + "/repisa/unload",1);
      }
   }
}

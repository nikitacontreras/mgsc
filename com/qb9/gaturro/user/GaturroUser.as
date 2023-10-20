package com.qb9.gaturro.user
{
   import com.qb9.flashlib.lang.map;
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.event.ContextEvent;
   import com.qb9.gaturro.commons.event.EventManager;
   import com.qb9.gaturro.commons.net.delegate.AbstractRequestDelegate;
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.net.delegate.PassportProductRequestDelegate;
   import com.qb9.gaturro.user.cellPhone.CellPhoneDevice;
   import com.qb9.gaturro.user.farm.GaturroFarm;
   import com.qb9.gaturro.user.inventory.GaturroInventory;
   import com.qb9.gaturro.user.passport.IPassportProductHolder;
   import com.qb9.gaturro.user.passport.PassportProduct;
   import com.qb9.gaturro.user.profile.GaturroProfile;
   import com.qb9.gaturro.world.community.CommunityManager;
   import com.qb9.mambo.net.manager.NetworkManager;
   import com.qb9.mambo.user.User;
   import com.qb9.mambo.user.events.UserEvent;
   import com.qb9.mambo.user.inventory.Inventory;
   import com.qb9.mambo.user.profile.Profile;
   import com.qb9.mambo.user.profile.UserChatType;
   import com.qb9.mines.mobject.Mobject;
   import flash.events.Event;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   
   public final class GaturroUser extends User implements IPassportProductHolder
   {
      
      private static const INVENTORIES:Array = [GaturroInventory.HOUSE,GaturroInventory.VISUALIZER,GaturroInventory.BAG];
       
      
      private var socialShow:Boolean = false;
      
      private var _club:com.qb9.gaturro.user.GaturroClub;
      
      private var session:Object;
      
      private var _farm:GaturroFarm;
      
      private var inventoriesToLoad:Array;
      
      private var _accountId:String;
      
      private var _cellPhone:CellPhoneDevice;
      
      private var _passwd:String;
      
      private var _passportProduct:PassportProduct;
      
      private var _hasApp:Boolean = false;
      
      private var _community:CommunityManager;
      
      private var lastModifiedNews:Number;
      
      private var _hashSessionId:String;
      
      private var socialEn:Boolean = false;
      
      public function GaturroUser(param1:NetworkManager, param2:Number)
      {
         this.session = {};
         super(param1);
         this.lastModifiedNews = param2;
      }
      
      private function onApiAdded(param1:ContextEvent) : void
      {
         if(param1.instanceType == GaturroRoomAPI)
         {
            this.setAvatarPassportAttrib();
            this.setAvatarAdminAttrib();
            Context.instance.removeEventListener(ContextEvent.ADDED,this.onApiAdded);
         }
      }
      
      public function get bag() : GaturroInventory
      {
         return inventory(GaturroInventory.BAG) as GaturroInventory;
      }
      
      public function set passportProduct(param1:PassportProduct) : void
      {
         this._passportProduct = param1;
      }
      
      public function get socialNetShow() : Boolean
      {
         return this.socialShow;
      }
      
      private function dequeueInventoryLoad(param1:Event = null) : void
      {
         var _loc2_:String = this.inventoriesToLoad.shift();
         if(_loc2_)
         {
            loadInventory(_loc2_);
         }
         else
         {
            dispatch(UserEvent.LOADED);
         }
      }
      
      public function get passport() : Number
      {
         return passportDate;
      }
      
      private function setAvatarAdminAttrib() : void
      {
         if(api.user.isAdmin)
         {
            api.setAvatarAttribute("thehand","true");
         }
      }
      
      public function get allItems() : Array
      {
         var _loc2_:GaturroInventory = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this.inventories)
         {
            _loc1_.push.apply(_loc1_,_loc2_.items);
         }
         return _loc1_;
      }
      
      public function get house() : GaturroInventory
      {
         return inventory(GaturroInventory.HOUSE) as GaturroInventory;
      }
      
      override public function buildFromMobject(param1:Mobject) : void
      {
         super.buildFromMobject(param1);
         this.socialEn = param1.getBoolean("socialEn");
         this.socialShow = param1.getBoolean("socialShow");
         Context.instance.addByType(this,GaturroUser);
         this.loadPassportProduct();
         if(Context.instance.hasByType(GaturroRoomAPI))
         {
            this.setAvatarPassportAttrib();
            this.setAvatarAdminAttrib();
         }
         else
         {
            Context.instance.addEventListener(ContextEvent.ADDED,this.onApiAdded);
         }
      }
      
      override protected function createProfile(param1:Mobject) : Profile
      {
         return new GaturroProfile(this.lastModifiedNews);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this._community.dispose();
         this._community = null;
      }
      
      public function get hasAPP() : Boolean
      {
         return this._hasApp;
      }
      
      public function get accountId() : String
      {
         return this._accountId;
      }
      
      private function setAvatarPassportAttrib() : void
      {
         var _loc1_:String = "none";
         if(this.isCitizen)
         {
            _loc1_ = "normal";
            if(Boolean(api.accomplishById("bocaMember")) || Boolean(api.isVipBoca3Dias()))
            {
               _loc1_ = "boca";
            }
            if(Boolean(api.accomplishById("riverMember")) || Boolean(api.isVipRiver3Dias()))
            {
               _loc1_ = "river";
            }
         }
         api.setAvatarAttribute("passportType",_loc1_);
      }
      
      public function get socialNetEn() : Boolean
      {
         return this.socialEn;
      }
      
      public function get isBlackList() : Boolean
      {
         return profile.chatType === UserChatType.BLACK_LIST;
      }
      
      public function get cellPhone() : CellPhoneDevice
      {
         return this._cellPhone;
      }
      
      public function set passwd(param1:String) : void
      {
         this._passwd = param1;
      }
      
      public function get allItemsGrouped() : Array
      {
         var _loc2_:GaturroInventory = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this.inventories)
         {
            _loc1_.push.apply(_loc1_,_loc2_.itemsGrouped);
         }
         return _loc1_;
      }
      
      override protected function createInventory(param1:Mobject) : Inventory
      {
         var _loc2_:Inventory = new GaturroInventory(net);
         Context.instance.addByType(_loc2_,GaturroInventory);
         return _loc2_;
      }
      
      public function get club() : com.qb9.gaturro.user.GaturroClub
      {
         return this._club;
      }
      
      public function get passwd() : String
      {
         return this._passwd;
      }
      
      public function set hashSessionId(param1:String) : void
      {
         this._hashSessionId = param1;
      }
      
      public function set hasAPP(param1:Boolean) : void
      {
         this._hasApp = param1;
      }
      
      public function loadPassportProduct(param1:Function = null) : void
      {
         var _loc2_:String = null;
         var _loc3_:URLLoader = null;
         var _loc4_:URLRequest = null;
         var _loc5_:AbstractRequestDelegate = null;
         if(this._passportProduct != null)
         {
            param1(this._passportProduct);
            api.setAvatarAttribute("passportType",api.hasPassportType("boca"));
         }
         else
         {
            _loc2_ = String(settings.passportProduct.getProductURL);
            _loc2_ += "&h=" + this.hashSessionId + "&u=" + username;
            _loc3_ = new URLLoader();
            (_loc4_ = new URLRequest(_loc2_)).method = URLRequestMethod.GET;
            _loc5_ = new PassportProductRequestDelegate(this,param1,new EventManager(),_loc3_);
            _loc3_.load(_loc4_);
            logger.debug("=========================== session id: " + this.hashSessionId);
            logger.debug("url COnsultesd: " + _loc2_);
         }
      }
      
      public function set accountId(param1:String) : void
      {
         this._accountId = param1;
      }
      
      public function setSession(param1:String, param2:Object) : void
      {
         this.session[param1] = param2;
      }
      
      override protected function whenUserDataIsLoaded() : void
      {
         addEventListener(UserEvent.INVENTORY_LOADED,this.dequeueInventoryLoad);
         this.inventoriesToLoad = INVENTORIES.concat();
         this.dequeueInventoryLoad();
         this._club = new com.qb9.gaturro.user.GaturroClub();
         this._cellPhone = new CellPhoneDevice();
         this._farm = new GaturroFarm();
         this._community = new CommunityManager();
         this._community.init();
      }
      
      public function getSession(param1:String) : Object
      {
         return this.session[param1];
      }
      
      public function get hashSessionId() : String
      {
         return this._hashSessionId == "" ? "hash" : this._hashSessionId;
      }
      
      private function buildBlockedFromMobject(param1:Mobject) : void
      {
      }
      
      public function get visualizer() : GaturroInventory
      {
         return inventory(GaturroInventory.VISUALIZER) as GaturroInventory;
      }
      
      public function get community() : CommunityManager
      {
         return this._community;
      }
      
      public function get inventories() : Array
      {
         return map(INVENTORIES,inventory);
      }
      
      public function get passportProduct() : PassportProduct
      {
         return this._passportProduct;
      }
      
      public function get lastModified() : Date
      {
         return new Date(this.lastModifiedNews);
      }
   }
}

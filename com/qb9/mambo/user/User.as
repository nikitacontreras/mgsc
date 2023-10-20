package com.qb9.mambo.user
{
   import com.qb9.mambo.core.attributes.CustomAttributes;
   import com.qb9.mambo.core.attributes.events.CustomAttributesEvent;
   import com.qb9.mambo.core.objects.MamboObject;
   import com.qb9.mambo.net.manager.NetworkManager;
   import com.qb9.mambo.net.manager.NetworkManagerEvent;
   import com.qb9.mambo.net.mobject.MobjectBuildable;
   import com.qb9.mambo.net.requests.inventory.InventoryDataRequest;
   import com.qb9.mambo.net.requests.user.AvatarDataRequest;
   import com.qb9.mambo.net.requests.user.UpdateProfileCustomAttributes;
   import com.qb9.mambo.user.buddies.BuddyList;
   import com.qb9.mambo.user.events.UserEvent;
   import com.qb9.mambo.user.inventory.Inventory;
   import com.qb9.mambo.user.profile.Profile;
   import com.qb9.mines.mobject.Mobject;
   
   public class User extends MamboObject implements MobjectBuildable
   {
       
      
      private var inventories:Object;
      
      private var _isAdmin:Boolean;
      
      protected var net:NetworkManager;
      
      protected var passportDate:Number;
      
      private var _buddies:BuddyList;
      
      private var _sceneObjectId:Number;
      
      private var _username:String;
      
      private var _profile:Profile;
      
      private var _id:Number;
      
      private var lockProfileAttributes:Boolean = false;
      
      public function User(param1:NetworkManager)
      {
         this.inventories = {};
         super();
         this.net = param1;
         this.init();
      }
      
      public function get isAdmin() : Boolean
      {
         return this._isAdmin;
      }
      
      protected function createInventory(param1:Mobject) : Inventory
      {
         return new Inventory(this.net);
      }
      
      protected function createProfile(param1:Mobject) : Profile
      {
         return new Profile();
      }
      
      protected function init() : void
      {
         debug("Loading user data");
         this.net.addEventListener(NetworkManagerEvent.CUSTOM_ATTRIBUTES_CHANGED,this.whenProfileCustomAttributesChanged);
         this.net.addEventListener(NetworkManagerEvent.AVATAR_DATA,this.userDataReceived);
         this.net.sendAction(new AvatarDataRequest());
      }
      
      override public function dispatch(param1:String, param2:* = null) : Boolean
      {
         return dispatchEvent(new UserEvent(param1));
      }
      
      protected function userDataReceived(param1:NetworkManagerEvent) : void
      {
         debug("User data received");
         this.net.removeEventListener(NetworkManagerEvent.AVATAR_DATA,this.userDataReceived);
         this.buildFromMobject(param1.mobject);
         this.whenUserDataIsLoaded();
      }
      
      public function get attributes() : CustomAttributes
      {
         return this.profile.attributes;
      }
      
      public function buildFromMobject(param1:Mobject) : void
      {
         this._id = param1.getInteger("id");
         this._username = param1.getString("username");
         this._sceneObjectId = Number(param1.getMobject("sceneObject").getString("id"));
         this._isAdmin = param1.getBoolean("isAdmin");
         this.passportDate = Number(param1.getString("passportDate")) || 0;
         if(this.profile)
         {
            this.profile.dispose();
         }
         this._profile = this.createProfile(param1);
         this.profile.buildFromMobject(param1.getMobject("profile"));
         this.profile.addEventListener(CustomAttributesEvent.CHANGED,this.updateProfileAttributes);
         if(this.buddies)
         {
            this.buddies.dispose();
         }
         this._buddies = new BuddyList(this.net);
         this.buddies.buildFromMobject(param1);
      }
      
      public function inventory(param1:String = null) : Inventory
      {
         param1 ||= Inventory.DEFAULT;
         var _loc2_:Inventory = this.inventories[param1] as Inventory;
         if(!_loc2_)
         {
            warning("No inventory named",param1,"found for",this.username);
         }
         return _loc2_;
      }
      
      public function get isCitizen() : Boolean
      {
         return true;
      }
      
      override public function dispose() : void
      {
         var _loc1_:Inventory = null;
         if(disposed)
         {
            return;
         }
         this.net.removeEventListener(NetworkManagerEvent.CUSTOM_ATTRIBUTES_CHANGED,this.whenProfileCustomAttributesChanged);
         this.net.removeEventListener(NetworkManagerEvent.INVENTORY_DATA,this.userDataReceived);
         this.net.removeEventListener(NetworkManagerEvent.INVENTORY_DATA,this.inventoryDataReceived);
         this.net = null;
         super.dispose();
         if(!this.profile)
         {
            return;
         }
         this.profile.dispose();
         this._profile = null;
         this.buddies.dispose();
         this._buddies = null;
         for each(_loc1_ in this.inventories)
         {
            _loc1_.dispose();
         }
         this.inventories = null;
      }
      
      public function get id() : Number
      {
         return this._id;
      }
      
      public function get buddies() : BuddyList
      {
         return this._buddies;
      }
      
      public function get sceneObjectId() : Number
      {
         return this._sceneObjectId;
      }
      
      public function get profile() : Profile
      {
         return this._profile;
      }
      
      private function whenProfileCustomAttributesChanged(param1:NetworkManagerEvent) : void
      {
         var _loc2_:Mobject = param1.mobject;
         if(_loc2_.getInteger("profileId"))
         {
            this.lockProfileAttributes = true;
            this.profile.attributes.mergeMobject(_loc2_);
            this.lockProfileAttributes = false;
         }
      }
      
      protected function whenUserDataIsLoaded() : void
      {
         this.dispatch(UserEvent.LOADED);
      }
      
      public function loadInventory(param1:String = null) : void
      {
         param1 ||= Inventory.DEFAULT;
         debug("Loading inventory:",param1);
         this.net.addEventListener(NetworkManagerEvent.INVENTORY_DATA,this.inventoryDataReceived);
         this.net.sendAction(new InventoryDataRequest(this.sceneObjectId,param1));
      }
      
      private function updateProfileAttributes(param1:CustomAttributesEvent) : void
      {
         if(!this.lockProfileAttributes)
         {
            this.net.sendAction(new UpdateProfileCustomAttributes(this.profile.id,param1.attributes));
         }
      }
      
      private function inventoryDataReceived(param1:NetworkManagerEvent) : void
      {
         debug("Inventory data received");
         this.net.removeEventListener(NetworkManagerEvent.INVENTORY_DATA,this.inventoryDataReceived);
         var _loc2_:Mobject = param1.mobject;
         var _loc3_:Inventory = this.createInventory(_loc2_);
         _loc3_.buildFromMobject(_loc2_);
         this.inventories[_loc3_.name] = _loc3_;
         this.dispatch(UserEvent.INVENTORY_LOADED);
      }
      
      public function get username() : String
      {
         return this._username;
      }
   }
}

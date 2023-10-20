package com.qb9.gaturro.world.community
{
   import com.qb9.flashlib.utils.ArrayUtil;
   import com.qb9.gaturro.globals.*;
   import com.qb9.gaturro.world.community.service.FriendshipConnection;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.Timer;
   
   public class CommunityManager extends EventDispatcher
   {
      
      public static const BUDDIES_LOADED:String = "BUDDIES_LOADED";
      
      public static const ERROR:String = "ERROR";
      
      public static const CONFIRM_LIST_REWARDS:String = "CONFIRM_LIST_REWARDS";
      
      public static const BUDDIES_BLOCK_LOADED:String = "BUDDIES_BLOCK_LOADED";
      
      public static const CONFIRM_RELATION:String = "CONFIRM_RELATION";
      
      public static const BUDDY_LOADED:String = "BUDDY_LOADED";
       
      
      private var timer:Timer;
      
      private var _currentLoadedBuddiesIndex:int = 0;
      
      private var lastRefreshTime:Number = 4.9e-324;
      
      private var _loadedBuddiesCount:int = 0;
      
      private var _buddies:Array;
      
      private var _buddiesBlock:int = 24;
      
      private var _isLoaded:Boolean = false;
      
      private var _totalBuddiesCount:int = 0;
      
      public function CommunityManager()
      {
         this._buddies = new Array();
         super();
         logger.debug(this,"COMUNIT MANAGER CREATED");
      }
      
      public function dispose() : void
      {
      }
      
      public function resetFriends() : void
      {
         this._currentLoadedBuddiesIndex = 0;
         this._buddies = new Array();
      }
      
      public function hasLoadedAllBudies() : Boolean
      {
         return this._totalBuddiesCount == this._loadedBuddiesCount;
      }
      
      public function get buddiesBlock() : int
      {
         return this._buddiesBlock;
      }
      
      private function get interval() : int
      {
         return settings.services.community.checkInterval;
      }
      
      public function get buddiesQuantity() : int
      {
         return this._totalBuddiesCount;
      }
      
      private function serviceError() : void
      {
         this.dispatchEvent(new Event(CommunityManager.ERROR));
      }
      
      public function init() : void
      {
         this.updateBuddiesBlock(true);
      }
      
      public function destroyRelation(param1:String, param2:int) : void
      {
         if(!settings.services.community || !settings.services.community.enabled)
         {
            return;
         }
         var _loc3_:FriendshipConnection = new FriendshipConnection(this.confirmDestroyRelation,this.serviceError);
         _loc3_.removeFriend(user.username,user.hashSessionId,param1,param2);
      }
      
      public function get isLoaded() : Boolean
      {
         return this._isLoaded;
      }
      
      public function hasLoadedInitialBuddies() : Boolean
      {
         return this._currentLoadedBuddiesIndex != 0;
      }
      
      private function confirmFriendAdded(param1:String, param2:Object) : void
      {
      }
      
      private function confirmRelation(param1:String, param2:Object) : void
      {
         if(param2.success)
         {
            this.dispatchEvent(new Event(CommunityManager.CONFIRM_RELATION));
         }
      }
      
      public function followThisBuddy(param1:String) : Boolean
      {
         var _loc2_:Buddy = null;
         for each(_loc2_ in this._buddies)
         {
            if(_loc2_.username == param1 && _loc2_.relationship == Buddy.FRIEND)
            {
               return true;
            }
         }
         return false;
      }
      
      public function sendFriendRequest(param1:String, param2:int) : void
      {
         if(!settings.services.community || !settings.services.community.enabled)
         {
            return;
         }
         var _loc3_:FriendshipConnection = new FriendshipConnection(this.confirmFriendAdded,this.serviceError);
         _loc3_.sendFriendRequest(user.username,user.hashSessionId,param1,param2);
      }
      
      private function confirmGotFriend(param1:String, param2:Object) : void
      {
         var _loc4_:Buddy = null;
         var _loc3_:int = 0;
         while(_loc3_ < this._buddies.length)
         {
            if((_loc4_ = this._buddies[_loc3_] as Buddy).username.toLowerCase() == String(param2.username).toLowerCase())
            {
               _loc4_.numberOfFriends = param2.numberOfFriends;
            }
            _loc3_++;
         }
         this.dispatchEvent(new Event(CommunityManager.BUDDY_LOADED));
      }
      
      public function get buddies() : Array
      {
         return this._buddies;
      }
      
      private function createBuddiesBlock(param1:String, param2:Object, param3:int, param4:int, param5:int) : void
      {
         var _loc6_:String = null;
         var _loc7_:Object = null;
         var _loc8_:Buddy = null;
         trace(" createBuddiesBlock buddies offset: " + param3 + ", max: " + param4 + ", totalBuddies: " + param5);
         this._currentLoadedBuddiesIndex = param4 + param3;
         this._totalBuddiesCount = param5;
         if(param3 == 0)
         {
            this._buddies = new Array();
         }
         for(_loc6_ in param2)
         {
            _loc7_ = param2[_loc6_];
            (_loc8_ = new Buddy(_loc7_.username,_loc7_.friendId,_loc7_.status.world)).online = _loc7_.status.onLine;
            _loc8_.worldName = _loc7_.status.world;
            _loc8_.setRelationship(_loc7_.type);
            if(_loc8_.relationship != Buddy.NO_RELATIONSHIP)
            {
               this._buddies.push(_loc8_);
            }
         }
         this._loadedBuddiesCount = this._buddies.length;
         this.dispatchEvent(new Event(CommunityManager.BUDDIES_BLOCK_LOADED));
         this._isLoaded = true;
      }
      
      public function get totalBuddiesCount() : int
      {
         return this._totalBuddiesCount;
      }
      
      public function get loadedBuddiesCount() : int
      {
         return this._loadedBuddiesCount;
      }
      
      public function updateBuddiesBlock(param1:Boolean = false) : void
      {
         var _loc2_:FriendshipConnection = new FriendshipConnection(this.createBuddiesBlock,this.serviceError);
         if(param1)
         {
            this._currentLoadedBuddiesIndex = 0;
            this._buddies = new Array();
         }
         _loc2_.getBuddiesBlock(user.username,user.hashSessionId,this._currentLoadedBuddiesIndex,this._buddiesBlock);
      }
      
      private function createBuddies(param1:String, param2:Object, param3:int, param4:int, param5:int) : void
      {
         var _loc6_:String = null;
         var _loc7_:Object = null;
         var _loc8_:Buddy = null;
         this._buddies = new Array();
         for(_loc6_ in param2)
         {
            _loc7_ = param2[_loc6_];
            (_loc8_ = new Buddy(_loc7_.username,_loc7_.friendId,_loc7_.status.world)).online = _loc7_.status.onLine;
            _loc8_.worldName = _loc7_.status.world;
            _loc8_.setRelationship(_loc7_.type);
            if(_loc8_.relationship != Buddy.NO_RELATIONSHIP)
            {
               this._buddies.push(_loc8_);
            }
         }
         this.dispatchEvent(new Event(CommunityManager.BUDDIES_LOADED));
         this._isLoaded = true;
      }
      
      private function confirmDestroyRelation(param1:String, param2:String) : void
      {
         var _loc3_:Buddy = this.getBuddy(param2);
         ArrayUtil.removeElement(this._buddies,_loc3_);
         var _loc4_:Object;
         (_loc4_ = new Object()).success = true;
         this.confirmRelation(param1,_loc4_);
      }
      
      public function getBuddiesList(param1:Boolean = false) : void
      {
         if(!settings.services.community || !settings.services.community.enabled)
         {
            return;
         }
         var _loc2_:Number = new Date().getTime();
         if(param1)
         {
            if(_loc2_ - this.lastRefreshTime < settings.services.community.blockRefreshPeriod)
            {
               return;
            }
         }
         this.lastRefreshTime = _loc2_;
         var _loc3_:FriendshipConnection = new FriendshipConnection(this.createBuddies,this.serviceError);
         _loc3_.getBuddiesWholeList(user.username,user.hashSessionId);
      }
      
      public function getBuddy(param1:String) : Buddy
      {
         var _loc2_:Buddy = null;
         param1 = param1.toLowerCase();
         for each(_loc2_ in this._buddies)
         {
            if(_loc2_.username.toLowerCase() == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function sendGetBuddyRequest(param1:String, param2:int) : void
      {
         if(!settings.services.community || !settings.services.community.enabled)
         {
            return;
         }
         var _loc3_:FriendshipConnection = new FriendshipConnection(this.confirmGotFriend,this.serviceError);
         _loc3_.getFriend(user.username,user.hashSessionId,param1,param2);
      }
   }
}

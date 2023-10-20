package com.qb9.gaturro.world.community
{
   public class Buddy
   {
      
      public static const FRIEND:int = 4;
      
      public static const NO_RELATIONSHIP:int = 1;
       
      
      private var _bestFriend:Boolean = false;
      
      private var _relationship:int = 0;
      
      private var _accountId:int;
      
      private var _online:Boolean = false;
      
      private var _username:String;
      
      private var _numberOfFriends:int = -1;
      
      private var _worldName:String;
      
      public function Buddy(param1:String, param2:int, param3:String)
      {
         super();
         this._username = param1.toUpperCase();
         this._accountId = param2;
         this._worldName = param3;
      }
      
      public function set bestFriend(param1:Boolean) : void
      {
         this._bestFriend = param1;
      }
      
      public function setRelationship(param1:String) : void
      {
         this._bestFriend = false;
         if(param1 == "SUPERFRIEND")
         {
            this._bestFriend = true;
            this._relationship = FRIEND;
         }
         if(param1 == "FRIEND")
         {
            this._relationship = FRIEND;
         }
      }
      
      public function get numberOfFriends() : int
      {
         return this._numberOfFriends;
      }
      
      public function set accountId(param1:int) : void
      {
         this._accountId = param1;
      }
      
      public function get online() : Boolean
      {
         return this._online;
      }
      
      public function get username() : String
      {
         return this._username;
      }
      
      public function get bestFriend() : Boolean
      {
         return this._bestFriend;
      }
      
      public function get offline() : Boolean
      {
         return !this._online;
      }
      
      public function set online(param1:Boolean) : void
      {
         this._online = param1;
      }
      
      public function get isFriend() : Boolean
      {
         return this._relationship == FRIEND;
      }
      
      public function get accountId() : int
      {
         return this._accountId;
      }
      
      public function set relationship(param1:int) : void
      {
         this._relationship = param1;
      }
      
      public function set numberOfFriends(param1:int) : void
      {
         this._numberOfFriends = param1;
      }
      
      public function get relationship() : int
      {
         return this._relationship;
      }
      
      public function set worldName(param1:String) : void
      {
         this._worldName = param1;
      }
      
      public function get worldName() : String
      {
         return this._worldName;
      }
   }
}

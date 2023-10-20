package com.qb9.gaturro.world.minigames
{
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.user.GaturroUser;
   import com.qb9.gaturro.world.core.elements.OwnedNpcRoomSceneObject;
   import com.qb9.mambo.core.attributes.CustomAttributes;
   
   public final class MinigameUserData
   {
       
      
      private var _roomApi:Object;
      
      private var user:GaturroUser;
      
      private var attributes:CustomAttributes;
      
      private var ownedNpc:OwnedNpcRoomSceneObject;
      
      public function MinigameUserData(param1:GaturroUser, param2:CustomAttributes, param3:OwnedNpcRoomSceneObject)
      {
         super();
         this.user = param1;
         this.attributes = param2;
         this.ownedNpc = param3;
         param1.isCitizen;
         this._roomApi = api;
      }
      
      public function setProfileVariable(param1:String, param2:Object) : void
      {
         this.user.profile.attributes[param1] = param2;
      }
      
      public function setVariable(param1:String, param2:Object) : void
      {
         this.user.setSession(param1,param2);
      }
      
      public function getProfileVariable(param1:String) : Object
      {
         return this.user.profile.attributes[param1];
      }
      
      public function getVariable(param1:String) : Object
      {
         return this.user.getSession(param1);
      }
      
      public function get avatarOwnedNpc() : OwnedNpcRoomSceneObject
      {
         return this.ownedNpc;
      }
      
      public function getAvatarVariable(param1:String) : Object
      {
         return this.attributes[param1];
      }
      
      public function get username() : String
      {
         return this.user.username;
      }
      
      public function get isCitizen() : Boolean
      {
         return this.user.isCitizen;
      }
      
      public function get roomApi() : Object
      {
         return this._roomApi;
      }
   }
}

package com.qb9.mambo.user.buddies
{
   import com.qb9.mambo.net.mobject.MobjectBuildable;
   import com.qb9.mines.mobject.Mobject;
   
   public final class Buddy implements MobjectBuildable
   {
       
      
      private var _accountId:int;
      
      private var _blocked:Boolean = false;
      
      private var _online:Boolean = false;
      
      private var _username:String;
      
      public function Buddy(param1:String = null, param2:int = 0)
      {
         super();
         this._username = param1;
         this._accountId = param2;
      }
      
      public function get online() : Boolean
      {
         return this._online;
      }
      
      internal function setStatus(param1:String) : void
      {
         this._online = param1 === "online";
      }
      
      public function get accountId() : int
      {
         return this._accountId;
      }
      
      public function get blocked() : Boolean
      {
         return this._blocked;
      }
      
      public function set accountId(param1:int) : void
      {
         this._accountId = param1;
      }
      
      public function setBlocked(param1:Boolean) : void
      {
         this._blocked = param1;
      }
      
      public function buildFromMobject(param1:Mobject) : void
      {
         this._username = param1.getString("username");
         this._blocked = param1.getBoolean("blocked");
         this.setStatus(param1.getString("status"));
      }
      
      public function get username() : String
      {
         return this._username;
      }
   }
}

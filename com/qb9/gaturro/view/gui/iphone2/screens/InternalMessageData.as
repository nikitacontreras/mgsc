package com.qb9.gaturro.view.gui.iphone2.screens
{
   internal final class InternalMessageData
   {
       
      
      private var _message:Object;
      
      private var _user:String;
      
      private var _friendType:int = -1;
      
      private var _forceWhiteList:Boolean;
      
      public function InternalMessageData(param1:String, param2:Object = null, param3:Boolean = false)
      {
         super();
         this._user = param1;
         this._message = !!param2 ? param2 : "";
         this._forceWhiteList = param3;
      }
      
      public function get message() : Object
      {
         return this._message;
      }
      
      public function get user() : String
      {
         return this._user;
      }
      
      public function get friendType() : int
      {
         return this._friendType;
      }
      
      public function get forceWhiteList() : Boolean
      {
         return this._forceWhiteList;
      }
      
      public function set friendType(param1:int) : void
      {
         this._friendType = param1;
      }
   }
}

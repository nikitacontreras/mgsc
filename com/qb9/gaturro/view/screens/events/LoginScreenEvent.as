package com.qb9.gaturro.view.screens.events
{
   import flash.events.Event;
   
   public final class LoginScreenEvent extends Event
   {
      
      public static const LOGIN:String = "lsLogin";
       
      
      private var _pass:String;
      
      private var _user:String;
      
      public function LoginScreenEvent(param1:String, param2:String, param3:String)
      {
         super(param1,false,true);
         this._user = param2;
         this._pass = param3;
      }
      
      public function get pass() : String
      {
         return this._pass;
      }
      
      public function get user() : String
      {
         return this._user;
      }
      
      override public function clone() : Event
      {
         return new LoginScreenEvent(type,this.user,this.pass);
      }
   }
}

package com.qb9.mines.network.event
{
   import com.qb9.mines.mobject.Mobject;
   import flash.events.Event;
   
   public class MinesEvent extends Event
   {
      
      public static const TIMEOUT:String = "MinesTimeout";
      
      public static const CONNECTION_LOST:String = "MinesLost";
      
      public static const MESSAGE:String = "MinesMessage";
      
      public static const LOGIN:String = "MinesLogin";
      
      public static const CONNECT:String = "MinesConnect";
      
      public static const LOGOUT:String = "MinesLogout";
       
      
      private var _success:Boolean;
      
      private var _errorCode:String;
      
      private var _mobject:Mobject;
      
      public function MinesEvent(param1:String, param2:Boolean, param3:String = null, param4:Mobject = null)
      {
         super(param1);
         this._success = param2;
         this._errorCode = param3;
         this._mobject = param4;
      }
      
      public function get success() : Boolean
      {
         return this._success;
      }
      
      public function get errorCode() : String
      {
         return this._errorCode;
      }
      
      public function get mobject() : Mobject
      {
         return this._mobject;
      }
   }
}

package com.qb9.gaturro.net.secure
{
   import flash.events.Event;
   
   public class SecureResponseErrorEvent extends Event
   {
      
      public static const ERROR:String = "response_error";
       
      
      private var _errorCode:int;
      
      private var _errorMessage:String;
      
      public function SecureResponseErrorEvent(param1:String, param2:String, param3:int = 0, param4:Boolean = false, param5:Boolean = false)
      {
         super(param1,param4,param5);
         this._errorMessage = param2;
         this._errorCode = param3;
      }
      
      override public function toString() : String
      {
         return formatToString("SecureResponseErrorEvent","type","bubbles","cancelable","eventPhase");
      }
      
      public function get errorCode() : int
      {
         return this._errorCode;
      }
      
      override public function clone() : Event
      {
         return new SecureResponseErrorEvent(type,this.errorMessage,this.errorCode,bubbles,cancelable);
      }
      
      public function get errorMessage() : String
      {
         return this._errorMessage;
      }
   }
}

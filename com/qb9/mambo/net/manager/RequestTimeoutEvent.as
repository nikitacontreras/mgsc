package com.qb9.mambo.net.manager
{
   import com.qb9.mines.mobject.Mobject;
   import flash.events.Event;
   
   public class RequestTimeoutEvent extends Event
   {
      
      public static const TIMEOUT:String = "RequestTimeout";
       
      
      private var _mo:Mobject;
      
      private var _requestType:String;
      
      public function RequestTimeoutEvent(param1:String, param2:String, param3:Mobject)
      {
         super(param1,false,true);
         this._requestType = param2;
         this._mo = param3;
      }
      
      public function get mobject() : Mobject
      {
         return this._mo;
      }
      
      override public function clone() : Event
      {
         return new RequestTimeoutEvent(type,this._requestType,this._mo);
      }
      
      public function get request() : String
      {
         return this._requestType;
      }
   }
}

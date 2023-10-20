package com.qb9.gaturro.net.secure
{
   import flash.events.Event;
   
   public class SecureResponseEvent extends Event
   {
      
      public static const SERVICE_COMPLETE:String = "service_complete";
      
      public static const API_MESSAGE_DELETE:String = "api_message_delete";
      
      public static const API_MESSAGE_WHITELIST:String = "api_message_whitelist";
      
      public static const API_MESSAGE_MARK_READ:String = "api_message_mark_read";
      
      public static const API_MESSAGE_GET_NEWEST:String = "api_message_get_newest";
      
      public static const PUT_IMAGE_COMPLETE:String = "put_image_complete";
      
      public static const PREPROCESS_COMPLETE:String = "preprocess_complete";
      
      public static const API_MESSAGE_GET:String = "api_message_get";
      
      public static const API_MESSAGE_CHECK:String = "api_message_check";
      
      public static const API_MESSAGE_NEW_CODED:String = "api_message_new_coded";
       
      
      private var _response:Object;
      
      public function SecureResponseEvent(param1:String, param2:Object, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this._response = param2;
      }
      
      public function get response() : Object
      {
         return this._response;
      }
      
      override public function toString() : String
      {
         return formatToString("SecureResponseEvent","type","bubbles","cancelable","eventPhase");
      }
      
      override public function clone() : Event
      {
         return new SecureResponseEvent(type,this.response,bubbles,cancelable);
      }
   }
}

package com.qb9.gaturro.net.security.files
{
   import com.qb9.gaturro.util.errors.FileControlFailure;
   import flash.events.Event;
   
   public final class FileControlEvent extends Event
   {
      
      public static const CONTROL_FAILED:String = "securityFileControlFailed";
       
      
      public var dataObject:FileControlFailure;
      
      public function FileControlEvent(param1:String, param2:FileControlFailure)
      {
         super(param1);
         this.dataObject = param2;
      }
      
      override public function clone() : Event
      {
         return new FileControlEvent(type,this.dataObject);
      }
   }
}

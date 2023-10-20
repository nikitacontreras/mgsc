package com.gameanalytics
{
   import flash.events.Event;
   
   public class GALogEvent extends Event
   {
      
      public static const LOG:String = "GA_LOG_EVENT";
       
      
      public var text:String;
      
      public function GALogEvent(param1:String, param2:String, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this.text = param2;
      }
      
      override public function clone() : Event
      {
         return new GALogEvent(type,this.text,bubbles,cancelable);
      }
   }
}

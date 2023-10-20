package com.qb9.gaturro.view.world.alert
{
   import flash.events.Event;
   
   public final class AlertEvent extends Event
   {
      
      public static const BAD:String = "aeBadAlert";
      
      public static const GOOD:String = "aeGoodAlert";
       
      
      private var _text:String;
      
      public function AlertEvent(param1:String, param2:String)
      {
         super(param1,true);
         this._text = param2;
      }
      
      public function get text() : String
      {
         return this._text;
      }
      
      override public function clone() : Event
      {
         return new AlertEvent(type,this.text);
      }
   }
}

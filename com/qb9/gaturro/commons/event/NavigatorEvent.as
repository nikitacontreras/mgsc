package com.qb9.gaturro.commons.event
{
   import flash.events.Event;
   
   public class NavigatorEvent extends Event
   {
      
      public static const NAVIGATION_CHANGED:String = "navigationChanged";
       
      
      private var _current;
      
      public function NavigatorEvent(param1:String, param2:*)
      {
         super(param1);
         this._current = param2;
      }
      
      public function get current() : *
      {
         return this._current;
      }
      
      override public function toString() : String
      {
         return formatToString("NavigatorEvent","type","current");
      }
      
      override public function clone() : Event
      {
         return new NavigatorEvent(type,this.current);
      }
   }
}

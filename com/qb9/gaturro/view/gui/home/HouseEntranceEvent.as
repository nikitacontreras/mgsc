package com.qb9.gaturro.view.gui.home
{
   import flash.events.Event;
   
   public final class HouseEntranceEvent extends Event
   {
      
      public static const ACTIVATE:String = "heeActivate";
       
      
      public function HouseEntranceEvent(param1:String)
      {
         super(param1,true);
      }
      
      override public function clone() : Event
      {
         return new HouseEntranceEvent(type);
      }
   }
}

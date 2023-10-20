package com.qb9.gaturro.commons.event
{
   import flash.events.Event;
   
   public class QuestSystemEvent extends Event
   {
      
      public static const MODEL_READY:String = "modelReady";
       
      
      public function QuestSystemEvent(param1:String)
      {
         super(param1);
      }
      
      override public function toString() : String
      {
         return formatToString("QuestSystemEvent","type");
      }
      
      override public function clone() : Event
      {
         return new QuestSystemEvent(type);
      }
   }
}

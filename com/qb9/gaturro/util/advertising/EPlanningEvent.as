package com.qb9.gaturro.util.advertising
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   
   public class EPlanningEvent extends Event
   {
      
      public static const CONTENT_LOADED:String = "EPLANNING_CONTENT_LOADED";
       
      
      private var displayObject:DisplayObject;
      
      public function EPlanningEvent(param1:String, param2:DisplayObject)
      {
         super(param1);
         this.displayObject = param2;
      }
      
      public function get content() : DisplayObject
      {
         return this.displayObject;
      }
   }
}

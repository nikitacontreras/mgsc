package com.qb9.mambo.net.library
{
   import flash.events.Event;
   
   public final class LibraryEvent extends Event
   {
      
      public static const LOADED:String = "libraryLoaded";
      
      public static const LOAD_FAILED:String = "libraryLoadFailed";
       
      
      public function LibraryEvent(param1:String)
      {
         super(param1);
      }
      
      override public function clone() : Event
      {
         return new LibraryEvent(type);
      }
   }
}

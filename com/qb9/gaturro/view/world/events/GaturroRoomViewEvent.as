package com.qb9.gaturro.view.world.events
{
   import flash.events.Event;
   
   public final class GaturroRoomViewEvent extends Event
   {
      
      public static const OBJECT_CLICKED:String = "grveObjectClicked";
      
      public static const ASSET_ADDED_COMPLETE:String = "assetAddedComplete";
       
      
      public function GaturroRoomViewEvent(param1:String)
      {
         super(param1,false,true);
      }
      
      override public function clone() : Event
      {
         return new GaturroRoomViewEvent(type);
      }
   }
}

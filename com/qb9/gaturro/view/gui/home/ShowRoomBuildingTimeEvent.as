package com.qb9.gaturro.view.gui.home
{
   import flash.events.Event;
   
   public class ShowRoomBuildingTimeEvent extends Event
   {
      
      public static const SHOW:String = "showRoomBuildingTimePopup";
       
      
      private var _time:int = 0;
      
      public function ShowRoomBuildingTimeEvent(param1:String, param2:int)
      {
         super(param1);
         this._time = param2;
      }
      
      public function get time() : int
      {
         return this._time;
      }
      
      override public function clone() : Event
      {
         return new ShowRoomBuildingTimeEvent(type,this._time);
      }
   }
}

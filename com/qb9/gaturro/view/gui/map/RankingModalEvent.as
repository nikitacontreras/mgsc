package com.qb9.gaturro.view.gui.map
{
   import flash.events.Event;
   
   public final class RankingModalEvent extends Event
   {
      
      public static const OPEN:String = "rankingOpenBanner";
       
      
      private var _gameName:String;
      
      public function RankingModalEvent(param1:String, param2:String)
      {
         super(param1,true);
         this._gameName = param2;
      }
      
      public function get gameName() : String
      {
         return this._gameName;
      }
      
      override public function clone() : Event
      {
         return new RankingModalEvent(type,this._gameName);
      }
   }
}

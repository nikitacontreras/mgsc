package com.qb9.gaturro.service.events
{
   import flash.errors.IllegalOperationError;
   
   public class EventsAttributeEnum
   {
      
      public static const ELITE_PARTY:String = "elite";
      
      public static const WEDDING_PARTY:String = "wedding";
      
      public static const BIRTHDAY_PARTY:String = "birthday";
      
      public static const TYPE:String = "t";
      
      public static const SERETUBERS:String = "seretubers";
      
      public static const GATUBERS_LIVE:String = "gatubersLive";
      
      public static const EVENT_ATTR:String = "party";
      
      public static const CARNAVAL_PARTY:String = "carnaval";
      
      public static const DURATION:String = "d";
      
      public static const MATEADA_PARTY:String = "mate";
      
      public static const TORNEO_BOCA:String = "torneoBoca";
      
      public static const PARTY_TYPES:Array = [WEDDING_PARTY,BIRTHDAY_PARTY];
      
      public static const HOST:String = "h";
      
      public static const PUBLIC:String = "p";
      
      public static const START_TIME:String = "st";
      
      public static const PARTY_LIMIT_ATTR:String = "partyLimit";
      
      public static const FEATURES:String = "f";
      
      public static const ROOM_ID:String = "rID";
       
      
      public function EventsAttributeEnum()
      {
         super();
         throw new IllegalOperationError("This class haven\'t be instatiated");
      }
   }
}

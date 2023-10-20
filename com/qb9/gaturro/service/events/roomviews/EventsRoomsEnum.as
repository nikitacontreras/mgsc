package com.qb9.gaturro.service.events.roomviews
{
   import com.qb9.gaturro.service.events.EventsAttributeEnum;
   
   public class EventsRoomsEnum
   {
      
      public static const CARNAVAL:Array = [51689577];
      
      public static const SERETUBERS_1:Array = [51689788];
      
      public static const SERETUBERS_ENTRANCE:Number = 51689785;
      
      private static var birthdayPartyRooms:Array = [51688765,51688766,51688767,51688768];
      
      public static const GATUBERS_1:Array = [51689049,51689098];
      
      public static const GATUBERS_2:Array = [51689062,51689101];
      
      public static const GATUBERS_3:Array = [51689063,51689103];
      
      public static const GATUBERS_4:Array = [51689064,51689105];
      
      public static const GATUBERS_ROOMS:Array = [GATUBERS_1,GATUBERS_2,GATUBERS_3,GATUBERS_4];
      
      public static const MATEADA:Array = [51690043,51690044];
      
      public static const GATUBERS_ENTRANCE:Number = 51689089;
      
      private static var elitePartyRooms:Array = [51689266,51689575,51689576];
      
      private static var weddingPartyRooms:Array = [51688784,51688820,51688821,51688822];
      
      public static const SERETUBERS_2:Array = [51689787];
      
      public static const SERETUBERS_3:Array = [51689786];
      
      public static const SERETUBERS_4:Array = [72846];
      
      public static const SERETUBERS_ROOMS:Array = [SERETUBERS_1,SERETUBERS_2,SERETUBERS_3,SERETUBERS_4];
       
      
      public function EventsRoomsEnum()
      {
         super();
         throw new Error("can\'t instantite mf !");
      }
      
      public static function getPartyRoom(param1:String) : Number
      {
         switch(param1)
         {
            case EventsAttributeEnum.BIRTHDAY_PARTY:
               return birthdayPartyRooms[Math.floor(Math.random() * birthdayPartyRooms.length)];
            case EventsAttributeEnum.WEDDING_PARTY:
               return weddingPartyRooms[Math.floor(Math.random() * weddingPartyRooms.length)];
            case EventsAttributeEnum.ELITE_PARTY:
               return elitePartyRooms[Math.floor(Math.random() * elitePartyRooms.length)];
            case EventsAttributeEnum.CARNAVAL_PARTY:
               return CARNAVAL[0];
            case EventsAttributeEnum.MATEADA_PARTY:
               return MATEADA[0];
            case EventsAttributeEnum.SERETUBERS:
               return SERETUBERS_1[0];
            default:
               return 0;
         }
      }
      
      public static function getGatubersType(param1:Number) : int
      {
         var _loc2_:Array = null;
         for each(_loc2_ in EventsRoomsEnum.GATUBERS_ROOMS)
         {
            if(_loc2_.indexOf(param1) != -1)
            {
               return EventsRoomsEnum.GATUBERS_ROOMS.indexOf(_loc2_);
            }
         }
         return 0;
      }
   }
}

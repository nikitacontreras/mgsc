package com.qb9.gaturro.manager.music.enum
{
   import flash.utils.Dictionary;
   
   public class MusicRhythmicEnum
   {
      
      public static const DELAY:int = 120;
      
      public static const TOTAL:int = 208;
      
      public static const CORCHEA:int = 2;
      
      public static const KICK_IF_DONT_PLAY_PENALTY_TIME:int = 10000;
      
      public static const REDONDA:int = 16;
      
      public static const THREE_TWO_ONE_GO:int = 90;
      
      public static const SEMICORCHEA:int = 1;
      
      public static const BLANCA:int = 8;
      
      private static var _map:Dictionary;
      
      public static const NEGRA:int = 4;
       
      
      public function MusicRhythmicEnum()
      {
         super();
         throw new Error("This class shouldn\'t be instantiated");
      }
      
      public static function get map() : Dictionary
      {
         if(!_map)
         {
            MusicRhythmicEnum.setupMap();
         }
         return _map;
      }
      
      private static function setupMap() : void
      {
         _map = new Dictionary();
         _map[REDONDA] = REDONDA;
         _map[BLANCA] = BLANCA;
         _map[NEGRA] = NEGRA;
         _map[CORCHEA] = CORCHEA;
         _map[SEMICORCHEA] = SEMICORCHEA;
      }
   }
}

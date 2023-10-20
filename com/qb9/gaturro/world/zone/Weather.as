package com.qb9.gaturro.world.zone
{
   import com.qb9.gaturro.globals.server;
   import com.qb9.gaturro.util.SeedRandom;
   
   public class Weather
   {
      
      private static const RAINY_LABEL:String = "rainy";
      
      private static const SUNNY_LABEL:String = "sunny";
      
      private static const NIGHT_LABEL:String = "night";
       
      
      public function Weather()
      {
         super();
      }
      
      private static function rnd(param1:Number) : Number
      {
         var _loc2_:SeedRandom = new SeedRandom(param1);
         var _loc3_:int = 0;
         while(_loc3_ < 15)
         {
            _loc2_.random();
            _loc3_++;
         }
         return _loc2_.random();
      }
      
      public static function get state() : String
      {
         var _loc1_:Timezone = new Timezone();
         if(_loc1_.isNight)
         {
            return NIGHT_LABEL;
         }
         var _loc2_:Date = new Date(server.time);
         var _loc3_:String = _loc2_.getUTCFullYear().toString();
         var _loc4_:String = (_loc4_ = (_loc2_.getUTCMonth() + 1).toString()).length == 1 ? "0" + _loc4_ : _loc4_;
         var _loc5_:String = (_loc5_ = _loc2_.getUTCDate().toString()).length == 1 ? "0" + _loc5_ : _loc5_;
         return Weather.stateByDate(Number(_loc3_ + _loc4_ + _loc5_));
      }
      
      public static function get isCharcoActive() : Boolean
      {
         return state == RAINY_LABEL;
      }
      
      private static function stateByDate(param1:Number) : String
      {
         var _loc2_:Number = rnd(param1);
         return stateName(_loc2_);
      }
      
      private static function stateName(param1:Number) : String
      {
         if(param1 <= 0.32)
         {
            return RAINY_LABEL;
         }
         return SUNNY_LABEL;
      }
   }
}

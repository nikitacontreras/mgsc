package com.qb9.gaturro.util.flights
{
   import com.qb9.gaturro.globals.api;
   
   public class FlightInjectorManager
   {
       
      
      private var _partidas:Array;
      
      public function FlightInjectorManager()
      {
         super();
      }
      
      public function get partidas() : Array
      {
         return this._partidas;
      }
      
      private function orderByFlightTime() : void
      {
         this._partidas = this._partidas.sortOn(["day","time"]);
      }
      
      private function getDestinationName(param1:int) : String
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         for each(_loc3_ in api.config.vuelos.destinos)
         {
            if(_loc3_.id == param1)
            {
               _loc2_ = String(_loc3_.name);
            }
         }
         return _loc2_;
      }
      
      private function addTravels(param1:Array, param2:Object) : void
      {
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc3_:int = 1;
         while(_loc3_ < 31)
         {
            _loc5_ = 0;
            while(_loc5_ < 24)
            {
               _loc6_ = 0;
               while(_loc6_ < 59)
               {
                  _loc7_ = this.calculateTime(_loc5_,_loc6_);
                  param1.push({
                     "id":param2.id,
                     "day":_loc3_,
                     "month":0,
                     "time":_loc7_,
                     "name":this.getDestinationName(param2.id)
                  });
                  _loc6_ += param2.frequencyMinutes;
               }
               _loc5_++;
            }
            _loc3_++;
         }
         for each(_loc4_ in api.config.vuelos.partidas)
         {
            param1.push({
               "id":_loc4_.id,
               "day":_loc4_.day,
               "month":0,
               "time":_loc4_.time,
               "name":this.getDestinationName(_loc4_.id)
            });
         }
      }
      
      private function calculateTime(param1:int, param2:int) : String
      {
         var _loc3_:* = null;
         if(param1 < 10)
         {
            _loc3_ = "0" + param1 + ":";
         }
         else
         {
            _loc3_ = param1 + ":";
         }
         if(param2 < 10)
         {
            _loc3_ += "0" + param2;
         }
         else
         {
            _loc3_ += param2;
         }
         return _loc3_;
      }
      
      public function injectTravel() : Array
      {
         this._partidas = [];
         var _loc1_:Array = api.config.vuelos.increaseFrequencyIDs as Array;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            this.addTravels(this._partidas,_loc1_[_loc2_]);
            _loc2_++;
         }
         this.orderByFlightTime();
         return this._partidas;
      }
   }
}

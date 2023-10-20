package com.qb9.gaturro.model.deserializer
{
   import com.qb9.gaturro.commons.model.deserializer.IDeserializer;
   import com.qb9.gaturro.model.config.cinema.CinemaMovieDefinition;
   import flash.utils.Dictionary;
   
   public class CinemaDeserializer implements IDeserializer
   {
      
      private static const IMAGE_TYPE:String = "image";
      
      public static const GATE_PREFIX:String = "gate";
      
      private static const APPLICATION_TYPE:String = "application";
      
      public static const LABEL_TAG:String = "label";
      
      public static const COUNTRY_PREFIX:String = "c_";
      
      private static const VIDEO_TYPE:String = "video/x-flv";
       
      
      public function CinemaDeserializer()
      {
         super();
      }
      
      private function getGate(param1:Object) : String
      {
         var _loc2_:String = null;
         for each(_loc2_ in param1.tags as Array)
         {
            if(_loc2_.indexOf(GATE_PREFIX) > -1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      private function cleanCountryKey(param1:String) : String
      {
         return param1.indexOf("-") > -1 ? param1.substr(1) : param1;
      }
      
      private function deserializeImage(param1:CinemaMovieDefinition, param2:Object) : void
      {
         param1.thumnail = param2.path;
      }
      
      private function deserializeVideo(param1:CinemaMovieDefinition, param2:Object) : void
      {
         param1.url = param2.path;
         param1.title = param2.title;
         param1.hasLabel = param2.tags.toString().indexOf(LABEL_TAG) > -1;
         param1.gate = this.getGate(param2);
         param1.countries = this.getCountries(param2);
      }
      
      private function getCountries(param1:Object) : Dictionary
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc2_:Dictionary = new Dictionary();
         for each(_loc5_ in param1.tags as Array)
         {
            if(_loc5_.indexOf(COUNTRY_PREFIX) > -1)
            {
               _loc3_ = _loc5_.substr(COUNTRY_PREFIX.length).toUpperCase();
               _loc4_ = this.cleanCountryKey(_loc3_);
               _loc2_[_loc4_] = _loc3_;
            }
         }
         return _loc2_;
      }
      
      public function deserialize(param1:Object, param2:CinemaMovieDefinition = null, param3:String = "") : CinemaMovieDefinition
      {
         if(!param2)
         {
            param2 = new CinemaMovieDefinition();
            param2.id = param3;
         }
         if(String(param1.type).indexOf(VIDEO_TYPE) > -1 || String(param1.type).indexOf(APPLICATION_TYPE) > -1)
         {
            this.deserializeVideo(param2,param1);
         }
         else if(String(param1.type).indexOf(IMAGE_TYPE) > -1)
         {
            this.deserializeImage(param2,param1);
         }
         return param2;
      }
   }
}

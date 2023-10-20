package com.qb9.gaturro.model.config.cinema
{
   import com.qb9.gaturro.commons.iterator.IIterator;
   import com.qb9.gaturro.commons.iterator.Iterator;
   import com.qb9.gaturro.commons.model.config.IConfigSettings;
   import com.qb9.gaturro.globals.logger;
   import flash.utils.Dictionary;
   
   public class CinemaConfig implements IConfigSettings
   {
      
      public static const THIRD_DOOR_TAG:String = "thirdDoor";
      
      public static const FIFITH_DOOR_TAG:String = "fifthDoor";
      
      public static const SECOND_DOOR_TAG:String = "secondDoor";
      
      public static const FOURTH_DOOR_TAG:String = "fourthDoor";
      
      public static const FISRT_DOOR_TAG:String = "firstDoor";
      
      public static const VIDEO_TAG:String = "videao";
       
      
      private var listByGate:Dictionary;
      
      private var _settings:Object;
      
      private var listDefinition:Dictionary;
      
      public function CinemaConfig()
      {
         super();
         this.listDefinition = new Dictionary();
         this.listByGate = new Dictionary();
      }
      
      public function getDefinitionByGate(param1:String) : CinemaMovieDefinition
      {
         var _loc2_:CinemaMovieDefinition = this.listByGate[param1];
         if(!_loc2_)
         {
            logger.debug("Theres non existe a definition with ID = [ " + param1 + "]");
            throw new Error("Theres non existe a definition with ID = [ " + param1 + "]");
         }
         return _loc2_;
      }
      
      public function hasDefinition(param1:String) : Boolean
      {
         return this.listDefinition[param1];
      }
      
      public function hasDefinitionByGate(param1:String) : Boolean
      {
         return this.listByGate[param1];
      }
      
      public function getDefinition(param1:String) : Object
      {
         return this.getCinemaDefinition(param1);
      }
      
      public function addDefinition(param1:CinemaMovieDefinition) : void
      {
         this.listDefinition[param1.id] = param1;
         this.listByGate[param1.gate] = param1;
      }
      
      public function set settings(param1:Object) : void
      {
         this._settings = param1;
      }
      
      public function getCinemaDefinition(param1:String) : CinemaMovieDefinition
      {
         var _loc2_:CinemaMovieDefinition = this.listDefinition[param1];
         if(!_loc2_)
         {
            logger.debug("Theres non existe a definition with ID = [ " + param1 + "]");
            throw new Error("Theres non existe a definition with ID = [ " + param1 + "]");
         }
         return _loc2_;
      }
      
      public function getIterator() : IIterator
      {
         var _loc1_:Iterator = new Iterator();
         _loc1_.setupIterable(this.listDefinition);
         return _loc1_;
      }
   }
}

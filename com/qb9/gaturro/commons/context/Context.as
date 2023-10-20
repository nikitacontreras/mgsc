package com.qb9.gaturro.commons.context
{
   import com.qb9.gaturro.commons.event.ContextEvent;
   import com.qb9.gaturro.globals.logger;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   
   public class Context extends EventDispatcher
   {
      
      private static var _instance:com.qb9.gaturro.commons.context.Context;
       
      
      private var map:Dictionary;
      
      public function Context()
      {
         super();
         _instance = this;
         this.setup();
      }
      
      public static function get instance() : com.qb9.gaturro.commons.context.Context
      {
         if(_instance)
         {
         }
         return _instance;
      }
      
      public function add(param1:Object, param2:Class, param3:String) : void
      {
         var _loc4_:Dictionary = null;
         if(!(param1 is param2))
         {
            logger.debug("The instance supplied missmatch with the type supplied");
            throw new TypeError("The instance supplied missmatch with the type supplied");
         }
         if(!this.map[param2])
         {
            this.map[param2] = new Dictionary();
         }
         (_loc4_ = this.map[param2])[param3] = param1;
         dispatchEvent(new ContextEvent(ContextEvent.ADDED,param1,param2,param3));
      }
      
      public function addByType(param1:Object, param2:Class) : void
      {
         if(!(param1 is param2))
         {
            logger.debug("The instance supplied missmatch with the type supplied");
            throw new TypeError("The instance supplied missmatch with the type supplied");
         }
         this.map[param2] = param1;
         dispatchEvent(new ContextEvent(ContextEvent.ADDED,param1,param2));
      }
      
      public function hasByID(param1:Class, param2:String) : Boolean
      {
         if(!this.map[param1])
         {
            logger.debug("Couldn\'t find stored instance of type = [" + param1 + "]");
            throw new Error("Couldn\'t find stored instance of type = [" + param1 + "]");
         }
         var _loc3_:Dictionary = this.map[param1];
         var _loc4_:Object;
         if(!(_loc4_ = _loc3_[param2]))
         {
            logger.debug("Couldn\'t find stored instance with ID = [" + param2 + "] and type = [" + param1 + "]");
            throw new Error("Couldn\'t find stored instance with ID = [" + param2 + "] and type = [" + param1 + "]");
         }
         return _loc4_ != null;
      }
      
      public function removeByType(param1:Class) : void
      {
         delete this.map[param1];
      }
      
      public function removeByID(param1:Class, param2:String) : void
      {
         if(!this.map[param1])
         {
            logger.debug("Couldn\'t find stored instance of type = [" + param1 + "]");
            throw new Error("Couldn\'t find stored instance of type = [" + param1 + "]");
         }
         var _loc3_:Dictionary = this.map[param1];
         _loc3_[param2];
         if(!_loc3_[param2])
         {
            logger.debug("Couldn\'t find stored instance with ID = [" + param2 + "] and type = [" + param1 + "]");
            throw new Error("Couldn\'t find stored instance with ID = [" + param2 + "] and type = [" + param1 + "]");
         }
         delete _loc3_[param2];
      }
      
      public function getByType(param1:Class) : Object
      {
         return this.map[param1];
      }
      
      public function hasByType(param1:Class) : Boolean
      {
         var _loc2_:Object = this.map[param1];
         return _loc2_ != null;
      }
      
      private function setup() : void
      {
         this.map = new Dictionary();
      }
      
      public function getByID(param1:Class, param2:String) : Object
      {
         if(!this.map[param1])
         {
            logger.debug("Couldn\'t find stored instance of type = [" + param1 + "]");
            throw new Error("Couldn\'t find stored instance of type = [" + param1 + "]");
         }
         var _loc3_:Dictionary = this.map[param1];
         var _loc4_:Object;
         if(!(_loc4_ = _loc3_[param2]))
         {
            logger.debug("Couldn\'t find stored instance with ID = [" + param2 + "] and type = [" + param1 + "]");
            throw new Error("Couldn\'t find stored instance with ID = [" + param2 + "] and type = [" + param1 + "]");
         }
         return _loc4_;
      }
   }
}

package com.qb9.gaturro.preloading.task.cinema
{
   import com.qb9.gaturro.commons.preloading.task.base.LoadingTask;
   import com.qb9.gaturro.model.config.cinema.CinemaConfig;
   import com.qb9.gaturro.model.config.cinema.CinemaMovieDefinition;
   import com.qb9.gaturro.model.deserializer.CinemaDeserializer;
   import flash.utils.getDefinitionByName;
   
   public class CinemaDeserializerTask extends LoadingTask
   {
      
      private static const ID_PREFIX:String = "id_";
       
      
      private var settings:Object;
      
      private var config:CinemaConfig;
      
      private var deserializerClassName:String;
      
      private var deserializer:CinemaDeserializer;
      
      public function CinemaDeserializerTask()
      {
         super();
      }
      
      override public function start() : void
      {
         super.start();
         this.instantiateDeserializer();
         this.deserialize();
         taskComplete();
      }
      
      override public function set data(param1:Object) : void
      {
         this.deserializerClassName = param1.deserializerClassName;
      }
      
      private function getKey(param1:Object) : String
      {
         var _loc2_:String = null;
         for each(_loc2_ in param1.tags as Array)
         {
            if(_loc2_.indexOf(ID_PREFIX) > -1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      private function instantiateDeserializer() : void
      {
         var _loc1_:Class = getDefinitionByName(this.deserializerClassName) as Class;
         this.deserializer = new _loc1_();
      }
      
      protected function deserialize() : void
      {
         var _loc1_:CinemaMovieDefinition = null;
         var _loc2_:Boolean = false;
         var _loc3_:String = null;
         var _loc4_:Object = null;
         this.settings = _sharedRespository.settings;
         this.config = _sharedRespository.config;
         for each(_loc4_ in this.settings)
         {
            _loc3_ = this.getKey(_loc4_);
            _loc2_ = this.config.hasDefinition(_loc3_);
            _loc1_ = _loc2_ ? this.config.getCinemaDefinition(_loc3_) : null;
            _loc1_ = this.deserializer.deserialize(_loc4_,_loc1_,_loc3_);
            if(!_loc2_)
            {
               this.config.addDefinition(_loc1_);
            }
         }
      }
   }
}

package com.qb9.gaturro.commons.preloading.task.setting
{
   import com.qb9.flashlib.config.Settings;
   import com.qb9.gaturro.commons.model.config.IConfigDefinition;
   import com.qb9.gaturro.commons.model.definition.IDefinition;
   import com.qb9.gaturro.commons.model.deserializer.IObjectDeserilizer;
   import com.qb9.gaturro.commons.preloading.task.base.LoadingTask;
   import flash.utils.getDefinitionByName;
   
   public class DeserializeSettingTask extends LoadingTask
   {
       
      
      private var settings:Settings;
      
      protected var config:IConfigDefinition;
      
      protected var deserializerClassName:String;
      
      protected var deserializer:IObjectDeserilizer;
      
      public function DeserializeSettingTask()
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
      
      private function instantiateDeserializer() : void
      {
         var _loc1_:Class = getDefinitionByName(this.deserializerClassName) as Class;
         this.deserializer = new _loc1_();
      }
      
      protected function deserialize() : void
      {
         var _loc1_:Object = null;
         var _loc2_:IDefinition = null;
         var _loc4_:String = null;
         this.settings = _sharedRespository.settings;
         this.config = _sharedRespository.config;
         var _loc3_:int = 0;
         for(_loc4_ in this.settings.definition)
         {
            trace("DeserializeSettingTask > deserialize > key = [" + _loc4_ + "] i = " + _loc3_);
            _loc1_ = this.settings.definition[_loc4_];
            _loc2_ = this.deserializer.deserialize(_loc1_,_loc4_);
            this.config.addDefinition(_loc2_,_loc4_);
            _loc3_++;
         }
      }
   }
}

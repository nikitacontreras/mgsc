package com.qb9.gaturro.manager.team
{
   import com.qb9.gaturro.commons.iterator.IIterator;
   import com.qb9.gaturro.commons.iterator.Iterator;
   import com.qb9.gaturro.commons.model.config.BaseSettingsConfig;
   import com.qb9.gaturro.globals.logger;
   import flash.utils.Dictionary;
   
   public class TeamConfig extends BaseSettingsConfig
   {
       
      
      private var featureMap:Dictionary;
      
      private var nameMap:Dictionary;
      
      public function TeamConfig()
      {
         super();
      }
      
      private function addToFeature(param1:TeamDefinition) : void
      {
         var _loc2_:TeamFeatureDefinition = null;
         var _loc3_:String = null;
         for each(_loc3_ in param1.featureList)
         {
            _loc2_ = this.featureMap[_loc3_];
            _loc2_.addTeam(param1);
         }
      }
      
      public function getTeamFeature(param1:String) : TeamFeatureDefinition
      {
         return this.featureMap[param1];
      }
      
      public function getTeamDefinitionList(param1:String) : IIterator
      {
         if(!this.featureMap[param1])
         {
            logger.debug("The feature: [" + param1 + "] is not configured");
            throw new Error("The feature: [" + param1 + "] is not configured");
         }
         var _loc2_:TeamFeatureDefinition = this.featureMap[param1];
         return _loc2_.getTeamList();
      }
      
      public function belongsToFeature(param1:String, param2:String) : Boolean
      {
         if(!this.featureMap[param1])
         {
            logger.debug("The feature: [" + param1 + "] is not configured");
            throw new Error("The feature: [" + param1 + "] is not configured");
         }
         var _loc3_:TeamDefinition = this.nameMap[param2];
         return _loc3_.belongsToFeature(param1);
      }
      
      public function getListAllURL() : String
      {
         return this.getURL("listAllURL");
      }
      
      public function getAddURL() : String
      {
         return this.getURL("addURL");
      }
      
      public function getTeamDefinition(param1:String) : TeamDefinition
      {
         return this.nameMap[param1];
      }
      
      public function getFeatureIterator() : IIterator
      {
         var _loc1_:IIterator = new Iterator();
         _loc1_.setupIterable(_settings.feature);
         return _loc1_;
      }
      
      public function getGetURL() : String
      {
         return this.getURL("getURL");
      }
      
      private function fillFeatureMap() : void
      {
         var _loc2_:Object = null;
         var _loc3_:TeamDefinition = null;
         var _loc1_:IIterator = getIterator();
         while(_loc1_.next())
         {
            _loc2_ = _loc1_.current();
            _loc3_ = new TeamDefinition(_loc2_);
            this.nameMap[_loc3_.name] = _loc3_;
            this.addToFeature(_loc3_);
         }
      }
      
      override public function set settings(param1:Object) : void
      {
         super.settings = param1;
         this.setupMap();
      }
      
      private function setupMap() : void
      {
         this.nameMap = new Dictionary();
         this.createFeatureMap();
         this.fillFeatureMap();
      }
      
      private function getURL(param1:String) : String
      {
         return String(_settings.url[param1].url);
      }
      
      private function createFeatureMap() : void
      {
         var _loc2_:Object = null;
         var _loc3_:Number = NaN;
         this.featureMap = new Dictionary();
         var _loc1_:IIterator = this.getFeatureIterator();
         while(_loc1_.next())
         {
            _loc2_ = _loc1_.current();
            _loc3_ = Date.parse(_loc2_.expiration);
            this.featureMap[_loc2_.name] = new TeamFeatureDefinition(_loc2_.name,new Date(_loc3_));
         }
      }
      
      public function getListURL() : String
      {
         return this.getURL("listURL");
      }
      
      public function existFeature(param1:String) : Boolean
      {
         return _settings.feature[param1] != null;
      }
   }
}

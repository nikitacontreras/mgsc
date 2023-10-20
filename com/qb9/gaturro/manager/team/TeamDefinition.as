package com.qb9.gaturro.manager.team
{
   public class TeamDefinition implements ITeamDefinition
   {
       
      
      private var _featureList:Array;
      
      private var source:Object;
      
      public function TeamDefinition(param1:Object)
      {
         super();
         this.source = param1;
         this.setupFeatureList();
      }
      
      public function get featureStr() : String
      {
         return this.source.feature;
      }
      
      public function get featureList() : Array
      {
         return this._featureList.slice();
      }
      
      public function belongsToFeature(param1:String) : Boolean
      {
         return this.featureStr.indexOf(param1) > -1;
      }
      
      public function get name() : String
      {
         return this.source.name;
      }
      
      public function get label() : String
      {
         return this.source.label;
      }
      
      private function setupFeatureList() : void
      {
         this._featureList = this.featureStr.split(",");
      }
   }
}

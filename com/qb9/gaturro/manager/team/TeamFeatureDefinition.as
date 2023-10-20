package com.qb9.gaturro.manager.team
{
   import com.qb9.gaturro.commons.iterator.IIterator;
   import com.qb9.gaturro.commons.iterator.Iterator;
   import flash.utils.Dictionary;
   
   public class TeamFeatureDefinition
   {
       
      
      private var _name:String;
      
      private var _expiration:Date;
      
      private var teamDefinitionList:Dictionary;
      
      public function TeamFeatureDefinition(param1:String, param2:Date)
      {
         super();
         this._expiration = param2;
         this._name = param1;
         this.setup();
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get expiration() : Date
      {
         return this._expiration;
      }
      
      public function getTeamList() : IIterator
      {
         var _loc1_:IIterator = new Iterator();
         _loc1_.setupIterable(this.teamDefinitionList);
         return _loc1_;
      }
      
      public function isAsociated(param1:String) : Boolean
      {
         return this.teamDefinitionList[param1];
      }
      
      private function setup() : void
      {
         this.teamDefinitionList = new Dictionary();
      }
      
      public function addTeam(param1:TeamDefinition) : void
      {
         this.teamDefinitionList[param1.name] = param1;
      }
   }
}

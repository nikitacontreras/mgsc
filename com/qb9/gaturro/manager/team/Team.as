package com.qb9.gaturro.manager.team
{
   public class Team implements ITeamDefinition
   {
       
      
      private var _points:int;
      
      private var _definition:com.qb9.gaturro.manager.team.TeamDefinition;
      
      public function Team(param1:com.qb9.gaturro.manager.team.TeamDefinition, param2:int)
      {
         super();
         this._definition = param1;
         this._points = param2;
      }
      
      public function get label() : String
      {
         return this._definition.label;
      }
      
      public function get points() : int
      {
         return this._points;
      }
      
      public function get featureStr() : String
      {
         return this._definition.featureStr;
      }
      
      public function get name() : String
      {
         return this._definition.name;
      }
      
      public function toString() : String
      {
         return "Team [ Name: " + this.name + " // points: " + this.points + " // features: " + this.featureStr + " ]";
      }
      
      public function get featureList() : Array
      {
         return this._definition.featureList;
      }
   }
}

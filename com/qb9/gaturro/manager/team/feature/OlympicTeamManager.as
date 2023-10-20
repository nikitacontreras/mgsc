package com.qb9.gaturro.manager.team.feature
{
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.iterator.IIterator;
   import com.qb9.gaturro.manager.team.TeamDefinition;
   import com.qb9.gaturro.manager.team.TeamManager;
   
   public class OlympicTeamManager
   {
      
      public static const TEAM_C:String = "superAgil";
      
      public static const OLYMPIC_MEDAL_FEATURE:String = "olympicMedal";
      
      public static const SILVER:String = "Silver";
      
      public static const GOLD:String = "Gold";
      
      public static const OLYMPIC_FEATURE:String = "olympic";
      
      public static const BRONCE:String = "Bronce";
      
      public static const TEAM_B:String = "ultraRapido";
      
      public static const TEAM_A:String = "megaElastico";
       
      
      private var teamManager:TeamManager;
      
      public function OlympicTeamManager()
      {
         super();
         this.setup();
      }
      
      public function addGold(param1:Function = null) : void
      {
         var _loc2_:String = this.teamManager.getSuscriptionName(OLYMPIC_FEATURE);
         this.teamManager.addPoints(_loc2_ + GOLD,1);
      }
      
      public function getTeamDefinitionList() : IIterator
      {
         return this.teamManager.getTeamList(OLYMPIC_FEATURE);
      }
      
      public function suscribe(param1:String) : Boolean
      {
         return this.teamManager.suscribeToTeam(param1,OLYMPIC_FEATURE);
      }
      
      public function getMedalStanding(param1:Function) : void
      {
         var _loc2_:Delegate = new Delegate(param1);
         this.teamManager.askForTeamList(OLYMPIC_MEDAL_FEATURE,_loc2_.execute);
      }
      
      public function addSilver(param1:Function = null) : void
      {
         var _loc2_:String = this.teamManager.getSuscriptionName(OLYMPIC_FEATURE);
         this.teamManager.addPoints(_loc2_ + SILVER,1);
      }
      
      public function addBronce(param1:Function = null) : void
      {
         var _loc2_:String = this.teamManager.getSuscriptionName(OLYMPIC_FEATURE);
         this.teamManager.addPoints(_loc2_ + BRONCE,1);
      }
      
      public function getExpirationDate() : Date
      {
         return this.teamManager.getExpirationDate(OLYMPIC_FEATURE);
      }
      
      public function getSuscriptionDefinnition() : TeamDefinition
      {
         return this.teamManager.getSuscriptionDefinnition(OLYMPIC_FEATURE);
      }
      
      public function isSuscribed() : Boolean
      {
         return this.teamManager.isSuscribed(OLYMPIC_FEATURE);
      }
      
      public function getSuscriptionName() : String
      {
         return this.teamManager.getSuscriptionName(OLYMPIC_FEATURE);
      }
      
      public function isExpired() : Boolean
      {
         return !this.teamManager.isEnabled(OLYMPIC_FEATURE);
      }
      
      private function setup() : void
      {
         this.teamManager = Context.instance.getByType(TeamManager) as TeamManager;
      }
   }
}

import com.qb9.gaturro.globals.logger;

class Delegate
{
    
   
   private var callback:Function;
   
   public function Delegate(param1:Function)
   {
      super();
      if(param1 == null)
      {
         logger.debug("The callback method can\'t be null");
         throw new Error("The callback method can\'t be null");
      }
      this.callback = param1;
   }
   
   public function execute(param1:Object) : void
   {
      this.callback.apply(this,[param1]);
   }
}

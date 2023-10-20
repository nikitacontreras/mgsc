package com.qb9.gaturro.view.gui.combat
{
   import com.qb9.gaturro.external.roomObjects.GaturroSceneObjectAPI;
   import flash.events.Event;
   
   public class CombatEvent extends Event
   {
      
      public static const NPC_DEFEATED:String = "combatNPCDefeated";
      
      public static const STOP:String = "combatStop";
      
      public static const START:String = "combatStart";
      
      public static const NPC_WRONG_ATTACK:String = "combatNPCWrongAttack";
      
      public static const NPC_CORRECT_ATTACK:String = "combatNPCCorrectAttack";
       
      
      private var _oapi:GaturroSceneObjectAPI;
      
      public function CombatEvent(param1:String, param2:GaturroSceneObjectAPI = null)
      {
         super(param1);
         this._oapi = param2;
      }
      
      public function get objectAPI() : GaturroSceneObjectAPI
      {
         return this._oapi;
      }
   }
}

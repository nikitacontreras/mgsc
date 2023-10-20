package com.qb9.gaturro.world.npc.struct.states.condition
{
   import com.qb9.gaturro.world.npc.interpreter.NpcInterpreterError;
   import com.qb9.gaturro.world.npc.struct.NpcContext;
   import com.qb9.gaturro.world.npc.struct.NpcStatement;
   import com.qb9.gaturro.world.npc.struct.states.NpcState;
   
   public final class NpcConditionState extends NpcState
   {
       
      
      public function NpcConditionState(param1:String, param2:NpcStatement, param3:Array)
      {
         super(param1,param2,param3);
         if(param2.argumentAt(1,null) !== "|")
         {
            throw new NpcInterpreterError("Bad FORK separator");
         }
      }
      
      public function get conditions() : Array
      {
         return statements.concat();
      }
      
      public function getFalseState(param1:NpcContext) : String
      {
         return top.argumentAt(2,param1) as String;
      }
      
      public function getTrueState(param1:NpcContext) : String
      {
         return top.argumentAt(0,param1) as String;
      }
   }
}

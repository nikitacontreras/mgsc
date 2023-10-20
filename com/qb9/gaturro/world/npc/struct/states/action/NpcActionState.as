package com.qb9.gaturro.world.npc.struct.states.action
{
   import com.qb9.gaturro.world.npc.struct.NpcStatement;
   import com.qb9.gaturro.world.npc.struct.states.NpcState;
   
   public final class NpcActionState extends NpcState
   {
       
      
      public function NpcActionState(param1:String, param2:NpcStatement, param3:Array)
      {
         super(param1,param2,param3);
      }
      
      public function get actions() : Array
      {
         return statements.concat();
      }
   }
}

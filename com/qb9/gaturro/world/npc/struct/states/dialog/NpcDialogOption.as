package com.qb9.gaturro.world.npc.struct.states.dialog
{
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.gaturro.world.npc.struct.NpcContext;
   import com.qb9.gaturro.world.npc.struct.NpcStatement;
   
   public final class NpcDialogOption implements IDisposable
   {
       
      
      private var statement:NpcStatement;
      
      public function NpcDialogOption(param1:NpcStatement)
      {
         super();
         this.statement = param1;
      }
      
      public function getMessage(param1:NpcContext) : String
      {
         return this.statement.argumentAt(1,param1) as String;
      }
      
      public function getState(param1:NpcContext) : String
      {
         return this.statement.argumentAt(0,param1) as String;
      }
      
      public function dispose() : void
      {
         this.statement = null;
      }
   }
}

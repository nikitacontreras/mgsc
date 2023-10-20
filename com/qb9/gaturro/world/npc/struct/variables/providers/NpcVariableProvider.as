package com.qb9.gaturro.world.npc.struct.variables.providers
{
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.gaturro.world.npc.struct.NpcContext;
   
   public interface NpcVariableProvider extends IDisposable
   {
       
      
      function has(param1:String, param2:NpcContext) : Boolean;
      
      function getValue(param1:String, param2:NpcContext) : Object;
   }
}

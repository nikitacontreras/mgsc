package com.qb9.gaturro.world.npc.struct.variables
{
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.gaturro.world.npc.struct.NpcContext;
   
   public interface NpcVariable extends IDisposable
   {
       
      
      function get defaultValue() : Object;
      
      function getValue(param1:NpcContext) : Object;
      
      function get name() : String;
      
      function setValue(param1:Object, param2:NpcContext) : void;
   }
}

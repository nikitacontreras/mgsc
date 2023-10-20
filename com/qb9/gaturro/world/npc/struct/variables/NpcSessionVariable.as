package com.qb9.gaturro.world.npc.struct.variables
{
   import com.qb9.gaturro.world.npc.struct.NpcContext;
   
   public final class NpcSessionVariable extends BaseNpcVariable implements NpcVariable
   {
       
      
      public function NpcSessionVariable(param1:String, param2:Boolean = false, param3:Object = null)
      {
         super(param1,param2,param3);
      }
      
      public function setValue(param1:Object, param2:NpcContext) : void
      {
         param2.api.setSession(getKey(param2),param1);
      }
      
      public function getValue(param1:NpcContext) : Object
      {
         return param1.api.getSession(getKey(param1));
      }
   }
}

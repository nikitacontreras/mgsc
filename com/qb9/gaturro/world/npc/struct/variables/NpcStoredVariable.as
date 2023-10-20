package com.qb9.gaturro.world.npc.struct.variables
{
   import com.qb9.gaturro.world.npc.struct.NpcContext;
   
   public final class NpcStoredVariable extends BaseNpcVariable implements NpcVariable
   {
       
      
      public function NpcStoredVariable(param1:String, param2:Boolean = true, param3:Object = null)
      {
         super(param1,param2,param3);
      }
      
      public function setValue(param1:Object, param2:NpcContext) : void
      {
         param2.api.setProfileAttribute(getKey(param2),param1);
      }
      
      public function getValue(param1:NpcContext) : Object
      {
         return param1.api.getProfileAttribute(getKey(param1));
      }
   }
}

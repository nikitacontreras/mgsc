package com.qb9.gaturro.world.npc.struct.variables.providers
{
   import com.qb9.flashlib.lang.filter;
   import com.qb9.gaturro.world.npc.struct.NpcContext;
   
   public final class NpcVariableProviderAvatars extends BaseNpcVariableProvider implements NpcVariableProvider
   {
       
      
      public function NpcVariableProviderAvatars()
      {
         super({"costume":this.costume});
      }
      
      public function costume(param1:NpcContext) : uint
      {
         return this.count(param1,HelperCostume.costume);
      }
      
      public function has(param1:String, param2:NpcContext) : Boolean
      {
         return param1 in functions || this.getValue(param1,param2) !== null;
      }
      
      public function getValue(param1:String, param2:NpcContext) : Object
      {
         return evaluate(param1,param2);
      }
      
      override protected function def(param1:String, param2:NpcContext) : Object
      {
         return null;
      }
      
      public function dispose() : void
      {
      }
      
      private function count(param1:NpcContext, param2:Function) : uint
      {
         return filter(param1.roomAPI.avatars,param2).length;
      }
   }
}

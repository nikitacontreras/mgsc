package com.qb9.gaturro.world.npc.struct.variables.providers
{
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.world.npc.struct.NpcContext;
   
   public class NpcVariableProviderRegion extends BaseNpcVariableProvider implements NpcVariableProvider
   {
       
      
      public function NpcVariableProviderRegion()
      {
         super();
      }
      
      public function has(param1:String, param2:NpcContext) : Boolean
      {
         return this.getValue(param1,param2) !== null;
      }
      
      public function getValue(param1:String, param2:NpcContext) : Object
      {
         switch(param1)
         {
            case "country":
               return region.country;
            case "languageId":
               return region.languageId;
            default:
               return "";
         }
      }
      
      public function dispose() : void
      {
      }
   }
}

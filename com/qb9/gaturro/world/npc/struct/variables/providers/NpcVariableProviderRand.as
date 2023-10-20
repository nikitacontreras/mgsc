package com.qb9.gaturro.world.npc.struct.variables.providers
{
   import com.qb9.flashlib.math.Random;
   import com.qb9.gaturro.world.npc.struct.NpcContext;
   
   public final class NpcVariableProviderRand extends BaseNpcVariableProvider implements NpcVariableProvider
   {
       
      
      public function NpcVariableProviderRand()
      {
         super({"round":this.round});
      }
      
      public function has(param1:String, param2:NpcContext) : Boolean
      {
         return param1 !== null;
      }
      
      public function getValue(param1:String, param2:NpcContext) : Object
      {
         return evaluate(param1,param2);
      }
      
      override protected function def(param1:String, param2:NpcContext) : Object
      {
         var _loc3_:Array = this.getRange(param1);
         return Random.randrange(_loc3_[0],_loc3_[1]);
      }
      
      private function getRange(param1:String) : Array
      {
         var _loc2_:Array = param1.split("-");
         var _loc3_:Number = Number(_loc2_.pop());
         return [!!_loc2_.length ? Number(_loc2_[0]) : 0,_loc3_];
      }
      
      public function round(param1:String, param2:NpcContext) : int
      {
         var _loc3_:Array = this.getRange(param1);
         return Random.randint(_loc3_[0],_loc3_[1]);
      }
      
      public function dispose() : void
      {
      }
   }
}

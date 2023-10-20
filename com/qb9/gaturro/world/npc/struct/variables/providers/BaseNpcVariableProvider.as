package com.qb9.gaturro.world.npc.struct.variables.providers
{
   import com.qb9.gaturro.world.npc.struct.NpcContext;
   
   internal class BaseNpcVariableProvider
   {
       
      
      protected var functions:Object;
      
      public function BaseNpcVariableProvider(param1:Object = null)
      {
         super();
         this.functions = param1 || {};
      }
      
      protected function evaluate(param1:String, param2:NpcContext) : Object
      {
         var _loc4_:String = null;
         if(param1 in this.functions)
         {
            return this.functions[param1](param2);
         }
         var _loc3_:int = param1.indexOf(".");
         if(_loc3_ !== -1)
         {
            if((_loc4_ = param1.slice(0,_loc3_)) in this.functions)
            {
               param1 = param1.slice(_loc3_ + 1);
               return this.functions[_loc4_](param1,param2);
            }
         }
         return this.def(param1,param2);
      }
      
      protected function def(param1:String, param2:NpcContext) : Object
      {
         return null;
      }
   }
}

package com.qb9.gaturro.world.npc.struct.variables.providers
{
   import com.qb9.flashlib.utils.StringUtil;
   import com.qb9.gaturro.world.npc.struct.NpcContext;
   
   public final class NpcVariableProviderTime extends BaseNpcVariableProvider implements NpcVariableProvider
   {
       
      
      public function NpcVariableProviderTime()
      {
         super({"pad":this.pad});
      }
      
      public function has(param1:String, param2:NpcContext) : Boolean
      {
         return this.getValue(param1,param2) !== null;
      }
      
      public function pad(param1:String, param2:NpcContext) : Object
      {
         var _loc3_:Object = this.def(param1,param2);
         if(_loc3_ !== null)
         {
            return StringUtil.padLeft(Number(_loc3_),2);
         }
         return _loc3_;
      }
      
      override protected function def(param1:String, param2:NpcContext) : Object
      {
         var _loc3_:Number = param2.api.serverTime;
         var _loc4_:Date = new Date(_loc3_);
         switch(param1)
         {
            case "epoch":
               return _loc3_;
            case "second":
               return _loc4_.getUTCSeconds();
            case "minute":
               return _loc4_.getUTCMinutes();
            case "hour":
               return _loc4_.getUTCHours();
            case "day":
               return _loc4_.getUTCDate();
            case "month":
               return _loc4_.getUTCMonth() + 1;
            case "year":
               return _loc4_.getUTCFullYear();
            case "secondstamp":
               return int(_loc3_ / 1000);
            case "minutestamp":
               return int(_loc3_ / 1000 / 60);
            case "hourstamp":
               return int(_loc3_ / 1000 / 60 / 60);
            case "daystamp":
               return int(_loc3_ / 1000 / 60 / 60 / 24);
            case "weekday":
               return _loc4_.getDay();
            default:
               return null;
         }
      }
      
      public function getValue(param1:String, param2:NpcContext) : Object
      {
         return evaluate(param1,param2);
      }
      
      public function dispose() : void
      {
      }
   }
}

package com.qb9.gaturro.whitelist
{
   import com.qb9.flashlib.interfaces.IDisposable;
   
   internal class BaseWhiteListVariableReplacer implements IDisposable
   {
      
      private static const MATCHER:RegExp = /\[(\w+)(\.\w+)?\]/g;
      
      protected static const EMPTY_VAR:String = "...";
       
      
      protected var source:Object;
      
      private var map:Object;
      
      public function BaseWhiteListVariableReplacer(param1:Object)
      {
         super();
         this.map = param1;
      }
      
      private function insertVariable(param1:String, param2:String, param3:String, param4:int, param5:String) : String
      {
         var _loc6_:Function = null;
         var _loc7_:String = null;
         param2 = param2.toLowerCase();
         if(param2 in this.map)
         {
            _loc6_ = this.map[param2] as Function;
            _loc7_ = !!param3 ? _loc6_(param3) : _loc6_();
         }
         return _loc7_ || EMPTY_VAR;
      }
      
      public function replaceFor(param1:Object, param2:String) : String
      {
         this.source = param1;
         return param2.replace(MATCHER,this.insertVariable);
      }
      
      public function dispose() : void
      {
         this.map = null;
         this.source = null;
      }
   }
}

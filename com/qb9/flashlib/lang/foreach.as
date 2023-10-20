package com.qb9.flashlib.lang
{
   public function foreach(param1:Object, param2:Function, ... rest) : void
   {
      var _loc4_:Object = null;
      for each(_loc4_ in param1)
      {
         param2.apply(null,[_loc4_].concat(rest));
      }
   }
}

package com.qb9.flashlib.lang
{
   public function every(param1:Object, param2:Function, ... rest) : Boolean
   {
      var _loc4_:Object = null;
      for each(_loc4_ in param1)
      {
         if(param2.apply(null,[_loc4_].concat(rest)) === false)
         {
            return false;
         }
      }
      return true;
   }
}

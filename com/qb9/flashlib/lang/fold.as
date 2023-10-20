package com.qb9.flashlib.lang
{
   public function fold(param1:Object, param2:Function, param3:Object = null, ... rest) : *
   {
      var _loc5_:Object = null;
      for each(_loc5_ in param1)
      {
         param3 = param3 === null ? _loc5_ : param2.apply(null,[_loc5_,param3].concat(rest));
      }
      return param3;
   }
}

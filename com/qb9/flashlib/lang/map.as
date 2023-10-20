package com.qb9.flashlib.lang
{
   public function map(param1:Object, param2:Function, ... rest) : *
   {
      var _loc5_:Object = null;
      var _loc4_:Object = param1 is Array ? [] : {};
      for(_loc5_ in param1)
      {
         _loc4_[_loc5_] = param2.apply(null,[param1[_loc5_]].concat(rest));
      }
      return _loc4_;
   }
}

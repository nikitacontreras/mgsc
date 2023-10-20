package com.qb9.flashlib.lang
{
   public function filter(param1:Object, param2:Function, ... rest) : *
   {
      var _loc6_:Object = null;
      var _loc7_:Object = null;
      var _loc4_:*;
      var _loc5_:Object = (_loc4_ = param1 is Array) ? [] : {};
      for(_loc6_ in param1)
      {
         _loc7_ = param1[_loc6_];
         if(param2.apply(null,[_loc7_].concat(rest)))
         {
            _loc5_[_loc4_ ? _loc5_.length : _loc6_] = _loc7_;
         }
      }
      return _loc5_;
   }
}

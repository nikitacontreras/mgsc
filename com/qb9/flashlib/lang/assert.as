package com.qb9.flashlib.lang
{
   public function assert(param1:Boolean, param2:String = null) : void
   {
      if(param1 == false)
      {
         throw new AssertionError(param2);
      }
   }
}

package com.qb9.flashlib.lang
{
   public class AssertionError extends Error
   {
       
      
      public function AssertionError(param1:String = null)
      {
         super(param1 || "Assertion error");
      }
   }
}

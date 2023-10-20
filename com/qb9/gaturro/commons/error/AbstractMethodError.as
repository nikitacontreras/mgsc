package com.qb9.gaturro.commons.error
{
   import flash.errors.IllegalOperationError;
   
   public class AbstractMethodError extends IllegalOperationError
   {
       
      
      public function AbstractMethodError(param1:String = "This is an abtract method and should be implemented by sub class", param2:* = 0)
      {
         super(param1,param2);
      }
   }
}

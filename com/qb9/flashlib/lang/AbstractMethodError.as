package com.qb9.flashlib.lang
{
   public class AbstractMethodError extends Error
   {
      
      protected static const MESSAGE:String = "Abstract method called";
       
      
      public function AbstractMethodError()
      {
         super();
         message = MESSAGE + ": " + (getStackTrace().split("\n")[1] as String).replace(/.*at /,"").replace(/\[.*\]/,"");
      }
   }
}

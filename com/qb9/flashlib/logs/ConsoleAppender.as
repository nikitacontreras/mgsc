package com.qb9.flashlib.logs
{
   public class ConsoleAppender implements IAppender
   {
       
      
      public function ConsoleAppender()
      {
         super();
      }
      
      public function append(param1:Array, param2:int) : void
      {
         trace.apply(null,param1);
      }
   }
}

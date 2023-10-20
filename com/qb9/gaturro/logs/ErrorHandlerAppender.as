package com.qb9.gaturro.logs
{
   import com.qb9.flashlib.logs.IAppender;
   import com.qb9.flashlib.logs.Logger;
   
   public class ErrorHandlerAppender implements IAppender
   {
       
      
      private var main:MMO;
      
      public function ErrorHandlerAppender(param1:MMO)
      {
         super();
         this.main = param1;
      }
      
      public function append(param1:Array, param2:int) : void
      {
         if(param2 === Logger.LOG_LEVEL_ERROR)
         {
            this.main.showErrorScreen(param1.join(" "));
         }
      }
   }
}

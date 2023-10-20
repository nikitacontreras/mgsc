package com.qb9.flashlib.movieclip.actions
{
   import flash.display.MovieClip;
   
   public class FunctionAction implements IAction
   {
       
      
      private var func:Function;
      
      public function FunctionAction(param1:Function)
      {
         super();
         this.func = param1;
      }
      
      public function run(param1:MovieClip) : void
      {
         if(this.func.length)
         {
            this.func(param1);
         }
         else
         {
            this.func();
         }
      }
   }
}

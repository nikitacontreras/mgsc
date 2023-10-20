package com.qb9.gaturro.tutorial.steps
{
   import com.qb9.gaturro.tutorial.TutorialOperations;
   import flash.utils.setTimeout;
   
   public class WaitStep extends Step
   {
       
      
      private var miliseconds:Number;
      
      public function WaitStep(param1:TutorialOperations, param2:Number)
      {
         super(param1);
         this.miliseconds = param2;
      }
      
      private function end() : void
      {
         _finish = true;
      }
      
      override public function execute() : void
      {
         super.execute();
         setTimeout(this.end,this.miliseconds);
      }
   }
}

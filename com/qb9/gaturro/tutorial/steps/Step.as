package com.qb9.gaturro.tutorial.steps
{
   import com.qb9.gaturro.tutorial.TutorialOperations;
   
   public class Step
   {
       
      
      protected var op:TutorialOperations;
      
      protected var _finish:Boolean = false;
      
      public function Step(param1:TutorialOperations)
      {
         super();
         this.op = param1;
      }
      
      public function get finish() : Boolean
      {
         return this._finish;
      }
      
      public function execute() : void
      {
      }
      
      public function dispose() : void
      {
         this.op = null;
      }
   }
}

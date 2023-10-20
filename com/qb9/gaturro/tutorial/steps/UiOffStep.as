package com.qb9.gaturro.tutorial.steps
{
   import com.qb9.gaturro.tutorial.TutorialOperations;
   
   public class UiOffStep extends Step
   {
       
      
      public function UiOffStep(param1:TutorialOperations)
      {
         super(param1);
      }
      
      override public function execute() : void
      {
         super.execute();
         this.op.uiOff();
         _finish = true;
      }
   }
}

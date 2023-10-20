package com.qb9.gaturro.tutorial.steps
{
   import com.qb9.gaturro.tutorial.TutorialOperations;
   
   public class UiArrowsOffStep extends Step
   {
       
      
      public function UiArrowsOffStep(param1:TutorialOperations)
      {
         super(param1);
      }
      
      override public function execute() : void
      {
         super.execute();
         this.op.uiArrowOff();
         _finish = true;
      }
   }
}

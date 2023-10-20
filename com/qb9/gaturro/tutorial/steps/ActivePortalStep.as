package com.qb9.gaturro.tutorial.steps
{
   import com.qb9.gaturro.tutorial.TutorialOperations;
   
   public class ActivePortalStep extends Step
   {
       
      
      public function ActivePortalStep(param1:TutorialOperations)
      {
         super(param1);
      }
      
      override public function execute() : void
      {
         super.execute();
         this.op.portalStatus(true);
         this.op.showArrow("portalArrow",true);
         this.op.showUiButton("portal",true);
      }
   }
}

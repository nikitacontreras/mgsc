package com.qb9.gaturro.tutorial.steps
{
   import com.qb9.gaturro.tutorial.TutorialManager;
   import com.qb9.gaturro.tutorial.TutorialOperations;
   
   public class FuncStep extends Step
   {
       
      
      private var func:String;
      
      public function FuncStep(param1:TutorialOperations, param2:String)
      {
         super(param1);
         this.func = param2;
      }
      
      override public function execute() : void
      {
         super.execute();
         TutorialManager[this.func]();
         _finish = true;
      }
   }
}

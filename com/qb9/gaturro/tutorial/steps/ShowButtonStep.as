package com.qb9.gaturro.tutorial.steps
{
   import com.qb9.gaturro.tutorial.TutorialOperations;
   
   public class ShowButtonStep extends Step
   {
       
      
      private var visible:Boolean;
      
      private var name:String;
      
      public function ShowButtonStep(param1:TutorialOperations, param2:String, param3:Boolean)
      {
         super(param1);
         this.name = param2;
         this.visible = param3;
      }
      
      override public function execute() : void
      {
         super.execute();
         this.op.showUiButton(this.name,this.visible);
         _finish = true;
      }
   }
}

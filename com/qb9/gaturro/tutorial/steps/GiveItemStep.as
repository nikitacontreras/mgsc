package com.qb9.gaturro.tutorial.steps
{
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.tutorial.TutorialOperations;
   
   public class GiveItemStep extends Step
   {
       
      
      private var itemName:String;
      
      public function GiveItemStep(param1:TutorialOperations, param2:String)
      {
         super(param1);
         this.itemName = param2;
      }
      
      override public function execute() : void
      {
         super.execute();
         api.giveUser(this.itemName);
         _finish = true;
      }
   }
}

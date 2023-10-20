package com.qb9.gaturro.tutorial.steps
{
   import com.qb9.gaturro.globals.achievements;
   import com.qb9.gaturro.tutorial.TutorialOperations;
   
   public class AchievementStep extends Step
   {
       
      
      private var achievName:String;
      
      public function AchievementStep(param1:TutorialOperations, param2:String)
      {
         super(param1);
         this.achievName = param2;
      }
      
      override public function execute() : void
      {
         super.execute();
         achievements.achieveNow(this.achievName);
         _finish = true;
      }
   }
}

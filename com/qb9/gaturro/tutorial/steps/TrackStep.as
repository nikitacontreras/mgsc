package com.qb9.gaturro.tutorial.steps
{
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.tutorial.TutorialOperations;
   
   public class TrackStep extends Step
   {
      
      private static const TUTORIAL_TRACK_CATEGORY:String = "TUTORIAL:STEP";
       
      
      private var action:String;
      
      public function TrackStep(param1:TutorialOperations, param2:String)
      {
         super(param1);
         this.action = param2;
      }
      
      override public function execute() : void
      {
         super.execute();
         if(api)
         {
            api.trackEvent(TUTORIAL_TRACK_CATEGORY,this.action);
         }
         _finish = true;
      }
   }
}

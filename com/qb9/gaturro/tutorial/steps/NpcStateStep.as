package com.qb9.gaturro.tutorial.steps
{
   import com.qb9.gaturro.tutorial.TutorialOperations;
   import flash.utils.setTimeout;
   
   public class NpcStateStep extends Step
   {
       
      
      private var initState:String;
      
      private var endingState:String;
      
      private var name:String;
      
      private const TIME_CHECK:int = 500;
      
      public function NpcStateStep(param1:TutorialOperations, param2:String, param3:String, param4:String)
      {
         super(param1);
         this.name = param2;
         this.initState = param3;
         this.endingState = param4;
      }
      
      override public function execute() : void
      {
         super.execute();
         setTimeout(this.checkNpcState,this.TIME_CHECK);
      }
      
      private function checkNpcState() : void
      {
         if(this.name == "" || !op)
         {
            return;
         }
         var _loc1_:String = op.getNpcState(this.name);
         if(_loc1_ != this.initState)
         {
            this.op.uiArrowOff();
         }
         if(_loc1_ != this.endingState)
         {
            setTimeout(this.checkNpcState,this.TIME_CHECK);
         }
         else
         {
            _finish = true;
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.name = "";
      }
   }
}

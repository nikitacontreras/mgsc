package com.qb9.gaturro.tutorial.steps
{
   import com.qb9.gaturro.globals.net;
   import com.qb9.gaturro.net.requests.npc.ScoreActionRequest;
   import com.qb9.gaturro.tutorial.TutorialOperations;
   import com.qb9.gaturro.view.gui.Gui;
   
   public class CoinsStep extends Step
   {
       
      
      private var mount:int;
      
      private var modalShowed:Boolean = false;
      
      protected var gui:Gui;
      
      public function CoinsStep(param1:TutorialOperations, param2:Gui, param3:int)
      {
         super(param1);
         this.gui = param2;
         this.mount = param3;
      }
      
      override public function execute() : void
      {
         super.execute();
         net.sendAction(new ScoreActionRequest(this.mount,0,"skate"));
         _finish = true;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.gui = null;
      }
   }
}

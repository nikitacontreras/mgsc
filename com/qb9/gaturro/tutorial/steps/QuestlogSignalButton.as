package com.qb9.gaturro.tutorial.steps
{
   import com.qb9.gaturro.tutorial.TutorialOperations;
   import com.qb9.gaturro.view.gui.Gui;
   
   public class QuestlogSignalButton extends Step
   {
       
      
      protected var gui:Gui;
      
      protected var text:String;
      
      protected var buttonText:String;
      
      public function QuestlogSignalButton(param1:TutorialOperations, param2:Gui, param3:String, param4:String)
      {
         super(param1);
         this.gui = param2;
         this.text = param3;
         this.buttonText = param4;
      }
      
      override public function execute() : void
      {
         super.execute();
         this.gui.questlog.addSignalSimpleButton(1,this.text,this.close,this.buttonText);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.gui = null;
      }
      
      private function close() : void
      {
         _finish = true;
      }
   }
}

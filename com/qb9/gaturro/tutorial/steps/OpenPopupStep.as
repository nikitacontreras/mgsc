package com.qb9.gaturro.tutorial.steps
{
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.tutorial.TutorialOperations;
   import com.qb9.gaturro.view.gui.Gui;
   
   public class OpenPopupStep extends Step
   {
       
      
      protected var modalName:String;
      
      private var modalShowed:Boolean = false;
      
      protected var gui:Gui;
      
      public function OpenPopupStep(param1:TutorialOperations, param2:Gui, param3:String)
      {
         super(param1);
         this.gui = param2;
         this.modalName = param3;
      }
      
      override public function execute() : void
      {
         super.execute();
         api.showBannerModal(this.modalName);
         _finish = true;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.gui = null;
      }
   }
}

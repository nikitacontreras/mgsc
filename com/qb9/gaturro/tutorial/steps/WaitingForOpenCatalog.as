package com.qb9.gaturro.tutorial.steps
{
   import com.qb9.gaturro.tutorial.TutorialOperations;
   import com.qb9.gaturro.view.gui.Gui;
   import flash.utils.setTimeout;
   
   public class WaitingForOpenCatalog extends WaitingForOpenPopup
   {
       
      
      private var name:String;
      
      public function WaitingForOpenCatalog(param1:TutorialOperations, param2:Gui, param3:String)
      {
         super(param1,param2,"CatalogTutorialModal");
         this.name = param3;
      }
      
      override public function execute() : void
      {
         super.execute();
         setTimeout(op.setNpcState,1000,this.name,"ready");
      }
   }
}

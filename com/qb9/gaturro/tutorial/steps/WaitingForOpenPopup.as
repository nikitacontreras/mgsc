package com.qb9.gaturro.tutorial.steps
{
   import com.qb9.gaturro.tutorial.TutorialOperations;
   import com.qb9.gaturro.view.gui.Gui;
   import flash.utils.setTimeout;
   
   public class WaitingForOpenPopup extends Step
   {
       
      
      protected var gui:Gui;
      
      private var modalShowed:Boolean = false;
      
      private var modalName:String;
      
      private const TIME_CHECK:int = 1;
      
      public function WaitingForOpenPopup(param1:TutorialOperations, param2:Gui, param3:String)
      {
         super(param1);
         this.gui = param2;
         this.modalName = param3;
      }
      
      override public function execute() : void
      {
         super.execute();
         setTimeout(this.checkOpenModal,this.TIME_CHECK);
      }
      
      private function isCorrectType() : Boolean
      {
         return this.modalName == "" || this.modalName == this.gui.modal.denomination;
      }
      
      private function checkOpenModal() : void
      {
         if(!this.gui)
         {
            return;
         }
         if(Boolean(this.gui.modal) && this.isCorrectType())
         {
            _finish = true;
         }
         else
         {
            setTimeout(this.checkOpenModal,this.TIME_CHECK);
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.gui = null;
      }
   }
}

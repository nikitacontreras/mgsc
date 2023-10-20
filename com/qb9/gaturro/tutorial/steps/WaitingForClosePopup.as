package com.qb9.gaturro.tutorial.steps
{
   import com.qb9.gaturro.tutorial.TutorialOperations;
   import com.qb9.gaturro.view.gui.Gui;
   import flash.utils.setTimeout;
   
   public class WaitingForClosePopup extends Step
   {
       
      
      private const TIME_CHECK:int = 1;
      
      private var modalShowed:Boolean = false;
      
      private var modalName:String;
      
      protected var gui:Gui;
      
      public function WaitingForClosePopup(param1:TutorialOperations, param2:Gui, param3:String)
      {
         super(param1);
         this.gui = param2;
         this.modalName = param3;
      }
      
      override public function execute() : void
      {
         super.execute();
         setTimeout(this.checkCloseModal,this.TIME_CHECK);
      }
      
      private function isCorrectType() : Boolean
      {
         return this.modalName == "" || this.modalName == this.gui.modal.denomination;
      }
      
      private function checkCloseModal() : void
      {
         if(!this.gui)
         {
            return;
         }
         if(!this.modalShowed)
         {
            this.modalShowed = this.gui.modal != null && this.isCorrectType();
         }
         if(!this.gui.modal && this.modalShowed)
         {
            _finish = true;
         }
         else
         {
            setTimeout(this.checkCloseModal,this.TIME_CHECK);
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.gui = null;
      }
   }
}

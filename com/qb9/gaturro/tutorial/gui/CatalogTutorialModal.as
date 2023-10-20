package com.qb9.gaturro.tutorial.gui
{
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.gaturro.tutorial.TutorialOperations;
   import com.qb9.gaturro.view.gui.catalog.CatalogModal;
   import com.qb9.gaturro.world.catalog.Catalog;
   import com.qb9.gaturro.world.catalog.CatalogItem;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.mambo.net.manager.NetworkManager;
   import flash.events.Event;
   
   public class CatalogTutorialModal extends CatalogModal
   {
       
      
      private var op:TutorialOperations;
      
      private var buyDone:Boolean = false;
      
      public function CatalogTutorialModal(param1:Catalog, param2:NetworkManager, param3:TaskContainer, param4:GaturroRoom, param5:TutorialOperations)
      {
         super(param1,param2,param3,param4);
         this.op = param5;
         this.showArrowList();
      }
      
      private function showArrowConfirmation() : void
      {
         switch(catalog.name)
         {
            case "tutorial_remeras":
               this.op.showArrow("clothesBuy2",false);
               this.op.showArrow("clothesBuy3",true);
               return;
            case "tutorial_sillas":
               this.op.showArrow("notWerable",false);
               this.op.showArrow("seatsBuy2",false);
               this.op.showArrow("seatsBuy3",true);
               return;
            default:
               return;
         }
      }
      
      override protected function buy(param1:Event) : void
      {
         this.hideAllArrows();
         this.buyDone = true;
         super.buy(param1);
      }
      
      private function hideAllArrows() : void
      {
         switch(catalog.name)
         {
            case "tutorial_remeras":
               this.op.showArrow("clothesBuy2",false);
               this.op.showArrow("clothesBuy3",false);
               return;
            case "tutorial_sillas":
               this.op.showArrow("notWerable",false);
               this.op.showArrow("seatsBuy2",false);
               this.op.showArrow("seatsBuy3",false);
               return;
            default:
               return;
         }
      }
      
      private function showArrowList() : void
      {
         if(this.buyDone)
         {
            this.op.showArrow("clothesBuy2",false);
            this.op.showArrow("clothesBuy3",false);
            this.op.showArrow("notWerable",false);
            this.op.showArrow("seatsBuy3",false);
            return;
         }
         switch(catalog.name)
         {
            case "tutorial_remeras":
               this.op.showArrow("clothesBuy2",true);
               this.op.showArrow("clothesBuy3",false);
               return;
            case "tutorial_sillas":
               this.op.showArrow("notWerable",false);
               this.op.showArrow("seatsBuy3",false);
               return;
            default:
               return;
         }
      }
      
      private function setupArrowsForCloseConfirmation() : void
      {
         this.op.showArrow("closeCatalog",true);
      }
      
      override protected function pressEscKey() : void
      {
      }
      
      override protected function init() : void
      {
         super.init();
         confirmation.addEventListener(Event.CANCEL,this.pressCancel);
         confirmation.cancel.visible = false;
      }
      
      override protected function showConfirmation(param1:CatalogItem) : void
      {
         this.showArrowConfirmation();
         this.setupArrowsForOpenConfirmation();
         super.showConfirmation(param1);
      }
      
      private function setupArrowsForOpenConfirmation() : void
      {
         this.op.showArrow("closeCatalog",false);
         this.op.showArrow("notWerable",false);
      }
      
      override protected function showError(param1:String, param2:int = 1, param3:String = "", param4:String = "") : void
      {
         this.hideAllArrows();
         super.showError(param1,param2,param3,param4);
      }
      
      private function pressCancel(param1:Event) : void
      {
         this.showArrowList();
         this.setupArrowsForCloseConfirmation();
      }
      
      override public function dispose() : void
      {
         confirmation.removeEventListener(Event.CANCEL,this.pressCancel);
         this.op = null;
      }
   }
}

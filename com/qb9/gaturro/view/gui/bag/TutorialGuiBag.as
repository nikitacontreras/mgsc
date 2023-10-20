package com.qb9.gaturro.view.gui.bag
{
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.gaturro.view.gui.Gui;
   import com.qb9.gaturro.view.gui.base.BaseGuiModal;
   import com.qb9.gaturro.world.core.GaturroRoom;
   
   public class TutorialGuiBag extends GuiBag
   {
       
      
      public function TutorialGuiBag(param1:Gui, param2:GaturroRoom, param3:TaskContainer)
      {
         super(param1,param2,param3);
      }
      
      override protected function createModal() : BaseGuiModal
      {
         return new BagGuiModal(room);
      }
   }
}

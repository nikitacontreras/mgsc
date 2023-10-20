package com.qb9.gaturro.view.gui.bag
{
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.view.gui.Gui;
   import com.qb9.gaturro.view.gui.base.BaseGuiModal;
   import com.qb9.gaturro.view.gui.base.inventory.BaseGuiInventoryButton;
   import com.qb9.gaturro.world.core.GaturroRoom;
   
   public class GuiBag extends BaseGuiInventoryButton
   {
       
      
      protected var room:GaturroRoom;
      
      public function GuiBag(param1:Gui, param2:GaturroRoom, param3:TaskContainer)
      {
         super(param1,param1.inventory,param3,user.bag,340,60);
         this.room = param2;
         this.tasks = param3;
      }
      
      override protected function createModal() : BaseGuiModal
      {
         return new BagGuiModal(this.room);
      }
      
      override public function dispose() : void
      {
         this.room = null;
         tasks = null;
         super.dispose();
      }
   }
}

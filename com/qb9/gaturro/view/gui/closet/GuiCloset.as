package com.qb9.gaturro.view.gui.closet
{
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.view.gui.Gui;
   import com.qb9.gaturro.view.gui.base.BaseGuiModal;
   import com.qb9.gaturro.view.gui.base.inventory.BaseGuiInventoryButton;
   import com.qb9.gaturro.world.core.GaturroRoom;
   
   public final class GuiCloset extends BaseGuiInventoryButton
   {
       
      
      private var room:GaturroRoom;
      
      public function GuiCloset(param1:Gui, param2:TaskContainer, param3:GaturroRoom)
      {
         super(param1,param1.home,param2,user.house,396,60);
         this.room = param3;
      }
      
      override protected function init() : void
      {
         super.init();
         mc.gotoAndPlay("inventory");
      }
      
      override protected function createModal() : BaseGuiModal
      {
         return new ClosetGuiModal(this.room);
      }
      
      override public function dispose() : void
      {
         this.room = null;
         super.dispose();
      }
   }
}

package com.qb9.gaturro.view.gui.home
{
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.view.gui.Gui;
   import com.qb9.gaturro.view.gui.base.inventory.BaseGuiInventoryButton;
   import com.qb9.gaturro.world.core.GaturroRoom;
   
   public final class GuiHome extends BaseGuiInventoryButton
   {
       
      
      private var room:GaturroRoom;
      
      public function GuiHome(param1:Gui, param2:GaturroRoom, param3:TaskContainer)
      {
         super(param1,param1.home,param3,user.house);
         this.room = param2;
      }
      
      override protected function action() : void
      {
         this.room.visit(this.room.userAvatar.username);
      }
      
      override public function dispose() : void
      {
         this.room = null;
         super.dispose();
      }
   }
}

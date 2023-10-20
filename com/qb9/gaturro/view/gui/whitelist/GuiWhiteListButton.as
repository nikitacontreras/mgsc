package com.qb9.gaturro.view.gui.whitelist
{
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.gaturro.view.gui.Gui;
   import com.qb9.gaturro.view.gui.base.BaseGuiModal;
   import com.qb9.gaturro.view.gui.base.BaseGuiModalOpener;
   import com.qb9.gaturro.view.world.whitelist.WhiteListViewEvent;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   
   public final class GuiWhiteListButton extends BaseGuiModalOpener
   {
       
      
      private var room:GaturroRoom;
      
      private var tasks:TaskContainer;
      
      public function GuiWhiteListButton(param1:Gui, param2:GaturroRoom, param3:TaskContainer)
      {
         super(param1,param1.messages,50);
         this.room = param2;
         this.tasks = param3;
      }
      
      override protected function createModal() : BaseGuiModal
      {
         var _loc1_:WhiteListModal = new WhiteListModal(this.room,this.tasks);
         _loc1_.addEventListener(WhiteListViewEvent.MESSAGE_SELECTED,this.whenMessageIsSelected);
         return _loc1_;
      }
      
      private function whenMessageIsSelected(param1:WhiteListViewEvent) : void
      {
         var _loc2_:WhiteListNode = param1.node;
         this.room.chat.sendKey(_loc2_.key);
         modal.removeEventListener(WhiteListViewEvent.MESSAGE_SELECTED,this.whenMessageIsSelected);
         modal.close();
      }
      
      override public function dispose() : void
      {
         this.tasks = null;
         this.room = null;
         super.dispose();
      }
   }
}

package com.qb9.gaturro.view.gui.actions
{
   import com.qb9.gaturro.view.gui.Gui;
   import com.qb9.gaturro.view.gui.base.BaseGuiModal;
   import com.qb9.gaturro.view.gui.base.BaseGuiModalOpener;
   import com.qb9.mambo.world.avatars.UserAvatar;
   
   public final class GuiActionsButton extends BaseGuiModalOpener
   {
       
      
      private var avatar:UserAvatar;
      
      public function GuiActionsButton(param1:Gui, param2:UserAvatar)
      {
         super(param1,param1.actions,205);
         this.avatar = param2;
      }
      
      override protected function createModal() : BaseGuiModal
      {
         return new ActionsGuiModal(this.avatar);
      }
      
      override public function dispose() : void
      {
         this.avatar = null;
         super.dispose();
      }
   }
}

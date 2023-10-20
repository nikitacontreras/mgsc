package com.qb9.gaturro.view.gui.map
{
   import com.qb9.gaturro.view.gui.Gui;
   import com.qb9.gaturro.view.gui.base.BaseGuiModal;
   import com.qb9.gaturro.view.gui.base.BaseGuiModalOpener;
   import com.qb9.gaturro.world.core.GaturroRoom;
   
   public final class GuiMap extends BaseGuiModalOpener
   {
       
      
      private var room:GaturroRoom;
      
      public function GuiMap(param1:Gui, param2:GaturroRoom)
      {
         super(param1,param1.map,0,0);
         this.room = param2;
      }
      
      override protected function createModal() : BaseGuiModal
      {
         return new MapGuiModal(this.room.userAvatar.isCitizen,this.room);
      }
      
      override public function dispose() : void
      {
         this.room = null;
         super.dispose();
      }
   }
}

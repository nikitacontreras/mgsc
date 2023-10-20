package com.qb9.gaturro.view.gui.whitelist
{
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.view.gui.base.BaseGuiModal;
   import com.qb9.gaturro.view.gui.util.GuiUtil;
   import com.qb9.gaturro.view.world.whitelist.WhiteListPane;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import flash.display.DisplayObject;
   
   public final class WhiteListModal extends BaseGuiModal
   {
       
      
      private var pane:WhiteListPane;
      
      public function WhiteListModal(param1:GaturroRoom, param2:TaskContainer)
      {
         super();
         this.pane = new WhiteListPane(param1.whitelist,param1.variables,param2);
         this.init();
      }
      
      private function init() : void
      {
         addChild(this.pane);
      }
      
      override public function dispose() : void
      {
         this.pane.dispose();
         this.pane = null;
         super.dispose();
      }
      
      override protected function get closeSound() : String
      {
         return null;
      }
      
      override protected function whenAddedToStage() : void
      {
         var _loc1_:DisplayObject = GuiUtil.createArrow();
         _loc1_.x = 80;
         _loc1_.alpha = settings.gui.overlay.alpha;
         this.pane.addChild(_loc1_);
      }
   }
}

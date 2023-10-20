package com.qb9.gaturro.editor.gui.modes
{
   import com.qb9.gaturro.editor.NetActionManager;
   import com.qb9.mambo.view.world.tiling.TileView;
   
   internal class BaseGuiMode implements GuiMode
   {
       
      
      protected var actions:NetActionManager;
      
      public function BaseGuiMode(param1:NetActionManager)
      {
         super();
         this.actions = param1;
      }
      
      public function press(param1:TileView) : void
      {
      }
      
      public function release(param1:TileView) : void
      {
      }
      
      public function setup() : void
      {
      }
      
      public function dispose() : void
      {
         this.actions = null;
      }
   }
}

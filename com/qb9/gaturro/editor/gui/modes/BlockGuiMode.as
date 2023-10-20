package com.qb9.gaturro.editor.gui.modes
{
   import com.qb9.gaturro.editor.NetActionManager;
   import com.qb9.mambo.view.world.elements.behaviors.RefreshableView;
   import com.qb9.mambo.view.world.tiling.TileView;
   import com.qb9.mambo.world.tiling.Tile;
   import flash.display.Sprite;
   
   public final class BlockGuiMode extends BaseGuiMode
   {
       
      
      public function BlockGuiMode(param1:NetActionManager)
      {
         super(param1);
      }
      
      override public function release(param1:TileView) : void
      {
         var _loc2_:Tile = param1.tile;
         var _loc3_:* = !_loc2_.blocked;
         _loc2_.mambo::blocked = _loc3_;
         actions.setTileState(_loc2_.coord,_loc3_);
         if(param1 is RefreshableView)
         {
            Sprite(param1).buttonMode = !_loc3_;
            RefreshableView(param1).refresh();
         }
      }
   }
}

package com.qb9.gaturro.editor.gui.modes
{
   import com.qb9.gaturro.editor.NetActionManager;
   import com.qb9.gaturro.world.core.avatar.pet.AvatarPet;
   import com.qb9.mambo.view.world.tiling.TileView;
   import com.qb9.mambo.world.avatars.Avatar;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import com.qb9.mambo.world.tiling.Tile;
   
   public final class MoveGuiMode extends BaseGuiMode
   {
       
      
      private var idSelected:Number;
      
      public function MoveGuiMode(param1:NetActionManager)
      {
         super(param1);
      }
      
      override public function press(param1:TileView) : void
      {
         var _loc3_:RoomSceneObject = null;
         trace("MoveGuiMode > press > asset.tile.coord = [" + param1.tile.coord + "]");
         var _loc2_:Tile = param1.tile;
         for each(_loc3_ in _loc2_.children)
         {
            if(_loc3_ is Avatar === false && _loc3_ is AvatarPet === false)
            {
               this.idSelected = _loc3_.id;
               trace("MoveGuiMode > press > idSelected = [" + this.idSelected + "]");
               break;
            }
         }
      }
      
      override public function release(param1:TileView) : void
      {
         trace("MoveGuiMode > release > asset.tile.coord  = [" + param1.tile.coord + "] // idSelected = [" + this.idSelected + "]");
         var _loc2_:Tile = param1.tile;
         actions.sceneMove(this.idSelected,_loc2_.coord);
         this.idSelected = -1;
      }
   }
}

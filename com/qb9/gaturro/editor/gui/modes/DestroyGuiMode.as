package com.qb9.gaturro.editor.gui.modes
{
   import com.qb9.gaturro.editor.NetActionManager;
   import com.qb9.gaturro.world.core.avatar.pet.AvatarPet;
   import com.qb9.mambo.view.world.tiling.TileView;
   import com.qb9.mambo.world.avatars.Avatar;
   import com.qb9.mambo.world.core.RoomSceneObject;
   
   public final class DestroyGuiMode extends BaseGuiMode
   {
       
      
      public function DestroyGuiMode(param1:NetActionManager)
      {
         super(param1);
      }
      
      override public function release(param1:TileView) : void
      {
         var _loc2_:RoomSceneObject = null;
         for each(_loc2_ in param1.tile.children)
         {
            if(_loc2_ is Avatar === false && _loc2_ is AvatarPet == false)
            {
               actions.sceneDestroy(_loc2_.id);
            }
         }
      }
   }
}

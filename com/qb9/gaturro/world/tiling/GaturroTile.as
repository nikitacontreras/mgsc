package com.qb9.gaturro.world.tiling
{
   import com.qb9.mambo.world.avatars.UserAvatar;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import com.qb9.mambo.world.tiling.Tile;
   
   public class GaturroTile extends Tile
   {
       
      
      private var _lastObjectClicked:RoomSceneObject;
      
      private var _objectContainer:RoomSceneObject;
      
      public function GaturroTile()
      {
         super();
      }
      
      public function get container() : RoomSceneObject
      {
         return this._objectContainer;
      }
      
      public function set lastObjectClicked(param1:RoomSceneObject) : void
      {
         this._lastObjectClicked = param1;
      }
      
      public function refreshContainer() : void
      {
         var _loc1_:RoomSceneObject = null;
         var _loc2_:RoomSceneObject = null;
         this._objectContainer = null;
         for each(_loc1_ in this.children)
         {
            _loc2_ = RoomSceneObject(_loc1_);
            if(Boolean(_loc2_) && _loc2_.attributes.slots != null)
            {
               this._objectContainer = _loc2_;
            }
         }
      }
      
      public function unlockTile() : void
      {
         this._blocked = false;
      }
      
      override public function activate(param1:UserAvatar) : void
      {
         if(Boolean(this._lastObjectClicked) && this._lastObjectClicked !== param1)
         {
            this._lastObjectClicked.activate(param1);
         }
         else
         {
            super.activate(param1);
         }
         this._lastObjectClicked = null;
      }
      
      override public function removeChild(param1:RoomSceneObject) : void
      {
         super.removeChild(param1);
         this.refreshContainer();
      }
      
      override public function addChild(param1:RoomSceneObject) : void
      {
         super.addChild(param1);
         this.refreshContainer();
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this._objectContainer = null;
         this._lastObjectClicked = null;
      }
   }
}

package com.qb9.mambo.world.avatars
{
   import com.qb9.mambo.core.attributes.CustomAttributes;
   import com.qb9.mambo.geom.Coord;
   import com.qb9.mambo.user.User;
   import com.qb9.mambo.world.tiling.Tile;
   import com.qb9.mambo.world.tiling.TileGrid;
   
   public class UserAvatar extends Avatar
   {
       
      
      private var _user:User;
      
      public function UserAvatar(param1:CustomAttributes, param2:TileGrid, param3:User)
      {
         super(param1,param2);
         this._user = param3;
      }
      
      override public function get monitorAttributes() : Boolean
      {
         return true;
      }
      
      public function get user() : User
      {
         return this._user;
      }
      
      override protected function reachedDestination() : void
      {
         var _loc2_:Tile = null;
         super.reachedDestination();
         tile.activate(this);
         if(disposed)
         {
            return;
         }
         var _loc1_:Coord = path.originalDestination;
         if(_loc1_.neighbors(coord))
         {
            _loc2_ = coordToTile(_loc1_);
            if(_loc2_.blockedByChildren)
            {
               _loc2_.activate(this);
            }
         }
      }
   }
}

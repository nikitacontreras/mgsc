package com.qb9.mambo.world.elements
{
   import com.qb9.flashlib.geom.Direction;
   import com.qb9.mambo.core.attributes.CustomAttributes;
   import com.qb9.mambo.geom.Coord;
   import com.qb9.mambo.world.core.RoomLink;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import com.qb9.mambo.world.tiling.TileGrid;
   import com.qb9.mines.mobject.Mobject;
   
   public class Portal extends RoomSceneObject
   {
       
      
      private var _link:RoomLink;
      
      private var roomCoord:Coord;
      
      public function Portal(param1:CustomAttributes, param2:TileGrid, param3:Coord)
      {
         super(param1,param2);
         this.roomCoord = param3;
      }
      
      public function get link() : RoomLink
      {
         return this._link;
      }
      
      override public function buildFromMobject(param1:Mobject) : void
      {
         super.buildFromMobject(param1);
         this._link = new RoomLink();
         this._link.buildFromMobject(param1.getMobject("link"));
      }
      
      override public function get direction() : int
      {
         return Direction.calculate(this.roomCoord,this.link.worldCoord);
      }
   }
}

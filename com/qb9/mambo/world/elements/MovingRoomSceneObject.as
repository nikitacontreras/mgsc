package com.qb9.mambo.world.elements
{
   import com.qb9.flashlib.geom.Direction;
   import com.qb9.mambo.core.attributes.CustomAttributes;
   import com.qb9.mambo.geom.Coord;
   import com.qb9.mambo.world.avatars.events.MovingRoomSceneObjectEvent;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import com.qb9.mambo.world.path.Path;
   import com.qb9.mambo.world.tiling.Tile;
   import com.qb9.mambo.world.tiling.TileGrid;
   import flash.utils.setTimeout;
   
   public class MovingRoomSceneObject extends RoomSceneObject
   {
       
      
      protected var path:Path;
      
      public function MovingRoomSceneObject(param1:CustomAttributes, param2:TileGrid)
      {
         super(param1,param2);
      }
      
      public function get nextTile() : Tile
      {
         return coordToTile(this.path.nextCoord);
      }
      
      public function moveTo(param1:Coord) : void
      {
         if(param1.equals(this.coord))
         {
            setTimeout(this.reachedDestination,10);
         }
         else
         {
            this.dispatch(MovingRoomSceneObjectEvent.WANTS_TO_MOVE,param1);
         }
      }
      
      public function moveBy(param1:Path) : void
      {
         this.path = param1;
         this.dispatch(MovingRoomSceneObjectEvent.STARTED_MOVING);
         this.step();
      }
      
      final override public function dispatch(param1:String, param2:* = null) : Boolean
      {
         return dispatchEvent(new MovingRoomSceneObjectEvent(param1,param2));
      }
      
      protected function step() : void
      {
         _coord = this.path.coord;
         if(this.moving)
         {
            _direction = 0;
            this.dispatch(MovingRoomSceneObjectEvent.MOVE_STEP);
         }
         else
         {
            this.reachedDestination();
         }
      }
      
      public function get moving() : Boolean
      {
         return this.path.nextCoord !== null;
      }
      
      public function stopMoving() : void
      {
         placeAt(this.path.nextCoord || coord);
      }
      
      override protected function setCoord(param1:Coord) : void
      {
         super.setCoord(param1);
         this.path = new Path([param1]);
      }
      
      public function get destination() : Coord
      {
         return this.path.destination;
      }
      
      public function arrivedToTile() : void
      {
         if(this.nextTile)
         {
            tile.removeChild(this);
            this.nextTile.addChild(this);
            this.path.step();
         }
         this.step();
      }
      
      public function limit(param1:Coord) : void
      {
         if(param1.equals(this.path.destination))
         {
            return;
         }
         if(this.path.has(param1))
         {
            this.path.cropAt(param1);
            if(this.moving)
            {
               return;
            }
         }
         placeAt(param1);
      }
      
      protected function reachedDestination() : void
      {
         this.dispatch(MovingRoomSceneObjectEvent.STOPPED_MOVING);
      }
      
      override public function get direction() : int
      {
         if(_direction === 0 && this.moving)
         {
            _direction = Direction.calculate(this.path.coord,this.path.nextCoord);
         }
         return _direction;
      }
   }
}

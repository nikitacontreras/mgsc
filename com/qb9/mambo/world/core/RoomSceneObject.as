package com.qb9.mambo.world.core
{
   import com.qb9.mambo.core.attributes.CustomAttributes;
   import com.qb9.mambo.core.objects.SceneObject;
   import com.qb9.mambo.geom.Coord;
   import com.qb9.mambo.world.core.events.RoomSceneObjectEvent;
   import com.qb9.mambo.world.tiling.Tile;
   import com.qb9.mambo.world.tiling.TileGrid;
   import com.qb9.mines.mobject.Mobject;
   
   public class RoomSceneObject extends SceneObject
   {
       
      
      protected var _direction:int;
      
      private var grid:TileGrid;
      
      public var _type:String;
      
      private var _blocks:Boolean;
      
      protected var _coord:Coord;
      
      public function RoomSceneObject(param1:CustomAttributes, param2:TileGrid)
      {
         super(param1);
         this.grid = param2;
      }
      
      private function removeFromCurrentTiles() : void
      {
         var _loc1_:Tile = null;
         for each(_loc1_ in this.takenTiles)
         {
            _loc1_.removeChild(this);
         }
      }
      
      public function get blocks() : Boolean
      {
         return this._blocks;
      }
      
      override protected function get dumpVars() : Array
      {
         return super.dumpVars.concat("coord");
      }
      
      private function addToTakenTiles() : void
      {
         var _loc1_:Tile = null;
         for each(_loc1_ in this.takenTiles)
         {
            _loc1_.addChild(this);
         }
      }
      
      override public function buildFromMobject(param1:Mobject) : void
      {
         super.buildFromMobject(param1);
         this._direction = param1.getInteger("direction");
         this._blocks = param1.getBoolean("blockingHint");
         this.setCoord(Coord.fromArray(param1.getIntegerArray("coord")));
      }
      
      protected function coordToTile(param1:Coord) : Tile
      {
         return !!param1 ? this.grid.getTileAtCoord(param1) : null;
      }
      
      override public function dispose() : void
      {
         this.removeFromCurrentTiles();
         this.grid = null;
         this._coord = null;
         super.dispose();
      }
      
      public function placeAt(param1:Coord) : void
      {
         this.setCoord(param1);
         dispatchEvent(new RoomSceneObjectEvent(RoomSceneObjectEvent.REPOSITIONED));
      }
      
      public function get isGrabbable() : Boolean
      {
         return attributes.grabbable === true;
      }
      
      public function get tile() : Tile
      {
         return this.coordToTile(this.coord);
      }
      
      protected function setCoord(param1:Coord) : void
      {
         if(this._coord)
         {
            this.removeFromCurrentTiles();
         }
         this._coord = param1;
         this.addToTakenTiles();
      }
      
      public function get coord() : Coord
      {
         return this._coord;
      }
      
      public function get takenTiles() : Array
      {
         var _loc4_:int = 0;
         var _loc5_:Coord = null;
         var _loc6_:Tile = null;
         var _loc1_:Coord = this.coord;
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < size.width)
         {
            _loc4_ = 0;
            while(_loc4_ < size.height)
            {
               _loc5_ = _loc1_.add(_loc3_,_loc4_);
               if(_loc6_ = this.grid.getTileAtCoord(_loc5_))
               {
                  _loc2_.push(_loc6_);
               }
               else
               {
                  warning("SceneObject with id",id,"and name",name,"takes a tile outside the room",_loc5_);
               }
               _loc4_++;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function get direction() : int
      {
         return this._direction;
      }
   }
}

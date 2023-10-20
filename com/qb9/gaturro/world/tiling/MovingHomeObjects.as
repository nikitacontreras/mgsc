package com.qb9.gaturro.world.tiling
{
   import com.qb9.gaturro.globals.net;
   import com.qb9.gaturro.net.GaturroNetResponses;
   import com.qb9.gaturro.view.world.elements.GaturroRoomSceneObjectView;
   import com.qb9.gaturro.view.world.tiling.GaturroTileView;
   import com.qb9.gaturro.world.core.avatar.pet.AvatarPet;
   import com.qb9.mambo.geom.Coord;
   import com.qb9.mambo.net.manager.NetworkManagerEvent;
   import com.qb9.mambo.net.requests.home.MoveHomeObjectActionRequest;
   import com.qb9.mambo.view.world.elements.RoomSceneObjectView;
   import com.qb9.mambo.view.world.util.TwoWayLink;
   import com.qb9.mambo.world.avatars.Avatar;
   import com.qb9.mambo.world.core.Room;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import com.qb9.mambo.world.tiling.Tile;
   import com.qb9.mambo.world.tiling.TileGrid;
   import com.qb9.mines.mobject.Mobject;
   import config.HouseConfig;
   
   public class MovingHomeObjects
   {
      
      public static const STACKING_ABORTED:int = 2;
      
      public static const STACKING_ACHIEVED:int = 1;
      
      public static const PRIVATE_PACKAGE:String = "privateRoom";
      
      public static const LOCATED_IN_TILE:int = 0;
       
      
      private var _dragItem:RoomSceneObject;
      
      private var _dragItemView:RoomSceneObjectView;
      
      private var _dragStart:Coord;
      
      private var _lastDragStart:Coord;
      
      private var room:Room;
      
      private var _dragMoved:Boolean;
      
      private var sceneObjects:TwoWayLink;
      
      private var _stacking:com.qb9.gaturro.world.tiling.StackingHomeObjects;
      
      private var _lastDragItem:RoomSceneObject;
      
      public function MovingHomeObjects(param1:Room, param2:TwoWayLink)
      {
         this._stacking = new com.qb9.gaturro.world.tiling.StackingHomeObjects();
         super();
         this.room = param1;
         this.sceneObjects = param2;
         net.addEventListener(GaturroNetResponses.MOVE_HOME_OBJECT,this.moveConfirmation);
      }
      
      private function ownerMoveObject(param1:Mobject) : void
      {
         var _loc7_:GaturroTile = null;
         var _loc2_:Boolean = param1.getBoolean("success");
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:int = param1.getInteger("id");
         var _loc4_:RoomSceneObject = this.room.sceneObjectById(_loc3_);
         var _loc5_:Array;
         if(!(_loc5_ = param1.getIntegerArray("coord")) || _loc5_.length <= 1)
         {
            return;
         }
         var _loc6_:Coord = new Coord(_loc5_[0],_loc5_[1]);
         if(Boolean(_loc4_) && Boolean(_loc6_))
         {
            _loc4_.placeAt(_loc6_);
            _loc7_ = GaturroTile(this.room.grid.getTileAt(_loc6_.x,_loc6_.y));
            this.stacking.updateStackObjects(this.sceneObjects,_loc7_);
         }
      }
      
      public function refreshStackings(param1:GaturroTileView) : void
      {
         this._stacking.updateStackObjects(this.sceneObjects,GaturroTile(param1.tile),true);
      }
      
      private function isValidTile(param1:Tile) : Boolean
      {
         return param1.children.length === 0 && !param1.blocked;
      }
      
      private function verifyDrop(param1:Mobject) : void
      {
         var _loc2_:Boolean = param1.getBoolean("success");
         if(!_loc2_)
         {
            if(!this._lastDragItem || !this._lastDragStart)
            {
               return;
            }
            this._lastDragItem.placeAt(this._lastDragStart);
            this.stopDrag();
         }
      }
      
      public function isDraggable(param1:RoomSceneObject) : Boolean
      {
         return (this.isEditable || !this.isEditable && this.isPortal(param1)) && !(param1 is AvatarPet || param1 is Avatar) && param1.name.indexOf(PRIVATE_PACKAGE) !== 0 && !("isHomeInteractive" in param1.attributes && param1.attributes["isHomeInteractive"]);
      }
      
      private function simpleDrag(param1:GaturroTileView, param2:GaturroTileView) : Boolean
      {
         if(!this.isValidTile(param2.tile))
         {
            return false;
         }
         this._dragItemView.y = 0;
         this._dragItemView.x = 0;
         this._dragItem.placeAt(param2.tile.coord);
         return true;
      }
      
      public function get dragStart() : Coord
      {
         return this._dragStart;
      }
      
      private function dragOnContainer(param1:GaturroTileView, param2:GaturroTileView) : Boolean
      {
         this._dragItem.placeAt(param2.tile.coord);
         var _loc3_:RoomSceneObject = GaturroTile(param2.tile).container;
         var _loc4_:GaturroRoomSceneObjectView = this.sceneObjects.getItem(_loc3_) as GaturroRoomSceneObjectView;
         var _loc5_:Object = {
            "item":this.dragItem,
            "itemView":this.dragItemView,
            "container":_loc3_,
            "containerView":_loc4_
         };
         if(this._stacking.checkObjectStacking(_loc5_))
         {
            this._stacking.updateStackObjects(this.sceneObjects,GaturroTile(param2.tile));
            return true;
         }
         this._dragItem.placeAt(param1.tile.coord);
         return false;
      }
      
      private function isPortal(param1:RoomSceneObject) : Boolean
      {
         return param1.hasOwnProperty("link");
      }
      
      public function get stacking() : com.qb9.gaturro.world.tiling.StackingHomeObjects
      {
         return this._stacking;
      }
      
      private function dragEntireContainer(param1:GaturroTileView, param2:GaturroTileView) : Boolean
      {
         var _loc3_:RoomSceneObject = null;
         if(!this.isValidTile(param2.tile))
         {
            return false;
         }
         for each(_loc3_ in param1.tile.children)
         {
            if(!(_loc3_ is Avatar))
            {
               _loc3_.placeAt(param2.tile.coord);
            }
         }
         this._stacking.updateStackObjects(this.sceneObjects,GaturroTile(param2.tile));
         return true;
      }
      
      public function stopDrag() : void
      {
         this._lastDragItem = this._dragItem;
         this._lastDragStart = this._dragStart;
         this._dragItem = null;
         this._dragItemView = null;
         this._dragStart = null;
         this._dragMoved = false;
      }
      
      public function get dragMoved() : Boolean
      {
         return this._dragMoved;
      }
      
      public function dropItem(param1:TileGrid, param2:TwoWayLink) : void
      {
         var _loc3_:Coord = null;
         var _loc4_:Coord = null;
         var _loc5_:GaturroTile = null;
         var _loc6_:GaturroTile = null;
         var _loc7_:GaturroTileView = null;
         var _loc8_:GaturroTileView = null;
         if(Boolean(this.dragItem.coord) && !this.dragItem.coord.equals(this._dragStart))
         {
            _loc3_ = this._dragStart;
            _loc4_ = this.dragItem.coord;
            _loc5_ = GaturroTile(param1.getTileAtCoord(_loc3_));
            _loc6_ = GaturroTile(param1.getTileAtCoord(_loc4_));
            _loc7_ = GaturroTileView(param2.getItem(_loc5_));
            _loc8_ = GaturroTileView(param2.getItem(_loc6_));
            this._stacking.updateStackObjects(this.sceneObjects,GaturroTile(_loc7_.tile),true);
            this._stacking.updateStackObjects(this.sceneObjects,GaturroTile(_loc8_.tile),true);
            this.notifyDragToServer(_loc6_);
         }
      }
      
      private function moveConfirmation(param1:NetworkManagerEvent) : void
      {
         if(this.room.ownedByUser)
         {
            this.verifyDrop(param1.mobject);
         }
         else
         {
            this.ownerMoveObject(param1.mobject);
         }
      }
      
      public function get dragItem() : RoomSceneObject
      {
         return this._dragItem;
      }
      
      public function whenTileIsHovered(param1:GaturroTileView, param2:GaturroTileView) : void
      {
         var _loc3_:Coord = !!this.dragItem ? this.dragItem.coord : null;
         var _loc4_:Coord = !!param2 ? param2.tile.coord : null;
         if(!_loc3_ || !_loc4_ || _loc3_.equals(_loc4_))
         {
            return;
         }
         this._stacking.updateStackObjects(this.sceneObjects,GaturroTile(param2.tile),true);
         var _loc5_:Function;
         if((_loc5_ = this.decideAction(param1,param2)) != null)
         {
            this._dragMoved = _loc5_(param1,param2);
         }
      }
      
      private function notifyDragToServer(param1:GaturroTile) : void
      {
         var _loc2_:RoomSceneObject = null;
         for each(_loc2_ in param1.children)
         {
            net.sendAction(new MoveHomeObjectActionRequest(_loc2_.id,_loc2_.coord));
         }
      }
      
      public function get dragItemView() : RoomSceneObjectView
      {
         return this._dragItemView;
      }
      
      public function get isEditable() : Boolean
      {
         return this.room.ownedByUser;
      }
      
      public function startDrag(param1:RoomSceneObject, param2:RoomSceneObjectView) : void
      {
         this._dragItem = param1;
         this._dragItemView = param2;
         this._dragStart = param1.coord;
         this._dragMoved = false;
      }
      
      public function dispose() : void
      {
         this.stopDrag();
         net.removeEventListener("MoveHomeObjectActionResponse",this.moveConfirmation);
         this._lastDragItem = null;
         this._lastDragStart = null;
         this.room = null;
         this._stacking = null;
         this.sceneObjects = null;
      }
      
      private function decideAction(param1:GaturroTileView, param2:GaturroTileView) : Function
      {
         var _loc3_:GaturroTile = GaturroTile(param1.tile);
         var _loc4_:GaturroTile = GaturroTile(param2.tile);
         if(!this.isDraggable(this._dragItem))
         {
            return null;
         }
         if(Boolean(HouseConfig.data.enabled) && this._dragItem.attributes.slots != null)
         {
            return this.dragEntireContainer;
         }
         if(!_loc4_.container)
         {
            return this.simpleDrag;
         }
         if(HouseConfig.data.enabled && _loc4_.container && _loc4_.container.attributes.containmentAllowed != null)
         {
            if(String(_loc4_.container.attributes.containmentAllowed).indexOf(this._dragItem.name) != -1)
            {
               return this.dragOnContainer;
            }
            return this.simpleDrag;
         }
         if(Boolean(HouseConfig.data.enabled) && Boolean(_loc4_.container))
         {
            return this.dragOnContainer;
         }
         return null;
      }
   }
}

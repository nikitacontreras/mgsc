package com.qb9.mambo.view.world
{
   import com.qb9.flashlib.geom.Size;
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.flashlib.lang.foreach;
   import com.qb9.flashlib.tasks.TaskRunner;
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.mambo.geom.Coord;
   import com.qb9.mambo.view.MamboView;
   import com.qb9.mambo.view.world.elements.MovingRoomSceneObjectView;
   import com.qb9.mambo.view.world.elements.PortalView;
   import com.qb9.mambo.view.world.elements.RoomSceneObjectView;
   import com.qb9.mambo.view.world.elements.behaviors.MouseCapturingView;
   import com.qb9.mambo.view.world.events.RoomViewEvent;
   import com.qb9.mambo.view.world.floor.TiledFloorView;
   import com.qb9.mambo.view.world.tiling.BaseTileView;
   import com.qb9.mambo.view.world.tiling.TileView;
   import com.qb9.mambo.view.world.util.TwoWayLink;
   import com.qb9.mambo.world.avatars.Avatar;
   import com.qb9.mambo.world.core.Room;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import com.qb9.mambo.world.core.events.RoomEvent;
   import com.qb9.mambo.world.elements.Portal;
   import com.qb9.mambo.world.tiling.Tile;
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class RoomView extends MamboView
   {
       
      
      protected var tileLayer:Sprite;
      
      protected var tiles:TwoWayLink;
      
      protected var tasks:TaskRunner;
      
      protected var room:Room;
      
      protected var floorLayer:Sprite;
      
      protected var frontLayer:Sprite;
      
      protected var sceneObjects:TwoWayLink;
      
      public function RoomView(param1:Room)
      {
         super();
         this.room = param1;
         this.init();
      }
      
      private function findCapturingObject(param1:DisplayObject) : DisplayObject
      {
         while(Boolean(param1) && param1 !== this.tileLayer)
         {
            if(param1 is MouseCapturingView && MouseCapturingView(param1).captures)
            {
               return param1;
            }
            param1 = param1.parent;
         }
         return null;
      }
      
      override protected function whenAddedToStage() : void
      {
         this.createLayers();
         this.createFloor();
         this.createTiles();
         this.initEvents();
         this.addInitialSceneObjects();
         this.whenReady();
      }
      
      protected function removeSceneObject(param1:RoomEvent) : void
      {
         var _loc2_:RoomSceneObject = param1.sceneObject;
         var _loc3_:DisplayObject = this.sceneObjects.getItem(_loc2_) as DisplayObject;
         this.disposeChild(_loc3_);
         this.sceneObjects.remove(_loc2_);
      }
      
      protected function createPortal(param1:Portal) : DisplayObject
      {
         return new PortalView(param1,this.tiles,this.room);
      }
      
      protected function whenReady() : void
      {
         this.reportReady();
      }
      
      protected function tileSelected(param1:Tile) : void
      {
         this.room.tileSelected(param1);
      }
      
      protected function reportReady() : void
      {
         dispatchEvent(new RoomViewEvent(RoomViewEvent.READY));
      }
      
      protected function checkIfTileSelected(param1:MouseEvent) : void
      {
         var _loc3_:Tile = null;
         var _loc2_:TileView = this.getTileViewFromEvent(param1);
         if(_loc2_)
         {
            _loc3_ = this.tiles.getItem(_loc2_) as Tile;
            this.tileSelected(_loc3_);
         }
      }
      
      protected function createSceneObject(param1:RoomSceneObject) : DisplayObject
      {
         if(param1 is Avatar)
         {
            return this.createAvatar(param1 as Avatar);
         }
         if(param1 is Portal)
         {
            return this.createPortal(param1 as Portal);
         }
         return this.createOtherSceneObject(param1);
      }
      
      protected function initEvents() : void
      {
         this.room.addEventListener(RoomEvent.SCENE_OBJECT_ADDED,this.addSceneObjectFromEvent);
         this.room.addEventListener(RoomEvent.SCENE_OBJECT_REMOVED,this.removeSceneObject);
         addEventListener(MouseEvent.MOUSE_UP,this.checkIfTileSelected,false,-1);
      }
      
      protected function createTile(param1:Tile) : TileView
      {
         return new BaseTileView(param1);
      }
      
      protected function createLayers() : void
      {
         this.floorLayer = this.addLayer(false);
         this.tileLayer = this.addLayer(true);
         this.frontLayer = this.addLayer(false);
      }
      
      protected function init() : void
      {
         this.tasks = new TaskRunner(this);
         this.tasks.start();
         this.tiles = new TwoWayLink();
         this.sceneObjects = new TwoWayLink();
      }
      
      protected function addSceneObject(param1:RoomSceneObject) : void
      {
         var _loc2_:DisplayObject = this.createSceneObject(param1);
         this.sceneObjects.add(param1,_loc2_);
         this.tiles.getItem(param1.tile).addChild(_loc2_);
      }
      
      protected function createOtherSceneObject(param1:RoomSceneObject) : DisplayObject
      {
         return new RoomSceneObjectView(param1,this.tiles);
      }
      
      protected function getTileViewFromEvent(param1:MouseEvent) : TileView
      {
         var _loc4_:TileView = null;
         var _loc5_:DisplayObject = null;
         var _loc6_:DisplayObject = null;
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         if(!this.tileLayer.contains(_loc2_))
         {
            return null;
         }
         var _loc3_:Array = stage.getObjectsUnderPoint(new Point(param1.stageX,param1.stageY));
         for each(_loc6_ in _loc3_)
         {
            if(_loc6_ is TileView)
            {
               _loc4_ ||= _loc6_ as TileView;
            }
            else
            {
               _loc5_ = this.findCapturingObject(_loc6_) || _loc5_;
            }
         }
         if(!_loc5_)
         {
            return Boolean(_loc4_) && _loc4_.mouseEnabled ? _loc4_ : null;
         }
         while(Boolean(_loc5_) && _loc5_ is TileView === false)
         {
            _loc5_ = _loc5_.parent;
         }
         return _loc5_ as TileView;
      }
      
      private function createTiles() : void
      {
         var _loc6_:uint = 0;
         var _loc1_:Size = this.room.grid.size;
         var _loc2_:uint = uint(_loc1_.width);
         var _loc3_:uint = uint(_loc1_.height);
         var _loc4_:Array = [];
         var _loc5_:uint = 0;
         while(_loc5_ < _loc3_)
         {
            _loc6_ = 0;
            while(_loc6_ < _loc2_)
            {
               _loc4_.push(Coord.create(_loc6_,_loc5_));
               _loc6_++;
            }
            _loc5_++;
         }
         foreach(this.zSort(_loc4_),this.addTile);
      }
      
      protected function disposeChild(param1:DisplayObject) : void
      {
         DisplayUtil.stopMovieClip(param1);
         if(param1 is IDisposable)
         {
            IDisposable(param1).dispose();
         }
         DisplayUtil.remove(param1);
      }
      
      protected function addInitialSceneObjects() : void
      {
         foreach(this.room.sceneObjects,this.addSceneObject);
      }
      
      private function addSceneObjectFromEvent(param1:RoomEvent) : void
      {
         this.addSceneObject(param1.sceneObject);
      }
      
      override public function dispose() : void
      {
         var _loc1_:DisplayObject = null;
         if(disposed)
         {
            return;
         }
         this.room.removeEventListener(RoomEvent.SCENE_OBJECT_ADDED,this.addSceneObjectFromEvent);
         this.room.removeEventListener(RoomEvent.SCENE_OBJECT_REMOVED,this.removeSceneObject);
         for each(_loc1_ in DisplayUtil.children(this,true))
         {
            this.disposeChild(_loc1_);
         }
         this.tasks.dispose();
         this.tasks = null;
         removeEventListener(MouseEvent.MOUSE_UP,this.checkIfTileSelected);
         this.tiles.dispose();
         this.tiles = null;
         this.sceneObjects.dispose();
         this.sceneObjects = null;
         this.floorLayer = this.tileLayer = this.frontLayer = null;
         this.room = null;
         super.dispose();
      }
      
      protected function createFloor() : void
      {
         this.floorLayer.addChild(new TiledFloorView(this.room.grid));
      }
      
      protected function createAvatar(param1:Avatar) : DisplayObject
      {
         return new MovingRoomSceneObjectView(param1,this.tasks,this.tiles);
      }
      
      private function addTile(param1:Coord) : void
      {
         var _loc2_:Tile = this.room.grid.getTileAtCoord(param1);
         var _loc3_:InteractiveObject = this.createTile(_loc2_) as InteractiveObject;
         this.tiles.add(_loc2_,_loc3_);
         this.tileLayer.addChild(_loc3_);
      }
      
      protected function addLayer(param1:Boolean) : Sprite
      {
         var _loc2_:Sprite = null;
         _loc2_ = new Sprite();
         _loc2_.mouseEnabled = _loc2_.mouseChildren = param1;
         addChild(_loc2_);
         return _loc2_;
      }
      
      protected function zSort(param1:Array) : Array
      {
         return param1;
      }
   }
}

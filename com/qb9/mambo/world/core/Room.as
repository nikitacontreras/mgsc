package com.qb9.mambo.world.core
{
   import com.qb9.flashlib.geom.Size;
   import com.qb9.flashlib.lang.foreach;
   import com.qb9.flashlib.utils.ObjectUtil;
   import com.qb9.flashlib.utils.StringUtil;
   import com.qb9.mambo.core.attributes.CustomAttributes;
   import com.qb9.mambo.core.attributes.events.CustomAttributesEvent;
   import com.qb9.mambo.core.objects.BaseCustomAttributeDispatcher;
   import com.qb9.mambo.geom.Coord;
   import com.qb9.mambo.net.manager.NetworkManager;
   import com.qb9.mambo.net.manager.NetworkManagerEvent;
   import com.qb9.mambo.net.mobject.MobjectBuildable;
   import com.qb9.mambo.net.requests.customAttributes.UpdateSceneObjectCustomAttributesRequest;
   import com.qb9.mambo.net.requests.user.MoveActionRequest;
   import com.qb9.mambo.user.User;
   import com.qb9.mambo.world.avatars.Avatar;
   import com.qb9.mambo.world.avatars.UserAvatar;
   import com.qb9.mambo.world.avatars.events.MovingRoomSceneObjectEvent;
   import com.qb9.mambo.world.core.events.GeneralEvent;
   import com.qb9.mambo.world.core.events.RoomEvent;
   import com.qb9.mambo.world.elements.MovingRoomSceneObject;
   import com.qb9.mambo.world.elements.Portal;
   import com.qb9.mambo.world.path.EightWayPathFinder;
   import com.qb9.mambo.world.path.Path;
   import com.qb9.mambo.world.path.PathCreator;
   import com.qb9.mambo.world.path.PathFinder;
   import com.qb9.mambo.world.path.TileGridPathMap;
   import com.qb9.mambo.world.tiling.Tile;
   import com.qb9.mambo.world.tiling.TileGrid;
   import com.qb9.mines.mobject.Mobject;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   
   public class Room extends BaseCustomAttributeDispatcher implements MobjectBuildable
   {
      
      private static const DEFAULT_CLICK_DELAY:uint = 500;
      
      private static const DUMP_VARS:Array = ["id","name","coord"];
       
      
      protected var objects:Object;
      
      protected var net:NetworkManager;
      
      private var _grid:TileGrid;
      
      private var updatingAttributes:Dictionary;
      
      private var _id:Number;
      
      protected var pathCreator:PathCreator;
      
      private var walkQueue:int = 0;
      
      protected var user:User;
      
      protected var waitToReposition:Boolean = false;
      
      protected var minClickDelay:uint = 500;
      
      private var lastClickStamp:uint = 0;
      
      protected var avatars:Object;
      
      private var _ownerName:String;
      
      private var _size:Size;
      
      private var _name:String;
      
      private var _coord:Coord;
      
      public function Room(param1:User, param2:NetworkManager)
      {
         this.updatingAttributes = new Dictionary(true);
         super();
         this.user = param1;
         this.net = param2;
      }
      
      public function get ownedByUser() : Boolean
      {
         return StringUtil.icompare(this.ownerName,this.user.username);
      }
      
      final override public function dispatch(param1:String, param2:* = null) : Boolean
      {
         return dispatchEvent(new RoomEvent(param1,param2));
      }
      
      protected function initAvatarEvents() : void
      {
         this.net.addEventListener(NetworkManagerEvent.AVATAR_JOINS,this.avatarPresenceChange);
         this.net.addEventListener(NetworkManagerEvent.AVATAR_LEFT,this.avatarPresenceChange);
         this.net.addEventListener(NetworkManagerEvent.AVATAR_MOVE,this.avatarMoved);
      }
      
      public function get userAvatar() : UserAvatar
      {
         if(!this.user)
         {
            return null;
         }
         var _loc1_:UserAvatar = this.avatarById(this.user.id) as UserAvatar;
         if(!_loc1_)
         {
            warning("The user avatar was not found with id:",this.user.id);
         }
         return _loc1_;
      }
      
      protected function removeAvatarEvents() : void
      {
         this.net.removeEventListener(NetworkManagerEvent.AVATAR_JOINS,this.avatarPresenceChange);
         this.net.removeEventListener(NetworkManagerEvent.AVATAR_LEFT,this.avatarPresenceChange);
         this.net.removeEventListener(NetworkManagerEvent.AVATAR_MOVE,this.avatarMoved);
      }
      
      public function avatarByUsername(param1:String) : Avatar
      {
         if(!this.avatars)
         {
            return null;
         }
         return this.avatars[param1.toLowerCase()] as Avatar;
      }
      
      protected function createPortal(param1:CustomAttributes) : Portal
      {
         return new Portal(param1,this.grid,this.coord);
      }
      
      protected function addSceneObject(param1:Mobject) : void
      {
         var _loc4_:Avatar = null;
         var _loc2_:CustomAttributes = new CustomAttributes();
         _loc2_.buildFromMobject(param1);
         var _loc3_:RoomSceneObject = this.createSceneObject(_loc2_,param1);
         _loc2_.assignTo(_loc3_);
         _loc3_.buildFromMobject(param1);
         if(_loc3_.id in this.objects)
         {
            return warning("sceneObject",_loc3_,"was already in this room");
         }
         this.objects[_loc3_.id] = _loc3_;
         if(_loc3_.monitorAttributes)
         {
            _loc3_.addEventListener(CustomAttributesEvent.CHANGED,this.sendSceneObjectCustomAttribute);
         }
         if(_loc3_ is MovingRoomSceneObject)
         {
            _loc3_.addEventListener(MovingRoomSceneObjectEvent.WANTS_TO_MOVE,this.whenSceneObjectWantsToMove);
         }
         if(_loc3_ is Avatar)
         {
            _loc4_ = _loc3_ as Avatar;
            if(Boolean(this.avatarById(_loc4_.avatarId)) || Boolean(this.avatarByUsername(_loc4_.username)))
            {
               return warning("Avatar",_loc4_,"was already in this room");
            }
            this.avatars[_loc4_.avatarId] = this.avatars[_loc4_.username.toLowerCase()] = _loc3_;
         }
         this.dispatch(RoomEvent.SCENE_OBJECT_ADDED,_loc3_);
      }
      
      protected function moveObjectTo(param1:MovingRoomSceneObject, param2:Coord) : void
      {
         if(!this.pathCreator)
         {
            return;
         }
         var _loc3_:Path = this.pathCreator.getPath(param1.coord,param2);
         if(_loc3_)
         {
            this.moveObjectBy(param1,_loc3_);
         }
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function createSceneObjectFromMobject(param1:Mobject) : void
      {
         this.addSceneObject(param1);
      }
      
      public function get size() : Size
      {
         return this._size;
      }
      
      public function buildFromMobject(param1:Mobject) : void
      {
         this._id = param1.getInteger("id");
         this._name = param1.getString("name");
         this._coord = Coord.fromArray(param1.getIntegerArray("coord"));
         this._size = Size.fromArray(param1.getIntegerArray("size"));
         this._ownerName = param1.getString("ownerUsername");
         this._grid = this.getNewTileGrid();
         this.grid.buildFromMobject(param1);
         _attributes = new CustomAttributes(this);
         attributes.buildFromMobject(param1);
         var _loc2_:Array = param1.getMobjectArray("sceneObjects");
         this.whenInitialSceneObjectsAreLoaded(_loc2_);
      }
      
      protected function getNewTileGrid() : TileGrid
      {
         return new TileGrid();
      }
      
      override public function dispose() : void
      {
         var _loc1_:RoomSceneObject = null;
         debug("Disposing room with id",this.id);
         if(disposed)
         {
            return;
         }
         this.removeAvatarEvents();
         this.removeObjectEvents();
         dispatchEvent(new GeneralEvent(GeneralEvent.DISPOSED));
         for each(_loc1_ in this.objects)
         {
            _loc1_.dispose();
         }
         this.objects = this.avatars = null;
         this.grid.dispose();
         this._grid = null;
         this.user = null;
         this.pathCreator = null;
         this.net = null;
         this._size = null;
         this._coord = null;
         super.dispose();
      }
      
      protected function createUserAvatar(param1:CustomAttributes) : UserAvatar
      {
         return new UserAvatar(param1,this.grid,this.user);
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      protected function whenSceneObjectWantsToMove(param1:MovingRoomSceneObjectEvent) : void
      {
         this.moveObjectTo(param1.object,param1.coord);
      }
      
      public function get hasOwner() : Boolean
      {
         return this.ownerName !== null;
      }
      
      public function get owner() : Avatar
      {
         return this.hasOwner ? this.avatarByUsername(this.ownerName) : null;
      }
      
      private function avatarPresenceChange(param1:NetworkManagerEvent) : void
      {
         if(disposed)
         {
            return;
         }
         var _loc2_:Mobject = param1.mobject;
         var _loc3_:Number = Number(_loc2_.getInteger("avatarId") || _loc2_.getInteger("id"));
         if(!_loc3_ || _loc3_ === this.user.id)
         {
            return;
         }
         if(param1.type === NetworkManagerEvent.AVATAR_JOINS)
         {
            info("Avatar(" + _loc3_ + ") joined room");
            this.addSceneObject(_loc2_.getMobject("sceneObject"));
         }
         else
         {
            info("Avatar(" + _loc3_ + ") left room");
            this.removeAvatar(_loc2_.getInteger("avatarId"));
         }
      }
      
      public function get grid() : TileGrid
      {
         return this._grid;
      }
      
      protected function initEvents() : void
      {
         this.initAvatarEvents();
         this.initObjectEvents();
      }
      
      protected function createPathFinder() : PathFinder
      {
         return new EightWayPathFinder(true);
      }
      
      protected function createSceneObject(param1:CustomAttributes, param2:Mobject) : RoomSceneObject
      {
         var _loc3_:* = false;
         if(param2.getMobject("avatar"))
         {
            _loc3_ = Number(param2.getString("id")) === this.user.sceneObjectId;
            return _loc3_ ? this.createUserAvatar(param1) : this.createAvatar(param1);
         }
         if(param2.getMobject("link"))
         {
            return this.createPortal(param1);
         }
         return this.createUnknownSceneObject(param1,param2);
      }
      
      public function changeTo(param1:RoomLink) : void
      {
         this.dispatch(RoomEvent.CHANGE_ROOM,param1);
      }
      
      protected function disposeSceneObject(param1:RoomSceneObject) : void
      {
         param1.dispose();
      }
      
      protected function initHelpers() : void
      {
         this.pathCreator = new PathCreator(this.createPathFinder(),new TileGridPathMap(this.grid));
      }
      
      protected function removeSceneObject(param1:Number) : void
      {
         var _loc2_:RoomSceneObject = this.sceneObjectById(param1);
         delete this.objects[param1];
         if(!_loc2_)
         {
            return warning("Trying to remove a scene object that isn\'t in the room:",param1);
         }
         this.dispatch(RoomEvent.SCENE_OBJECT_REMOVED,_loc2_);
         this.disposeSceneObject(_loc2_);
      }
      
      override protected function get dumpVars() : Array
      {
         return DUMP_VARS;
      }
      
      private function sceneObjectJoinsRoom(param1:NetworkManagerEvent) : void
      {
         var _loc2_:Mobject = param1.mobject;
         info("Scene Object(" + _loc2_.getString("id") + ") joined room");
         this.addSceneObject(_loc2_);
      }
      
      public function avatarById(param1:Number) : Avatar
      {
         return this.avatars[param1] as Avatar;
      }
      
      public function sceneObjectById(param1:Number) : RoomSceneObject
      {
         return this.objects[param1] as RoomSceneObject;
      }
      
      public function get ownerName() : String
      {
         return this._ownerName;
      }
      
      protected function addAvatar(param1:Avatar) : void
      {
         this.avatars[param1.avatarId] = this.avatars[param1.username.toLowerCase()] = param1;
      }
      
      private function sceneObjectLeavesRoom(param1:NetworkManagerEvent) : void
      {
         var _loc2_:Number = Number(param1.mobject.getString("sceneObjectId"));
         info("Scene Object(" + _loc2_ + ") left room");
         this.removeSceneObject(_loc2_);
      }
      
      protected function removeObjectEvents() : void
      {
         this.net.removeEventListener(NetworkManagerEvent.OBJECT_JOINS,this.sceneObjectJoinsRoom);
         this.net.removeEventListener(NetworkManagerEvent.OBJECT_LEFT,this.sceneObjectLeavesRoom);
         this.net.removeEventListener(NetworkManagerEvent.CUSTOM_ATTRIBUTES_CHANGED,this.updateCustomAttributesFromEvent);
      }
      
      protected function createUnknownSceneObject(param1:CustomAttributes, param2:Mobject) : RoomSceneObject
      {
         return new RoomSceneObject(param1,this.grid);
      }
      
      protected function whenInitialSceneObjectsAreLoaded(param1:Array) : void
      {
         this.initHelpers();
         this.initEvents();
         this.objects = {};
         this.avatars = {};
         foreach(param1,this.addSceneObject);
      }
      
      protected function initObjectEvents() : void
      {
         this.net.addEventListener(NetworkManagerEvent.OBJECT_JOINS,this.sceneObjectJoinsRoom);
         this.net.addEventListener(NetworkManagerEvent.OBJECT_LEFT,this.sceneObjectLeavesRoom);
         this.net.addEventListener(NetworkManagerEvent.CUSTOM_ATTRIBUTES_CHANGED,this.updateCustomAttributesFromEvent);
      }
      
      public function tileSelected(param1:Tile) : void
      {
         if(getTimer() - this.lastClickStamp < this.minClickDelay)
         {
            return;
         }
         this.lastClickStamp = getTimer();
         var _loc2_:Coord = this.userAvatar.coord;
         var _loc3_:Coord = param1.coord;
         if(_loc3_.equals(_loc2_))
         {
            return param1.activate(this.userAvatar);
         }
         var _loc4_:Path;
         if(!(_loc4_ = this.pathCreator.getPath(_loc2_,_loc3_)))
         {
            if(_loc3_.neighbors(_loc2_))
            {
               param1.activate(this.userAvatar);
            }
            return;
         }
         info("Tile was selected:",_loc3_);
         this.net.sendAction(new MoveActionRequest(_loc4_.toArray()));
         ++this.walkQueue;
         this.moveObjectBy(this.userAvatar,_loc4_);
      }
      
      protected function moveObjectBy(param1:MovingRoomSceneObject, param2:Path) : void
      {
         param1.moveBy(param2);
      }
      
      private function sendSceneObjectCustomAttribute(param1:CustomAttributesEvent) : void
      {
         var _loc2_:RoomSceneObject = param1.target as RoomSceneObject;
         if(!this.updatingAttributes[_loc2_])
         {
            this.net.sendAction(new UpdateSceneObjectCustomAttributesRequest(_loc2_.id,param1.attributes));
         }
      }
      
      private function avatarMoved(param1:NetworkManagerEvent) : void
      {
         var _loc2_:Mobject = param1.mobject;
         var _loc3_:Number = Number(_loc2_.getString("id"));
         var _loc4_:Avatar = this.sceneObjectById(_loc3_) as Avatar;
         var _loc5_:Coord = Coord.fromArray(_loc2_.getIntegerArray("coord"));
         if(!_loc4_)
         {
            return warning("The server requested to move an unknown avatar, sceneObject id is",_loc3_);
         }
         if(_loc4_ is UserAvatar === false)
         {
            return this.moveObjectTo(_loc4_,_loc5_);
         }
         if(this.waitToReposition && --this.walkQueue > 0)
         {
            return;
         }
         this.walkQueue = 0;
         _loc4_.limit(_loc5_);
      }
      
      protected function createAvatar(param1:CustomAttributes) : Avatar
      {
         return new Avatar(param1,this.grid);
      }
      
      public function get sceneObjects() : Array
      {
         return ObjectUtil.values(this.objects);
      }
      
      public function moveToTile(param1:Coord) : void
      {
         var _loc2_:Coord = this.userAvatar.coord;
         var _loc3_:Path = this.pathCreator.getPath(_loc2_,param1);
         if(!_loc3_)
         {
            return;
         }
         info("Moved avatar to tile:",param1);
         this.net.sendAction(new MoveActionRequest(_loc3_.toArray()));
         ++this.walkQueue;
         this.moveObjectBy(this.userAvatar,_loc3_);
      }
      
      public function moveToTileXY(param1:int, param2:int) : void
      {
         var _loc3_:Coord = this.userAvatar.coord;
         var _loc4_:Coord = new Coord(param1,param2);
         var _loc5_:Path;
         if(!(_loc5_ = this.pathCreator.getPath(_loc3_,_loc4_)))
         {
            return;
         }
         info("Moved avatar to tile:",_loc4_);
         this.net.sendAction(new MoveActionRequest(_loc5_.toArray()));
         ++this.walkQueue;
         this.moveObjectBy(this.userAvatar,_loc5_);
      }
      
      public function get coord() : Coord
      {
         return this._coord;
      }
      
      protected function removeAvatar(param1:Number) : void
      {
         var _loc2_:Avatar = this.avatars[param1];
         if(!_loc2_)
         {
            return warning("Could not find the avatar by id",param1,"to remove it");
         }
         delete this.avatars[param1];
         delete this.avatars[_loc2_.username.toLowerCase()];
         this.removeSceneObject(_loc2_.id);
      }
      
      private function updateCustomAttributesFromEvent(param1:NetworkManagerEvent) : void
      {
         var _loc2_:Mobject = param1.mobject;
         var _loc3_:Number = Number(_loc2_.getString("sceneObjectId"));
         if(!_loc3_)
         {
            return;
         }
         var _loc4_:RoomSceneObject;
         if(!(_loc4_ = this.sceneObjectById(_loc3_)))
         {
            return warning("SceneObject with id",_loc3_,"not found while trying to update its customAttributes");
         }
         this.updatingAttributes[_loc4_] = true;
         _loc4_.attributes.mergeMobject(_loc2_,!_loc4_.monitorAttributes);
         delete this.updatingAttributes[_loc4_];
      }
   }
}

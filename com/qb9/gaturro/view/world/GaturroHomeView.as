package com.qb9.gaturro.view.world
{
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.net;
   import com.qb9.gaturro.net.GaturroNetResponses;
   import com.qb9.gaturro.net.requests.house.BuyRoomActionRequest;
   import com.qb9.gaturro.tutorial.TutorialManager;
   import com.qb9.gaturro.view.gui.closet.GuiCloset;
   import com.qb9.gaturro.view.gui.granja.GranjeroTutorial;
   import com.qb9.gaturro.view.gui.home.GuiHouseMap;
   import com.qb9.gaturro.view.gui.home.ShowBuildingTimeModal;
   import com.qb9.gaturro.view.gui.home.ShowRoomBuildingTimeEvent;
   import com.qb9.gaturro.view.world.cursor.Cursor;
   import com.qb9.gaturro.view.world.elements.GaturroLeaveHomePortalView;
   import com.qb9.gaturro.view.world.elements.GaturroRoomSceneObjectView;
   import com.qb9.gaturro.view.world.elements.LeaveHomeRoomSceneObjectView;
   import com.qb9.gaturro.view.world.elements.NpcRoomSceneObjectView;
   import com.qb9.gaturro.view.world.events.GaturroRoomViewEvent;
   import com.qb9.gaturro.view.world.tiling.GaturroTileView;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.core.elements.HomeInteractiveRoomSceneObject;
   import com.qb9.gaturro.world.core.elements.NpcRoomSceneObject;
   import com.qb9.gaturro.world.core.elements.events.GaturroRoomSceneObjectEvent;
   import com.qb9.gaturro.world.npc.struct.behavior.NpcBehaviorEvent;
   import com.qb9.gaturro.world.reports.InfoReportQueue;
   import com.qb9.gaturro.world.tiling.GaturroTile;
   import com.qb9.gaturro.world.tiling.MovingHomeObjects;
   import com.qb9.mambo.core.attributes.CustomAttributes;
   import com.qb9.mambo.core.attributes.events.CustomAttributeEvent;
   import com.qb9.mambo.geom.Coord;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import com.qb9.mambo.net.mail.Mailer;
   import com.qb9.mambo.net.manager.NetworkManagerEvent;
   import com.qb9.mambo.view.world.elements.RoomSceneObjectView;
   import com.qb9.mambo.view.world.tiling.TileView;
   import com.qb9.mambo.world.avatars.Avatar;
   import com.qb9.mambo.world.avatars.events.MovingRoomSceneObjectEvent;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import com.qb9.mambo.world.core.events.RoomEvent;
   import com.qb9.mambo.world.elements.Portal;
   import com.qb9.mambo.world.tiling.Tile;
   import com.qb9.mines.mobject.Mobject;
   import config.HouseConfig;
   import farm.Countdown;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   
   public class GaturroHomeView extends GaturroRoomView
   {
      
      private static const WALL_X:uint = 15;
      
      private static const IS_WALL:RegExp = /privateRoom.pared*/;
       
      
      private var moving:MovingHomeObjects;
      
      private var lastRoomObject:RoomSceneObject;
      
      private var houseOwner:Avatar;
      
      public function GaturroHomeView(param1:GaturroRoom, param2:InfoReportQueue, param3:Mailer, param4:WhiteListNode)
      {
         super(param1,param2,param3,param4);
         this.moving = new MovingHomeObjects(param1,this.sceneObjects);
         this.loadCustomAttributesInSettings();
      }
      
      private function onCountDownEnterFrame(param1:Event) : void
      {
         if(param1.target.currentFrame == param1.target.totalFrames)
         {
            if(gRoom)
            {
               gRoom.visit(gRoom.userAvatar.username);
            }
            param1.target.removeEventListener(Event.ENTER_FRAME,this.onCountDownEnterFrame);
         }
      }
      
      override protected function whenMouseChangesPosition(param1:MouseEvent) : void
      {
         var _loc6_:TileView = null;
         var _loc7_:* = false;
         var _loc2_:DisplayObjectContainer = param1.target as DisplayObjectContainer;
         var _loc3_:TileView = getTileViewFromEvent(param1);
         var _loc4_:Tile = !!_loc3_ ? _loc3_.tile : null;
         var _loc5_:RoomSceneObject = this.getRoomObjectBySprite(_loc2_);
         if(!_loc4_ && !_loc5_)
         {
            this.lastRoomObject = null;
            if(cursor)
            {
               cursor.visible = false;
            }
            rolloutLastTile();
         }
         else
         {
            if(_loc4_ && _loc4_.children.length == 2 && _loc4_.children[0] is Portal)
            {
               this.lastRoomObject = null;
               super.whenMouseChangesPosition(param1);
               return;
            }
            if(Boolean(_loc5_) && _loc5_.tile.children.length >= 2)
            {
               if(_loc5_ == this.lastRoomObject)
               {
                  return;
               }
               if(_loc5_ && _loc5_.attributes.slots || this.lastRoomObject && this.lastRoomObject.attributes.slots)
               {
                  this.rolloutLastObject();
                  if(Boolean(lastTile) && lastTile.tile.children.length == 1)
                  {
                     rolloutLastTile();
                  }
               }
               else
               {
                  _loc7_ = !(Boolean(_loc5_) && Boolean(this.lastRoomObject) && _loc5_.tile == this.lastRoomObject.tile);
                  rolloutLastTile(_loc7_);
               }
               this.lastRoomObject = _loc5_;
               if((Boolean(_loc6_ = !_loc5_ ? null : TileView(tiles.getItem(_loc5_.tile)))) && lastTile != _loc6_)
               {
                  lastTile = _loc6_;
               }
               if(_loc6_)
               {
                  this.whenObjectIsHovered(_loc6_,_loc5_);
               }
            }
            else if(Boolean(_loc4_) && _loc4_.children.length <= 1)
            {
               this.lastRoomObject = null;
               super.whenMouseChangesPosition(param1);
               return;
            }
         }
      }
      
      override protected function createMapHomeButtons() : IDisposable
      {
         return new GuiHouseMap(gui,gRoom,true,this.buyRoom);
      }
      
      private function saveLastObjectClicked(param1:TileView, param2:DisplayObjectContainer) : void
      {
         var _loc3_:RoomSceneObject = this.getRoomObjectBySprite(param2);
         if(_loc3_)
         {
            GaturroTile(param1.tile).lastObjectClicked = _loc3_;
         }
      }
      
      private function whenAssetIsLoaded(param1:Event) : void
      {
         var _loc4_:GaturroTileView = null;
         EventDispatcher(param1.currentTarget).removeEventListener(GaturroRoomViewEvent.ASSET_ADDED_COMPLETE,this.whenAssetIsLoaded);
         var _loc2_:DisplayObject = GaturroRoomSceneObjectView(param1.currentTarget);
         var _loc3_:RoomSceneObject = sceneObjects.getItem(_loc2_) as RoomSceneObject;
         this.moving.stacking.checkSlotsAttribute(_loc3_,_loc2_);
         var _loc5_:DisplayObjectContainer = _loc2_.parent;
         while(_loc5_ != null)
         {
            if(_loc5_ is GaturroTileView)
            {
               _loc4_ = GaturroTileView(_loc5_);
               break;
            }
            _loc5_ = _loc5_.parent;
         }
         if(!_loc4_)
         {
            return;
         }
         this.moving.refreshStackings(_loc4_);
         GaturroTile(_loc4_.tile).refreshContainer();
      }
      
      protected function rolloutLastObject() : void
      {
         var _loc1_:DisplayObject = DisplayObject(sceneObjects.getItem(this.lastRoomObject));
         if(_loc1_)
         {
            deactivateSceneObject(_loc1_);
         }
      }
      
      override protected function removeSceneObject(param1:RoomEvent) : void
      {
         super.removeSceneObject(param1);
         if(param1.sceneObject is Avatar && param1.sceneObject == this.houseOwner)
         {
            this.houseOwner.removeCustomAttributeListener("message",this.onHomeOwnerMessage);
         }
      }
      
      override protected function buyRoom(param1:int) : void
      {
         GaturroRoom(this.room).buyRoomRequest(param1);
      }
      
      override protected function initEvents() : void
      {
         super.initEvents();
         room.userAvatar.addEventListener(MovingRoomSceneObjectEvent.MOVE_STEP,this.evalUserPos);
         room.addEventListener(ShowRoomBuildingTimeEvent.SHOW,this.showRoomBuildingTime);
         if(this.moving.isEditable)
         {
            addEventListener(MouseEvent.MOUSE_DOWN,this.checkStartDrag);
         }
      }
      
      override protected function addSceneObject(param1:RoomSceneObject) : void
      {
         var _loc2_:DisplayObject = createSceneObject(param1);
         sceneObjects.add(param1,_loc2_);
         tiles.getItem(param1.tile).addChild(_loc2_);
         if(_loc2_ is GaturroRoomSceneObjectView)
         {
            _loc2_.addEventListener(GaturroRoomViewEvent.ASSET_ADDED_COMPLETE,this.whenAssetIsLoaded);
         }
      }
      
      protected function addSceneObjects() : void
      {
         var _loc4_:Object = null;
         var _loc5_:Mobject = null;
         var _loc6_:Array = null;
         var _loc7_:Mobject = null;
         var _loc8_:Mobject = null;
         var _loc9_:int = 0;
         var _loc10_:GaturroTile = null;
         var _loc1_:int = GaturroRoom(room).getThisRoomNum();
         if(_loc1_ == -1)
         {
            _loc1_ = 1;
         }
         var _loc2_:Array = HouseConfig.data.rooms[_loc1_ - 1].sceneObjects;
         var _loc3_:int = 0;
         for each(_loc4_ in _loc2_)
         {
            _loc3_++;
            (_loc5_ = new Mobject()).setString("id",String(_loc3_));
            _loc5_.setString("name",_loc4_.name);
            _loc6_ = [];
            if(_loc4_.customAttributes)
            {
               _loc6_ = _loc4_.customAttributes;
            }
            if(_loc4_.link)
            {
               if(!HouseConfig.data.enabled)
               {
                  continue;
               }
               if(_loc4_.link.id > 0 && GaturroRoom(room).getRoomId(_loc4_.link.id) == -1)
               {
                  _loc6_.push({
                     "type":"inactive",
                     "data":"true"
                  });
               }
               else
               {
                  _loc3_++;
                  (_loc7_ = new Mobject()).setString("id",String(_loc3_));
                  _loc7_.setString("name","");
                  _loc7_.setIntegerArray("size",_loc4_.size);
                  _loc7_.setIntegerArray("coord",_loc4_.coord);
                  _loc8_ = new Mobject();
                  _loc9_ = _loc4_.link.id <= 0 ? int(_loc4_.link.id) : GaturroRoom(room).getRoomId(_loc4_.link.id);
                  _loc8_.setInteger("roomId",_loc9_);
                  _loc8_.setIntegerArray("worldCoord",[0,0,0]);
                  _loc8_.setIntegerArray("coord",_loc4_.link.destCoord);
                  _loc7_.setMobjectArray("customAttributes",this.addAttributes(_loc4_.link.customAttributes));
                  _loc7_.setMobject("link",_loc8_);
                  room.createSceneObjectFromMobject(_loc7_);
                  (_loc10_ = GaturroTile(room.grid.getTileAt(_loc4_.coord[0],_loc4_.coord[1]))).unlockTile();
               }
            }
            if(_loc6_.length > 0)
            {
               _loc5_.setMobjectArray("customAttributes",this.addAttributes(_loc6_));
            }
            _loc5_.setIntegerArray("size",_loc4_.size);
            _loc5_.setIntegerArray("coord",_loc4_.coord);
            room.createSceneObjectFromMobject(_loc5_);
         }
         gui.houseMap.tutorialArrow.visible = false;
         if(!room.ownedByUser)
         {
            return;
         }
         if(!TutorialManager.isTutorialDone())
         {
            return;
         }
      }
      
      private function getRoomObjectBySprite(param1:DisplayObject = null) : RoomSceneObject
      {
         var _loc2_:RoomSceneObject = null;
         while(param1)
         {
            _loc2_ = RoomSceneObject(sceneObjects.getItem(param1));
            if(_loc2_)
            {
               if(_loc2_ is HomeInteractiveRoomSceneObject || this.moving.isDraggable(_loc2_))
               {
                  return _loc2_;
               }
            }
            param1 = param1.parent is DisplayObjectContainer ? param1.parent : null;
         }
         return null;
      }
      
      private function evalUserPos(param1:Event = null) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc2_:* = room.userAvatar.coord.x >= WALL_X;
         for each(_loc3_ in this.walls)
         {
            _loc3_.visible = _loc2_;
         }
      }
      
      private function checkStartDrag(param1:MouseEvent) : void
      {
         var _loc2_:RoomSceneObject = null;
         if(param1.target is TileView)
         {
            _loc2_ = this.getRoomObjectByTile(TileView(param1.target).tile);
         }
         else
         {
            _loc2_ = this.getRoomObjectBySprite(DisplayObject(param1.target));
         }
         if(!_loc2_ || _loc2_ is Portal)
         {
            return;
         }
         this.moving.startDrag(_loc2_,RoomSceneObjectView(sceneObjects.getItem(_loc2_)));
      }
      
      override protected function isActivable(param1:DisplayObject) : Boolean
      {
         if(param1 is LeaveHomeRoomSceneObjectView)
         {
            return true;
         }
         return this.isSceneObjectDraggable(param1) || this.isSceneObjectHomeInteractive(param1);
      }
      
      private function onHomeOwnerMessage(param1:CustomAttributeEvent) : void
      {
         var _loc5_:NpcRoomSceneObjectView = null;
         var _loc7_:NpcRoomSceneObject = null;
         var _loc2_:Array = param1.attribute.value.split(":");
         var _loc3_:String = String(_loc2_[0]);
         var _loc4_:String = String(_loc2_[1]);
         var _loc6_:int = 0;
         while(_loc6_ < room.sceneObjects.length)
         {
            if(room.sceneObjects[_loc6_] is NpcRoomSceneObject)
            {
               if((_loc7_ = room.sceneObjects[_loc6_]).behaviorName == _loc3_)
               {
                  _loc5_ = sceneObjects.getItem(_loc7_) as NpcRoomSceneObjectView;
               }
            }
            _loc6_++;
         }
         if(!_loc5_)
         {
            return;
         }
         if(_loc4_ == "multiplayerActivate")
         {
            _loc5_.dispatchEvent(new Event(NpcBehaviorEvent.MULTIPLAYER_ACTIVATE));
            return;
         }
         _loc5_.multiplayerCustomEvent(_loc4_);
      }
      
      override protected function checkIfTileSelected(param1:MouseEvent) : void
      {
         var _loc2_:TileView = null;
         if(this.moving.dragMoved)
         {
            this.moving.dropItem(room.grid,tiles);
         }
         else
         {
            _loc2_ = getTileViewFromEvent(param1);
            if(Boolean(_loc2_) && param1.target is DisplayObjectContainer)
            {
               this.saveLastObjectClicked(_loc2_,DisplayObjectContainer(param1.target));
            }
            super.checkIfTileSelected(param1);
         }
         rolloutLastTile();
         if(this.moving)
         {
            this.moving.stopDrag();
         }
      }
      
      override protected function getSelectedCursor(param1:DisplayObject) : String
      {
         return this.isSceneObjectDraggable(param1) ? Cursor.DRAG : Cursor.HAND;
      }
      
      override protected function createPortal(param1:Portal) : DisplayObject
      {
         if(param1.link.roomId == -100)
         {
            return new GaturroLeaveHomePortalView(param1,tiles,gRoom,cursor);
         }
         return super.createPortal(param1);
      }
      
      private function granjaBuyResponse(param1:NetworkManagerEvent) : void
      {
         if(net)
         {
            net.removeEventListener(GaturroNetResponses.BUY_ROOM,this.granjaBuyResponse);
         }
         this.setCountdown();
         api.setProfileAttribute(GaturroHomeGranjaView.TUTORIAL_NAME,2);
      }
      
      override protected function createHomeGuiButton() : IDisposable
      {
         if(room.ownedByUser)
         {
            return new GuiCloset(gui,tasks,gRoom);
         }
         return super.createHomeGuiButton();
      }
      
      public function triggerGranjaBuy() : void
      {
         net.addEventListener(GaturroNetResponses.BUY_ROOM,this.granjaBuyResponse);
         net.sendAction(new BuyRoomActionRequest(10));
      }
      
      private function isSceneObjectHomeInteractive(param1:DisplayObject) : Boolean
      {
         var _loc2_:RoomSceneObject = sceneObjects.getItem(param1) as RoomSceneObject;
         return "isHomeInteractive" in _loc2_.attributes && Boolean(_loc2_.attributes["isHomeInteractive"]);
      }
      
      private function addAttributes(param1:Array) : Array
      {
         var _loc3_:Object = null;
         var _loc4_:Mobject = null;
         var _loc2_:Array = new Array();
         for each(_loc3_ in param1)
         {
            (_loc4_ = new Mobject()).setString("type",_loc3_.type);
            _loc4_.setString("data",_loc3_.data);
            _loc2_.push(_loc4_);
         }
         return _loc2_;
      }
      
      override protected function whenTryingToGrab(param1:GaturroRoomSceneObjectEvent) : void
      {
      }
      
      override protected function whenTileIsHovered(param1:TileView) : void
      {
         super.whenTileIsHovered(param1);
         this.execDragMovement(param1);
      }
      
      private function isSceneObjectDraggable(param1:DisplayObject) : Boolean
      {
         var _loc2_:RoomSceneObject = sceneObjects.getItem(param1) as RoomSceneObject;
         return this.moving.isDraggable(_loc2_);
      }
      
      private function get walls() : Array
      {
         var _loc2_:RoomSceneObject = null;
         var _loc1_:Array = [];
         for each(_loc2_ in room.sceneObjects)
         {
            if(Boolean(_loc2_) && IS_WALL.test(_loc2_.name))
            {
               _loc1_.push(sceneObjects.getItem(_loc2_));
            }
         }
         return _loc1_;
      }
      
      override public function dispose() : void
      {
         if(room)
         {
            room.removeEventListener(ShowRoomBuildingTimeEvent.SHOW,this.showRoomBuildingTime);
            room.userAvatar.removeEventListener(MovingRoomSceneObjectEvent.MOVE_STEP,this.evalUserPos);
         }
         this.moving.dispose();
         this.moving = null;
         this.lastRoomObject = null;
         removeEventListener(MouseEvent.MOUSE_DOWN,this.checkStartDrag);
         super.dispose();
      }
      
      private function setCountdown() : void
      {
         var _loc1_:Countdown = new Countdown();
         _loc1_.x = 100;
         _loc1_.y = 100;
         gui.phTop.addChild(_loc1_);
         _loc1_.gotoAndPlay(1);
         _loc1_.addEventListener(Event.ENTER_FRAME,this.onCountDownEnterFrame);
      }
      
      protected function execDragMovement(param1:TileView) : void
      {
         var _loc2_:GaturroTile = null;
         var _loc3_:GaturroTileView = null;
         var _loc4_:GaturroTileView = null;
         if(Boolean(this.moving.dragItem) && Boolean(this.moving.dragItem.coord))
         {
            cursor.pointer = Cursor.DRAG;
            _loc2_ = GaturroTile(room.grid.getTileAtCoord(this.moving.dragItem.coord));
            _loc3_ = GaturroTileView(tiles.getItem(_loc2_));
            _loc4_ = GaturroTileView(param1);
            this.moving.whenTileIsHovered(_loc3_,_loc4_);
         }
      }
      
      override protected function createAvatar(param1:Avatar) : DisplayObject
      {
         if(room.owner == param1)
         {
            this.houseOwner = param1;
            this.houseOwner.addCustomAttributeListener("message",this.onHomeOwnerMessage);
         }
         return super.createAvatar(param1);
      }
      
      private function loadCustomAttributesInSettings() : void
      {
         var _loc1_:int = GaturroRoom(room).getThisRoomNum();
         if(_loc1_ == -1)
         {
            return;
         }
         var _loc2_:Array = HouseConfig.data.rooms[_loc1_ - 1].customAttributes;
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:CustomAttributes = new CustomAttributes();
         var _loc4_:Mobject;
         (_loc4_ = new Mobject()).setMobjectArray("customAttributes",this.addAttributes(_loc2_));
         this.room.attributes.buildFromMobject(_loc4_);
      }
      
      protected function whenObjectIsHovered(param1:TileView, param2:RoomSceneObject) : void
      {
         var _loc3_:DisplayObject = null;
         if(param2)
         {
            _loc3_ = whenObjectHovered(DisplayObject(sceneObjects.getItem(param2)));
         }
         checkCursorState(_loc3_);
         this.execDragMovement(param1);
      }
      
      private function showRoomBuildingTime(param1:ShowRoomBuildingTimeEvent) : void
      {
         var _loc2_:ShowBuildingTimeModal = new ShowBuildingTimeModal(param1.time);
         gui.addModal(_loc2_);
      }
      
      private function addGranjaTutorial() : void
      {
         gui.houseMap.tutorialArrow.visible = false;
         var _loc1_:int = api.getProfileAttribute(GaturroHomeGranjaView.TUTORIAL_NAME) as int;
         if(_loc1_ >= 3)
         {
            return;
         }
         var _loc2_:Object = {
            "api":api,
            "gui":gui
         };
         var _loc3_:GranjeroTutorial = new GranjeroTutorial(_loc2_);
         gui.phTop.addChild(_loc3_);
         gui.houseMap.granjaBground.visible = false;
         gui.houseMap.btn10.visible = false;
         if(_loc1_ == 0)
         {
            api.showBannerModal("construyeGranja");
            api.setProfileAttribute(GaturroHomeGranjaView.TUTORIAL_NAME,1);
         }
         if(_loc1_ == 2)
         {
            gui.houseMap.tutorialArrow.visible = true;
            gui.houseMap.granjaBground.visible = true;
            gui.houseMap.btn10.visible = true;
         }
      }
      
      private function getRoomObjectByTile(param1:Tile) : RoomSceneObject
      {
         var _loc3_:RoomSceneObject = null;
         var _loc4_:RoomSceneObject = null;
         var _loc2_:Array = param1.children;
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.attributes.slots)
            {
               return _loc3_;
            }
         }
         for each(_loc4_ in _loc2_)
         {
            if(this.moving.isDraggable(_loc4_))
            {
               return _loc4_;
            }
         }
         return null;
      }
      
      override protected function whenAddedToStage() : void
      {
         super.whenAddedToStage();
         this.evalUserPos();
         this.addSceneObjects();
      }
      
      override protected function zSort(param1:Array) : Array
      {
         var _loc4_:Coord = null;
         if(GaturroRoom(this.room).getThisRoomNum() != 1)
         {
            return super.zSort(param1);
         }
         var _loc2_:Array = [];
         var _loc3_:int = int(param1.length - 1);
         while(_loc3_ >= 0)
         {
            if((_loc4_ = param1[_loc3_]).x >= WALL_X)
            {
               _loc2_.push(_loc4_);
               param1.splice(_loc3_,1);
            }
            _loc3_--;
         }
         _loc2_.sortOn(["x","y"],Array.NUMERIC);
         return param1.concat(_loc2_);
      }
   }
}

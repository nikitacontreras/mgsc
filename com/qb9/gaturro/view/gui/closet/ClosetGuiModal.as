package com.qb9.gaturro.view.gui.closet
{
   import com.qb9.flashlib.math.Random;
   import com.qb9.flashlib.utils.ObjectUtil;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.audio;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.user.inventory.GaturroInventory;
   import com.qb9.gaturro.user.inventory.GaturroInventorySceneObject;
   import com.qb9.gaturro.user.inventory.InventoryUtil;
   import com.qb9.gaturro.view.gui.base.inventory.BaseInventoryTabsModal;
   import com.qb9.gaturro.view.gui.base.inventory.HouseInventoryWidget;
   import com.qb9.gaturro.view.gui.base.inventory.InventoryWidgetEvent;
   import com.qb9.gaturro.view.gui.base.inventory.repeater.inventory.InventoryWidgetCell;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.core.avatar.ownednpc.OwnedNpcFactory;
   import com.qb9.gaturro.world.core.elements.NpcRoomSceneObject;
   import com.qb9.gaturro.world.core.elements.OwnedNpcRoomSceneObject;
   import com.qb9.gaturro.world.tiling.MovingHomeObjects;
   import com.qb9.mambo.core.attributes.CustomAttributes;
   import com.qb9.mambo.core.objects.SceneObject;
   import com.qb9.mambo.geom.Coord;
   import com.qb9.mambo.user.inventory.InventorySceneObject;
   import com.qb9.mambo.user.inventory.events.InventoryEvent;
   import com.qb9.mambo.world.avatars.Avatar;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import com.qb9.mambo.world.elements.MovingRoomSceneObject;
   import config.HouseConfig;
   import flash.events.Event;
   
   public class ClosetGuiModal extends BaseInventoryTabsModal
   {
      
      private static const ROWS:uint = 7;
      
      private static const COLS:uint = 9;
       
      
      private const CATEGORY_CARS:int = 4;
      
      private const CATEGORY_WALL_FLOOR:int = 3;
      
      private var room:GaturroRoom;
      
      private const CATEGORY_CLOTHES:int = 2;
      
      private const CATEGORY_OBJECTS:int = 1;
      
      public function ClosetGuiModal(param1:GaturroRoom)
      {
         var _loc2_:Array = [new HouseInventoryWidget(COLS,ROWS,true,this.isOnRoom,{"cat":this.CATEGORY_OBJECTS}),new HouseInventoryWidget(COLS,ROWS,true,this.isOnRoom,{"cat":this.CATEGORY_CLOTHES}),new HouseInventoryWidget(COLS,ROWS,true,this.isOnRoom,{"cat":this.CATEGORY_WALL_FLOOR}),new HouseInventoryWidget(1,1,true,this.isOnRoom,{"cat":this.CATEGORY_CARS},"assets.InventoryCarButtonMC")];
         super(_loc2_);
         this.room = param1;
         this.initModal();
      }
      
      private function addToList(param1:Array, param2:Object) : void
      {
         var _loc5_:GaturroInventorySceneObject = null;
         var _loc3_:Array = param2 as Array;
         var _loc4_:GaturroInventorySceneObject;
         if((Boolean(_loc4_ = _loc3_[0] as GaturroInventorySceneObject)) && OwnedNpcFactory.isOwnedNpcItem(_loc4_))
         {
            for each(_loc5_ in _loc3_)
            {
               param1.push([_loc5_]);
            }
         }
         else
         {
            param1.push(param2);
         }
      }
      
      private function isFloor(param1:Object) : Boolean
      {
         var _loc2_:String = null;
         if(param1.name)
         {
            _loc2_ = String(param1.name);
            if(_loc2_.length > 11 && (_loc2_.substr(0,17) == "privateHomeFloors" || _loc2_.substr(0,16) == "privateHomeRoofs" || _loc2_.substr(0,18) == "privateAticFloors1"))
            {
               return true;
            }
         }
         return false;
      }
      
      private function isObjectOnRoom(param1:SceneObject) : Boolean
      {
         var _loc2_:SceneObject = null;
         for each(_loc2_ in this.room.sceneObjects)
         {
            if(param1 == _loc2_)
            {
               return true;
            }
         }
         return false;
      }
      
      protected function get inventoryItems() : Array
      {
         return InventoryUtil.removeQuestItems(user.allItemsGrouped);
      }
      
      private function dropToRoom(param1:InventorySceneObject, param2:InventoryWidgetCell) : void
      {
         var _loc3_:GaturroInventory = null;
         var _loc4_:Coord = null;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         audio.addLazyPlay("popdown2");
         for each(_loc3_ in this.inventories)
         {
            if(_loc3_.byId(param1.id))
            {
               if(this.isWall(param1) || this.isFloor(param1))
               {
                  _loc4_ = Coord.create(0,this.isWall(param1) ? 0 : 1);
                  this.grabExclusiveElements(param1);
               }
               else
               {
                  if((_loc5_ = this.room.getThisRoomNum()) <= -1)
                  {
                     _loc5_ = 1;
                  }
                  _loc5_--;
                  _loc6_ = HouseConfig.data.rooms[_loc5_].drop_limits;
                  _loc7_ = Random.randint(_loc6_.MIN_DROP_X,_loc6_.MAX_DROP_X);
                  _loc8_ = Random.randint(_loc6_.MIN_DROP_Y,_loc6_.MAX_DROP_Y);
                  _loc4_ = Coord.create(_loc7_,_loc8_);
               }
               param2.dropOne(true);
               if("availableOnRoomId" in param1.attributes)
               {
                  if((_loc9_ = int(param1.attributes["availableOnRoomId"])) != this.room.getThisRoomNum())
                  {
                     logger.debug("Cant drop item",param1,"in this room");
                     if(param1.name == "cars.customCar")
                     {
                        api.showModal(region.getText("DEBES GUARDAR TU AUTOMOVIL EN TU GARAGE"),"garage");
                     }
                     return;
                  }
               }
               return _loc3_.drop(param1.id,_loc4_);
            }
         }
         logger.warning("Could not find",param1,"in any inventory");
      }
      
      private function initEvents() : void
      {
         var _loc1_:GaturroInventory = null;
         var _loc2_:Object = null;
         for each(_loc1_ in this.inventories)
         {
            _loc1_.addEventListener(InventoryEvent.ITEM_ADDED,this.updateItems);
            _loc1_.addEventListener(InventoryEvent.ITEM_REMOVED,this.updateItems);
         }
         for each(_loc2_ in widgets)
         {
            HouseInventoryWidget(_loc2_).addEventListener(InventoryWidgetEvent.SELECTED,this.dropToRoomEvent);
            HouseInventoryWidget(_loc2_).addEventListener(InventoryWidgetEvent.UNSELECTED,this.grabFromRoomEvent);
         }
      }
      
      private function grabFromRoomNow(param1:SceneObject, param2:InventoryWidgetCell) : void
      {
         var _loc3_:GaturroInventory = InventoryUtil.getInventory(param1);
         _loc3_.grab(param1.id);
         param2.dropOne(true);
         if(param1 is RoomSceneObject)
         {
            this.grabStackedObjects(_loc3_,RoomSceneObject(param1));
         }
      }
      
      private function isGrabbableRoomObject(param1:RoomSceneObject) : Boolean
      {
         if(!param1)
         {
            return false;
         }
         return (param1 is NpcRoomSceneObject && !(param1 is Avatar) || !(param1 is MovingRoomSceneObject)) && param1.name.indexOf(MovingHomeObjects.PRIVATE_PACKAGE) !== 0;
      }
      
      private function grabExclusiveElements(param1:InventorySceneObject) : void
      {
      }
      
      private function isWall(param1:Object) : Boolean
      {
         var _loc2_:String = null;
         if(param1.name)
         {
            _loc2_ = String(param1.name);
            if(_loc2_.length > 11 && (_loc2_.substr(0,16) == "privateHomeWalls" || _loc2_.substr(0,15) == "privateHomeSkys" || _loc2_.substr(0,17) == "privateAticWalls1"))
            {
               return true;
            }
         }
         return false;
      }
      
      protected function dropToRoomEvent(param1:InventoryWidgetEvent) : void
      {
         var _loc2_:InventorySceneObject = param1.item as InventorySceneObject;
         if(!_loc2_)
         {
            return;
         }
         this.dropToRoom(_loc2_,param1.cell);
      }
      
      private function grabStackedObjects(param1:GaturroInventory, param2:RoomSceneObject) : void
      {
         var _loc3_:RoomSceneObject = null;
         if(!param2.attributes["slots"])
         {
            return;
         }
         for each(_loc3_ in param2.tile.children)
         {
            param1.grab(_loc3_.id);
         }
      }
      
      protected function get allItems() : Array
      {
         return this.inventoryItems.concat(this.roomItems);
      }
      
      protected function grabFromRoomEvent(param1:InventoryWidgetEvent) : void
      {
         var _loc2_:RoomSceneObject = param1.item as RoomSceneObject;
         if(!_loc2_)
         {
            return;
         }
         this.grabFromRoomNow(_loc2_,param1.cell);
      }
      
      private function isOnRoom(param1:SceneObject) : Boolean
      {
         return param1 is RoomSceneObject;
      }
      
      override protected function get openSound() : String
      {
         return "cosas1";
      }
      
      private function shouldAppear(param1:Object) : Boolean
      {
         if(!param1.name)
         {
            return false;
         }
         if(param1.name == "")
         {
            return false;
         }
         if(param1 is OwnedNpcRoomSceneObject)
         {
            return false;
         }
         if(param1.name.substr(0,11) == "privateRoom")
         {
            return false;
         }
         if(param1.name.substr(0,7) == "penguin")
         {
            return false;
         }
         if(param1.name.substr(0,6) == "granja")
         {
            return false;
         }
         if(param1.name == "navidad2015.SantaPrueba")
         {
            return false;
         }
         if(param1.name.indexOf("serenito.trajePixelado") > -1)
         {
            return false;
         }
         if(this.room.id == this.room.getRoomId(11) && param1.name.substr(0,17) == "privateHomeFloors")
         {
            return false;
         }
         if(this.room.id == this.room.getRoomId(11) && param1.name.substr(0,16) == "privateHomeWalls")
         {
            return false;
         }
         if(this.room.id == this.room.getRoomId(12) && param1.name.substr(0,17) == "privateHomeFloors")
         {
            return false;
         }
         if(this.room.id == this.room.getRoomId(12) && param1.name.substr(0,16) == "privateHomeWalls")
         {
            return false;
         }
         if(this.room.id != this.room.getRoomId(11) && param1.name.substr(0,16) == "privateHomeRoofs")
         {
            return false;
         }
         if(this.room.id != this.room.getRoomId(11) && param1.name.substr(0,15) == "privateHomeSkys")
         {
            return false;
         }
         if(this.room.id != this.room.getRoomId(12) && param1.name.substr(0,16) == "privateAticWalls1")
         {
            return false;
         }
         if(this.room.id != this.room.getRoomId(12) && param1.name.substr(0,15) == "privateAticFloors1")
         {
            return false;
         }
         return true;
      }
      
      protected function get roomItems() : Array
      {
         var _loc3_:RoomSceneObject = null;
         var _loc1_:Object = {};
         var _loc2_:int = 0;
         for each(_loc3_ in this.room.sceneObjects)
         {
            if(this.isGrabbableRoomObject(_loc3_) !== false)
            {
               if(OwnedNpcFactory.isOwnedNpcItem(_loc3_))
               {
                  _loc1_[_loc3_.name + "_" + _loc2_.toString()] = [_loc3_];
               }
               else if(_loc3_.name in _loc1_)
               {
                  _loc1_[_loc3_.name].push(_loc3_);
               }
               else
               {
                  _loc1_[_loc3_.name] = [_loc3_];
               }
               _loc2_++;
            }
         }
         return ObjectUtil.values(_loc1_);
      }
      
      override public function dispose() : void
      {
         var _loc1_:GaturroInventory = null;
         var _loc2_:Object = null;
         for each(_loc1_ in this.inventories)
         {
            _loc1_.removeEventListener(InventoryEvent.ITEM_ADDED,this.updateItems);
            _loc1_.removeEventListener(InventoryEvent.ITEM_REMOVED,this.updateItems);
         }
         for each(_loc2_ in widgets)
         {
            HouseInventoryWidget(_loc2_).removeEventListener(InventoryWidgetEvent.SELECTED,this.dropToRoomEvent);
            HouseInventoryWidget(_loc2_).removeEventListener(InventoryWidgetEvent.UNSELECTED,this.grabFromRoomEvent);
         }
         this.room = null;
         super.dispose();
      }
      
      private function getCategory(param1:Object) : int
      {
         var _loc2_:CustomAttributes = null;
         var _loc3_:String = null;
         if(!this.shouldAppear(param1[0]))
         {
            return -1;
         }
         if(this.isWall(param1[0]) || this.isFloor(param1[0]))
         {
            return this.CATEGORY_WALL_FLOOR;
         }
         if(param1[0]["attributes"])
         {
            _loc2_ = CustomAttributes(param1[0]["attributes"]);
            for(_loc3_ in _loc2_)
            {
               if(_loc3_.substr(0,4) == "wear")
               {
                  return this.CATEGORY_CLOTHES;
               }
               if(_loc3_ == "availableOnRoomId")
               {
                  return this.CATEGORY_CARS;
               }
            }
         }
         return this.CATEGORY_OBJECTS;
      }
      
      override protected function get closeSound() : String
      {
         return "cosas2";
      }
      
      private function get inventories() : Array
      {
         return user.inventories;
      }
      
      private function initModal() : void
      {
         this.updateItems();
         this.initEvents();
      }
      
      private function updateItems(param1:Event = null) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         for each(_loc2_ in this.widgets)
         {
            HouseInventoryWidget(_loc2_).elements = new Array();
         }
         _loc3_ = new Array();
         _loc4_ = 0;
         while(_loc4_ < this.widgets.length)
         {
            _loc3_.push(new Array());
            _loc4_++;
         }
         for each(_loc5_ in this.allItems)
         {
            if((_loc7_ = this.getCategory(_loc5_)) != -1)
            {
               this.addToList(_loc3_[_loc7_ - 1] as Array,_loc5_);
            }
         }
         _loc6_ = 0;
         while(_loc6_ < _loc3_.length)
         {
            HouseInventoryWidget(this.widgets[_loc6_]).elements = _loc3_[_loc6_];
            _loc6_++;
         }
      }
   }
}

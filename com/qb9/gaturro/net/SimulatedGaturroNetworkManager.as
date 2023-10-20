package com.qb9.gaturro.net
{
   import com.qb9.flashlib.math.Random;
   import com.qb9.flashlib.utils.ObjectUtil;
   import com.qb9.mambo.net.manager.NetworkManagerEvent;
   import com.qb9.mambo.net.manager.simulated.SimulatedNetworkManager;
   import com.qb9.mambo.user.inventory.Inventory;
   import com.qb9.mines.mobject.Mobject;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public final class SimulatedGaturroNetworkManager extends SimulatedNetworkManager
   {
      
      private static const BACKGROUNDS:Array = ["privateRoom","beach1","beach2","beach3","diner","park1","park2","city1","city2","city3","city4","sky1","sky2","sky3"];
      
      private static const SIMULATION_MIN_ID:uint = 2000;
      
      private static const ROOM_SIZE:Array = [24,14];
      
      private static const USER_ID:int = 69;
      
      private static const SIMULATION_USERS:Array = ["PONTURA","PLAYMOBIL","MATE","SINDROMEX"];
      
      private static const WHITE_LIST:Array = ["Hola","Como te va","Que tal"];
      
      private static const SIMULATION_INTERVAL:uint = 3000;
      
      private static const USER_NAME:String = "MAGO";
       
      
      private var userAttributes:Object;
      
      private var rooms:Object;
      
      private var userAvatar:Object;
      
      private var bots:Array;
      
      private var botIntervalId:int;
      
      private var roomId:int = 2;
      
      private var roomOwner:String = "";
      
      private var userSceneObject:Object;
      
      private var ids:int = 1000;
      
      private var inventories:Object;
      
      public function SimulatedGaturroNetworkManager(param1:uint = 1)
      {
         this.inventories = {};
         this.rooms = {};
         this.userAttributes = {};
         super(param1);
         this.init();
      }
      
      private function get isAtHome() : Boolean
      {
         return this.roomId === 1;
      }
      
      private function initEvents() : void
      {
         addEventListener("AvatarDataRequest",this.avatarData);
         addEventListener("InventoryDataRequest",this.inventoryData);
         addEventListener("ServerDataRequest",this.serverData);
         addEventListener("WhiteListDataRequest",this.whiteListData);
         addEventListener("RoomDataRequest",this.roomData);
         addEventListener("ChangeRoomActionRequest",this.changeRoom);
         addEventListener("UpdateCustomAttributeDataRequest",this.updateCustomAttribute);
         addEventListener("ObjectCreateOrUpdateRequest",this.createOrUpdateObject);
         addEventListener("ChatMessageActionRequest",this.chatMessage);
         addEventListener("MoveActionRequest",this.moveAction);
         addEventListener("GrabObjectActionRequest",this.grabObject);
         addEventListener("DropObjectActionRequest",this.dropObject);
      }
      
      private function serverData(param1:NetworkManagerEvent) : void
      {
         response(NetworkManagerEvent.SERVER_DATA,{
            "time":new Date().getTime().toString(),
            "version":"server-trucho-0.7",
            "extensionVersion":"gaturro-trucho-0.7",
            "extraData":{"resellPriceRation":0.25}
         });
      }
      
      private function createOrUpdateObject(param1:NetworkManagerEvent) : void
      {
         var _loc2_:Mobject = param1.mobject;
         var _loc3_:Number = this.ids++;
         _loc2_.setInteger("id",_loc3_);
         this.currentRoom[_loc3_] = _loc2_;
         mobjectResponse(NetworkManagerEvent.OBJECT_JOINS,_loc2_);
      }
      
      private function chatMessage(param1:NetworkManagerEvent) : void
      {
         var _loc2_:Mobject = param1.mobject;
         _loc2_.setString("messageType","room");
         _loc2_.setString("sender",USER_NAME);
         mobjectResponse(NetworkManagerEvent.MESSAGE_RECEIVED,_loc2_);
      }
      
      private function init() : void
      {
         this.userAvatar = this.makeAvatar(USER_ID,USER_NAME);
         this.userSceneObject = this.makeSceneObject(USER_ID,[12,6]);
         this.initEvents();
      }
      
      private function dropObject(param1:NetworkManagerEvent) : void
      {
         var _loc4_:String = null;
         var _loc5_:Object = null;
         var _loc6_:Mobject = null;
         var _loc2_:Mobject = param1.mobject;
         var _loc3_:Number = Number(_loc2_.getString("sceneObjectId"));
         for each(_loc4_ in ObjectUtil.keys(this.inventories))
         {
            if(_loc6_ = (_loc5_ = this.inventories[_loc4_])[_loc3_] as Mobject)
            {
               _loc6_.setIntegerArray("coord",_loc2_.getIntegerArray("coord"));
               delete _loc5_[_loc3_];
               this.currentRoom[_loc3_] = _loc6_;
               mobjectResponse(NetworkManagerEvent.OBJECT_JOINS,_loc6_);
               response(NetworkManagerEvent.REMOVED_FROM_INVENTORY,{
                  "inventoryName":_loc4_,
                  "sceneObjectId":_loc3_
               });
            }
         }
      }
      
      private function abortSimulation() : void
      {
         var _loc1_:Bot = null;
         clearTimeout(this.botIntervalId);
         for each(_loc1_ in this.bots)
         {
            _loc1_.dispose();
         }
         this.bots = [];
      }
      
      private function addAvatar(param1:int) : void
      {
         var _loc2_:Number = SIMULATION_MIN_ID + param1;
         var _loc3_:String = String(SIMULATION_USERS[param1]);
         var _loc4_:Object;
         (_loc4_ = this.makeAvatar(_loc2_,_loc3_)).sceneObject = this.makeSceneObject(_loc2_);
         _loc4_.sceneObject.avatar = this.makeAvatar(_loc2_,_loc3_);
         this.bots.push(new Bot(_loc4_,this));
         if(this.bots.length in SIMULATION_USERS)
         {
            this.queueBot();
         }
      }
      
      public function getWalkableCoord() : Array
      {
         return [Random.randint(8,ROOM_SIZE[0]) - 4,Random.randint(0,ROOM_SIZE[1] - 1)];
      }
      
      private function makeSceneObject(param1:Number, param2:Array = null) : Object
      {
         return {
            "id":param1,
            "name":"avatar",
            "coord":param2 || this.getWalkableCoord(),
            "size":[1,1],
            "blockingHint":false,
            "customAttributes":[]
         };
      }
      
      private function updateCustomAttribute(param1:NetworkManagerEvent) : void
      {
         var _loc4_:Mobject = null;
         var _loc2_:Mobject = param1.mobject;
         var _loc3_:Number = Number(_loc2_.getString("sceneObjectId"));
         if(_loc3_ === USER_ID)
         {
            for each(_loc4_ in _loc2_.getMobjectArray("customAttributes"))
            {
               this.userAttributes[_loc4_.getString("type")] = _loc4_.getString("data");
            }
         }
         mobjectResponse(NetworkManagerEvent.CUSTOM_ATTRIBUTES_CHANGED,_loc2_);
      }
      
      private function avatarData(param1:NetworkManagerEvent) : void
      {
         this.userAvatar.sceneObject = this.userSceneObject;
         response(NetworkManagerEvent.AVATAR_DATA,this.userAvatar);
         delete this.userAvatar.sceneObject;
      }
      
      private function simulate() : void
      {
         this.queueBot();
      }
      
      private function roomData(param1:NetworkManagerEvent) : void
      {
         var _loc5_:String = null;
         var _loc6_:int = 0;
         this.userSceneObject.avatar = this.userAvatar;
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < ROOM_SIZE[0])
         {
            _loc6_ = 0;
            while(_loc6_ < ROOM_SIZE[1])
            {
               _loc2_.push({"coord":[_loc3_,_loc6_]});
               _loc6_++;
            }
            _loc3_++;
         }
         this.rooms[this.roomId] = this.currentRoom || {};
         var _loc4_:Array;
         (_loc4_ = ObjectUtil.values(this.currentRoom)).unshift(this.userSceneObject);
         _loc4_.push(this.makeDoor(2,[18,6],this.roomId + 1));
         this.userSceneObject.customAttributes = [];
         for(_loc5_ in this.userAttributes)
         {
            this.userSceneObject.customAttributes.push({
               "type":_loc5_,
               "data":this.userAttributes[_loc5_]
            });
         }
         response(NetworkManagerEvent.ROOM_DATA,{
            "id":this.roomId,
            "name":"room",
            "coord":[0,0,0],
            "size":ROOM_SIZE,
            "sceneObjects":_loc4_,
            "ownerUsername":this.roomOwner,
            "customAttributes":[{
               "type":"background",
               "data":this.background
            }],
            "tiles":[{
               "id":1,
               "blockingHint":false,
               "typeName":"",
               "typeValue":"",
               "coords":_loc2_
            }]
         });
         delete this.userSceneObject.avatar;
      }
      
      private function inventoryData(param1:NetworkManagerEvent) : void
      {
         var _loc2_:String = String(param1.mobject.getString("name") || Inventory.DEFAULT);
         this.inventories[_loc2_] = {};
         response(NetworkManagerEvent.INVENTORY_DATA,{
            "name":_loc2_,
            "sceneObjects":[]
         });
      }
      
      private function makeAvatar(param1:Number, param2:String) : Object
      {
         return {
            "id":param1,
            "isAdmin":true,
            "username":param2,
            "profile":{
               "id":1,
               "chatType":1,
               "customAttributes":[]
            },
            "buddies":[]
         };
      }
      
      private function changeRoom(param1:NetworkManagerEvent) : void
      {
         var _loc2_:Mobject = param1.mobject;
         this.roomOwner = _loc2_.getString("ownerUsername") || "";
         if(this.roomOwner)
         {
            this.roomId = 1;
         }
         else
         {
            this.roomId = _loc2_.getInteger("roomId");
         }
         _loc2_.setInteger("roomId",this.roomId);
         response(NetworkManagerEvent.CHANGE_ROOM);
      }
      
      private function get background() : String
      {
         var _loc1_:Number = (this.roomId - 1) % BACKGROUNDS.length;
         if(_loc1_ === 1 && !this.isAtHome)
         {
            _loc1_++;
         }
         return BACKGROUNDS[_loc1_];
      }
      
      private function whiteListData(param1:NetworkManagerEvent) : void
      {
         var _loc2_:Array = [];
         var _loc3_:Number = 0;
         while(_loc3_ < WHITE_LIST.length)
         {
            _loc2_.push({
               "key":_loc3_ + 1,
               "text":WHITE_LIST[_loc3_]
            });
            _loc3_++;
         }
         response(NetworkManagerEvent.WHITE_LIST_DATA,{"children":_loc2_});
      }
      
      private function grabObject(param1:NetworkManagerEvent) : void
      {
         var _loc2_:Mobject = param1.mobject;
         var _loc3_:Number = Number(_loc2_.getString("sceneObjectId"));
         var _loc4_:String = String(_loc2_.getString("inventoryName") || Inventory.DEFAULT);
         _loc2_ = this.currentRoom[_loc3_];
         delete this.currentRoom[_loc3_];
         this.inventories[_loc4_][_loc3_] = _loc2_;
         response(NetworkManagerEvent.OBJECT_LEFT,{"sceneObjectId":_loc3_});
         response(NetworkManagerEvent.ADDED_TO_INVENTORY,{
            "inventoryName":_loc4_,
            "sceneObject":_loc2_
         });
      }
      
      private function moveAction(param1:NetworkManagerEvent) : void
      {
         var _loc2_:Mobject = param1.mobject.getMobjectArray("path").pop();
         this.userSceneObject.coord = [_loc2_.getInteger("x"),_loc2_.getInteger("y")];
      }
      
      private function get currentRoom() : Object
      {
         return this.rooms[this.roomId];
      }
      
      private function makeDoor(param1:Number, param2:Array, param3:int) : Object
      {
         var _loc4_:Object;
         (_loc4_ = this.makeSceneObject(param1,param2)).name = "door";
         _loc4_.link = {
            "roomId":param3,
            "coord":this.userSceneObject.coord,
            "worldCoord":[1,0,0]
         };
         return _loc4_;
      }
      
      private function queueBot() : void
      {
         var _loc1_:int = int(this.bots.length);
         this.botIntervalId = setTimeout(this.addAvatar,(_loc1_ + 1) * SIMULATION_INTERVAL,_loc1_);
      }
   }
}

import com.qb9.flashlib.math.Random;
import com.qb9.gaturro.net.SimulatedGaturroNetworkManager;
import com.qb9.mambo.net.manager.NetworkManagerEvent;
import flash.utils.clearInterval;
import flash.utils.setInterval;

class Bot
{
   
   private static const WALK_INTERVAL:uint = 5000;
    
   
   private var intervalId:int;
   
   private var data:Object;
   
   private var net:SimulatedGaturroNetworkManager;
   
   public function Bot(param1:Object, param2:SimulatedGaturroNetworkManager)
   {
      super();
      this.data = param1;
      this.net = param2;
      this.init();
   }
   
   public function dispose() : void
   {
      clearInterval(this.intervalId);
      this.data = null;
      this.net = null;
   }
   
   private function walk() : void
   {
      this.net.response(NetworkManagerEvent.AVATAR_MOVE,{
         "id":this.data.id,
         "coord":this.net.getWalkableCoord()
      });
   }
   
   private function join() : void
   {
      this.net.response(NetworkManagerEvent.AVATAR_JOINS,this.data);
   }
   
   private function leave() : void
   {
      this.net.response(NetworkManagerEvent.AVATAR_LEFT,this.data.id);
   }
   
   private function init() : void
   {
      this.join();
      this.intervalId = setInterval(this.walk,WALK_INTERVAL * Random.randrange(0.7,1.2));
   }
}

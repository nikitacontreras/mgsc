package com.qb9.gaturro.view.gui.home
{
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.user.profile.GaturroProfile;
   import com.qb9.gaturro.view.gui.Gui;
   import com.qb9.gaturro.view.screens.GaturroLoadingScreen;
   import com.qb9.gaturro.world.catalog.Catalog;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.core.avatar.GaturroUserAvatar;
   import com.qb9.mambo.geom.Coord;
   import com.qb9.mambo.world.core.RoomLink;
   import config.HouseConfig;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   
   public class GuiHouseMap implements IDisposable
   {
       
      
      private var links:Array;
      
      private var timer:Timer;
      
      private var modalX:Number = 0;
      
      private var modalY:Number = 0;
      
      private var room:GaturroRoom;
      
      private const ROOMS_CATALOG_NAME:String = "houses";
      
      private var modal:com.qb9.gaturro.view.gui.home.AcquiredHouseRoomGuiModal;
      
      private var buildMinutesLeft:int = 0;
      
      private var buyRoomFunction:Function;
      
      private var gui:Gui;
      
      private var lastNumRoomTryBuy:int = 0;
      
      public function GuiHouseMap(param1:Gui, param2:GaturroRoom, param3:Boolean, param4:Function)
      {
         super();
         this.gui = param1;
         this.room = param2;
         this.buyRoomFunction = param4;
         if(Boolean(HouseConfig.data.enabled) && param3)
         {
            this.initMap();
         }
         else
         {
            this.gui.houseMap.visible = false;
         }
      }
      
      private function getLinkId(param1:int) : String
      {
         var _loc3_:Object = null;
         var _loc2_:Array = this.room.houseRooms;
         if(!_loc2_)
         {
            _loc2_ = new Array();
         }
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.roomNum == param1)
            {
               return _loc3_.roomId;
            }
         }
         return int.MIN_VALUE.toString();
      }
      
      private function tryToBuyRoomClick(param1:MouseEvent) : void
      {
         this.lastNumRoomTryBuy = int(MovieClip(param1.currentTarget).name.split("btn")[1]);
         this.room.getCatalogData(this.ROOMS_CATALOG_NAME,this.extractCatalogData);
      }
      
      private function checkBuildingAnother() : Boolean
      {
         var _loc1_:MovieClip = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.gui.houseMap.numChildren)
         {
            _loc1_ = this.getButtonByNum(_loc2_ + 1);
            if(Boolean(_loc1_) && _loc1_.currentLabel == "building")
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      private function buyRoom(param1:Event = null) : void
      {
         var _loc2_:int = this.modal.roomNumber;
         var _loc3_:MovieClip = this.getButtonByNum(_loc2_);
         _loc3_.gotoAndStop("building");
         if(_loc2_ == 10)
         {
            setTimeout(api.changeRoom,5000,api.room.id,api.userAvatar.coord);
         }
         this.buyRoomFunction(_loc2_);
      }
      
      private function isContiguousRoom(param1:int) : Boolean
      {
         var _loc3_:Object = null;
         var _loc2_:Array = HouseConfig.data.rooms[param1 - 1].sceneObjects;
         if(_loc2_.length == 0)
         {
            return true;
         }
         for each(_loc3_ in _loc2_)
         {
            if(Boolean(_loc3_.link) && Boolean(_loc3_.link.id) && this.room.getRoomId(_loc3_.link.id) > 0)
            {
               return true;
            }
         }
         return false;
      }
      
      private function tickTack(param1:Event) : void
      {
         if(this.buildMinutesLeft > 0)
         {
            --this.buildMinutesLeft;
         }
      }
      
      private function openBuyDialog(param1:int, param2:String, param3:int, param4:Boolean, param5:Number) : void
      {
         if(Boolean(this.modal) && Boolean(this.modal.parent))
         {
            return this.modal.close();
         }
         var _loc6_:GaturroUserAvatar = GaturroUserAvatar(this.room.owner);
         var _loc7_:int = GaturroProfile(_loc6_.user.profile).coins;
         var _loc8_:Boolean = _loc6_.isCitizen;
         var _loc9_:Boolean = this.checkBuildingThis(param1);
         var _loc10_:Boolean = this.checkBuildingAnother();
         var _loc11_:Boolean = this.isContiguousRoom(param1);
         this.modal = new com.qb9.gaturro.view.gui.home.AcquiredHouseRoomGuiModal(param1,param2,_loc11_,_loc7_,param3,param5,_loc8_,param4,_loc9_,_loc10_,this.buildMinutesLeft);
         this.modal.addEventListener(Event.CLOSE,this.cleanModal);
         this.modal.addEventListener(com.qb9.gaturro.view.gui.home.AcquiredHouseRoomGuiModal.BUY,this.buyRoom);
         if(this.modalX)
         {
            this.modal.x = this.modalX;
         }
         if(this.modalY)
         {
            this.modal.y = this.modalY;
         }
         this.gui.addModal(this.modal);
      }
      
      private function initRoomButton(param1:MovieClip, param2:String, param3:Coord) : void
      {
         var _loc5_:int = int(param2);
         param1.gotoAndStop("off");
         if(_loc5_ <= int.MIN_VALUE)
         {
            if(this.room.ownerName == this.room.userAvatar.username)
            {
               param1.buttonMode = true;
               param1.addEventListener(MouseEvent.CLICK,this.tryToBuyRoomClick);
            }
         }
         else if(_loc5_ == 0)
         {
            this.buildMinutesLeft = int(param2.substr(1,param2.length - 1));
            param1.gotoAndStop("building");
            this.timer = new Timer(60000);
            this.timer.addEventListener(TimerEvent.TIMER,this.tickTack);
            this.timer.start();
            if(this.room.ownerName == this.room.userAvatar.username)
            {
               param1.buttonMode = true;
               param1.addEventListener(MouseEvent.CLICK,this.tryToBuyRoomClick);
            }
         }
         else if(_loc5_ == this.room.id)
         {
            param1.gotoAndStop("active");
         }
         else
         {
            param1.buttonMode = true;
            param1.addEventListener(MouseEvent.CLICK,this.accessToRoomClick);
            param1.gotoAndStop("on");
            this.links.push({
               "btn":param1.name,
               "link":_loc5_,
               "coord":param3
            });
         }
      }
      
      private function checkBuildingThis(param1:int) : Boolean
      {
         var _loc2_:MovieClip = this.getButtonByNum(param1);
         if(Boolean(_loc2_) && _loc2_.currentLabel == "building")
         {
            return true;
         }
         return false;
      }
      
      private function extractCatalogData(param1:Catalog, param2:Object = null) : void
      {
         var _loc7_:Object = null;
         var _loc8_:int = 0;
         var _loc3_:String = "";
         var _loc4_:int = -1;
         var _loc5_:Boolean = true;
         var _loc6_:Number = 72;
         for each(_loc7_ in param1.items)
         {
            if((_loc8_ = int(String(_loc7_.name).split(".")[2])) == this.lastNumRoomTryBuy)
            {
               _loc3_ = String(_loc7_.description);
               _loc4_ = int(_loc7_.price);
               _loc5_ = Boolean(_loc7_.vip);
               _loc6_ = Number(_loc7_.buildTime);
               this.openBuyDialog(this.lastNumRoomTryBuy,_loc3_,_loc4_,_loc5_,_loc6_);
               return;
            }
         }
      }
      
      private function cleanModal(param1:Event = null) : void
      {
         if(!this.modal)
         {
            return;
         }
         this.modal.removeEventListener(Event.CLOSE,this.cleanModal);
         this.modal.removeEventListener(com.qb9.gaturro.view.gui.home.AcquiredHouseRoomGuiModal.BUY,this.buyRoom);
         this.modal = null;
      }
      
      public function dispose() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.gui.houseMap.numChildren)
         {
            _loc1_ = this.getButtonByNum(_loc2_ + 1);
            if(_loc1_)
            {
               _loc1_.removeEventListener(MouseEvent.CLICK,this.accessToRoomClick);
               _loc1_.removeEventListener(MouseEvent.CLICK,this.tryToBuyRoomClick);
            }
            _loc2_++;
         }
         if(this.timer)
         {
            this.timer.stop();
            this.timer.removeEventListener(TimerEvent.TIMER,this.tickTack);
            this.timer = null;
         }
         this.gui = null;
         this.room = null;
      }
      
      private function getButtonByNum(param1:int) : MovieClip
      {
         return MovieClip(this.gui.houseMap.getChildByName("btn" + param1.toString()));
      }
      
      private function initHouseRoom(param1:int) : void
      {
         var _loc4_:Coord = null;
         var _loc2_:MovieClip = this.getButtonByNum(param1);
         var _loc3_:String = this.getLinkId(param1);
         if(_loc2_)
         {
            _loc2_.stop();
            _loc4_ = new Coord(HouseConfig.data.rooms[param1 - 1].defaultCoord[0],HouseConfig.data.rooms[param1 - 1].defaultCoord[1]);
            this.initRoomButton(_loc2_,_loc3_,_loc4_);
         }
      }
      
      private function initMap() : void
      {
         this.links = new Array();
         var _loc1_:int = 0;
         while(_loc1_ < this.gui.houseMap.numChildren)
         {
            this.initHouseRoom(_loc1_ + 1);
            _loc1_++;
         }
      }
      
      private function accessToRoomClick(param1:MouseEvent) : void
      {
         var _loc2_:Object = null;
         for each(_loc2_ in this.links)
         {
            if(_loc2_.btn == MovieClip(param1.currentTarget).name)
            {
               if(_loc2_.btn == "btn10")
               {
                  GaturroLoadingScreen.TYPE = GaturroLoadingScreen.GRANJA;
               }
               this.room.changeTo(new RoomLink(_loc2_.coord,_loc2_.link));
            }
         }
      }
   }
}

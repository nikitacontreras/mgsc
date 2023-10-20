package com.qb9.gaturro.editor
{
   import com.adobe.serialization.json.JSON;
   import com.qb9.flashlib.geom.Size;
   import com.qb9.flashlib.input.Console;
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.flashlib.lang.filter;
   import com.qb9.flashlib.utils.StringUtil;
   import com.qb9.gaturro.commons.constraint.ConstraintManager;
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.editor.filter.SceneObjectFilter;
   import com.qb9.gaturro.editor.requests.*;
   import com.qb9.gaturro.external.roomObjects.GaturroSceneObjectAPI;
   import com.qb9.gaturro.globals.*;
   import com.qb9.gaturro.manager.counter.GaturroCounterManager;
   import com.qb9.gaturro.manager.crafting.CraftingManager;
   import com.qb9.gaturro.manager.music.MusicManager;
   import com.qb9.gaturro.manager.passport.BetterWithPassportManager;
   import com.qb9.gaturro.manager.provider.ProviderManager;
   import com.qb9.gaturro.manager.team.TeamManager;
   import com.qb9.gaturro.net.requests.npc.ScoreActionRequest;
   import com.qb9.gaturro.quest.model.GaturroSystemQuestModel;
   import com.qb9.gaturro.service.catalog.CatalogCarouselDefinition;
   import com.qb9.gaturro.service.catalog.CatalogCarouselService;
   import com.qb9.gaturro.service.events.EventData;
   import com.qb9.gaturro.service.events.EventsService;
   import com.qb9.gaturro.tutorial.TutorialManager;
   import com.qb9.gaturro.user.GaturroUser;
   import com.qb9.gaturro.user.inventory.InventoryUtil;
   import com.qb9.gaturro.user.profile.GaturroProfile;
   import com.qb9.gaturro.user.settings.UserSettings;
   import com.qb9.gaturro.view.world.TorneoRoomView;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.core.elements.GaturroRoomSceneObject;
   import com.qb9.gaturro.world.core.elements.NpcRoomSceneObject;
   import com.qb9.gaturro.world.tiling.GaturroTile;
   import com.qb9.mambo.core.attributes.CustomAttribute;
   import com.qb9.mambo.core.attributes.CustomAttributes;
   import com.qb9.mambo.core.objects.SceneObject;
   import com.qb9.mambo.geom.Coord;
   import com.qb9.mambo.net.manager.NetworkManager;
   import com.qb9.mambo.net.requests.buddies.BlockBuddyActionRequest;
   import com.qb9.mambo.net.requests.buddies.UnblockBuddyActionRequest;
   import com.qb9.mambo.net.requests.customAttributes.BaseUpdateCustomAttributesRequest;
   import com.qb9.mambo.net.requests.inventory.DestroyInventoryObjectActionRequest;
   import com.qb9.mambo.net.requests.room.ChangeRoomActionRequest;
   import com.qb9.mambo.net.requests.room.DestroyRoomObjectActionRequest;
   import com.qb9.mambo.net.requests.server.ReloadConfigActionRequest;
   import com.qb9.mambo.user.inventory.Inventory;
   import com.qb9.mambo.world.avatars.Avatar;
   import com.qb9.mambo.world.avatars.AvatarBodyEnum;
   import com.qb9.mambo.world.avatars.UserAvatar;
   import com.qb9.mambo.world.core.RoomLink;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import com.qb9.mambo.world.tiling.Tile;
   import com.qb9.mines.mobject.Mobject;
   import config.ItemControl;
   import flash.desktop.Clipboard;
   import flash.desktop.ClipboardFormats;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.external.ExternalInterface;
   import flash.net.SharedObject;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.utils.Dictionary;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import flash.utils.setTimeout;
   
   public final class NetActionManager implements IDisposable
   {
      
      private static const NORTH:String = "n";
      
      private static const DOWN:String = "d";
      
      private static const SOUTH:String = "s";
      
      private static const WEST:String = "w";
      
      private static const UP:String = "u";
      
      private static const EAST:String = "e";
       
      
      private var scenObjectFilter:SceneObjectFilter;
      
      private var stressTestInterval:int;
      
      private var console:Console;
      
      private var net:NetworkManager;
      
      private var room:GaturroRoom;
      
      private var lastGiftCode:String = "";
      
      public function NetActionManager(param1:NetworkManager, param2:GaturroRoom)
      {
         super();
         this.net = param1;
         this.room = param2;
      }
      
      private function isNotAvatar(param1:RoomSceneObject) : Boolean
      {
         return param1 is Avatar === false;
      }
      
      public function musicInterprete(param1:Array = null) : void
      {
         var _loc2_:MusicManager = null;
         if(!Context.instance.hasByType(MusicManager))
         {
            _loc2_ = new MusicManager();
            Context.instance.addByType(_loc2_,MusicManager);
         }
         else
         {
            _loc2_ = Context.instance.getByType(MusicManager) as MusicManager;
         }
         _loc2_.playSerializedSequence("DiFhGFgGaGiGhHfHdHaHJJiKuKhKrehhri845ujo54yeqgqgrfyghdfljhdJFLGA");
      }
      
      public function userSetting(param1:String, param2:*) : void
      {
         var _loc3_:UserSettings = null;
         if(Context.instance.getByType(UserSettings))
         {
            _loc3_ = Context.instance.getByType(UserSettings) as UserSettings;
            _loc3_.setValue(param1,param2);
         }
      }
      
      public function roomName() : String
      {
         return this.room.name;
      }
      
      public function betterWithPassport(param1:String) : void
      {
         var _loc2_:BetterWithPassportManager = Context.instance.getByType(BetterWithPassportManager) as BetterWithPassportManager;
         _loc2_.openModal(param1);
      }
      
      public function sceneBatchDestroy(param1:int, param2:int) : String
      {
         var _loc3_:String = "";
         var _loc4_:int = param1;
         while(_loc4_ <= param2)
         {
            _loc3_ += this.sceneDestroy(_loc4_) + "\n";
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function changeRoomByName(param1:String, param2:int = 0, param3:int = 0) : void
      {
         if(settings.cache.packs)
         {
            api.cleanCache();
         }
         var _loc4_:Coord = new Coord(param2 == 0 ? this.avatar.coord.x : param2,param3 == 0 ? this.avatar.coord.y : param3);
         this.net.sendAction(new ChangeRoomActionRequest(new RoomLink(_loc4_,settings.rooms.links[param1].roomId)));
      }
      
      public function setTilesState(param1:Array, param2:Boolean) : void
      {
         this.net.sendAction(new UpdateRoomTileActionRequest(param2,param1));
      }
      
      public function userCloth() : String
      {
         var _loc1_:String = "";
         _loc1_ += "hats: " + this.handleAttr("sceneObjectId",this.avatar,AvatarBodyEnum.HATS,null) + "\n";
         _loc1_ += "hairs: " + this.handleAttr("sceneObjectId",this.avatar,AvatarBodyEnum.HAIRS,null) + "\n";
         _loc1_ += "mouths: " + this.handleAttr("sceneObjectId",this.avatar,AvatarBodyEnum.MOUTHS,null) + "\n";
         _loc1_ += "neck: " + this.handleAttr("sceneObjectId",this.avatar,AvatarBodyEnum.NECK,null) + "\n";
         _loc1_ += "accesories: " + this.handleAttr("sceneObjectId",this.avatar,AvatarBodyEnum.ACCESORIES,null) + "\n";
         _loc1_ += "cloth: " + this.handleAttr("sceneObjectId",this.avatar,AvatarBodyEnum.CLOTH,null) + "\n";
         _loc1_ += "leg: " + this.handleAttr("sceneObjectId",this.avatar,AvatarBodyEnum.LEG,null) + "\n";
         _loc1_ += "foot: " + this.handleAttr("sceneObjectId",this.avatar,AvatarBodyEnum.FOOT,null) + "\n";
         _loc1_ += "arm: " + this.handleAttr("sceneObjectId",this.avatar,AvatarBodyEnum.ARM,null) + "\n";
         _loc1_ += "armFore: " + this.handleAttr("sceneObjectId",this.avatar,AvatarBodyEnum.ARM_FORE,null) + "\n";
         _loc1_ += "armBack: " + this.handleAttr("sceneObjectId",this.avatar,AvatarBodyEnum.ARM_BACK,null) + "\n";
         _loc1_ += "glove: " + this.handleAttr("sceneObjectId",this.avatar,AvatarBodyEnum.GLOVE,null) + "\n";
         _loc1_ += "gloveFore: " + this.handleAttr("sceneObjectId",this.avatar,AvatarBodyEnum.GLOVE_FORE,null) + "\n";
         _loc1_ += "gloveBack: " + this.handleAttr("sceneObjectId",this.avatar,AvatarBodyEnum.GLOVE_BACK,null) + "\n";
         _loc1_ += "grip: " + this.handleAttr("sceneObjectId",this.avatar,AvatarBodyEnum.GRIP,null) + "\n";
         _loc1_ += "gripFore: " + this.handleAttr("sceneObjectId",this.avatar,AvatarBodyEnum.GRIP_FORE,null) + "\n";
         _loc1_ += "gripBack: " + this.handleAttr("sceneObjectId",this.avatar,AvatarBodyEnum.GRIP_BACK,null) + "\n";
         _loc1_ += "transport: " + this.handleAttr("sceneObjectId",this.avatar,AvatarBodyEnum.TRANSPORT,null) + "\n";
         return _loc1_ + ("customization: " + this.handleAttr("sceneObjectId",this.avatar,AvatarBodyEnum.CUSTOMIZATION,null) + "\n");
      }
      
      public function interaction(param1:String, param2:String) : void
      {
         this.room.proposeInteraction(param1,param2.toUpperCase());
      }
      
      public function cellPhoneAppAdd(param1:String) : String
      {
         return this.user.cellPhone.apps.add(param1);
      }
      
      public function reloadRoom() : void
      {
         this.changeRoom(this.room.id);
      }
      
      public function shake(param1:int = 5000, param2:int = 2) : void
      {
         api.shakeRoom(param1,param2);
      }
      
      public function openBanner(param1:String, param2:String = null) : void
      {
         api.showBannerModal(param1,new GaturroSceneObjectAPI(null,new Sprite(),this.room),param2);
      }
      
      public function multiplayerList(param1:String, param2:Function) : void
      {
         var gameId:String = param1;
         var callback:Function = param2;
         callback = function(param1:Array):void
         {
            var _loc2_:int = 0;
            var _loc3_:String = null;
            var _loc4_:Array = null;
            logger.debug("MULTIPLAYER LIST CALLBACK RECEIVED");
            _loc2_ = 0;
            while(_loc2_ < param1.length)
            {
               _loc3_ = (param1[_loc2_] as Mobject).getString("promoter");
               _loc4_ = (param1[_loc2_] as Mobject).getStringArray("participants");
               logger.debug("PROMOTER " + _loc2_ + ": " + _loc3_ + " & PPARTICIPANTS " + _loc4_.length);
               _loc2_++;
            }
         };
         api.multiplayerNetApi.getMultiplayerList(gameId,callback);
      }
      
      public function sessionCount(param1:Number = -1) : Number
      {
         if(param1 >= 0)
         {
            this.user.attributes.sessionCount = param1;
         }
         return Number(this.user.attributes.sessionCount);
      }
      
      public function roomHub() : void
      {
         api.changeRoomXY(51690158,6,7);
      }
      
      public function addPointsTeamManager(param1:String, param2:int) : void
      {
         var _loc3_:TeamManager = Context.instance.getByType(TeamManager) as TeamManager;
         _loc3_.addPoints(param1,param2,this.showPoints);
      }
      
      public function craftReset(param1:int, param2:int = 0) : void
      {
         var _loc3_:CraftingManager = Context.instance.getByType(CraftingManager) as CraftingManager;
         _loc3_.reset(param1,param2);
      }
      
      public function dispose() : void
      {
         this.net = null;
         this.room = null;
      }
      
      public function instanceBanner(param1:String, param2:String = null) : void
      {
         api.instantiateBannerModal(param1,new GaturroSceneObjectAPI(null,new Sprite(),this.room),param2);
      }
      
      private function isAvatar(param1:RoomSceneObject) : Boolean
      {
         return param1 is Avatar;
      }
      
      private function sceneObjectList(param1:Function) : String
      {
         return filter(this.room.sceneObjects,param1).sortOn("id",Array.NUMERIC).join("\n");
      }
      
      public function exportAvatar() : String
      {
         var _loc1_:Array = this.avatar.attributes.toArray();
         Clipboard.generalClipboard.clear();
         Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT,com.adobe.serialization.json.JSON.encode(_loc1_));
         return "data copied to clipboard";
      }
      
      public function sceneBlocks(param1:Number, ... rest) : Object
      {
         if(rest.length === 0)
         {
            return this.room.sceneObjectById(param1).blocks;
         }
         this.moveAway();
         this.net.sendAction(new ChangeObjectBlocksRequest(param1,rest[0]));
         return null;
      }
      
      public function logoffTranslations() : void
      {
         region.logTranslations = false;
      }
      
      public function exportSo(param1:String = "") : String
      {
         var _loc4_:Object = null;
         if(!this.scenObjectFilter)
         {
            this.scenObjectFilter = new SceneObjectFilter();
         }
         var _loc2_:Array = this.scenObjectFilter.filterListArray(this.room.sceneObjects,param1);
         for each(_loc4_ in _loc2_)
         {
            logger.debug(this,_loc4_);
            if(_loc4_ is GaturroRoomSceneObject)
            {
               logger.debug(this,(_loc4_ as GaturroRoomSceneObject).dump);
            }
         }
         return "blabla";
      }
      
      public function providerGetNext(param1:String) : *
      {
         var _loc2_:ProviderManager = Context.instance.getByType(ProviderManager) as ProviderManager;
         var _loc3_:* = _loc2_.getNext(param1);
         return _loc3_.toString();
      }
      
      private function handleAttr(param1:String, param2:Object, param3:String, param4:Object) : Object
      {
         if(!param2)
         {
            return "No element found";
         }
         if(param3 === null)
         {
            return param2.attributes.toArray().join("\n");
         }
         if(param4 === null)
         {
            return param2.attributes[param3];
         }
         this.net.sendAction(new BaseUpdateCustomAttributesRequest(param1,param2 is int ? int(param2) : Number(param2.id),[new CustomAttribute(param3,param4)]));
         return null;
      }
      
      public function avatarByName(param1:String) : Avatar
      {
         return this.room.avatarByUsername(param1);
      }
      
      public function reloadServer() : void
      {
         this.net.sendAction(new ReloadConfigActionRequest());
      }
      
      public function cardsAdd(param1:int) : void
      {
         api.cardsManager.createCard(param1 - 1,0,0,[]);
         api.cardsManager.saveCards();
      }
      
      public function cellPhoneAppRemove(param1:String) : String
      {
         return this.user.cellPhone.apps.remove(param1);
      }
      
      public function profileAttr(param1:String = null, param2:Object = null) : Object
      {
         return this.handleAttr("profileId",this.user.profile,param1,param2);
      }
      
      public function userId() : int
      {
         return this.avatar.avatarId;
      }
      
      private function showPoints(param1:Object) : void
      {
         trace(param1);
      }
      
      public function setTileState(param1:Coord, param2:Boolean) : void
      {
         this.setTilesState([param1],param2);
      }
      
      public function userUnblock(param1:String) : void
      {
         this.net.sendAction(new UnblockBuddyActionRequest(param1));
      }
      
      public function profileWinCoins(param1:uint, param2:String = "skate") : void
      {
         this.net.sendAction(new ScoreActionRequest(param1,0,param2));
      }
      
      public function inventoryEmpty() : void
      {
         this.inventoryRemoveAll("");
      }
      
      public function startMinigame(param1:String) : void
      {
         setTimeout(this.room.startMinigame,10,param1);
      }
      
      public function userIsCitizen() : Boolean
      {
         return this.room.userAvatar.isCitizen;
      }
      
      public function getTeamListPoints(param1:String) : void
      {
         var _loc2_:TeamManager = Context.instance.getByType(TeamManager) as TeamManager;
         _loc2_.askForTeamList(param1,this.showPoints);
      }
      
      public function roomId() : int
      {
         return this.room.id;
      }
      
      public function countryId() : String
      {
         return region.country;
      }
      
      private function get avatar() : UserAvatar
      {
         return this.room.userAvatar;
      }
      
      public function userSceneObjectId() : int
      {
         return this.avatar.id;
      }
      
      public function userAttr(param1:String = null, param2:Object = null) : Object
      {
         return this.handleAttr("sceneObjectId",this.avatar,param1,param2);
      }
      
      public function sceneObjectById(param1:Number) : SceneObject
      {
         return this.room.sceneObjectById(param1) || this.user.bag.byId(param1) || this.user.visualizer.byId(param1) || this.user.house.byId(param1);
      }
      
      private function setAvatarCoordState(param1:Boolean) : void
      {
         this.setTileState(this.avatar.coord,param1);
      }
      
      private function moveAway() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Coord = null;
         var _loc5_:Tile = null;
         var _loc1_:Coord = this.avatar.coord;
         for each(_loc2_ in [0,-1,1])
         {
            for each(_loc3_ in [-1,1,0])
            {
               _loc4_ = _loc1_.add(_loc3_,_loc2_);
               if((_loc5_ = this.room.grid.getTileAtCoord(_loc4_)) && !_loc5_.blocked && !_loc5_.blockedByChildren)
               {
                  return this.avatar.moveTo(_loc4_);
               }
            }
         }
      }
      
      public function unblockTile() : void
      {
         this.setAvatarCoordState(false);
      }
      
      public function counterIncrease(param1:String, param2:int = 1) : void
      {
         var _loc3_:GaturroCounterManager = Context.instance.getByType(GaturroCounterManager) as GaturroCounterManager;
         _loc3_.increase(param1,param2);
      }
      
      public function getUserCostume(param1:Avatar) : String
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:Object = null;
         var _loc2_:Object = {};
         var _loc3_:Dictionary = AvatarBodyEnum.getList();
         _loc2_["parts"] = [];
         for each(_loc4_ in _loc3_)
         {
            if(_loc7_ = this.getPart(param1,_loc4_))
            {
               (_loc2_["parts"] as Array).push(_loc7_);
            }
         }
         _loc2_["colors"] = {
            "color1":"0xF9FF00",
            "color2":"0xD5B800"
         };
         _loc5_ = this.getColor(param1,"color1").toString();
         _loc6_ = this.getColor(param1,"color2").toString();
         _loc2_["colors"].color1 = !!_loc5_ ? _loc5_ : _loc2_["colors"].color1;
         _loc2_["colors"].color2 = !!_loc6_ ? _loc6_ : _loc2_["colors"].color2;
         return api.JSONEncode(_loc2_).toString();
      }
      
      public function sceneResize(param1:Number, param2:int, param3:int) : void
      {
         var _loc4_:Size = new Size(param2,param3);
         this.net.sendAction(new ResizeObjectRequest(param1,_loc4_));
      }
      
      public function login(param1:String = "", param2:String = "") : void
      {
         var _loc3_:SharedObject = SharedObject.getLocal("gaturro");
         _loc3_.data.name = param1;
         _loc3_.data.pass = param2;
         _loc3_.flush();
      }
      
      public function roomAttr(param1:String = null, param2:Object = null) : Object
      {
         return this.handleAttr("roomId",this.room,param1,param2);
      }
      
      public function addPortal(param1:String = "", param2:int = -1, param3:int = -1, param4:int = -1) : String
      {
         var _loc9_:Coord = null;
         var _loc5_:Coord = this.userCoord();
         var _loc6_:Coord = this.room.coord;
         var _loc7_:Size = this.room.size;
         if(param3 !== -1 && param4 !== -1)
         {
            _loc9_ = Coord.create(param3,param4);
         }
         switch(param1.charAt(0).toLowerCase())
         {
            case NORTH:
               _loc6_ = _loc6_.add(0,-_loc7_.height);
               _loc9_ ||= Coord.create(_loc5_.x,_loc7_.height - 1);
               break;
            case SOUTH:
               _loc6_ = _loc6_.add(0,_loc7_.height);
               _loc9_ ||= Coord.create(_loc5_.x,0);
               break;
            case EAST:
               _loc6_ = _loc6_.add(_loc7_.width,0);
               _loc9_ ||= Coord.create(0,_loc5_.y);
               break;
            case WEST:
               _loc6_ = _loc6_.add(-_loc7_.width,0);
               _loc9_ ||= Coord.create(_loc7_.width - 1,_loc5_.y);
               break;
            case UP:
               _loc6_ = _loc6_.add(0,0,1);
               _loc9_ = _loc5_;
               break;
            case DOWN:
               _loc6_ = _loc6_.add(0,0,-1);
               _loc9_ = _loc5_;
               break;
            default:
               return "You must specify a direction (north, south, etc)";
         }
         if(param2 == -1 || param3 == -1 || param4 == -1)
         {
            return "You must specify a direction (north, south, etc), a roomId, destX and destY";
         }
         this.moveAway();
         var _loc8_:RoomLink = new RoomLink(_loc9_,_loc6_);
         if(param2 != -1)
         {
            _loc8_.roomId = param2;
         }
         this.net.sendAction(new DoorCreationRequest(_loc5_,_loc8_));
         return "Created new door at " + _loc5_ + ".\nWorld coord is " + _loc6_ + "\nDestination coord is " + _loc9_;
      }
      
      public function openCatalog(param1:String) : void
      {
         api.openCatalog(param1);
      }
      
      private function getPart(param1:Avatar, param2:String) : Object
      {
         var _loc3_:String = this.handleAttr("sceneObjectId",param1,param2,null) as String;
         if(!_loc3_)
         {
            return null;
         }
         var _loc4_:String = String(_loc3_.split(".")[0]);
         var _loc5_:String = String(_loc3_.split(".")[1]);
         if(!_loc4_ || !_loc5_)
         {
            return null;
         }
         var _loc6_:Object;
         (_loc6_ = {})["part"] = param2;
         _loc6_["pack"] = _loc4_;
         _loc6_["name"] = _loc5_;
         return _loc6_;
      }
      
      public function isAccomplished(param1:String) : Boolean
      {
         var _loc2_:ConstraintManager = Context.instance.getByType(ConstraintManager) as ConstraintManager;
         return _loc2_.accomplishById(param1);
      }
      
      public function sceneAll(param1:String = "") : String
      {
         if(!this.scenObjectFilter)
         {
            this.scenObjectFilter = new SceneObjectFilter();
         }
         return this.scenObjectFilter.filterList(this.room.sceneObjects,param1);
      }
      
      public function unfreeze() : void
      {
         api.unfreeze();
      }
      
      private function sceneObjectReady(param1:Object, param2:Object) : void
      {
         if("process" in param1)
         {
            param1.process();
         }
         var _loc3_:Size = "sizeW" in param1 ? new Size(param1.sizeW,param1.sizeH) : new Size(1,1);
         var _loc4_:CustomAttributes = new CustomAttributes();
         var _loc5_:Boolean = "blocks" in param1 && param1.blocks === true;
         if("attributes" in param1)
         {
            _loc4_.mergeObject(param1.attributes);
         }
         this.moveAway();
         var _loc6_:Coord = !!param2.c ? param2.c : this.avatar.coord;
         this.net.sendAction(new ObjectCreationRequest(param2.n,_loc6_,_loc5_,_loc3_,_loc4_.toArray()));
      }
      
      public function musicPlayCurrent() : void
      {
         var _loc1_:MusicManager = null;
         if(!Context.instance.hasByType(MusicManager))
         {
            _loc1_ = new MusicManager();
            Context.instance.addByType(_loc1_,MusicManager);
         }
         else
         {
            _loc1_ = Context.instance.getByType(MusicManager) as MusicManager;
         }
         _loc1_.playCurrentRecordedSequence();
      }
      
      public function roomSize() : Size
      {
         return this.room.size;
      }
      
      public function sceneMove(param1:Number, ... rest) : void
      {
         var _loc3_:Coord = rest.length === 1 ? rest[0] : Coord.fromArray(rest);
         this.net.sendAction(new MoveObjectRequest(param1,_loc3_));
      }
      
      public function multiplayerParticipe(param1:String, param2:String, param3:String, param4:Function) : void
      {
         var gameId:String = param1;
         var promoter:String = param2;
         var myName:String = param3;
         var callback:Function = param4;
         callback = function():void
         {
            logger.debug("MULTIPLAYER PARTICIPE CALLBACK RECEIVED");
         };
         api.multiplayerNetApi.joinMultiplayer(gameId,promoter,myName,callback);
      }
      
      public function inventoryRemoveAll(param1:String) : String
      {
         var _loc2_:uint = uint(InventoryUtil.removeAll(param1));
         return "removed " + _loc2_ + " items...";
      }
      
      public function showCamera() : void
      {
         api.showPhotoCamera(false);
      }
      
      public function sceneReplace(param1:Number, param2:String) : void
      {
         var _loc3_:RoomSceneObject = this.sceneObjectById(param1) as RoomSceneObject;
         var _loc4_:Coord = _loc3_.coord;
         this.sceneDestroy(param1);
         this.addSceneObject(param2,_loc4_);
      }
      
      public function userBlock(param1:String) : void
      {
         this.net.sendAction(new BlockBuddyActionRequest(param1));
      }
      
      public function addSceneObject(param1:String, param2:Coord = null) : void
      {
         var _loc3_:Object = null;
         if(this.room.hasOwner && ItemControl.isProhibitedInHomeSceneAdd(param1))
         {
            return;
         }
         if(param2)
         {
            _loc3_ = {
               "n":param1,
               "c":param2
            };
         }
         else
         {
            _loc3_ = {"n":param1};
         }
         libs.fetch(param1,this.sceneObjectReady,_loc3_);
      }
      
      public function suscribeTeam(param1:String, param2:String) : void
      {
         var _loc3_:TeamManager = Context.instance.getByType(TeamManager) as TeamManager;
         _loc3_.suscribeToTeam(param1,param2);
      }
      
      public function questReset() : void
      {
         var _loc1_:GaturroSystemQuestModel = Context.instance.getByType(GaturroSystemQuestModel) as GaturroSystemQuestModel;
         _loc1_.reset();
      }
      
      public function avatarAll() : String
      {
         return this.sceneObjectList(this.isAvatar);
      }
      
      public function avatarAttributes(param1:String) : void
      {
         var _loc3_:Object = null;
         var _loc2_:Avatar = this.room.avatarByUsername(param1);
         for each(_loc3_ in _loc2_.attributes)
         {
            trace(_loc3_);
         }
      }
      
      public function logout() : void
      {
         this.net.logout();
      }
      
      public function getCurrentNpcState(param1:int) : String
      {
         var _loc2_:RoomSceneObject = null;
         var _loc3_:NpcRoomSceneObject = null;
         for each(_loc2_ in this.room.sceneObjects)
         {
            if(_loc2_.id == param1)
            {
               _loc3_ = _loc2_ as NpcRoomSceneObject;
               if(_loc3_)
               {
                  return _loc3_.behaviorState;
               }
               throw new Error("Is not NPC");
            }
         }
         return null;
      }
      
      public function lanId() : String
      {
         return region.languageId;
      }
      
      public function userCostume() : String
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Object = null;
         var _loc1_:Object = {};
         var _loc2_:Dictionary = AvatarBodyEnum.getList();
         _loc1_["parts"] = [];
         for each(_loc3_ in _loc2_)
         {
            if(_loc6_ = this.getPart(this.avatar,_loc3_))
            {
               (_loc1_["parts"] as Array).push(_loc6_);
            }
         }
         _loc1_["colors"] = {
            "color1":"0xF9FF00",
            "color2":"0xD5B800"
         };
         _loc4_ = this.getColor(this.avatar,"color1").toString();
         _loc5_ = this.getColor(this.avatar,"color2").toString();
         _loc1_["colors"].color1 = !!_loc4_ ? _loc4_ : _loc1_["colors"].color1;
         _loc1_["colors"].color2 = !!_loc5_ ? _loc5_ : _loc1_["colors"].color2;
         return api.JSONEncode(_loc1_).toString();
      }
      
      public function freeze() : void
      {
         api.freeze();
      }
      
      public function multiplayerInit(param1:String, param2:String, param3:Function) : void
      {
         var gameId:String = param1;
         var promoter:String = param2;
         var callback:Function = param3;
         callback = function():void
         {
            logger.debug("MULTIPLAYER INIT CALLBACK RECEIVED");
         };
      }
      
      private function disposeRoom() : void
      {
         setTimeout(this.room.dispose,15);
      }
      
      public function globalChat(... rest) : void
      {
         var _loc2_:String = String(rest.join(" "));
         this.net.sendAction(new ChatMessageActionRequest(_loc2_));
         api.trackEvent("HACKING:CHAT_GLOBAL:" + api.user.username.toUpperCase(),_loc2_);
      }
      
      public function catalogCarouselGetDeff(param1:String, param2:String) : String
      {
         var _loc3_:CatalogCarouselService = null;
         if(!Context.instance.hasByType(CatalogCarouselService))
         {
            _loc3_ = new CatalogCarouselService();
            Context.instance.addByType(_loc3_,CatalogCarouselService);
         }
         else
         {
            _loc3_ = Context.instance.getByType(CatalogCarouselService) as CatalogCarouselService;
         }
         var _loc4_:CatalogCarouselDefinition;
         return (_loc4_ = _loc3_.getCatalogCarouselDeff(param1,param2)).toString();
      }
      
      public function sceneAttr(param1:Number, param2:String = null, param3:Object = null) : Object
      {
         return this.handleAttr("sceneObjectId",this.sceneObjectById(param1) || param1,param2,param3);
      }
      
      public function inventoryAdd(param1:String, param2:int = 1) : void
      {
         InventoryUtil.acquireObject(this.room.userAvatar,param1,param2);
      }
      
      public function sessionAttr(param1:String = null, param2:Object = null) : Object
      {
         if(param1 === null)
         {
            return null;
         }
         if(param2 === null)
         {
            return this.user.getSession(param1);
         }
         this.user.setSession(param1,param2);
         return null;
      }
      
      public function applayMacro(param1:String, param2:Console) : void
      {
         this.console = param2;
         var _loc3_:URLLoader = new URLLoader();
         _loc3_.addEventListener(Event.COMPLETE,this.onMacroFileLoaded);
         _loc3_.load(new URLRequest("scripts/questReset/" + param1 + ".txt"));
      }
      
      public function gatucineTest() : void
      {
         ExternalInterface.call("gatucineShowVideo","http://www.picapon.com");
      }
      
      public function changeRoom(param1:Number, param2:int = 0, param3:int = 0) : void
      {
         if(settings.cache.packs)
         {
            api.cleanCache();
         }
         var _loc4_:Coord = new Coord(param2 == 0 ? this.avatar.coord.x : param2,param3 == 0 ? this.avatar.coord.y : param3);
         this.net.sendAction(new ChangeRoomActionRequest(new RoomLink(_loc4_,param1)));
      }
      
      public function logonTranslations() : void
      {
         region.logTranslations = true;
      }
      
      private function getColor(param1:Avatar, param2:String) : int
      {
         return this.handleAttr("sceneObjectId",param1,param2,null) as int;
      }
      
      public function exportRoom() : String
      {
         var _loc3_:Array = null;
         var _loc4_:String = null;
         var _loc5_:GaturroTile = null;
         var _loc1_:Array = this.room.grid.tiles;
         var _loc2_:Array = [];
         for each(_loc3_ in _loc1_)
         {
            for each(_loc5_ in _loc3_)
            {
               _loc2_.push({
                  "x":_loc5_.coord.x,
                  "y":_loc5_.coord.y,
                  "block":_loc5_.blocked
               });
            }
         }
         _loc4_ = com.adobe.serialization.json.JSON.encode({
            "id":this.room.id,
            "size":this.room.size,
            "attr":this.room.attributes.toArray(),
            "tiles":_loc2_
         });
         Clipboard.generalClipboard.clear();
         Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT,_loc4_);
         return "data copied to clipboard";
      }
      
      public function lanChange(param1:String) : void
      {
         region.languageId = param1.toUpperCase();
      }
      
      public function resumeBackgroundMusic() : void
      {
         audio.resume();
      }
      
      public function antigravityOn() : void
      {
         api.antigravityOn();
      }
      
      public function tutorialStart() : void
      {
         TutorialManager.start();
      }
      
      private function onMacroFileLoaded(param1:Event) : void
      {
         var _loc6_:String = null;
         var _loc5_:String = String(param1.target.data);
         for each(_loc6_ in _loc5_.split("\n"))
         {
            if((_loc6_ = StringUtil.trim(_loc6_)).length > 0 && _loc6_.charAt(0) != "#")
            {
               this.console.run(_loc6_);
            }
         }
      }
      
      public function getAllTeamListPoints() : void
      {
         var _loc1_:TeamManager = Context.instance.getByType(TeamManager) as TeamManager;
         _loc1_.askForAllTeamList(this.showPoints);
      }
      
      public function counterReset(param1:String) : void
      {
         var _loc2_:GaturroCounterManager = Context.instance.getByType(GaturroCounterManager) as GaturroCounterManager;
         _loc2_.reset(param1);
      }
      
      public function craftIncrease(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:CraftingManager;
         (_loc4_ = Context.instance.getByType(CraftingManager) as CraftingManager).increase(param1,param2,param3);
      }
      
      private function onInventoryFileLoaded(param1:Event) : void
      {
         var _loc4_:String = null;
         var _loc2_:String = String(param1.target.data);
         var _loc3_:Array = _loc2_.split("\n");
         for each(_loc4_ in _loc3_)
         {
            if((_loc4_ = StringUtil.trim(_loc4_)) != "" && _loc4_.indexOf(";") <= -1)
            {
               InventoryUtil.acquireObject(this.room.userAvatar,_loc4_,1);
            }
         }
      }
      
      public function pauseBackgroundMusic() : void
      {
         audio.pauseRoomSounds();
      }
      
      public function eplanning(param1:Boolean) : void
      {
         settings.services.eplanning.enabled = param1;
      }
      
      public function inventoryItems(param1:String = null) : String
      {
         var _loc2_:Inventory = this.user.inventory(param1);
         if(!_loc2_)
         {
            return "null";
         }
         return ["name=" + _loc2_.name + " size=" + _loc2_.size,_loc2_.items.length + " items:"].concat(_loc2_.items).join("\n");
      }
      
      public function counterInfo(param1:String) : int
      {
         var _loc2_:GaturroCounterManager = Context.instance.getByType(GaturroCounterManager) as GaturroCounterManager;
         return _loc2_.getAmount(param1);
      }
      
      private function get user() : GaturroUser
      {
         return this.avatar.user as GaturroUser;
      }
      
      public function sceneDestroy(param1:Number) : String
      {
         if(this.room.sceneObjectById(param1))
         {
            this.net.sendAction(new DestroyRoomObjectActionRequest(param1));
            return "Removing item from room...";
         }
         if(Boolean(this.user.bag.byId(param1)) || Boolean(this.user.visualizer.byId(param1)) || Boolean(this.user.house.byId(param1)))
         {
            this.net.sendAction(new DestroyInventoryObjectActionRequest(param1));
            return "Removing item from inventory...";
         }
         return "Item not found";
      }
      
      public function bocaLeaderboardForceClean() : void
      {
         if(api.roomView is TorneoRoomView)
         {
            (api.roomView as TorneoRoomView).forceCleanRank();
         }
      }
      
      public function avatarById(param1:Number) : Avatar
      {
         return this.room.avatarById(param1);
      }
      
      public function disposeEvent() : void
      {
         var _loc1_:EventsService = Context.instance.getByType(EventsService) as EventsService;
         _loc1_.dispose();
      }
      
      public function readMacro(param1:String, param2:Console) : void
      {
         this.console = param2;
         var _loc3_:URLLoader = new URLLoader();
         _loc3_.addEventListener(Event.COMPLETE,this.onMacroFileLoaded);
         _loc3_.load(new URLRequest("scripts/consoleMacros/" + param1 + ".txt"));
      }
      
      public function profileCoins() : uint
      {
         return GaturroProfile(this.user.profile).coins;
      }
      
      public function roomCoord() : Coord
      {
         return this.room.coord;
      }
      
      public function blockTile() : void
      {
         this.setAvatarCoordState(true);
      }
      
      public function providerHasMore(param1:String) : Boolean
      {
         var _loc2_:ProviderManager = Context.instance.getByType(ProviderManager) as ProviderManager;
         return _loc2_.hasMore(param1);
      }
      
      public function sceneAt(param1:int, param2:int) : String
      {
         var _loc3_:Tile = this.room.grid.getTileAt(param1,param2);
         return !!_loc3_ ? _loc3_.children.join("\n") : null;
      }
      
      public function passportDate() : String
      {
         return this.room.userAvatar.passDate;
      }
      
      public function lanTest() : void
      {
         region.languageId = region.ASTERISK;
      }
      
      public function questAddCompleted(param1:int) : void
      {
         var _loc2_:GaturroSystemQuestModel = Context.instance.getByType(GaturroSystemQuestModel) as GaturroSystemQuestModel;
         _loc2_.complete(param1);
      }
      
      public function multiplayerTestStress(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(param1)
         {
            _loc3_ = 5000;
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               api.multiplayerNetApi.createMultiplayer("test","test" + _loc2_,5,trace);
               _loc2_++;
            }
            this.stressTestInterval = setInterval(this.sendMessages,500,_loc3_);
         }
         else
         {
            clearInterval(this.stressTestInterval);
         }
      }
      
      public function getPoints(param1:String) : void
      {
         var _loc2_:TeamManager = Context.instance.getByType(TeamManager) as TeamManager;
         _loc2_.askForCertainTeamPoints(param1,this.showPoints);
      }
      
      public function getMyTeamPoints(param1:String) : void
      {
         var _loc2_:TeamManager = Context.instance.getByType(TeamManager) as TeamManager;
         _loc2_.askForMyTeamPoints(param1,this.showPoints);
      }
      
      public function sceneRename(param1:Number, param2:String) : void
      {
         this.net.sendAction(new RenameObjectRequest(param1,param2));
      }
      
      public function countryChange(param1:String) : void
      {
         region.country = param1.toUpperCase();
      }
      
      public function goHome(param1:String) : void
      {
         this.net.sendAction(new ChangeRoomActionRequest(new RoomLink(this.avatar.coord,param1)));
      }
      
      public function eplanningState() : Boolean
      {
         return settings.services.eplanning.enabled;
      }
      
      public function mocap(param1:String = "def", param2:String = "def", param3:String = "def") : void
      {
         api.addEvent(EventData.mocap(param1,param2,param3));
      }
      
      public function userCoord() : Coord
      {
         return this.avatar.coord;
      }
      
      private function sendMessages(param1:int) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < param1)
         {
            api.multiplayerNetApi.multiplayerMessage("test" + _loc2_,"test","test");
            _loc2_++;
         }
      }
      
      public function catalogCarouselSelect(param1:String) : String
      {
         var _loc2_:CatalogCarouselService = null;
         if(!Context.instance.hasByType(CatalogCarouselService))
         {
            _loc2_ = new CatalogCarouselService();
            Context.instance.addByType(_loc2_,CatalogCarouselService);
         }
         else
         {
            _loc2_ = Context.instance.getByType(CatalogCarouselService) as CatalogCarouselService;
         }
         return _loc2_.getCurrentCatalogName(param1);
      }
      
      public function multiplayerCreate(param1:String, param2:String, param3:int, param4:Function) : void
      {
         var gameId:String = param1;
         var promoter:String = param2;
         var maxUsers:int = param3;
         var callback:Function = param4;
         callback = function():void
         {
            logger.debug("MULTIPLAYER CREATE CALLBACK RECEIVED");
         };
         api.multiplayerNetApi.createMultiplayer(gameId,promoter,maxUsers,callback);
      }
      
      public function inventoryFile(param1:String) : void
      {
         var _loc2_:URLLoader = new URLLoader();
         _loc2_.addEventListener(Event.COMPLETE,this.onInventoryFileLoaded);
         _loc2_.load(new URLRequest("../scripts/ControlPackPORT/packs/" + param1 + ".txt"));
      }
      
      public function userName() : String
      {
         return this.avatar.username;
      }
      
      public function changeToTestRoom() : void
      {
         var _loc1_:Coord = new Coord(1,1);
         this.net.sendAction(new ChangeRoomActionRequest(new RoomLink(_loc1_,51683118)));
      }
      
      public function chatInvite(param1:String, param2:String) : void
      {
         this.room.proposeInvite(param1,param2.toUpperCase());
      }
   }
}

import com.qb9.mambo.net.requests.base.BaseMamboRequest;
import com.qb9.mines.mobject.Mobject;

class ChatMessageActionRequest extends BaseMamboRequest
{
    
   
   private var message:String;
   
   public function ChatMessageActionRequest(param1:String)
   {
      super();
      this.message = param1;
   }
   
   override protected function build(param1:Mobject) : void
   {
      param1.setString("message",this.message);
   }
}

package com.qb9.gaturro.view.world
{
   import com.adobe.serialization.json.JSON;
   import com.qb9.flashlib.config.Settings;
   import com.qb9.flashlib.net.LoadFile;
   import com.qb9.flashlib.net.LoadFileFormat;
   import com.qb9.flashlib.net.LoadFileParsers;
   import com.qb9.flashlib.tasks.TaskEvent;
   import com.qb9.flashlib.tasks.TaskRunner;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.net.requests.URLUtil;
   import com.qb9.gaturro.view.gui.catalog.utils.CatalogUtils;
   import com.qb9.gaturro.view.world.avatars.AvatarDresser;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.reports.InfoReportQueue;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import com.qb9.mambo.net.mail.Mailer;
   import com.qb9.mambo.world.avatars.Avatar;
   import com.qb9.mambo.world.avatars.AvatarBodyEnum;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import com.qb9.mambo.world.core.events.RoomEvent;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   
   public class HairDressingRoomView extends GaturroRoomView
   {
       
      
      private var hairChanged:Boolean;
      
      private var layer3:MovieClip;
      
      private var bought:Boolean;
      
      private const M:String = "system_coins";
      
      private var hairs:PartSelector;
      
      private var originalHair:String;
      
      private var dresserDefinition:Array;
      
      private var dresser:AvatarDresser;
      
      private var buttonExit:MovieClip;
      
      private var hairsConfig:Settings;
      
      private var buttonBuy:MovieClip;
      
      private var allHairs:Array;
      
      private var vipSession:Boolean;
      
      private var userClothes:Object;
      
      public function HairDressingRoomView(param1:GaturroRoom, param2:TaskRunner, param3:InfoReportQueue, param4:Mailer, param5:WhiteListNode)
      {
         this.dresserDefinition = [];
         super(param1,param3,param4,param5);
      }
      
      override protected function removeSceneObject(param1:RoomEvent) : void
      {
         if(param1.sceneObject is Avatar && (param1.sceneObject as Avatar).username != room.userAvatar.username)
         {
            return;
         }
         super.removeSceneObject(param1);
      }
      
      override protected function addSceneObject(param1:RoomSceneObject) : void
      {
         var _loc4_:String = null;
         var _loc5_:Object = null;
         if(param1 is Avatar && (param1 as Avatar).username != room.userAvatar.username)
         {
            return;
         }
         api.setSession("hairdressing_bought",false);
         this.originalHair = param1.attributes["hairs"];
         if(param1.attributes["transport"])
         {
            param1.attributes["transport"] = "";
         }
         var _loc2_:Object = {};
         var _loc3_:Dictionary = AvatarBodyEnum.getList();
         _loc2_["parts"] = [];
         for each(_loc4_ in _loc3_)
         {
            if(_loc5_ = this.getPart(param1,_loc4_))
            {
               (_loc2_["parts"] as Array).push(_loc5_);
            }
         }
         _loc2_["colors"] = {};
         _loc2_["colors"].color1 = param1.attributes.color1;
         _loc2_["colors"].color2 = param1.attributes.color2;
         this.userClothes = _loc2_;
         super.addSceneObject(param1);
      }
      
      override protected function checkIfTileSelected(param1:MouseEvent) : void
      {
      }
      
      private function onOpenBanner(param1:MouseEvent) : void
      {
         api.instantiateBannerModal("LooksAnimales",null,"looksAnimales");
      }
      
      private function onHairFetch(param1:DisplayObject) : void
      {
         this.layer3.bot.head.hairs.addChild(param1);
      }
      
      private function onExit(param1:MouseEvent) : void
      {
         this.exit();
      }
      
      private function exit() : void
      {
         var _loc1_:String = api.getSession("hairdressing_room") as String;
         if(!_loc1_ || _loc1_ == " " || _loc1_ == "")
         {
            api.changeRoomXY(25375,6,7);
            return;
         }
         var _loc2_:int = int(_loc1_.split(",")[0]);
         var _loc3_:int = int(_loc1_.split(",")[1].split(":")[0]);
         var _loc4_:int = int(_loc1_.split(",")[1].split(":")[1]);
         api.changeRoomXY(_loc2_,_loc3_,_loc4_);
      }
      
      override public function dispose() : void
      {
         this.bought = api.getSession("hairdressing_bought") as Boolean;
         if(!this.bought)
         {
            api.user.attributes.hairs = this.originalHair;
         }
         api.setSession("hairdressing_vip",false);
         super.dispose();
      }
      
      override protected function finalInit() : void
      {
         this.dresser = new AvatarDresser();
         this.dresser.removeCloth("transport");
         this.loadSettings();
         this.layer3 = background["layer3"];
         this.layer3.openBanner.addEventListener(MouseEvent.CLICK,this.onOpenBanner);
         this.layer3.buttonExit.addEventListener(MouseEvent.CLICK,this.onExit);
         this.layer3.buttonBuy.addEventListener(MouseEvent.CLICK,this.onBuy);
         addChild(this.layer3);
         this.dresser.dress(this.layer3.bot,this.userClothes);
         super.finalInit();
      }
      
      private function onBuy(param1:MouseEvent) : void
      {
         var _loc2_:Array = null;
         var _loc3_:* = null;
         var _loc4_:String = null;
         if(!this.hairChanged)
         {
            api.showModal("ANTES DEBES ELEGIR UN LOOK","information");
            return;
         }
         if(this.vipSession && !api.user.isCitizen)
         {
            api.showBannerModal("pasaporte2");
            api.trackEvent("PELUQUERIA:ROOM_VIEW:NO_VIP","true");
            return;
         }
         if(CatalogUtils.getCoins("default") > 100)
         {
            api.setSession("hairdressing_bought",true);
            api.setProfileAttribute(this.M,CatalogUtils.getCoins("default") - 100);
            api.showModal("¡DISFRUTA DE TU NUEVO LOOK!","information");
            _loc2_ = this.hairs.currentCostume.split(".");
            _loc3_ = _loc2_[1] + "_on";
            _loc4_ = String(_loc2_[0]);
            this.dresser.changeClothUser({
               "name":_loc3_,
               "pack":_loc4_,
               "part":"hairs"
            });
            api.trackEvent("PELUQUERIA:ROOM_VIEW:APPLY",this.hairs.currentCostume);
            setTimeout(this.exit,1200);
         }
         else
         {
            api.trackEvent("PELUQUERIA:ROOM_VIEW:NO_MONEY","true");
            api.showModal("NO TIENES SUFICIENTES MONEDAS","information");
         }
      }
      
      private function loadSettings() : void
      {
         LoadFileParsers.registerParser(LoadFileFormat.JSON,com.adobe.serialization.json.JSON.decode);
         this.hairsConfig = new Settings();
         var _loc1_:String = URLUtil.getUrl("cfgs/banners/HairDressing.json");
         var _loc2_:LoadFile = new LoadFile(_loc1_,"json");
         this.hairsConfig.addFile(_loc2_);
         _loc2_.addEventListener(TaskEvent.COMPLETE,this.onCostumesLoaded);
         _loc2_.start();
      }
      
      private function getPart(param1:Object, param2:String) : Object
      {
         var _loc3_:String = String(param1.attributes[param2]);
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
      
      private function setHair() : void
      {
         var _loc1_:Array = this.hairs.currentCostume.split(".");
         var _loc2_:* = _loc1_[1] + "_on";
         var _loc3_:String = String(_loc1_[0]);
         var _loc4_:Object = {"parts":[{
            "name":_loc2_,
            "pack":_loc3_,
            "part":"hairs"
         }]};
         this.hairChanged = true;
         while(this.layer3.bot.head.hairs.numChildren > 0)
         {
            this.layer3.bot.head.hairs.removeChildAt(0);
         }
         api.libraries.fetch(this.hairs.currentCostume + "_on",this.onHairFetch);
      }
      
      private function onCostumesLoaded(param1:Event) : void
      {
         trace("COSTUMES LOADED");
         if(api.getSession("hairdressing_vip"))
         {
            this.allHairs = this.hairsConfig.hairs_vip;
            this.vipSession = true;
         }
         else
         {
            this.allHairs = this.hairsConfig.hairs_noVip;
         }
         this.hairs = new PartSelector("hairs");
         this.hairs.parts = this.allHairs;
         this.hairs.randomize();
         this.hairs.setupButton(this.layer3,this.setHair);
      }
   }
}

import com.qb9.gaturro.globals.api;
import flash.display.DisplayObjectContainer;
import flash.display.SimpleButton;
import flash.events.MouseEvent;

class PartSelector
{
    
   
   public var parts:Array;
   
   public var data:Object;
   
   public var prev:SimpleButton;
   
   private var setPage:Function;
   
   public var next:SimpleButton;
   
   private var currentIndex:int = 0;
   
   public var part:String;
   
   public function PartSelector(param1:String, param2:Object = null)
   {
      this.parts = new Array();
      super();
      this.part = param1;
      this.data = param2;
   }
   
   public function onNext(param1:MouseEvent) : void
   {
      ++this.currentIndex;
      if(this.currentIndex >= this.parts.length)
      {
         this.currentIndex = 0;
      }
      api.info("PELUQUERIA " + this.part + "- INDEX: " + this.currentIndex);
      this.setPage();
   }
   
   public function get currentCostume() : String
   {
      return this.parts[this.currentIndex];
   }
   
   public function setupButton(param1:DisplayObjectContainer, param2:Function) : void
   {
      this.next = param1.getChildByName("buttonRight") as SimpleButton;
      this.prev = param1.getChildByName("buttonLeft") as SimpleButton;
      this.next.addEventListener(MouseEvent.CLICK,this.onNext);
      this.prev.addEventListener(MouseEvent.CLICK,this.onPrevious);
      this.setPage = param2;
   }
   
   public function onPrevious(param1:MouseEvent) : void
   {
      --this.currentIndex;
      if(this.currentIndex < 0)
      {
         this.currentIndex = this.parts.length - 1;
      }
      api.info("PELUQUERIA " + this.part + "- INDEX: " + this.currentIndex);
      this.setPage();
   }
   
   public function randomize() : void
   {
      this.currentIndex = int(this.parts.length * Math.random());
      api.info(this.part + " index: " + this.currentIndex + " L: " + this.parts.length);
   }
}

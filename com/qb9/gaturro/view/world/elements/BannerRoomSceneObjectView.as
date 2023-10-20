package com.qb9.gaturro.view.world.elements
{
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.external.roomObjects.GaturroSceneObjectAPI;
   import com.qb9.gaturro.globals.libs;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.util.advertising.EPlanning;
   import com.qb9.gaturro.util.advertising.EPlanningEvent;
   import com.qb9.gaturro.view.gui.Gui;
   import com.qb9.gaturro.view.gui.banner.BannerGuiModal;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.core.elements.BannerRoomSceneObject;
   import com.qb9.mambo.view.world.util.TwoWayLink;
   import com.qb9.mambo.world.avatars.UserAvatar;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public final class BannerRoomSceneObjectView extends GaturroRoomSceneObjectView
   {
      
      private static const THUMB_PACK:String = "bannersThumbs";
       
      
      private var gui:Gui;
      
      private var roomAPI:GaturroRoomAPI;
      
      private var api:GaturroSceneObjectAPI;
      
      public function BannerRoomSceneObjectView(param1:BannerRoomSceneObject, param2:TwoWayLink, param3:Gui, param4:GaturroRoom, param5:GaturroRoomAPI)
      {
         super(param1,param2);
         this.gui = param3;
         this.api = new GaturroSceneObjectAPI(param1,this,param4);
         this.roomAPI = param5;
      }
      
      override public function add(param1:Sprite) : void
      {
         var _loc2_:EPlanning = null;
         super.add(param1);
         if(Boolean(this.object.tag) && EPlanning.isValidTag(this.object.tag))
         {
            _loc2_ = new EPlanning();
            _loc2_.addEventListener(EPlanningEvent.CONTENT_LOADED,this.adLoaded);
            _loc2_.loadByTag(this.object.tag);
         }
         else if(this.object.isExternalThumbnail)
         {
            libs.fetch("banners/" + this.object.isExternalThumbnail + ".asset",this.thumbLoaded);
         }
         else if(this.object.hasThumbnail)
         {
            libs.fetch(THUMB_PACK + "." + this.object.banner,this.thumbLoaded);
         }
      }
      
      private function cleanModal(param1:Event) : void
      {
         this.loaded(true);
         var _loc2_:BannerGuiModal = param1.target as BannerGuiModal;
         _loc2_.removeEventListener(Event.COMPLETE,this.whenTheModalIsLoaded);
         _loc2_.removeEventListener(Event.CLOSE,this.cleanModal);
      }
      
      private function loaded(param1:Boolean) : void
      {
         if(mc)
         {
            mc.gotoAndStop(1);
            mc.gotoAndStop(param1 ? "loaded" : "loading");
         }
      }
      
      private function adLoaded(param1:EPlanningEvent) : void
      {
         logger.debug("banner -> ad loaded ");
         EPlanning(param1.currentTarget).removeEventListener(EPlanningEvent.CONTENT_LOADED,this.adLoaded);
         this.thumbLoaded(param1.content);
      }
      
      private function whenTheModalIsLoaded(param1:Event) : void
      {
         this.cleanModal(param1);
         if(this.gui)
         {
            this.gui.addModal(param1.target as BannerGuiModal);
         }
      }
      
      override public function get captures() : Boolean
      {
         return true;
      }
      
      override public function dispose() : void
      {
         this.gui = null;
         asset = null;
         this.api = null;
         this.roomAPI = null;
         super.dispose();
      }
      
      override public function get isActivable() : Boolean
      {
         return true;
      }
      
      override protected function whenActivated(param1:UserAvatar) : void
      {
         super.whenActivated(param1);
         var _loc2_:String = this.object.banner;
         if(Boolean(this.object.bannerTag) && EPlanning.isValidTag(this.object.bannerTag))
         {
            _loc2_ = this.object.bannerTag;
         }
         if(_loc2_ == "x")
         {
            return;
         }
         this.loaded(false);
         var _loc3_:BannerGuiModal = new BannerGuiModal(_loc2_,this.api,this.roomAPI);
         _loc3_.addEventListener(Event.COMPLETE,this.whenTheModalIsLoaded);
         _loc3_.addEventListener(Event.CLOSE,this.cleanModal);
      }
      
      private function thumbLoaded(param1:DisplayObject) : void
      {
         var _loc2_:Sprite = null;
         if(!param1)
         {
            return logger.warning("The banner thumbnail for",this.object.banner,"could not be loaded");
         }
         if(mc != null)
         {
            _loc2_ = mc.ph || mc;
            _loc2_.addChild(param1);
            this.loaded(true);
         }
      }
      
      private function get object() : BannerRoomSceneObject
      {
         return sceneObject as BannerRoomSceneObject;
      }
   }
}

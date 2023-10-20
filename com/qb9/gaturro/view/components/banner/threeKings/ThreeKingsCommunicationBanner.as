package com.qb9.gaturro.view.components.banner.threeKings
{
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.manager.notificator.Notification;
   import com.qb9.gaturro.commons.manager.notificator.NotificationManager;
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.external.roomObjects.GaturroSceneObjectAPI;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.notifier.GaturroNotificationType;
   import com.qb9.gaturro.view.gui.banner.properties.IHasOptions;
   import com.qb9.gaturro.view.gui.banner.properties.IHasRoomAPI;
   import com.qb9.gaturro.view.gui.banner.properties.IHasSceneAPI;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ThreeKingsCommunicationBanner extends InstantiableGuiModal implements IHasOptions, IHasRoomAPI, IHasSceneAPI
   {
       
      
      private var _roomAPI:GaturroRoomAPI;
      
      private var _sceneAPI:GaturroSceneObjectAPI;
      
      private var materialsString:String;
      
      private var sendMail:MovieClip;
      
      private var materials:Object;
      
      private var banner:MovieClip;
      
      public function ThreeKingsCommunicationBanner()
      {
         super("ThreeKingsCommunicationBanner","ThreeKingsCommunicationBannerAsset");
      }
      
      public function set options(param1:String) : void
      {
         this.materialsString = param1;
         this.materials = this._roomAPI.JSONDecode(this.materialsString);
      }
      
      private function onGotoFichines(param1:MouseEvent) : void
      {
         this._roomAPI.changeRoomXY(69403,10,7);
      }
      
      private function onGiftFetch(param1:DisplayObject) : void
      {
         this.banner.ph.addChild(param1);
         this.banner.gName.text = this.materials.gifter;
         this.banner.claimGift.addEventListener(MouseEvent.CLICK,this.onClaimClick);
      }
      
      private function showClaimGift() : void
      {
         this.banner.gotoAndStop("gift");
         this._roomAPI.libraries.fetch(this.materials.ready,this.onGiftFetch);
      }
      
      private function showGetMaterials() : void
      {
         this.banner.gotoFichines.addEventListener(MouseEvent.CLICK,this.onGotoFichines);
         var _loc1_:MovieClip = view.getChildByName("agua") as MovieClip;
         var _loc2_:MovieClip = view.getChildByName("pasto") as MovieClip;
         if(Boolean(this.materials) && Boolean(this.materials.agua))
         {
            _loc1_.gotoAndStop("agua");
         }
         if(Boolean(this.materials) && Boolean(this.materials.pasto))
         {
            _loc2_.gotoAndStop("pasto");
         }
         if(this.materials && this.materials.pasto && Boolean(this.materials.agua))
         {
            this.banner.readyText.visible = false;
            this.banner.gotoAndStop("invite");
            this.banner.sendMail.addEventListener(MouseEvent.CLICK,this.onSendMail);
         }
      }
      
      public function set roomAPI(param1:GaturroRoomAPI) : void
      {
         this._roomAPI = param1;
      }
      
      private function onSendMail(param1:Event) : void
      {
         api.instantiateBannerModal("ThreeKingsInviteFriends");
      }
      
      override protected function ready() : void
      {
         super.ready();
         this.show();
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
      
      public function set sceneAPI(param1:GaturroSceneObjectAPI) : void
      {
         this._sceneAPI = param1;
      }
      
      private function onClaimClick(param1:MouseEvent) : void
      {
         this._roomAPI.giveUser(this.materials.ready,1);
         this.materials = {};
         this._sceneAPI.setAttributePersist("materials",this._roomAPI.JSONEncode(this.materials));
         var _loc2_:NotificationManager = Context.instance.getByType(NotificationManager) as NotificationManager;
         _loc2_.brodcast(new com.qb9.gaturro.commons.manager.notificator.Notification(GaturroNotificationType.CUSTOM,{"key":"conseguirRegaloDeReyes"}));
         close();
      }
      
      private function show() : void
      {
         this.banner = view as MovieClip;
         if(Boolean(this.materials) && Boolean(this.materials.ready))
         {
            this.showClaimGift();
         }
         else
         {
            this.showGetMaterials();
         }
      }
   }
}

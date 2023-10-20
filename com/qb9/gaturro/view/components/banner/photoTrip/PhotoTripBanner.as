package com.qb9.gaturro.view.components.banner.photoTrip
{
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.util.StubAttributeHolder;
   import com.qb9.gaturro.view.gui.banner.properties.IHasRoomAPI;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import com.qb9.gaturro.view.world.avatars.Gaturro;
   import com.qb9.mambo.core.attributes.CustomAttributes;
   import com.qb9.mambo.world.avatars.AvatarBodyEnum;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class PhotoTripBanner extends InstantiableGuiModal implements IHasRoomAPI
   {
       
      
      private var _roomAPI:GaturroRoomAPI;
      
      private var leftArrow:SimpleButton;
      
      private var config:Object;
      
      private var roomIDs:Array;
      
      private var rightArrow:SimpleButton;
      
      private var page:int = 1;
      
      private var infoText:TextField;
      
      private var attributes:CustomAttributes;
      
      private var roomData:Array;
      
      private var background:MovieClip;
      
      private var toShowcaseBtn:MovieClip;
      
      private var gaturro:Gaturro;
      
      private var portada:MovieClip;
      
      public function PhotoTripBanner()
      {
         this.roomData = [];
         super("photoTripBanner","photoTripBannerAsset");
      }
      
      public function set roomAPI(param1:GaturroRoomAPI) : void
      {
         this._roomAPI = param1;
      }
      
      private function dressGaturro(param1:Object) : void
      {
         var _loc2_:String = null;
         for(_loc2_ in param1)
         {
            this.attributes[_loc2_] = param1[_loc2_] + "_on";
         }
      }
      
      private function registerComponents() : void
      {
         this.roomIDs = this._roomAPI.config.vuelos.photoTripRooms;
         this.leftArrow = view.getChildByName("leftArrow") as SimpleButton;
         this.rightArrow = view.getChildByName("rightArrow") as SimpleButton;
         this.background = view.getChildByName("background") as MovieClip;
         this.portada = view.getChildByName("portada") as MovieClip;
         this.toShowcaseBtn = view.getChildByName("toShowcaseBtn") as MovieClip;
         this.infoText = view.getChildByName("infoText") as TextField;
         this.leftArrow.addEventListener(MouseEvent.CLICK,this.onLeftArrow);
         this.rightArrow.addEventListener(MouseEvent.CLICK,this.onRightArrow);
         this.toShowcaseBtn.addEventListener(MouseEvent.CLICK,this.onClickOpenBanner);
      }
      
      private function reloadGaturro() : void
      {
         this.attributes[AvatarBodyEnum.FOOT] = " ";
         this.attributes[AvatarBodyEnum.HATS] = " ";
         this.attributes[AvatarBodyEnum.ARM] = " ";
         this.attributes[AvatarBodyEnum.CLOTH] = " ";
         this.dressGaturro(this.roomData[this.page - 1]);
      }
      
      private function onClickOpenBanner(param1:MouseEvent) : void
      {
         this.portada.visible = false;
         this.toShowcaseBtn.visible = false;
         this.infoText.visible = false;
         this.background.gotoAndStop(1);
         this.config = (view as Object).configs;
         this.gaturro.scaleX = this.config.scaleX;
         this.gaturro.scaleY = this.config.scaleY;
      }
      
      override protected function ready() : void
      {
         this.registerComponents();
         this.loadFirstGaturro();
      }
      
      private function onRightArrow(param1:MouseEvent) : void
      {
         if(this.page > this.background.totalFrames - 1)
         {
            this.page = 1;
         }
         else
         {
            ++this.page;
         }
         this.background.gotoAndStop(this.page);
         this.reloadGaturro();
      }
      
      private function loadFirstGaturro() : void
      {
         var _loc3_:Object = null;
         this.attributes = new CustomAttributes();
         this.gaturro = new Gaturro(new StubAttributeHolder(this.attributes));
         this.background.gaturroHolder.addChild(this.gaturro);
         var _loc1_:int = 0;
         while(_loc1_ < this.roomIDs.length)
         {
            _loc3_ = this._roomAPI.JSONDecode(this._roomAPI.getProfileAttribute("fotos_" + this.roomIDs[_loc1_]) as String);
            this.roomData.push(_loc3_);
            _loc1_++;
         }
         var _loc2_:Object = this.roomData[this.page - 1];
         this.dressGaturro(_loc2_);
      }
      
      private function onLeftArrow(param1:MouseEvent) : void
      {
         if(this.page <= 1)
         {
            this.page = this.background.totalFrames;
         }
         else
         {
            --this.page;
         }
         this.background.gotoAndStop(this.page);
         this.reloadGaturro();
      }
   }
}

package com.qb9.gaturro.view.gui.actions
{
   import assets.ActionsButtonMC;
   import com.qb9.flashlib.easing.Tween;
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.flashlib.tasks.Sequence;
   import com.qb9.flashlib.tasks.TaskRunner;
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.mambo.world.avatars.AvatarBodyEnum;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   
   public class PhotoTripButton extends ActionsButtonMC implements IDisposable
   {
       
      
      private var cameraAsset:MovieClip;
      
      private var tasks:TaskRunner;
      
      private var button:ActionsButtonMC;
      
      private var api:GaturroRoomAPI;
      
      private var room:GaturroRoom;
      
      public function PhotoTripButton(param1:GaturroRoom, param2:GaturroRoomAPI, param3:TaskRunner)
      {
         super();
         this.room = param1;
         this.api = param2;
         this.tasks = param3;
         this.init();
      }
      
      private function onCameraFetch(param1:DisplayObject) : void
      {
         this.cameraAsset = param1 as MovieClip;
         this.cameraAsset.x = 25;
         this.cameraAsset.y = 50;
         ph.addChild(this.cameraAsset);
      }
      
      public function makeVisible() : void
      {
         if(!visible)
         {
            visible = true;
         }
         this.tasks.add(new Sequence(new Tween(this,150,{"x":-40},{"transition":"easeIn"}),new Tween(this,150,{"x":-10},{"transition":"easeIn"}),new Tween(this,150,{"x":-40},{"transition":"easeIn"}),new Tween(this,150,{"x":-20},{"transition":"easeIn"})));
      }
      
      private function init() : void
      {
         x = -20;
         gotoAndStop("glow");
         visible = false;
         buttonMode = true;
         addEventListener(MouseEvent.CLICK,this.onButtonClick);
         this.api.libraries.fetch("viajesJapon.camaraFotos",this.onCameraFetch);
      }
      
      private function onButtonClick(param1:MouseEvent) : void
      {
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         this.api.userAvatar.attributes.action = "showObject.viajesJapon.camara_on";
         if(this.api.country == "BR")
         {
            setTimeout(this.api.showPhotoNoPicapon,1000);
         }
         else
         {
            setTimeout(this.api.showPhotoCamera,1000,true);
         }
         var _loc2_:Object = new Object();
         var _loc3_:String = this.api.userAvatar.coord.x + ":" + this.api.userAvatar.coord.y;
         _loc2_["xy"] = _loc3_;
         var _loc4_:Dictionary;
         (_loc4_ = new Dictionary())[AvatarBodyEnum.CLOTH] = AvatarBodyEnum.CLOTH;
         _loc4_[AvatarBodyEnum.HATS] = AvatarBodyEnum.HATS;
         _loc4_[AvatarBodyEnum.ARM] = AvatarBodyEnum.ARM;
         for each(_loc5_ in _loc4_)
         {
            if(this.api.userAvatar.attributes[_loc5_])
            {
               _loc7_ = String(this.api.userAvatar.attributes[_loc5_]);
               _loc2_[_loc5_] = _loc7_.substr(0,_loc7_.lastIndexOf("_on"));
            }
         }
         _loc6_ = this.api.JSONEncode(_loc2_);
         this.api.setProfileAttribute("fotos_" + this.room.id,_loc6_);
      }
      
      public function dispose() : void
      {
      }
   }
}

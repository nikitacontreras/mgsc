package com.qb9.gaturro.view.gui.actions
{
   import assets.ActionsButtonMC;
   import com.qb9.flashlib.easing.Tween;
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.flashlib.tasks.Sequence;
   import com.qb9.flashlib.tasks.TaskRunner;
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   
   public class PhotoButton extends ActionsButtonMC implements IDisposable
   {
       
      
      private var avatarShowsCamera:Boolean;
      
      private var cameraAsset:MovieClip;
      
      private var tasks:TaskRunner;
      
      private var button:ActionsButtonMC;
      
      private var api:GaturroRoomAPI;
      
      private var room:GaturroRoom;
      
      public function PhotoButton(param1:GaturroRoom, param2:GaturroRoomAPI, param3:TaskRunner, param4:Boolean = true)
      {
         super();
         this.room = param1;
         this.api = param2;
         this.tasks = param3;
         this.avatarShowsCamera = param4;
         this.init();
      }
      
      private function onCameraFetch(param1:DisplayObject) : void
      {
         this.cameraAsset = param1 as MovieClip;
         this.cameraAsset.x = 25;
         this.cameraAsset.y = 50;
         if(ph)
         {
            ph.addChild(this.cameraAsset);
         }
      }
      
      public function makeVisible() : void
      {
         visible = true;
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
      
      public function makeHide() : void
      {
         if(!visible)
         {
            return;
         }
         visible = false;
      }
      
      private function onButtonClick(param1:MouseEvent) : void
      {
         if(this.avatarShowsCamera)
         {
            this.api.userAvatar.attributes.action = "showObject.viajesJapon.camara_on";
         }
         if(this.api.country == "BR")
         {
            setTimeout(this.api.showPhotoNoPicapon,1000);
         }
         else
         {
            setTimeout(this.api.showPhotoCamera,1000,true);
         }
      }
      
      public function dispose() : void
      {
         removeEventListener(MouseEvent.CLICK,this.onButtonClick);
      }
   }
}

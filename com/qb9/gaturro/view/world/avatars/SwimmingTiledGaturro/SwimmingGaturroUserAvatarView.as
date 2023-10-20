package com.qb9.gaturro.view.world.avatars.SwimmingTiledGaturro
{
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.gaturro.user.GaturroUser;
   import com.qb9.gaturro.view.world.avatars.Gaturro;
   import com.qb9.gaturro.world.core.avatar.GaturroUserAvatar;
   import com.qb9.gaturro.world.core.elements.events.GaturroRoomSceneObjectEvent;
   import com.qb9.mambo.user.inventory.Inventory;
   import com.qb9.mambo.view.world.util.TwoWayLink;
   import com.qb9.mambo.world.avatars.UserAvatar;
   import flash.display.DisplayObject;
   import flash.events.Event;
   
   public class SwimmingGaturroUserAvatarView extends SwimmingGaturroAvatarView
   {
       
      
      public function SwimmingGaturroUserAvatarView(param1:UserAvatar, param2:TaskContainer, param3:TwoWayLink, param4:TwoWayLink)
      {
         super(param1,param2,param3,param4);
      }
      
      override protected function init() : void
      {
         this.checkIfOwnsTransport();
         super.init();
      }
      
      private function lookAt(param1:GaturroRoomSceneObjectEvent) : void
      {
         evaluateSide(parent,tiles.getItem(param1.object.tile) as DisplayObject);
      }
      
      private function tieneTransporteMagico(param1:String) : Boolean
      {
         if(param1.indexOf("zapatos.vacio") != -1)
         {
            return true;
         }
         if(param1.indexOf("gatoonsClothes.") != -1)
         {
            return true;
         }
         if(param1.indexOf("gatoons.vacio") != -1)
         {
            return true;
         }
         if(param1.indexOf("antro2017/wears.vacio") != -1)
         {
            return true;
         }
         if(param1.indexOf("virtualGoods3.") != -1)
         {
            return true;
         }
         return false;
      }
      
      private function get transportAsset() : String
      {
         var _loc1_:String = String(sceneObject.attributes[Gaturro.TRANSPORT_KEY]);
         if(!_loc1_)
         {
            return "";
         }
         return _loc1_.slice(0,_loc1_.lastIndexOf("_"));
      }
      
      private function checkIfOwnsTransport() : void
      {
         if(this.transportAsset == "")
         {
            return;
         }
         if(!this.visualizer.hasAnyOf(this.transportAsset) && !this.tieneTransporteMagico(this.transportAsset))
         {
            sceneObject.attributes[Gaturro.TRANSPORT_KEY] = "";
         }
      }
      
      override protected function initEvents() : void
      {
         super.initEvents();
         sceneObject.addEventListener(GaturroRoomSceneObjectEvent.LOOK_AT,this.lookAt);
      }
      
      override protected function whenClicked(param1:Event) : void
      {
      }
      
      private function get visualizer() : Inventory
      {
         return ((sceneObject as GaturroUserAvatar).user as GaturroUser).visualizer;
      }
   }
}

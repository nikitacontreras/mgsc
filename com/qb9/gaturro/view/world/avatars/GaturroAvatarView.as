package com.qb9.gaturro.view.world.avatars
{
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.gaturro.view.gui.avatars.AvatarsGuiModalEvent;
   import com.qb9.gaturro.view.world.elements.GaturroMovingRoomSceneObjectView;
   import com.qb9.gaturro.view.world.elements.behaviors.NamedView;
   import com.qb9.gaturro.view.world.events.CreateOwnedNpcEvent;
   import com.qb9.gaturro.view.world.events.GaturroRoomViewEvent;
   import com.qb9.mambo.view.world.util.TwoWayLink;
   import com.qb9.mambo.world.avatars.Avatar;
   import flash.events.Event;
   
   public class GaturroAvatarView extends GaturroMovingRoomSceneObjectView implements NamedView
   {
       
      
      protected var notWalking:Boolean = false;
      
      private var showName:Boolean = true;
      
      private var _clip:com.qb9.gaturro.view.world.avatars.Gaturro;
      
      public function GaturroAvatarView(param1:Avatar, param2:TaskContainer, param3:TwoWayLink, param4:TwoWayLink)
      {
         super(param1,param2,param3,param4);
      }
      
      public function setNotWalking() : void
      {
         this.notWalking = true;
      }
      
      public function get displayHeight() : uint
      {
         return 102;
      }
      
      override protected function get speed() : Number
      {
         return this.clip.speed;
      }
      
      override protected function initEvents() : void
      {
         super.initEvents();
         addEventListener(GaturroRoomViewEvent.OBJECT_CLICKED,this.whenClicked);
      }
      
      public function get isVisible() : Boolean
      {
         return !(this._clip.visible == false || this._clip.alpha == 0);
      }
      
      protected function whenClicked(param1:Event) : void
      {
         if(this.isVisible)
         {
            dispatchEvent(new AvatarsGuiModalEvent(AvatarsGuiModalEvent.OPEN));
         }
      }
      
      override public function dispose() : void
      {
         removeEventListener(GaturroRoomViewEvent.OBJECT_CLICKED,this.whenClicked);
         this._clip.removeEventListener(CreateOwnedNpcEvent.NAME,this.createOwnedNpc);
         this.clip.dispose();
         this._clip = null;
         super.dispose();
      }
      
      override protected function startMoving() : void
      {
         super.startMoving();
         if(this.notWalking)
         {
            return;
         }
         this.clip.walk();
      }
      
      public function get displayName() : String
      {
         return this.isVisible ? this.avatar.username : "";
      }
      
      public function get clip() : com.qb9.gaturro.view.world.avatars.Gaturro
      {
         return this._clip;
      }
      
      private function createOwnedNpc(param1:CreateOwnedNpcEvent) : void
      {
         var _loc2_:CreateOwnedNpcEvent = new CreateOwnedNpcEvent(param1.data,this.avatar);
         this.dispatchEvent(_loc2_);
         param1.dispose();
      }
      
      public function get avatar() : Avatar
      {
         return sceneObject as Avatar;
      }
      
      override protected function stopMoving() : void
      {
         this.clip.stand();
         super.stopMoving();
      }
      
      override protected function init() : void
      {
         this._clip = new com.qb9.gaturro.view.world.avatars.Gaturro(sceneObject,false);
         this._clip.addEventListener(CreateOwnedNpcEvent.NAME,this.createOwnedNpc);
         addChild(this.clip);
         super.init();
      }
   }
}

package com.qb9.gaturro.view.world.elements
{
   import assets.MissingAssetMC;
   import com.qb9.gaturro.view.world.elements.behaviors.ActivableView;
   import com.qb9.gaturro.view.world.elements.behaviors.RollableView;
   import com.qb9.gaturro.view.world.events.GaturroRoomViewEvent;
   import com.qb9.gaturro.world.core.elements.events.GaturroRoomSceneObjectEvent;
   import com.qb9.mambo.view.world.elements.RoomSceneObjectView;
   import com.qb9.mambo.view.world.elements.behaviors.MouseCapturingView;
   import com.qb9.mambo.view.world.util.TwoWayLink;
   import com.qb9.mambo.world.avatars.UserAvatar;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class GaturroRoomSceneObjectView extends RoomSceneObjectView implements RollableView, ActivableView, MouseCapturingView
   {
       
      
      protected var asset:Sprite;
      
      public function GaturroRoomSceneObjectView(param1:RoomSceneObject, param2:TwoWayLink)
      {
         super(param1,param2);
      }
      
      public function add(param1:Sprite) : void
      {
         this.asset = param1 || new MissingAssetMC();
         addChild(this.asset);
         this.dispatchEvent(new Event(GaturroRoomViewEvent.ASSET_ADDED_COMPLETE));
      }
      
      public function getAssetName() : String
      {
         return sceneObject.name;
      }
      
      public function getAttribute(param1:String) : *
      {
         return sceneObject.attributes[param1];
      }
      
      public function get isRollable() : Boolean
      {
         return this.rollTarget !== null;
      }
      
      public function rollout() : void
      {
         if(this.rollTarget.currentFrame != 1)
         {
            this.rollTarget.gotoAndStop(1);
         }
      }
      
      private function get rollTarget() : MovieClip
      {
         return !!this.asset ? this.asset.getChildByName("activable") as MovieClip : null;
      }
      
      public function get isActivable() : Boolean
      {
         return sceneObject.isGrabbable;
      }
      
      public function get assetSize() : Point
      {
         return new Point(Boolean(this.asset) && Boolean(this.asset["sizeW"]) ? Number(this.asset["sizeW"]) : 1,Boolean(this.asset) && Boolean(this.asset["sizeH"]) ? Number(this.asset["sizeH"]) : 1);
      }
      
      public function get captures() : Boolean
      {
         return false;
      }
      
      public function getAssetId() : Number
      {
         return sceneObject.id;
      }
      
      public function get mc() : MovieClip
      {
         return this.asset as MovieClip;
      }
      
      override protected function init() : void
      {
         if(sceneObject.attributes.flipped)
         {
            scaleX = -1;
         }
      }
      
      public function rollover() : void
      {
         if(this.rollTarget.currentLabel != "on")
         {
            this.rollTarget.gotoAndPlay("on");
         }
      }
      
      override protected function whenActivated(param1:UserAvatar) : void
      {
         if(sceneObject.isGrabbable)
         {
            dispatchEvent(new GaturroRoomSceneObjectEvent(GaturroRoomSceneObjectEvent.TRY_TO_GRAB,sceneObject));
         }
      }
      
      override public function dispose() : void
      {
         this.asset = null;
         super.dispose();
      }
   }
}

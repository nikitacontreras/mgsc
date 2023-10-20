package com.qb9.gaturro.view.world.elements
{
   import assets.MissingAssetMC;
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.external.roomObjects.GaturroSceneObjectAPI;
   import com.qb9.gaturro.view.world.elements.behaviors.ActivableView;
   import com.qb9.gaturro.view.world.elements.behaviors.RollableView;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.core.elements.HomeInteractiveRoomSceneObject;
   import com.qb9.mambo.view.world.elements.RoomSceneObjectView;
   import com.qb9.mambo.view.world.elements.behaviors.MouseCapturingView;
   import com.qb9.mambo.view.world.util.TwoWayLink;
   import com.qb9.mambo.world.avatars.UserAvatar;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class HomeInteractiveRoomSceneObjectView extends RoomSceneObjectView implements RollableView, ActivableView, MouseCapturingView
   {
      
      public static const TOOLTIP_IN:String = "TOOLTIP_IN";
      
      public static const TOOLTIP_OUT:String = "TOOLTIP_OUT";
       
      
      private var _sceneObject:HomeInteractiveRoomSceneObject;
      
      private var selfAPI:GaturroSceneObjectAPI;
      
      protected var asset:DisplayObject;
      
      private var roomAPI:GaturroRoomAPI;
      
      public function HomeInteractiveRoomSceneObjectView(param1:HomeInteractiveRoomSceneObject, param2:TwoWayLink, param3:GaturroRoom, param4:GaturroRoomAPI)
      {
         super(param1,param2);
         this._sceneObject = param1;
         this.roomAPI = param4;
         this.selfAPI = new GaturroSceneObjectAPI(param1,this,param3);
      }
      
      public function add(param1:DisplayObject) : void
      {
         this.asset = param1 || new MissingAssetMC();
         addChild(this.asset);
         if(this._sceneObject.stateMachine)
         {
            this.initStateMachine();
         }
      }
      
      private function initStateMachine() : void
      {
         this._sceneObject.stateMachine.start(this.asset,this.roomAPI,this.selfAPI);
      }
      
      public function get isRollable() : Boolean
      {
         return mouseEnabled && this.rollTarget !== null;
      }
      
      public function rollout() : void
      {
         this.rollTarget.gotoAndStop(1);
      }
      
      public function get captures() : Boolean
      {
         return mouseEnabled;
      }
      
      public function get isActivable() : Boolean
      {
         return mouseEnabled;
      }
      
      public function rollover() : void
      {
         this.rollTarget.gotoAndPlay("on");
      }
      
      private function get rollTarget() : MovieClip
      {
         return !!this.asset ? Sprite(this.asset).getChildByName("activable") as MovieClip : null;
      }
      
      override protected function whenActivated(param1:UserAvatar) : void
      {
         super.whenActivated(param1);
         if(this._sceneObject.stateMachine)
         {
            this._sceneObject.stateMachine.activate();
         }
      }
   }
}

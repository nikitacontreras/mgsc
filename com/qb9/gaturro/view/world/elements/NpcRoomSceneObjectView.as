package com.qb9.gaturro.view.world.elements
{
   import assets.MissingAssetMC;
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.external.roomObjects.GaturroSceneObjectAPI;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.globals.tracker;
   import com.qb9.gaturro.net.metrics.TrackActions;
   import com.qb9.gaturro.net.metrics.TrackCategories;
   import com.qb9.gaturro.view.gui.combat.CombatEvent;
   import com.qb9.gaturro.view.world.chat.ChatViewEvent;
   import com.qb9.gaturro.view.world.elements.behaviors.ActivableView;
   import com.qb9.gaturro.view.world.elements.behaviors.RollableView;
   import com.qb9.gaturro.view.world.events.GaturroRoomViewEvent;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.core.elements.NpcRoomSceneObject;
   import com.qb9.gaturro.world.core.elements.events.GaturroRoomSceneObjectEvent;
   import com.qb9.gaturro.world.npc.interpreter.NpcInterpeter;
   import com.qb9.gaturro.world.npc.struct.behavior.NpcBehaviorEvent;
   import com.qb9.mambo.core.attributes.CustomAttribute;
   import com.qb9.mambo.core.attributes.events.CustomAttributesEvent;
   import com.qb9.mambo.view.world.elements.behaviors.MouseCapturingView;
   import com.qb9.mambo.view.world.util.TwoWayLink;
   import com.qb9.mambo.world.avatars.Avatar;
   import com.qb9.mambo.world.avatars.UserAvatar;
   import com.qb9.mambo.world.avatars.events.MovingRoomSceneObjectEvent;
   import com.qb9.mambo.world.core.events.GeneralEvent;
   import com.qb9.mambo.world.core.events.RoomEvent;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class NpcRoomSceneObjectView extends GaturroMovingRoomSceneObjectView implements MouseCapturingView, RollableView, ActivableView
   {
       
      
      private var room:GaturroRoom;
      
      private var selfAPI:GaturroSceneObjectAPI;
      
      private var roomAPI:GaturroRoomAPI;
      
      public function NpcRoomSceneObjectView(param1:NpcRoomSceneObject, param2:TaskContainer, param3:TwoWayLink, param4:TwoWayLink, param5:GaturroRoom, param6:GaturroRoomAPI)
      {
         this.room = param5;
         super(param1,param2,param3,param4);
         this.object.load(param6,new GaturroSceneObjectAPI(this.object,this,param5));
      }
      
      private function triggerWalk(param1:Event) : void
      {
         this.trigger(NpcBehaviorEvent.AVATAR_MOVED);
      }
      
      private function whenANewSceneObjectIsAdded(param1:RoomEvent) : void
      {
         if(param1.object is Avatar)
         {
            this.trigger(NpcBehaviorEvent.AVATAR_JOINED);
         }
      }
      
      public function get isDisabled() : Boolean
      {
         if(this.asset is MovieClip)
         {
            if(MovieClip(this.asset).currentLabel == "disabled")
            {
               return true;
            }
         }
         return false;
      }
      
      private function specialRoomActivate(param1:Event) : void
      {
         if(this.interpreter.hasEvent(NpcBehaviorEvent.FINISHED_CHAT))
         {
            this.trigger(NpcBehaviorEvent.CLICK);
         }
         else
         {
            this.whenActivated(this.avatar);
         }
      }
      
      private function triggerClick(param1:GaturroRoomViewEvent) : void
      {
         var _loc2_:UserAvatar = this.room.userAvatar;
         if(!_loc2_ || !this.isWaitingForClick)
         {
            return;
         }
         if(!_loc2_.moving)
         {
            _loc2_.dispatchEvent(new GaturroRoomSceneObjectEvent(GaturroRoomSceneObjectEvent.LOOK_AT,this.object));
            this.trigger(NpcBehaviorEvent.CLICK);
            tracker.event(TrackCategories.MMO,TrackActions.SPEAK_TO_NPC,this.object.behaviorName);
            if(this.isWaitingForClick)
            {
               param1.preventDefault();
            }
         }
      }
      
      override protected function initEvents() : void
      {
         super.initEvents();
         this.object.addEventListener(GeneralEvent.READY,this.whenNpcIsReady);
         this.object.addEventListener(GaturroRoomSceneObjectEvent.SHOWING,this.triggerShow);
         this.room.addEventListener(RoomEvent.SCENE_OBJECT_ADDED,this.whenANewSceneObjectIsAdded);
         addEventListener(ChatViewEvent.FINISHED,this.whenSelfFinishedSayingSomething);
         addEventListener(GaturroRoomViewEvent.OBJECT_CLICKED,this.triggerClick);
      }
      
      private function whenSelfFinishedSayingSomething(param1:Event) : void
      {
         this.trigger(NpcBehaviorEvent.FINISHED_CHAT);
      }
      
      private function multiPlayerActivate(param1:Event) : void
      {
         this.trigger(NpcBehaviorEvent.MULTIPLAYER_ACTIVATE);
      }
      
      private function whenNPCWrongAttack(param1:CombatEvent) : void
      {
         if(this.object === param1.objectAPI.object)
         {
            this.trigger(NpcBehaviorEvent.NPC_WRONG_ATTACK);
         }
      }
      
      protected function trigger(param1:String, param2:Boolean = false) : void
      {
         var event:String = param1;
         var attr:Boolean = param2;
         if(!this.object || !this.object.ready)
         {
            return;
         }
         try
         {
            this.interpreter.triggerEvent(event);
         }
         catch(err:Error)
         {
            logger.warning(err.message);
         }
      }
      
      private function whenNpcIsReady(param1:Event = null) : void
      {
         var e:Event = param1;
         if(!numChildren || this.isDisabled)
         {
            return;
         }
         try
         {
            this.object.addEventListener(CustomAttributesEvent.CHANGED,this.whenAnAttributeChanges);
            this.avatar.addEventListener(MovingRoomSceneObjectEvent.STARTED_MOVING,this.triggerWalk);
            this.avatar.addEventListener(CustomAttributesEvent.CHANGED,this.whenAnAttributeChanges);
            this.object.addEventListener(CombatEvent.NPC_DEFEATED,this.whenNPCDefeated);
            this.object.addEventListener(CombatEvent.NPC_WRONG_ATTACK,this.whenNPCWrongAttack);
            this.object.addEventListener(CombatEvent.NPC_CORRECT_ATTACK,this.whenNPCCorrectAttack);
            addEventListener(NpcBehaviorEvent.SPECIAL_ROOM_ACTIVATE,this.specialRoomActivate);
            addEventListener(NpcBehaviorEvent.MULTIPLAYER_ACTIVATE,this.multiPlayerActivate);
            addEventListener(NpcBehaviorEvent.MULTIPLAYER_HIDE,this.multiPlayerHide);
            this.interpreter.start();
            if(this.object.showing)
            {
               this.trigger(NpcBehaviorEvent.SHOW);
            }
         }
         catch(err:Error)
         {
            logger.warning(err.message);
         }
      }
      
      private function triggerShow(param1:Event) : void
      {
         this.trigger(NpcBehaviorEvent.SHOW);
      }
      
      public function get isActivable() : Boolean
      {
         return mouseEnabled;
      }
      
      public function get object() : NpcRoomSceneObject
      {
         return sceneObject as NpcRoomSceneObject;
      }
      
      public function get assetSize() : Point
      {
         return new Point(Boolean(asset) && Boolean(asset["sizeW"]) ? Number(asset["sizeW"]) : 1,Boolean(asset) && Boolean(asset["sizeH"]) ? Number(asset["sizeH"]) : 1);
      }
      
      private function get avatar() : UserAvatar
      {
         return this.room.userAvatar;
      }
      
      private function whenNPCCorrectAttack(param1:CombatEvent) : void
      {
         if(this.object === param1.objectAPI.object)
         {
            this.trigger(NpcBehaviorEvent.NPC_CORRECT_ATTACK);
         }
      }
      
      override protected function get speed() : Number
      {
         return 130;
      }
      
      public function rollover() : void
      {
         this.rollTarget.gotoAndPlay("on");
      }
      
      public function get isRollable() : Boolean
      {
         return mouseEnabled && this.rollTarget !== null;
      }
      
      private function get isWaitingForClick() : Boolean
      {
         return Boolean(this.interpreter) && this.interpreter.hasEvent(NpcBehaviorEvent.CLICK);
      }
      
      private function multiPlayerHide(param1:Event) : void
      {
         this.trigger(NpcBehaviorEvent.MULTIPLAYER_HIDE);
      }
      
      override protected function whenActivated(param1:UserAvatar) : void
      {
         super.whenActivated(param1);
         this.trigger(NpcBehaviorEvent.ACTIVATE);
      }
      
      override public function dispose() : void
      {
         if(this.avatar)
         {
            this.avatar.removeEventListener(MovingRoomSceneObjectEvent.STARTED_MOVING,this.triggerWalk);
            this.avatar.removeEventListener(CustomAttributesEvent.CHANGED,this.whenAnAttributeChanges);
         }
         this.room.removeEventListener(RoomEvent.SCENE_OBJECT_ADDED,this.whenANewSceneObjectIsAdded);
         this.room = null;
         this.roomAPI = null;
         this.selfAPI = null;
         removeEventListener(GaturroRoomViewEvent.OBJECT_CLICKED,this.triggerClick);
         removeEventListener(ChatViewEvent.FINISHED,this.whenSelfFinishedSayingSomething);
         if(this.object)
         {
            this.object.removeEventListener(GeneralEvent.READY,this.whenNpcIsReady);
            this.object.removeEventListener(GaturroRoomSceneObjectEvent.SHOWING,this.triggerShow);
            this.object.removeEventListener(CustomAttributesEvent.CHANGED,this.whenAnAttributeChanges);
            this.object.removeEventListener(CombatEvent.NPC_DEFEATED,this.whenNPCDefeated);
         }
         super.dispose();
      }
      
      public function add(param1:DisplayObject) : void
      {
         if(this.disposed)
         {
            return;
         }
         addChild(param1 || new MissingAssetMC());
         if(this.object.ready)
         {
            this.whenNpcIsReady();
         }
      }
      
      public function get captures() : Boolean
      {
         return mouseEnabled;
      }
      
      private function get rollTarget() : MovieClip
      {
         return !!asset ? Sprite(asset).getChildByName("activable") as MovieClip : null;
      }
      
      public function multiplayerCustomEvent(param1:String) : void
      {
         this.trigger(param1);
      }
      
      public function rollout() : void
      {
         this.rollTarget.gotoAndStop(1);
      }
      
      override protected function stopMoving() : void
      {
         super.stopMoving();
         this.trigger(NpcBehaviorEvent.ARRIVED);
      }
      
      private function whenNPCDefeated(param1:CombatEvent) : void
      {
         trace(" NPC ROOM VIEW : EVENTO NPC DEFEATED ");
         if(this.object === param1.objectAPI.object)
         {
            this.trigger(NpcBehaviorEvent.NPC_DEFEATED);
         }
      }
      
      private function get interpreter() : NpcInterpeter
      {
         return !!this.object ? this.object.interpreter : null;
      }
      
      private function whenAnAttributeChanges(param1:CustomAttributesEvent) : void
      {
         var _loc3_:CustomAttribute = null;
         var _loc2_:String = param1.target === this.object ? NpcBehaviorEvent.NPC_ATTR_PREFFIX : NpcBehaviorEvent.AVATAR_ATTR_PREFFIX;
         for each(_loc3_ in param1.attributes)
         {
            this.trigger(_loc2_ + _loc3_.key,true);
            this.trigger(_loc2_ + _loc3_.key + "_" + _loc3_.value,true);
         }
      }
   }
}

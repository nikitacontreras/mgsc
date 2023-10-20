package com.qb9.mambo.view.world.elements
{
   import com.qb9.flashlib.color.Color;
   import com.qb9.flashlib.easing.Tween;
   import com.qb9.flashlib.geom.Anchor;
   import com.qb9.flashlib.prototyping.shapes.IsoscelesTriangle;
   import com.qb9.flashlib.tasks.Func;
   import com.qb9.flashlib.tasks.ITask;
   import com.qb9.flashlib.tasks.Sequence;
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.mambo.view.world.util.TwoWayLink;
   import com.qb9.mambo.world.avatars.events.MovingRoomSceneObjectEvent;
   import com.qb9.mambo.world.elements.MovingRoomSceneObject;
   import flash.display.Sprite;
   
   public class MovingRoomSceneObjectView extends RoomSceneObjectView
   {
       
      
      protected var tasks:TaskContainer;
      
      protected var moveTask:ITask;
      
      public function MovingRoomSceneObjectView(param1:MovingRoomSceneObject, param2:TaskContainer, param3:TwoWayLink)
      {
         this.tasks = param2;
         super(param1,param3);
      }
      
      protected function createMovementTween(param1:Object) : ITask
      {
         return new Tween(this,300,param1);
      }
      
      override public function dispose() : void
      {
         this.abortMovement();
         sceneObject.removeEventListener(MovingRoomSceneObjectEvent.STARTED_MOVING,this.changeMovingState);
         sceneObject.removeEventListener(MovingRoomSceneObjectEvent.MOVE_STEP,this.moveAvatar);
         sceneObject.removeEventListener(MovingRoomSceneObjectEvent.STOPPED_MOVING,this.changeMovingState);
         super.dispose();
      }
      
      override protected function reposition() : void
      {
         super.reposition();
         this.abortMovement();
         this.stopMoving();
         y = 0;
         x = 0;
      }
      
      protected function abortMovement() : void
      {
         if(Boolean(this.moveTask) && this.moveTask.running)
         {
            this.tasks.remove(this.moveTask);
         }
      }
      
      override protected function initEvents() : void
      {
         super.initEvents();
         sceneObject.addEventListener(MovingRoomSceneObjectEvent.STARTED_MOVING,this.changeMovingState);
         sceneObject.addEventListener(MovingRoomSceneObjectEvent.MOVE_STEP,this.moveAvatar);
         sceneObject.addEventListener(MovingRoomSceneObjectEvent.STOPPED_MOVING,this.changeMovingState);
      }
      
      private function moveAvatar(param1:MovingRoomSceneObjectEvent) : void
      {
         var _loc2_:Sprite = parent as Sprite;
         var _loc3_:Sprite = tiles.getItem(this.movingObject.nextTile) as Sprite;
         this.move(_loc2_,_loc3_);
      }
      
      protected function get movingObject() : MovingRoomSceneObject
      {
         return sceneObject as MovingRoomSceneObject;
      }
      
      override protected function init() : void
      {
         addChild(new IsoscelesTriangle(12,12,Color.RED,Anchor.center));
      }
      
      protected function move(param1:Sprite, param2:Sprite) : void
      {
         var _loc4_:int = 0;
         var _loc6_:int = 0;
         var _loc8_:Object = null;
         this.abortMovement();
         var _loc3_:int = DisplayUtil.offsetX(param2);
         _loc4_ = DisplayUtil.offsetY(param2);
         var _loc5_:int = DisplayUtil.offsetX(param1);
         _loc6_ = DisplayUtil.offsetY(param1);
         var _loc7_:*;
         if(_loc7_ = this.zOrder(_loc3_,_loc4_) >= this.zOrder(_loc5_,_loc6_))
         {
            x += _loc5_ - _loc3_;
            y += _loc6_ - _loc4_;
            moveToTile(param2);
            this.moveTask = new Sequence(this.createMovementTween({
               "x":0,
               "y":0
            }),new Func(this.movingObject.arrivedToTile));
         }
         else
         {
            _loc8_ = {
               "x":_loc3_ - _loc5_,
               "y":_loc4_ - _loc6_
            };
            this.moveTask = new Sequence(this.createMovementTween(_loc8_),new Func(this.arrivedToTile,param2),new Func(this.movingObject.arrivedToTile));
         }
         this.tasks.add(this.moveTask);
      }
      
      protected function zOrder(param1:int, param2:int) : int
      {
         return param1 - param2;
      }
      
      protected function startMoving() : void
      {
      }
      
      private function changeMovingState(param1:MovingRoomSceneObjectEvent) : void
      {
         if(param1.type === MovingRoomSceneObjectEvent.STARTED_MOVING)
         {
            this.startMoving();
         }
         else
         {
            this.stopMoving();
         }
      }
      
      protected function arrivedToTile(param1:Sprite) : void
      {
         moveToTile(param1);
         y = 0;
         x = 0;
      }
      
      protected function stopMoving() : void
      {
      }
   }
}

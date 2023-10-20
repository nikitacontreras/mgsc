package com.qb9.gaturro.view.world.elements
{
   import com.qb9.flashlib.easing.SpeedBasedTween;
   import com.qb9.flashlib.math.QMath;
   import com.qb9.flashlib.tasks.ITask;
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.gaturro.util.RedrawForcer;
   import com.qb9.gaturro.view.world.avatars.Gaturro;
   import com.qb9.gaturro.world.core.elements.HolderRoomSceneObject;
   import com.qb9.mambo.geom.Coord;
   import com.qb9.mambo.view.world.elements.MovingRoomSceneObjectView;
   import com.qb9.mambo.view.world.util.TwoWayLink;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import com.qb9.mambo.world.elements.MovingRoomSceneObject;
   import com.qb9.mambo.world.tiling.Tile;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class GaturroMovingRoomSceneObjectView extends MovingRoomSceneObjectView
   {
       
      
      protected var sceneObjects:TwoWayLink;
      
      private var holder:HolderRoomSceneObject;
      
      public function GaturroMovingRoomSceneObjectView(param1:MovingRoomSceneObject, param2:TaskContainer, param3:TwoWayLink, param4:TwoWayLink)
      {
         this.sceneObjects = param4;
         super(param1,param2,param3);
      }
      
      private function get inHolder() : Boolean
      {
         var _loc1_:DisplayObject = null;
         _loc1_ = this;
         while(Boolean(_loc1_) && !(_loc1_ is HolderRoomSceneObjectView))
         {
            _loc1_ = _loc1_.parent;
         }
         return _loc1_ != null;
      }
      
      private function removeFromHolder() : void
      {
         if(this.holder)
         {
            this.holder.removeChild(sceneObject);
         }
         this.holder = null;
      }
      
      override public function dispose() : void
      {
         this.removeFromHolder();
         super.dispose();
      }
      
      private function lastMove(param1:Sprite) : Boolean
      {
         var _loc2_:Tile = tiles.getItem(param1) as Tile;
         var _loc3_:Coord = _loc2_.coord;
         return _loc3_.equals(movingObject.destination);
      }
      
      protected function get speed() : Number
      {
         return 1;
      }
      
      override protected function createMovementTween(param1:Object) : ITask
      {
         return new SpeedBasedTween(this,this.speed,param1);
      }
      
      override protected function move(param1:Sprite, param2:Sprite) : void
      {
         this.removeFromHolder();
         if(this.lastMove(param2))
         {
            param2 = this.getNextParent(param2) || param2;
         }
         this.evaluateSide(param1,param2);
         if(param2 is HolderRoomSceneObjectView || this.inHolder)
         {
            arrivedToTile(param2);
            movingObject.arrivedToTile();
            stage.addChild(new RedrawForcer());
         }
         else
         {
            super.move(param1,param2);
         }
      }
      
      override protected function stopMoving() : void
      {
         if(Boolean(this.holder) && Boolean(this.holder.action))
         {
            sceneObject.attributes[Gaturro.ACTION_KEY] = this.holder.action;
         }
         super.stopMoving();
      }
      
      private function handleHolder(param1:RoomSceneObject) : Sprite
      {
         var _loc2_:HolderRoomSceneObjectView = null;
         this.holder = param1 as HolderRoomSceneObject;
         this.holder.addChild(sceneObject);
         return this.sceneObjects.getItem(param1) as HolderRoomSceneObjectView;
      }
      
      protected function get asset() : DisplayObject
      {
         return !!numChildren ? getChildAt(0) : null;
      }
      
      protected function getNextParent(param1:Sprite) : Sprite
      {
         var _loc4_:RoomSceneObject = null;
         var _loc2_:Tile = tiles.getItem(param1) as Tile;
         var _loc3_:Array = !!_loc2_ ? _loc2_.children : null;
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_ is HolderRoomSceneObject)
            {
               return this.handleHolder(_loc4_);
            }
         }
         return null;
      }
      
      protected function evaluateSide(param1:DisplayObject, param2:DisplayObject) : void
      {
         var _loc3_:int = DisplayUtil.offsetX(param2) - (DisplayUtil.offsetX(param1) + x);
         if(Boolean(_loc3_) && Boolean(this.asset))
         {
            this.asset.scaleX = QMath.sign(_loc3_) * Math.abs(this.asset.scaleX);
            this.asset.dispatchEvent(new Event(Gaturro.GATURRO_FLIPPED));
         }
      }
      
      override protected function init() : void
      {
         if(Boolean(sceneObject.attributes.flipped) && sceneObject.attributes.flipped == true)
         {
            scaleX = -1;
         }
         this.getNextParent(currentTile);
         this.stopMoving();
      }
   }
}

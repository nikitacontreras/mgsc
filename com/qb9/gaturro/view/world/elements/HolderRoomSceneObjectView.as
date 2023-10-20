package com.qb9.gaturro.view.world.elements
{
   import com.qb9.flashlib.lang.filter;
   import com.qb9.flashlib.lang.foreach;
   import com.qb9.flashlib.lang.map;
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.gaturro.event.HolderSceneObjectEvent;
   import com.qb9.gaturro.view.world.avatars.GaturroAvatarView;
   import com.qb9.gaturro.world.core.elements.HolderRoomSceneObject;
   import com.qb9.mambo.view.world.util.TwoWayLink;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import com.qb9.mambo.world.elements.MovingRoomSceneObject;
   import com.qb9.mambo.world.tiling.Tile;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public final class HolderRoomSceneObjectView extends GaturroRoomSceneObjectView
   {
       
      
      protected var sceneObjects:TwoWayLink;
      
      public function HolderRoomSceneObjectView(param1:HolderRoomSceneObject, param2:TwoWayLink, param3:TwoWayLink)
      {
         this.sceneObjects = param3;
         super(param1,param2);
      }
      
      override public function add(param1:Sprite) : void
      {
         super.add(param1);
         var _loc2_:Array = this.movingOnCurrentTile;
         foreach(map(_loc2_,this.sceneObjects.getItem),this.addChild);
         foreach(_loc2_,this.object.addChild);
      }
      
      override public function dispose() : void
      {
         var _loc2_:DisplayObject = null;
         var _loc1_:int = 0;
         while(Boolean(this.placeholder) && _loc1_ < this.placeholder.numChildren)
         {
            _loc2_ = this.placeholder.getChildAt(0);
            if(_loc2_)
            {
               _loc2_.removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
            }
            _loc1_++;
         }
         this.migrateChildren();
         super.dispose();
      }
      
      private function migrateChildren() : void
      {
         var _loc1_:DisplayObject = null;
         if(this.placeholder)
         {
            for each(_loc1_ in DisplayUtil.children(this.placeholder))
            {
               parent.addChild(_loc1_);
            }
         }
      }
      
      override public function get captures() : Boolean
      {
         return true;
      }
      
      private function get placeholder() : Sprite
      {
         return (asset && asset.getChildByName("container") || asset) as Sprite;
      }
      
      override protected function repositionFromEvent(param1:Event) : void
      {
         this.migrateChildren();
         foreach(this.object.children,this.object.removeChild);
         super.repositionFromEvent(param1);
      }
      
      override public function get isActivable() : Boolean
      {
         return !this.object.blocks && Boolean(this.object.action);
      }
      
      private function isMoving(param1:RoomSceneObject) : Boolean
      {
         return param1 is MovingRoomSceneObject;
      }
      
      private function onRemoved(param1:Event) : void
      {
         var _loc2_:DisplayObject = param1.currentTarget as DisplayObject;
         _loc2_.removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
         var _loc3_:HolderSceneObjectEvent = new HolderSceneObjectEvent(HolderSceneObjectEvent.REMOVE,_loc2_);
         dispatchEvent(_loc3_);
         asset.dispatchEvent(_loc3_);
         if(_loc2_ is GaturroAvatarView && Boolean((_loc2_ as GaturroAvatarView).clip))
         {
            (_loc2_ as GaturroAvatarView).clip.transport.visible = true;
         }
      }
      
      private function get movingOnCurrentTile() : Array
      {
         var _loc1_:Tile = tiles.getItem(currentTile) as Tile;
         return filter(_loc1_.children,this.isMoving);
      }
      
      override public function addChild(param1:DisplayObject) : DisplayObject
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:HolderSceneObjectEvent = null;
         if(!param1)
         {
            return null;
         }
         if(param1 !== asset && Boolean(this.placeholder))
         {
            if(param1 is GaturroAvatarView)
            {
               (param1 as GaturroAvatarView).clip.transport.visible = false;
            }
            _loc2_ = this.placeholder.addChild(param1);
            param1.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
            _loc3_ = new HolderSceneObjectEvent(HolderSceneObjectEvent.ADDED,param1);
            dispatchEvent(_loc3_);
            asset.dispatchEvent(_loc3_);
            return _loc2_;
         }
         return super.addChild(param1);
      }
      
      private function get object() : HolderRoomSceneObject
      {
         return sceneObject as HolderRoomSceneObject;
      }
   }
}

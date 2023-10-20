package com.qb9.gaturro.view.world.elements
{
   import com.qb9.flashlib.lang.filter;
   import com.qb9.flashlib.lang.foreach;
   import com.qb9.flashlib.lang.map;
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.gaturro.world.core.elements.MultiHolderRoomSceneObject;
   import com.qb9.mambo.view.world.util.TwoWayLink;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import com.qb9.mambo.world.elements.MovingRoomSceneObject;
   import com.qb9.mambo.world.tiling.Tile;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public final class MultiHolderRoomSceneObjectView extends GaturroRoomSceneObjectView
   {
       
      
      protected var sceneObjects:TwoWayLink;
      
      public function MultiHolderRoomSceneObjectView(param1:MultiHolderRoomSceneObject, param2:TwoWayLink, param3:TwoWayLink)
      {
         this.sceneObjects = param3;
         super(param1,param2);
      }
      
      override public function add(param1:Sprite) : void
      {
         var _loc2_:Array = null;
         super.add(param1);
         _loc2_ = this.movingOnCurrentTile;
         foreach(map(_loc2_,this.sceneObjects.getItem),this.addChild);
         foreach(_loc2_,this.object.addChild);
      }
      
      override public function dispose() : void
      {
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
         var _loc1_:uint = 0;
         while(_loc1_ < asset.numChildren)
         {
            if(Object(asset.getChildAt(_loc1_)).isPlaceHolder)
            {
               if(asset.getChildAt(_loc1_) is Sprite && Sprite(asset.getChildAt(_loc1_)).numChildren == 0)
               {
                  return asset.getChildAt(_loc1_) as Sprite;
               }
            }
            _loc1_++;
         }
         trace("NULLLLLLLLLL");
         return null;
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
      
      private function get movingOnCurrentTile() : Array
      {
         var _loc1_:Tile = tiles.getItem(currentTile) as Tile;
         return filter(_loc1_.children,this.isMoving);
      }
      
      override public function addChild(param1:DisplayObject) : DisplayObject
      {
         if(param1 !== asset && Boolean(this.placeholder))
         {
            return this.placeholder.addChild(param1);
         }
         return super.addChild(param1);
      }
      
      private function get object() : MultiHolderRoomSceneObject
      {
         return sceneObject as MultiHolderRoomSceneObject;
      }
   }
}

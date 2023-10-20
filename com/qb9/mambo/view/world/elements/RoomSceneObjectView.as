package com.qb9.mambo.view.world.elements
{
   import com.qb9.flashlib.geom.Anchor;
   import com.qb9.flashlib.prototyping.shapes.BasicShapeConfig;
   import com.qb9.flashlib.prototyping.shapes.Circle;
   import com.qb9.flashlib.prototyping.shapes.Square;
   import com.qb9.mambo.core.objects.events.SceneObjectEvent;
   import com.qb9.mambo.geom.Coord;
   import com.qb9.mambo.view.MamboView;
   import com.qb9.mambo.view.world.util.TwoWayLink;
   import com.qb9.mambo.world.avatars.UserAvatar;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import com.qb9.mambo.world.core.events.RoomSceneObjectEvent;
   import com.qb9.mambo.world.tiling.Tile;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class RoomSceneObjectView extends MamboView
   {
       
      
      protected var tiles:TwoWayLink;
      
      protected var sceneObject:RoomSceneObject;
      
      public function RoomSceneObjectView(param1:RoomSceneObject, param2:TwoWayLink)
      {
         super();
         this.sceneObject = param1;
         this.tiles = param2;
         this.initEvents();
         this.init();
      }
      
      public function get nameMC() : String
      {
         return this.sceneObject.name;
      }
      
      protected function reposition() : void
      {
         this.moveToTile(this.currentTile);
      }
      
      protected function getTile(param1:Tile) : Sprite
      {
         return this.tiles.getItem(param1) as Sprite;
      }
      
      protected function get currentTile() : Sprite
      {
         return this.getTile(this.sceneObject.tile);
      }
      
      protected function initEvents() : void
      {
         this.sceneObject.addEventListener(SceneObjectEvent.ACTIVATED,this._whenActivated);
         this.sceneObject.addEventListener(RoomSceneObjectEvent.REPOSITIONED,this.repositionFromEvent);
      }
      
      protected function init() : void
      {
         var _loc2_:int = 0;
         var _loc3_:DisplayObject = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.sceneObject.size.width)
         {
            _loc2_ = 0;
            while(_loc2_ < this.sceneObject.size.height)
            {
               _loc3_ = this.sceneObject.blocks ? this.wall() : this.tree();
               _loc3_.x = 21 * _loc1_;
               _loc3_.y = 21 * _loc2_;
               addChild(_loc3_);
               _loc2_++;
            }
            _loc1_++;
         }
      }
      
      private function wall() : DisplayObject
      {
         var _loc1_:Sprite = null;
         var _loc3_:int = 0;
         var _loc4_:Square = null;
         _loc1_ = new Sprite();
         var _loc2_:int = -1;
         while(_loc2_ < 2)
         {
            _loc3_ = -1;
            while(_loc3_ < 2)
            {
               (_loc4_ = new Square(5,new BasicShapeConfig(8947848,1,1),Anchor.center)).x = _loc2_ * _loc4_.width;
               _loc4_.y = _loc3_ * _loc4_.height;
               _loc1_.addChild(_loc4_);
               _loc3_++;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      protected function repositionFromEvent(param1:Event) : void
      {
         this.reposition();
      }
      
      protected function whenActivated(param1:UserAvatar) : void
      {
      }
      
      private function _whenActivated(param1:SceneObjectEvent) : void
      {
         this.whenActivated(param1.object as UserAvatar);
      }
      
      protected function moveToTile(param1:Sprite) : void
      {
         param1.addChild(this);
      }
      
      public function get currentCoord() : Coord
      {
         return this.sceneObject.coord;
      }
      
      private function tree() : DisplayObject
      {
         return new Circle(8,new BasicShapeConfig(21760,1,1),Anchor.center);
      }
      
      override public function dispose() : void
      {
         this.sceneObject.removeEventListener(SceneObjectEvent.ACTIVATED,this._whenActivated);
         this.sceneObject.removeEventListener(RoomSceneObjectEvent.REPOSITIONED,this.repositionFromEvent);
         this.sceneObject = null;
         super.dispose();
      }
   }
}

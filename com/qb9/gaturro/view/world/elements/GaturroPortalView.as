package com.qb9.gaturro.view.world.elements
{
   import com.qb9.flashlib.color.Color;
   import com.qb9.flashlib.prototyping.shapes.Rect;
   import com.qb9.gaturro.globals.audio;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.view.world.cursor.Cursor;
   import com.qb9.gaturro.view.world.elements.behaviors.ActivableView;
   import com.qb9.gaturro.view.world.elements.behaviors.RollableView;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.mambo.core.attributes.CustomAttributes;
   import com.qb9.mambo.view.world.elements.PortalView;
   import com.qb9.mambo.view.world.elements.behaviors.MouseCapturingView;
   import com.qb9.mambo.view.world.util.TwoWayLink;
   import com.qb9.mambo.world.avatars.UserAvatar;
   import com.qb9.mambo.world.elements.Portal;
   import flash.utils.setTimeout;
   
   public class GaturroPortalView extends PortalView implements RollableView, ActivableView, MouseCapturingView
   {
      
      private static const HIT_COLOR:int = Color.BLUE;
       
      
      private var cursor:Cursor;
      
      public function GaturroPortalView(param1:Portal, param2:TwoWayLink, param3:GaturroRoom, param4:Cursor)
      {
         super(param1,param2,param3);
         this.cursor = param4;
      }
      
      public function rollout() : void
      {
         audio.stop("flecha");
      }
      
      public function get isRollable() : Boolean
      {
         return this.visible;
      }
      
      override public function dispose() : void
      {
         audio.stop("flecha");
         super.dispose();
      }
      
      override protected function init() : void
      {
         var _loc7_:Rect = null;
         var _loc1_:CustomAttributes = sceneObject.attributes;
         var _loc2_:Object = settings.tiles;
         var _loc3_:int = int(int(_loc1_.hitWidth) || int(_loc2_.width));
         var _loc4_:int = int(int(_loc1_.hitHeight) || int(_loc2_.height));
         var _loc5_:int = int(int(_loc1_.hitX) || int(-_loc3_ / 2));
         var _loc6_:int = int(int(_loc1_.hitY) || int(-_loc4_ / 2));
         (_loc7_ = new Rect(_loc3_,_loc4_,HIT_COLOR)).alpha = !!settings.debug.showTiles ? 0.3 : 0;
         _loc7_.x = _loc5_;
         _loc7_.y = _loc6_;
         addChild(_loc7_);
      }
      
      public function rollover() : void
      {
         setTimeout(this.cursor.toArrow,10,this.direction,this.destinationName);
         audio.loop("flecha");
      }
      
      public function get captures() : Boolean
      {
         return true;
      }
      
      override protected function whenActivated(param1:UserAvatar) : void
      {
         if(this.isActivable)
         {
            super.whenActivated(param1);
         }
      }
      
      private function get destinationName() : String
      {
         return String(sceneObject.attributes.label) || "";
      }
      
      public function get isActivable() : Boolean
      {
         return this.visible;
      }
      
      private function get direction() : int
      {
         return int(sceneObject.attributes.direction) || sceneObject.direction;
      }
   }
}

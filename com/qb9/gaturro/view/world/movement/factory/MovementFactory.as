package com.qb9.gaturro.view.world.movement.factory
{
   import com.qb9.gaturro.view.world.movement.*;
   import com.qb9.gaturro.view.world.movement.impl.*;
   import flash.display.*;
   import flash.utils.*;
   
   public class MovementFactory
   {
       
      
      private var map:Dictionary;
      
      public function MovementFactory()
      {
         super();
         this.srtupMap();
      }
      
      private function srtupMap() : void
      {
         this.map = new Dictionary();
         this.map[MovementsEnum.GRAVITY_VERTICAL] = GravityVerticalMovement;
         this.map[MovementsEnum.GRAVITY_ROTATION] = GravityRotationMovement;
         this.map[MovementsEnum.HORIZONTAL_FLIPPING] = HorizontalFlippingMovement;
         this.map[MovementsEnum.SKI] = SkiMovement;
         this.map[MovementsEnum.AVATAR_ACTIONS] = AvatarActionMovement;
      }
      
      public function build(param1:String, param2:DisplayObject, param3:Object = null) : AbstractMovement
      {
         var _loc5_:AbstractMovement;
         var _loc4_:Class;
         (_loc5_ = new (_loc4_ = this.map[param1])(param1,param2)).options = param3;
         _loc5_.ready();
         return _loc5_;
      }
   }
}

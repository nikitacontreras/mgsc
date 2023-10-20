package com.qb9.gaturro.view.camera
{
   import com.qb9.flashlib.math.QMath;
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.globals.stageData;
   import com.qb9.mambo.world.avatars.UserAvatar;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public final class RoomGranjaCamera extends AbstractCamera implements ICamera
   {
      
      private static const roomDisplay_WIDTH:uint = 1600;
      
      private static const MAX_SPEED:Number = settings.camera.maxSpeed;
      
      private static const EASE:Number = settings.camera.easing;
       
      
      private var lastX:Number;
      
      private var movingTo:int;
      
      private var min:uint;
      
      private var max:uint;
      
      private var gaturro:UserAvatar;
      
      private var center:uint;
      
      private var changeDirection:Boolean;
      
      private var trackingTarget:DisplayObject;
      
      public function RoomGranjaCamera(param1:Sprite, param2:Array, param3:int, param4:DisplayObject, param5:UserAvatar)
      {
         super(param1,param2,param3);
         this.trackingTarget = param4;
         this.gaturro = param5;
      }
      
      override public function update(param1:uint) : void
      {
         this.doMove(param1);
      }
      
      private function setInitialPosition() : void
      {
         this.lastX = this.delta;
         this.setLayersPosition(this.lastX);
      }
      
      private function setLayersPosition(param1:Number) : void
      {
         var _loc2_:DisplayObject = null;
         for each(_loc2_ in layers)
         {
            _loc2_.x = param1;
         }
      }
      
      private function get delta() : Number
      {
         var _loc1_:Number = DisplayUtil.offsetX(this.trackingTarget,roomDisplay);
         var _loc2_:Number = QMath.clamp(_loc1_,this.center + this.min,this.max);
         return this.center - _loc2_;
      }
      
      override protected function doMove(param1:uint) : void
      {
         var _loc2_:Number = NaN;
         if(this.gaturro.coord.x <= 7)
         {
            this.movingTo = 0;
            this.changeDirection = true;
         }
         else if(this.gaturro.coord.x <= 12)
         {
            this.movingTo = -310;
            this.changeDirection = true;
         }
         else
         {
            this.movingTo = -800;
            this.changeDirection = true;
         }
         if(this.lastX < this.movingTo)
         {
            _loc2_ = this.lastX - 50;
         }
         else
         {
            _loc2_ = this.lastX - 50;
         }
         if(_loc2_ <= this.movingTo)
         {
            _loc2_ = this.movingTo;
         }
         this.lastX = _loc2_;
         this.setLayersPosition(_loc2_);
      }
      
      override public function init() : void
      {
         layers.push(roomDisplay);
         this.lastX = roomDisplay.x;
         this.center = stageData.width / 2;
         if(bounds > 0)
         {
            this.max = roomDisplay_WIDTH - this.center - bounds;
         }
         else
         {
            this.max = roomDisplay_WIDTH - this.center;
         }
         if(bounds < 0)
         {
            this.min = -bounds;
         }
         else
         {
            this.min = 0;
         }
         this.setInitialPosition();
      }
   }
}

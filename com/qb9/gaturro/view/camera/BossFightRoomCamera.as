package com.qb9.gaturro.view.camera
{
   import com.qb9.flashlib.math.QMath;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.globals.stageData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class BossFightRoomCamera extends AbstractCamera
   {
      
      private static const ROOM_WIDTH:uint = 1600;
      
      private static const MAX_SPEED:Number = settings.camera.maxSpeed;
      
      private static const EASE:Number = settings.camera.easing;
       
      
      public var initialAnimation:Boolean = false;
      
      private var lastX:Number;
      
      public var nextX:Number;
      
      private var changeDirection:Boolean;
      
      private var min:uint;
      
      private var max:uint;
      
      private var center:uint;
      
      private var destinyPoint:Point;
      
      public function BossFightRoomCamera(param1:Sprite, param2:Array, param3:int)
      {
         super(param1,param2,param3);
      }
      
      override protected function doMove(param1:uint) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         _loc2_ = this.lastX - (this.lastX - this.delta) * EASE;
         _loc3_ = (_loc2_ - this.lastX) / param1;
         if(Math.abs(_loc3_) > MAX_SPEED)
         {
            _loc2_ = this.lastX + MAX_SPEED * param1 * QMath.sign(_loc3_);
         }
         this.lastX = _loc2_;
         trace("doMove");
         if(Math.abs(this.lastX - this.delta) <= 1)
         {
            trace("doMove COMPELTE");
            dispatchEvent(new Event(Event.COMPLETE,true));
            stop();
         }
         this.setLayersPosition(_loc2_);
      }
      
      private function setLayersPosition(param1:int) : void
      {
         var _loc2_:DisplayObject = null;
         for each(_loc2_ in layers)
         {
            _loc2_.x = param1;
         }
      }
      
      override public function init() : void
      {
         layers.push(roomDisplay);
         this.lastX = roomDisplay.x;
         this.center = stageData.width / 2;
         if(bounds > 0)
         {
            this.max = ROOM_WIDTH - this.center - bounds;
         }
         else
         {
            this.max = ROOM_WIDTH - this.center;
         }
         if(bounds < 0)
         {
            this.min = -bounds;
         }
         else
         {
            this.min = 0;
         }
         stop();
      }
      
      override public function move(param1:Point) : void
      {
         this.destinyPoint = param1;
         start();
      }
      
      private function get delta() : Number
      {
         var _loc1_:Number = this.destinyPoint.x;
         var _loc2_:Number = QMath.clamp(_loc1_,this.min,this.max);
         return this.center - _loc2_;
      }
   }
}

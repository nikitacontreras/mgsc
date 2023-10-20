package com.qb9.flashlib.easing
{
   import com.qb9.flashlib.tasks.ITask;
   
   public class SpeedBasedTween extends Tween
   {
       
      
      protected var speed:Number;
      
      public function SpeedBasedTween(param1:Object, param2:Number, param3:Object, param4:Object = null)
      {
         super(param1,100000,param3,param4);
         this.speed = param2;
      }
      
      override public function start() : void
      {
         var _loc2_:String = null;
         var _loc3_:Number = NaN;
         super.start();
         var _loc1_:Number = 0;
         for(_loc2_ in dest)
         {
            _loc3_ = dest[_loc2_] - src[_loc2_];
            _loc1_ += _loc3_ * _loc3_;
         }
         duration = Math.round(Math.sqrt(_loc1_) / this.speed * 1000);
      }
      
      override public function clone() : ITask
      {
         return new SpeedBasedTween(obj,this.speed,dest,options);
      }
   }
}

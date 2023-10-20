package com.qb9.gaturro.view.world.movement.impl
{
   import com.qb9.flashlib.math.Random;
   import com.qb9.flashlib.tasks.Loop;
   import com.qb9.flashlib.tasks.Sequence;
   import com.qb9.flashlib.tasks.Task;
   import com.qb9.flashlib.tasks.Wait;
   import com.qb9.gaturro.view.world.movement.AbstractMovement;
   import flash.display.DisplayObject;
   
   public class SkiMovement extends AbstractMovement
   {
       
      
      public function SkiMovement(param1:String, param2:DisplayObject)
      {
         super(param1,param2);
      }
      
      override public function start() : void
      {
      }
      
      override protected function buildTask() : Task
      {
         var _loc1_:int = Random.randint(500,5000);
         var _loc2_:Wait = new Wait(_loc1_);
         var _loc3_:SkiTween = new SkiTween(target,4030,{"x":target.x},{"transition":"easeInOut"});
         var _loc4_:Loop = new Loop(_loc3_);
         return new Sequence(_loc2_,_loc4_);
      }
   }
}

import com.qb9.flashlib.easing.Tween;
import com.qb9.flashlib.math.Random;
import com.qb9.flashlib.tasks.ITask;

class SkiTween extends Tween
{
    
   
   public function SkiTween(param1:Object, param2:int, param3:Object, param4:Object = null)
   {
      super(param1,param2,param3,param4);
   }
   
   override public function start() : void
   {
      var _loc1_:int = 0;
      if(dest.x == 0)
      {
         _loc1_ = Random.randint(-600,600);
      }
      else if(dest.x < 0)
      {
         _loc1_ = Random.randint(200,600);
      }
      else
      {
         _loc1_ = Random.randint(-600,-200);
      }
      var _loc2_:int = int(dest.x);
      dest.x = _loc1_;
      duration = Math.abs(dest.x - _loc2_) * 5;
      super.start();
   }
   
   override public function clone() : ITask
   {
      return new SkiTween(obj,duration,dest,options);
   }
}

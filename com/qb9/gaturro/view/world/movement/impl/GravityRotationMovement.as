package com.qb9.gaturro.view.world.movement.impl
{
   import com.qb9.flashlib.tasks.Loop;
   import com.qb9.flashlib.tasks.Task;
   import com.qb9.gaturro.view.world.movement.AbstractMovement;
   import flash.display.DisplayObject;
   
   public class GravityRotationMovement extends AbstractMovement
   {
       
      
      public function GravityRotationMovement(param1:String, param2:DisplayObject)
      {
         super(param1,param2);
      }
      
      override public function start() : void
      {
      }
      
      override protected function buildTask() : Task
      {
         var _loc1_:RandomTweestingTween = new RandomTweestingTween(target,1500 + Math.random() * 800,{"rotation":(target.rotation <= 0 ? 20 : -20)});
         return new Loop(_loc1_);
      }
   }
}

import com.qb9.flashlib.easing.Tween;
import com.qb9.flashlib.tasks.ITask;

class RandomTweestingTween extends Tween
{
    
   
   public function RandomTweestingTween(param1:Object, param2:int, param3:Object, param4:Object = null)
   {
      super(param1,param2,param3,param4);
   }
   
   override public function start() : void
   {
      duration = 1500 + Math.random() * 800;
      dest.rotation = obj.rotation <= 0 ? 20 : -20;
      super.start();
   }
   
   override public function clone() : ITask
   {
      return new RandomTweestingTween(obj,duration,dest,options);
   }
}

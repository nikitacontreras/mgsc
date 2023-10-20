package com.qb9.gaturro.view.world.movement.impl
{
   import com.qb9.flashlib.tasks.Loop;
   import com.qb9.flashlib.tasks.Sequence;
   import com.qb9.flashlib.tasks.Task;
   import com.qb9.flashlib.tasks.Wait;
   import com.qb9.gaturro.view.world.movement.AbstractMovement;
   import flash.display.DisplayObject;
   
   public class HorizontalFlippingMovement extends AbstractMovement
   {
       
      
      public function HorizontalFlippingMovement(param1:String, param2:DisplayObject)
      {
         super(param1,param2);
      }
      
      override public function start() : void
      {
      }
      
      override protected function buildTask() : Task
      {
         var _loc1_:HorizontalFlippingTween = new HorizontalFlippingTween(target,30,{"scaleX":target.scaleX * -1},{"transition":"easeOut"});
         var _loc2_:Wait = new Wait(4000);
         var _loc3_:Sequence = new Sequence(_loc1_,_loc2_);
         return new Loop(_loc3_);
      }
   }
}

import com.qb9.flashlib.easing.Tween;
import com.qb9.flashlib.tasks.ITask;

class HorizontalFlippingTween extends Tween
{
    
   
   public function HorizontalFlippingTween(param1:Object, param2:int, param3:Object, param4:Object = null)
   {
      super(param1,param2,param3,param4);
   }
   
   override public function start() : void
   {
      dest.scaleX *= -1;
      super.start();
   }
   
   override public function clone() : ITask
   {
      return new HorizontalFlippingTween(obj,duration,dest,options);
   }
}

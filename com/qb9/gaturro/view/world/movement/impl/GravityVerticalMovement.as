package com.qb9.gaturro.view.world.movement.impl
{
   import com.qb9.flashlib.tasks.Loop;
   import com.qb9.flashlib.tasks.Task;
   import com.qb9.gaturro.view.world.movement.AbstractMovement;
   import flash.display.DisplayObject;
   
   public class GravityVerticalMovement extends AbstractMovement
   {
       
      
      public function GravityVerticalMovement(param1:String, param2:DisplayObject)
      {
         super(param1,param2);
      }
      
      override public function start() : void
      {
      }
      
      override protected function buildTask() : Task
      {
         var _loc1_:Number = 1000 + Math.random() * 1000;
         var _loc2_:GravityVerticalTween = new GravityVerticalTween(target,_loc1_,{"y":(target.y == 0 ? -100 - Math.random() * 30 : 0)},{"transition":(target.y == 0 ? "easeOut" : "easeIn")});
         return new Loop(_loc2_);
      }
   }
}

import com.qb9.flashlib.easing.Tween;
import com.qb9.flashlib.tasks.ITask;
import com.qb9.gaturro.globals.api;

class GravityVerticalTween extends Tween
{
    
   
   public function GravityVerticalTween(param1:Object, param2:int, param3:Object, param4:Object = null)
   {
      super(param1,param2,param3,param4);
   }
   
   override public function start() : void
   {
      var _loc1_:int = 0;
      duration = 1000 + Math.random() * 1000;
      dest.y = obj.y == 0 ? -100 - Math.random() * 30 : 0;
      options.transition = obj.y == 0 ? "easeIn" : "easeOut";
      super.start();
      if(dest.y != 0)
      {
         _loc1_ = 1 + int(Math.random() * 7);
         api.playSound("parqueDiversiones/boing" + _loc1_.toString());
         trace(_loc1_);
      }
   }
   
   override public function clone() : ITask
   {
      return new GravityVerticalTween(obj,duration,dest,options);
   }
}

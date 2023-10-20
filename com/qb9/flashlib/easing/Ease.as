package com.qb9.flashlib.easing
{
   import com.qb9.flashlib.tasks.ITask;
   import com.qb9.flashlib.tasks.TimeBasedTask;
   
   public class Ease extends TimeBasedTask
   {
       
      
      private var callback:Function;
      
      private var easeFunction:Function;
      
      private var change:Number;
      
      private var from:Number;
      
      private var args:Array;
      
      public function Ease(param1:Function, param2:int, param3:Number = 0, param4:Number = 1, param5:String = "linear", ... rest)
      {
         super(param2);
         this.callback = param1;
         this.args = rest;
         this.from = param3;
         this.change = param4 - param3;
         this.easeFunction = Easing.getFunction(param5);
      }
      
      override public function clone() : ITask
      {
         var _loc1_:Ease = new Ease(this.callback,duration);
         _loc1_.args = this.args;
         _loc1_.from = this.from;
         _loc1_.change = this.change;
         _loc1_.easeFunction = this.easeFunction;
         return _loc1_;
      }
      
      override protected function updateState() : void
      {
         var _loc1_:Number = this.easeFunction(this.elapsed,this.from,this.change,this.duration);
         this.callback.apply(null,[_loc1_].concat(this.args));
      }
   }
}

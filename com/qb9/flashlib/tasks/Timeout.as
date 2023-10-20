package com.qb9.flashlib.tasks
{
   public class Timeout extends Wait
   {
       
      
      private var callback:Function;
      
      private var args:Array;
      
      public function Timeout(param1:Function, param2:uint, ... rest)
      {
         super(param2);
         this.callback = param1;
         this.args = rest;
      }
      
      public static function fromArgsArray(param1:Function, param2:uint, param3:Array) : Timeout
      {
         var _loc4_:Timeout;
         (_loc4_ = new Timeout(param1,param2)).args = param3;
         return _loc4_;
      }
      
      override public function clone() : ITask
      {
         return fromArgsArray(this.callback,duration,this.args);
      }
      
      override protected function taskComplete() : void
      {
         this.callback.apply(null,this.args);
         super.taskComplete();
      }
   }
}

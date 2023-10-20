package com.qb9.flashlib.tasks
{
   public class Func extends Task
   {
       
      
      private var callback:Function;
      
      private var args:Array;
      
      public function Func(param1:Function, ... rest)
      {
         super();
         this.callback = param1;
         this.args = rest;
      }
      
      public static function fromArgsArray(param1:Function, param2:Array) : Func
      {
         var _loc3_:Func = new Func(param1);
         _loc3_.args = param2;
         return _loc3_;
      }
      
      override public function start() : void
      {
         super.start();
         if(this.callback != null)
         {
            this.callback.apply(null,this.args);
         }
         this.taskComplete();
      }
      
      override public function clone() : ITask
      {
         return fromArgsArray(this.callback,this.args);
      }
   }
}

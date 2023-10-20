package com.qb9.flashlib.tasks
{
   public class TimeBasedTask extends Task
   {
       
      
      public var duration:uint;
      
      public function TimeBasedTask(param1:uint)
      {
         super();
         this.duration = param1;
      }
      
      override public function update(param1:uint) : void
      {
         var _loc2_:uint = Math.min(param1,this.timeLeft);
         super.update(_loc2_);
         this.updateState();
         if(elapsed == this.duration)
         {
            this.taskComplete();
         }
      }
      
      public function get timeLeft() : int
      {
         return this.duration - elapsed;
      }
      
      override public function clone() : ITask
      {
         return new TimeBasedTask(this.duration);
      }
      
      protected function updateState() : void
      {
      }
   }
}

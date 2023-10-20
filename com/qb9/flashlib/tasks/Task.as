package com.qb9.flashlib.tasks
{
   import com.qb9.flashlib.events.QEventDispatcher;
   
   public class Task extends QEventDispatcher implements ITask
   {
       
      
      protected var _running:Boolean;
      
      protected var _elapsed:uint;
      
      public function Task()
      {
         super();
         this._elapsed = 0;
         this._running = false;
      }
      
      override public function dispatch(param1:String, param2:* = null) : Boolean
      {
         if(!this.hasEventListener(param1))
         {
            return true;
         }
         return this.dispatchEvent(new TaskEvent(param1,param2));
      }
      
      public function stop() : void
      {
         if(!this.running)
         {
            return;
         }
         this._running = false;
         this.dispatch(TaskEvent.STOPPED);
      }
      
      public function get elapsed() : uint
      {
         return this._elapsed;
      }
      
      public function get running() : Boolean
      {
         return this._running;
      }
      
      public function start() : void
      {
         if(this.running)
         {
            return;
         }
         this._running = true;
         this.dispatch(TaskEvent.STARTED);
      }
      
      protected function updateSubtask(param1:ITask, param2:uint) : uint
      {
         var _loc3_:uint = param1.elapsed;
         param1.update(param2);
         return param1.elapsed - _loc3_;
      }
      
      public function clone() : ITask
      {
         return new Task();
      }
      
      override public function dispose() : void
      {
         if(this.running)
         {
            this.stop();
         }
         super.dispose();
      }
      
      public function update(param1:uint) : void
      {
         this._elapsed += param1;
         this.dispatch(TaskEvent.UPDATE,{"milliseconds":param1});
      }
      
      protected function taskComplete() : void
      {
         this.stop();
         this.dispatch(TaskEvent.COMPLETE);
      }
   }
}

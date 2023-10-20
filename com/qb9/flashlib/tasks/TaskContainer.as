package com.qb9.flashlib.tasks
{
   import com.qb9.flashlib.utils.ArrayUtil;
   
   public class TaskContainer extends Task
   {
       
      
      protected var autoStartAddedTasks:Boolean;
      
      public var subtasks:Array;
      
      public function TaskContainer(param1:Boolean = true, ... rest)
      {
         super();
         this.autoStartAddedTasks = param1;
         this.subtasks = [];
         this.addTaskOrArray(rest);
      }
      
      protected function disposeTask(param1:ITask) : void
      {
         param1.removeEventListener(TaskEvent.COMPLETE,this.onSubTaskComplete);
         param1.dispose();
      }
      
      override public function dispose() : void
      {
         var _loc1_:ITask = null;
         for each(_loc1_ in this.subtasks)
         {
            this.disposeTask(_loc1_);
         }
         this.subtasks.length = 0;
         super.dispose();
      }
      
      public function add(param1:ITask) : void
      {
         this.subtasks.push(param1);
         param1.addEventListener(TaskEvent.COMPLETE,this.onSubTaskComplete);
         if(this.autoStartAddedTasks && this.running)
         {
            param1.start();
         }
      }
      
      override public function start() : void
      {
         var _loc1_:ITask = null;
         if(running)
         {
            return;
         }
         super.start();
         if(this.autoStartAddedTasks)
         {
            for each(_loc1_ in this.subtasks.slice())
            {
               _loc1_.start();
            }
         }
      }
      
      public function remove(param1:ITask) : void
      {
         this.disposeTask(param1);
         ArrayUtil.removeElement(this.subtasks,param1);
      }
      
      override public function clone() : ITask
      {
         return new TaskContainer(this.autoStartAddedTasks,this.cloneSubtasks());
      }
      
      public function get empty() : Boolean
      {
         return this.subtasks.length == 0;
      }
      
      protected function addTaskOrArray(param1:*) : void
      {
         var _loc2_:* = undefined;
         if(param1 is Array)
         {
            for each(_loc2_ in param1)
            {
               this.addTaskOrArray(_loc2_);
            }
         }
         else
         {
            this.add(param1 as ITask);
         }
      }
      
      protected function cloneSubtasks() : Array
      {
         var _loc2_:ITask = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this.subtasks)
         {
            _loc1_.push(_loc2_.clone());
         }
         return _loc1_;
      }
      
      override public function update(param1:uint) : void
      {
         super.update(this.updateSubtasks(param1));
      }
      
      override public function stop() : void
      {
         var _loc1_:ITask = null;
         if(!running)
         {
            return;
         }
         super.stop();
         if(this.autoStartAddedTasks)
         {
            for each(_loc1_ in this.subtasks.slice())
            {
               _loc1_.stop();
            }
         }
      }
      
      protected function updateSubtasks(param1:uint) : uint
      {
         var _loc3_:ITask = null;
         var _loc2_:uint = 0;
         for each(_loc3_ in this.subtasks.slice())
         {
            if(_loc3_.running)
            {
               _loc2_ = Math.max(_loc2_,updateSubtask(_loc3_,param1));
            }
         }
         return running ? _loc2_ : param1;
      }
      
      protected function onSubTaskComplete(param1:TaskEvent) : void
      {
         var _loc2_:ITask = param1.target as ITask;
         this.remove(_loc2_);
      }
   }
}

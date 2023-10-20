package com.qb9.flashlib.tasks
{
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.flashlib.interfaces.IUpdateable;
   import flash.events.IEventDispatcher;
   
   public interface ITask extends IDisposable, IUpdateable, IEventDispatcher
   {
       
      
      function stop() : void;
      
      function start() : void;
      
      function get elapsed() : uint;
      
      function clone() : ITask;
      
      function get running() : Boolean;
   }
}

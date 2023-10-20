package com.qb9.gaturro.view.world.movement
{
   import com.qb9.flashlib.tasks.Task;
   import com.qb9.gaturro.commons.dispose.ICheckableDisposable;
   
   public interface IMovement extends ICheckableDisposable
   {
       
      
      function perform() : Task;
      
      function start() : void;
      
      function ready() : void;
      
      function stop() : void;
      
      function set options(param1:Object) : void;
      
      function get performer() : Task;
   }
}

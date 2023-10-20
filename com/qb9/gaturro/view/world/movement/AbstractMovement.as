package com.qb9.gaturro.view.world.movement
{
   import com.qb9.flashlib.tasks.Task;
   import com.qb9.gaturro.event.MovementEvent;
   import flash.display.DisplayObject;
   import flash.errors.IllegalOperationError;
   import flash.events.EventDispatcher;
   
   public class AbstractMovement extends EventDispatcher implements IMovement
   {
       
      
      private var _disposed:Boolean;
      
      private var _performer:Task;
      
      private var _type:String;
      
      private var _options:Object;
      
      private var _target:DisplayObject;
      
      public function AbstractMovement(param1:String, param2:DisplayObject)
      {
         super();
         this._type = param1;
         this._target = param2;
      }
      
      public function stop() : void
      {
         this._target = null;
      }
      
      public function set options(param1:Object) : void
      {
         this._options = param1;
      }
      
      public function get performer() : Task
      {
         return this._performer;
      }
      
      public function get target() : DisplayObject
      {
         return this._target;
      }
      
      protected function finish() : void
      {
         dispatchEvent(new MovementEvent(MovementEvent.FINISHED,this));
         this.stop();
      }
      
      protected function buildTask() : Task
      {
         throw new IllegalOperationError("This is an abstract method and shoudln\'t invoke it. The subclass has to implement this");
      }
      
      final public function perform() : Task
      {
         this._performer = this.buildTask();
         return this._performer;
      }
      
      public function start() : void
      {
         throw new IllegalOperationError("This is an abstract method and shoudln\'t invoke it. The subclass has to implement this");
      }
      
      public function ready() : void
      {
      }
      
      public function get disposed() : Boolean
      {
         return this._disposed;
      }
      
      public function get options() : Object
      {
         return this._options;
      }
      
      public function dispose() : void
      {
         this._disposed = true;
      }
      
      public function get type() : String
      {
         return this._type;
      }
   }
}

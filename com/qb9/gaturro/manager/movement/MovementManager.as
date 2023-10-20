package com.qb9.gaturro.manager.movement
{
   import com.qb9.flashlib.tasks.Task;
   import com.qb9.flashlib.tasks.TaskRunner;
   import com.qb9.flashlib.utils.ArrayUtil;
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.event.ContextEvent;
   import com.qb9.gaturro.commons.manager.notificator.Notification;
   import com.qb9.gaturro.commons.manager.notificator.NotificationManager;
   import com.qb9.gaturro.notifier.GaturroNotificationType;
   import com.qb9.gaturro.view.world.movement.AbstractMovement;
   import com.qb9.gaturro.view.world.movement.factory.MovementFactory;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.utils.Dictionary;
   
   public class MovementManager
   {
      
      private static const STOPPED:int = 0;
      
      private static const PLAYING:int = 1;
       
      
      private var notificationManager:NotificationManager;
      
      private var mapByTarget:Dictionary;
      
      private var _status:int;
      
      private var _factory:MovementFactory;
      
      private var runner:TaskRunner;
      
      private var motor:MovieClip;
      
      public function MovementManager()
      {
         super();
         this.motor = new MovieClip();
         this.runner = new TaskRunner(this.motor);
         this.mapByTarget = new Dictionary();
         this.setup();
      }
      
      private function setupNotificationManager() : void
      {
         this.notificationManager = Context.instance.getByType(NotificationManager) as NotificationManager;
         this.notificationManager.observe(GaturroNotificationType.ROOM_CHANGED,this.onRoomChanged);
      }
      
      public function stop() : void
      {
         this.runner.stop();
         this.status = STOPPED;
      }
      
      public function reset() : void
      {
         var _loc1_:Array = null;
         var _loc2_:AbstractMovement = null;
         this.stop();
         for each(_loc1_ in this.mapByTarget)
         {
            for each(_loc2_ in _loc1_)
            {
               this.runner.remove(_loc2_.performer);
            }
         }
      }
      
      public function remove(param1:String, param2:DisplayObject) : void
      {
         var _loc4_:AbstractMovement = null;
         var _loc3_:Array = this.mapByTarget[param2];
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.type == param1)
            {
               ArrayUtil.removeElement(_loc3_,_loc4_);
               this.runner.remove(_loc4_.performer);
               break;
            }
         }
      }
      
      public function set factory(param1:MovementFactory) : void
      {
         this._factory = param1;
      }
      
      private function onAdded(param1:ContextEvent) : void
      {
         if(param1.instanceType == NotificationManager)
         {
            this.setupNotificationManager();
         }
      }
      
      private function set status(param1:int) : void
      {
         if(param1 != 0 && param1 != 1)
         {
            throw new Error("Attempted to chage the status property with invalid value");
         }
         this._status = param1;
      }
      
      private function store(param1:AbstractMovement, param2:DisplayObject) : void
      {
         var _loc3_:Array = this.mapByTarget[param2];
         if(!_loc3_)
         {
            _loc3_ = new Array();
            this.mapByTarget[param2] = _loc3_;
         }
      }
      
      public function start() : void
      {
         if(this.status == STOPPED)
         {
            this.runner.start();
            this.status = PLAYING;
         }
      }
      
      public function removeByTarget(param1:DisplayObject) : void
      {
         var _loc4_:AbstractMovement = null;
         var _loc2_:Array = this.mapByTarget[param1];
         for each(_loc4_ in _loc2_)
         {
            this.runner.remove(_loc4_.performer);
         }
         _loc2_.length = 0;
         delete this.mapByTarget[param1];
      }
      
      private function get status() : int
      {
         return this._status;
      }
      
      public function addMovement(param1:String, param2:DisplayObject, param3:Object = null) : void
      {
         var _loc4_:AbstractMovement;
         var _loc5_:Task = (_loc4_ = this._factory.build(param1,param2,param3)).perform();
         this.runner.add(_loc5_);
         this.store(_loc4_,param2);
      }
      
      private function onRoomChanged(param1:com.qb9.gaturro.commons.manager.notificator.Notification) : void
      {
         this.reset();
      }
      
      private function setup() : void
      {
         if(Context.instance.hasByType(NotificationManager))
         {
            this.setupNotificationManager();
         }
         else
         {
            Context.instance.addEventListener(ContextEvent.ADDED,this.onAdded);
         }
      }
   }
}

package com.qb9.flashlib.tasks
{
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.utils.getTimer;
   
   public class TaskRunner extends TaskContainer
   {
       
      
      protected var source:IEventDispatcher;
      
      private var lastUpdate:uint;
      
      public function TaskRunner(param1:IEventDispatcher)
      {
         this.source = param1;
         super();
      }
      
      override public function stop() : void
      {
         if(!running)
         {
            return;
         }
         this.source.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         super.stop();
      }
      
      override public function start() : void
      {
         if(running)
         {
            return;
         }
         this.lastUpdate = getTimer();
         this.source.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         super.start();
      }
      
      protected function onEnterFrame(param1:Event) : void
      {
         var _loc2_:int = getTimer() - this.lastUpdate;
         this.lastUpdate = getTimer();
         if(_loc2_ <= 0 || _loc2_ > 10000)
         {
            return;
         }
         this.update(_loc2_);
      }
   }
}

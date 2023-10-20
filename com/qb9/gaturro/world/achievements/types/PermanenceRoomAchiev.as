package com.qb9.gaturro.world.achievements.types
{
   import com.qb9.gaturro.globals.user;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class PermanenceRoomAchiev extends Achievement
   {
       
      
      protected var timer:Timer;
      
      protected var timeNeeds:Number;
      
      protected var timeSpend:Number = 0;
      
      protected var roomId:Number;
      
      protected const TIME_LOOP:int = 2000;
      
      public function PermanenceRoomAchiev(param1:Object)
      {
         super(param1);
         this.roomId = param1.data.roomId;
         this.timeNeeds = param1.data.time;
      }
      
      private function tick(param1:Event) : void
      {
         if(!room)
         {
            return;
         }
         var _loc2_:Number = room.owner && room.ownerName && room.owner.username == user.username ? 0 : room.id;
         if(this.roomId != _loc2_)
         {
            return;
         }
         this.timeSpend += this.TIME_LOOP;
         if(this.timeSpend >= this.timeNeeds)
         {
            achieve();
         }
      }
      
      override protected function deactivate() : void
      {
         if(!this.timer)
         {
            return;
         }
         this.timer.removeEventListener(TimerEvent.TIMER,this.tick);
         this.timer.stop();
         this.timer = null;
      }
      
      override public function init(param1:String, param2:Boolean) : void
      {
         super.init(param1,param2);
         if(param1 == Achievement.ACHIEVEMENT_SUCCESS)
         {
            achieved = true;
         }
         else
         {
            this.activate();
         }
      }
      
      override protected function activate() : void
      {
         if(!monitor)
         {
            return;
         }
         this.timer = new Timer(this.TIME_LOOP);
         this.timer.addEventListener(TimerEvent.TIMER,this.tick);
         this.timer.start();
      }
      
      override public function dispose() : void
      {
         this.deactivate();
         super.dispose();
      }
   }
}

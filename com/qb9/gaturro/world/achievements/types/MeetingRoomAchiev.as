package com.qb9.gaturro.world.achievements.types
{
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.world.core.avatar.GaturroUserAvatar;
   import com.qb9.mambo.world.avatars.Avatar;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class MeetingRoomAchiev extends Achievement
   {
       
      
      protected var timer:Timer;
      
      protected var quantityNeeds:int;
      
      protected var roomId:Number;
      
      protected const TIME_LOOP:int = 8000;
      
      public function MeetingRoomAchiev(param1:Object)
      {
         super(param1);
         this.roomId = param1.data.roomId;
         this.quantityNeeds = param1.data.quantity;
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
      
      private function tick(param1:Event) : void
      {
         var _loc4_:Object = null;
         if(!room)
         {
            return;
         }
         var _loc2_:Number = Boolean(room.owner) && room.owner.username == user.username ? 0 : room.id;
         if(this.roomId != _loc2_)
         {
            return;
         }
         var _loc3_:int = 0;
         for each(_loc4_ in room.sceneObjects)
         {
            if(_loc4_ is Avatar || _loc4_ is GaturroUserAvatar)
            {
               _loc3_++;
            }
         }
         if(_loc3_ >= this.quantityNeeds)
         {
            achieve();
         }
      }
      
      override public function dispose() : void
      {
         this.deactivate();
         super.dispose();
      }
   }
}

package com.qb9.gaturro.world.achievements.types
{
   import com.qb9.gaturro.globals.user;
   import com.qb9.mambo.geom.Coord;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   
   public class LocationRoomAchiev extends Achievement
   {
       
      
      protected var timer:Timer;
      
      protected var tileTo:Point;
      
      protected var roomId:Number;
      
      protected var tileFrom:Point;
      
      protected const TIME_LOOP:int = 4000;
      
      public function LocationRoomAchiev(param1:Object)
      {
         super(param1);
         this.roomId = param1.data.roomId;
         var _loc2_:Object = param1.data.tiles;
         this.tileFrom = new Point(_loc2_[0],_loc2_[1]);
         this.tileTo = new Point(_loc2_[2],_loc2_[3]);
      }
      
      private function tick(param1:Event) : void
      {
         if(!room)
         {
            return;
         }
         var _loc2_:Number = Boolean(room.owner) && room.owner.username == user.username ? 0 : room.id;
         if(this.roomId != _loc2_)
         {
            return;
         }
         if(!room.userAvatar)
         {
            return;
         }
         var _loc3_:Coord = room.userAvatar.tile.coord;
         if(!_loc3_)
         {
            return;
         }
         if(_loc3_.x >= this.tileFrom.x && _loc3_.x <= this.tileTo.x)
         {
            if(_loc3_.y >= this.tileFrom.y && _loc3_.y <= this.tileTo.y)
            {
               achieve();
            }
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

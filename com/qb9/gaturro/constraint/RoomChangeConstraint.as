package com.qb9.gaturro.constraint
{
   import com.qb9.gaturro.commons.constraint.AbstractConstraint;
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.event.ContextEvent;
   import com.qb9.gaturro.commons.manager.notificator.Notification;
   import com.qb9.gaturro.commons.manager.notificator.NotificationManager;
   import com.qb9.gaturro.notifier.GaturroNotificationType;
   
   public class RoomChangeConstraint extends AbstractConstraint
   {
       
      
      private var notificationManager:NotificationManager;
      
      private var changedRoomId:int = 0;
      
      private var roomId:int;
      
      public function RoomChangeConstraint(param1:Boolean)
      {
         super(param1);
         this.setup();
      }
      
      private function onAdded(param1:ContextEvent) : void
      {
         if(param1.instanceType == NotificationManager)
         {
            this.setupNotification();
            Context.instance.removeEventListener(ContextEvent.ADDED,this.onAdded);
         }
      }
      
      override public function accomplish(param1:* = null) : Boolean
      {
         var _loc2_:* = this.changedRoomId == this.roomId;
         return doInvert(_loc2_);
      }
      
      override public function dispose() : void
      {
         Context.instance.removeEventListener(ContextEvent.ADDED,this.onAdded);
         if(this.notificationManager)
         {
            this.notificationManager.unobserve(GaturroNotificationType.ROOM_CHANGED_PREPARATION,this.OnPreparingRoomChange);
            this.notificationManager.unobserve(GaturroNotificationType.ROOM_CHANGED,this.onRoomChanged);
            this.notificationManager = null;
         }
         super.dispose();
      }
      
      private function setupNotification() : void
      {
         this.notificationManager = Context.instance.getByType(NotificationManager) as NotificationManager;
         this.notificationManager.observe(GaturroNotificationType.ROOM_CHANGED_PREPARATION,this.OnPreparingRoomChange);
      }
      
      private function OnPreparingRoomChange(param1:com.qb9.gaturro.commons.manager.notificator.Notification) : void
      {
         if(param1.data.room == this.roomId)
         {
            this.notificationManager.observe(GaturroNotificationType.ROOM_CHANGED,this.onRoomChanged);
         }
      }
      
      private function onRoomChanged(param1:com.qb9.gaturro.commons.manager.notificator.Notification) : void
      {
         if(param1.data.room == this.roomId)
         {
            this.changedRoomId = param1.data.room;
            changed();
         }
      }
      
      override public function setData(param1:*) : void
      {
         this.roomId = param1.roomId;
      }
      
      private function setup() : void
      {
         if(!weak)
         {
            if(Context.instance.hasByType(NotificationManager))
            {
               this.setupNotification();
            }
            else
            {
               Context.instance.addEventListener(ContextEvent.ADDED,this.onAdded);
            }
         }
      }
   }
}

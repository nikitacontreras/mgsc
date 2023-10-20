package com.qb9.gaturro.constraint
{
   import com.qb9.gaturro.commons.constraint.AbstractConstraint;
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.event.ContextEvent;
   import com.qb9.gaturro.commons.manager.notificator.Notification;
   import com.qb9.gaturro.commons.manager.notificator.NotificationManager;
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.notifier.GaturroNotificationType;
   
   public class IsOwnerHomeConstraint extends AbstractConstraint
   {
       
      
      private var notificationManager:NotificationManager;
      
      private var roomAPI:GaturroRoomAPI;
      
      public function IsOwnerHomeConstraint(param1:Boolean)
      {
         super(param1);
         this.setup();
      }
      
      override public function accomplish(param1:* = null) : Boolean
      {
         var _loc2_:Boolean = api != null && Boolean(api.room.ownedByUser);
         return doInvert(_loc2_);
      }
      
      private function setupNotificationManager() : void
      {
         this.notificationManager = Context.instance.getByType(NotificationManager) as NotificationManager;
         if(!weak)
         {
            this.notificationManager.observe(GaturroNotificationType.ROOM_CHANGED,this.onRoomChanged);
         }
      }
      
      private function onInstanceAdded(param1:ContextEvent) : void
      {
         if(param1.instanceType == NotificationManager && !weak)
         {
            this.setupNotificationManager();
            Context.instance.removeEventListener(ContextEvent.ADDED,this.onInstanceAdded);
         }
      }
      
      override public function dispose() : void
      {
         Context.instance.removeEventListener(ContextEvent.ADDED,this.onInstanceAdded);
         if(this.notificationManager)
         {
            this.notificationManager.unobserve(GaturroNotificationType.ROOM_CHANGED,this.onRoomChanged);
            this.notificationManager = null;
         }
         super.dispose();
      }
      
      private function onApiAdded(param1:ContextEvent) : void
      {
         if(param1.instanceType == GaturroRoomAPI)
         {
            Context.instance.removeEventListener(ContextEvent.ADDED,this.onApiAdded);
            if(api.room.isHome)
            {
               changed();
            }
         }
      }
      
      private function onRoomChanged(param1:Notification) : void
      {
         if(api)
         {
            if(api.room.isHome)
            {
               changed();
            }
         }
         else
         {
            Context.instance.addEventListener(ContextEvent.ADDED,this.onApiAdded);
         }
      }
      
      private function setup() : void
      {
         if(!weak)
         {
            if(Context.instance.hasByType(NotificationManager))
            {
               this.setupNotificationManager();
            }
            else
            {
               Context.instance.addEventListener(ContextEvent.ADDED,this.onInstanceAdded);
            }
         }
      }
   }
}

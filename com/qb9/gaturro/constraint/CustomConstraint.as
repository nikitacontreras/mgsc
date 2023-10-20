package com.qb9.gaturro.constraint
{
   import com.qb9.gaturro.commons.constraint.AbstractConstraint;
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.event.ContextEvent;
   import com.qb9.gaturro.commons.manager.notificator.Notification;
   import com.qb9.gaturro.commons.manager.notificator.NotificationManager;
   import com.qb9.gaturro.notifier.GaturroNotificationType;
   
   public class CustomConstraint extends AbstractConstraint
   {
       
      
      private var notificationManager:NotificationManager;
      
      private var key:String;
      
      private var sendedKey:String;
      
      public function CustomConstraint(param1:Boolean)
      {
         super(param1);
         this.setup();
      }
      
      private function setupNotificationManager() : void
      {
         this.notificationManager = Context.instance.getByType(NotificationManager) as NotificationManager;
         this.notificationManager.observe(GaturroNotificationType.CUSTOM,this.onCustomActivate);
      }
      
      override public function accomplish(param1:* = null) : Boolean
      {
         var _loc2_:* = this.key == this.sendedKey;
         return doInvert(_loc2_);
      }
      
      private function onCustomActivate(param1:com.qb9.gaturro.commons.manager.notificator.Notification) : void
      {
         if(param1.data.key == this.key)
         {
            this.sendedKey = param1.data.key;
            changed();
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
      
      override public function setData(param1:*) : void
      {
         this.key = param1.key;
      }
      
      private function setup() : void
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
      
      override public function dispose() : void
      {
         super.dispose();
         Context.instance.removeEventListener(ContextEvent.ADDED,this.onInstanceAdded);
         if(!weak)
         {
            this.notificationManager.unobserve(GaturroNotificationType.CUSTOM,this.onCustomActivate);
            this.notificationManager = null;
         }
      }
   }
}

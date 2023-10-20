package com.qb9.gaturro.constraint
{
   import com.qb9.gaturro.commons.constraint.AbstractConstraint;
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.event.ContextEvent;
   import com.qb9.gaturro.commons.manager.notificator.Notification;
   import com.qb9.gaturro.commons.manager.notificator.NotificationManager;
   import com.qb9.gaturro.notifier.GaturroNotificationType;
   
   public class DropObjectConstraint extends AbstractConstraint
   {
       
      
      private var notificationManager:NotificationManager;
      
      private var droped:Boolean = false;
      
      private var item:String;
      
      public function DropObjectConstraint(param1:Boolean)
      {
         super(param1);
         this.setup();
      }
      
      private function setupNotificationManager() : void
      {
         this.notificationManager = Context.instance.getByType(NotificationManager) as NotificationManager;
         if(!weak)
         {
            this.notificationManager.observe(GaturroNotificationType.DROP_OBJECT,this.onDroped);
         }
      }
      
      override public function accomplish(param1:* = null) : Boolean
      {
         var _loc2_:Boolean = false;
         return doInvert(_loc2_);
      }
      
      private function onDroped(param1:com.qb9.gaturro.commons.manager.notificator.Notification) : void
      {
         if(param1.data.toString() == this.item)
         {
            this.droped = true;
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
         this.item = param1.item;
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
      
      override public function dispose() : void
      {
         super.dispose();
         Context.instance.removeEventListener(ContextEvent.ADDED,this.onInstanceAdded);
         if(!weak)
         {
            this.notificationManager.unobserve(GaturroNotificationType.DROP_OBJECT,this.onDroped);
         }
      }
   }
}

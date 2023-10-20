package com.qb9.gaturro.constraint
{
   import com.qb9.gaturro.commons.constraint.AbstractConstraint;
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.event.ContextEvent;
   import com.qb9.gaturro.commons.manager.notificator.Notification;
   import com.qb9.gaturro.commons.manager.notificator.NotificationManager;
   import com.qb9.gaturro.notifier.GaturroNotificationType;
   
   public class BuyCatalogConstraint extends AbstractConstraint
   {
       
      
      private var notificationManager:NotificationManager;
      
      private var result:Boolean;
      
      private var catalog:String;
      
      public function BuyCatalogConstraint(param1:Boolean)
      {
         super(param1);
         this.setup();
      }
      
      override public function accomplish(param1:* = null) : Boolean
      {
         this.result = doInvert(this.result);
         return this.result;
      }
      
      private function setupNotificationManager() : void
      {
         this.notificationManager = Context.instance.getByType(NotificationManager) as NotificationManager;
         if(!weak)
         {
            this.notificationManager.observe(GaturroNotificationType.BUY,this.onBuy);
         }
      }
      
      override public function dispose() : void
      {
         if(this.notificationManager)
         {
            this.notificationManager.unobserve(GaturroNotificationType.BUY,this.onBuy);
            this.notificationManager = null;
         }
         super.dispose();
      }
      
      private function onBuy(param1:com.qb9.gaturro.commons.manager.notificator.Notification) : void
      {
         if(param1.data.catalog == this.catalog)
         {
            this.result = true;
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
         this.catalog = param1.item;
         super.setData(param1);
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

package com.qb9.gaturro.constraint
{
   import com.qb9.gaturro.commons.constraint.AbstractConstraint;
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.event.ContextEvent;
   import com.qb9.gaturro.commons.manager.notificator.Notification;
   import com.qb9.gaturro.commons.manager.notificator.NotificationManager;
   import com.qb9.gaturro.notifier.GaturroNotificationType;
   
   public class BuyItemConstraint extends AbstractConstraint
   {
       
      
      private var notificationManager:NotificationManager;
      
      private var item:String;
      
      private var result:Boolean;
      
      public function BuyItemConstraint(param1:Boolean)
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
      
      private function onBuy(param1:com.qb9.gaturro.commons.manager.notificator.Notification) : void
      {
         if(param1.data.item == this.item)
         {
            this.result = true;
            changed();
         }
      }
      
      override public function setData(param1:*) : void
      {
         this.item = param1.item;
         super.setData(param1);
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
      
      private function onInstanceAdded(param1:ContextEvent) : void
      {
         if(param1.instanceType == NotificationManager && !weak)
         {
            this.setupNotificationManager();
            Context.instance.removeEventListener(ContextEvent.ADDED,this.onInstanceAdded);
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

package com.qb9.gaturro.constraint
{
   import com.qb9.gaturro.commons.constraint.AbstractConstraint;
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.event.ContextEvent;
   import com.qb9.gaturro.commons.manager.notificator.Notification;
   import com.qb9.gaturro.commons.manager.notificator.NotificationManager;
   import com.qb9.gaturro.notifier.GaturroNotificationType;
   
   public class ExchangedPackConstraint extends AbstractConstraint
   {
       
      
      private var notificationManager:NotificationManager;
      
      private var exchangedItem:String;
      
      private var pack:String;
      
      public function ExchangedPackConstraint(param1:Boolean)
      {
         super(param1);
         this.setup();
      }
      
      private function setupNotificationManager() : void
      {
         this.notificationManager = Context.instance.getByType(NotificationManager) as NotificationManager;
         this.notificationManager.observe(GaturroNotificationType.EXCHANGED,this.onExchangedItem);
      }
      
      override public function accomplish(param1:* = null) : Boolean
      {
         var _loc2_:* = this.exchangedItem.indexOf(this.pack) == 0;
         return doInvert(_loc2_);
      }
      
      override public function setData(param1:*) : void
      {
         this.pack = param1.pack;
      }
      
      private function onInstanceAdded(param1:ContextEvent) : void
      {
         if(param1.instanceType == NotificationManager && !weak)
         {
            this.setupNotificationManager();
            Context.instance.removeEventListener(ContextEvent.ADDED,this.onInstanceAdded);
         }
      }
      
      private function onExchangedItem(param1:com.qb9.gaturro.commons.manager.notificator.Notification) : void
      {
         if(String(param1.data.item).indexOf(this.pack) == 0)
         {
            this.exchangedItem = param1.data.item;
            changed();
         }
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
            this.notificationManager.unobserve(GaturroNotificationType.EXCHANGED,this.onExchangedItem);
            this.notificationManager = null;
         }
      }
   }
}

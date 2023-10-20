package com.qb9.gaturro.constraint
{
   import com.qb9.gaturro.commons.constraint.AbstractConstraint;
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.event.ContextEvent;
   import com.qb9.gaturro.commons.manager.notificator.Notification;
   import com.qb9.gaturro.commons.manager.notificator.NotificationManager;
   import com.qb9.gaturro.notifier.GaturroNotificationType;
   
   public class NpcTakesConstraint extends AbstractConstraint
   {
       
      
      private var notificationManager:NotificationManager;
      
      private var gift:String;
      
      private var amount:int;
      
      private var result:Boolean;
      
      public function NpcTakesConstraint(param1:Boolean)
      {
         super(param1);
         this.setup();
      }
      
      private function onAdded(param1:ContextEvent) : void
      {
         if(param1.instanceType == NotificationManager)
         {
            Context.instance.removeEventListener(ContextEvent.ADDED,this.onAdded);
         }
      }
      
      override public function accomplish(param1:* = null) : Boolean
      {
         this.result = doInvert(this.result);
         return this.result;
      }
      
      private function setupNotification() : void
      {
         this.notificationManager = Context.instance.getByType(NotificationManager) as NotificationManager;
         this.notificationManager.observe(GaturroNotificationType.NPC_TAKES,this.onTakes);
      }
      
      override public function setData(param1:*) : void
      {
         this.gift = param1.gift;
         this.amount = param1.amount;
      }
      
      private function onTakes(param1:com.qb9.gaturro.commons.manager.notificator.Notification) : void
      {
         if(param1.data.type == this.gift)
         {
            this.result = !this.amount || this.amount && param1.data.amount == this.amount ? true : false;
            changed();
         }
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
      
      override public function dispose() : void
      {
         Context.instance.removeEventListener(ContextEvent.ADDED,this.onAdded);
         if(this.notificationManager)
         {
            this.notificationManager.unobserve(GaturroNotificationType.NPC_TAKES,this.onTakes);
            this.notificationManager = null;
         }
         super.dispose();
      }
   }
}

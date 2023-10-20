package com.qb9.gaturro.constraint
{
   import com.qb9.gaturro.commons.constraint.AbstractConstraint;
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.event.ContextEvent;
   import com.qb9.gaturro.commons.manager.notificator.Notification;
   import com.qb9.gaturro.commons.manager.notificator.NotificationManager;
   import com.qb9.gaturro.manager.counter.GaturroCounterManager;
   import com.qb9.gaturro.notifier.GaturroNotificationType;
   
   public class CounterConstraint extends AbstractConstraint
   {
      
      private static const GREAT_THAN:String = "gt";
      
      private static const EQUAL:String = "eq";
      
      private static const LESS_THAN:String = "lt";
       
      
      private var notificationManager:NotificationManager;
      
      private var name:String;
      
      private var comparer:String = "gt";
      
      private var counterManager:GaturroCounterManager;
      
      private var amount:int;
      
      private var type:String;
      
      public function CounterConstraint(param1:Boolean)
      {
         super(param1);
         this.setup();
      }
      
      override public function accomplish(param1:* = null) : Boolean
      {
         var _loc3_:* = false;
         var _loc2_:int = this.counterManager.getAmount(this.name);
         switch(this.comparer)
         {
            case LESS_THAN:
               _loc3_ = _loc2_ <= this.amount;
               break;
            case GREAT_THAN:
               _loc3_ = _loc2_ >= this.amount;
               break;
            case EQUAL:
               _loc3_ = this.amount == _loc2_;
               break;
            default:
               _loc3_ = _loc2_ >= this.amount;
         }
         return doInvert(_loc3_);
      }
      
      private function setupNotificationManager() : void
      {
         this.notificationManager = Context.instance.getByType(NotificationManager) as NotificationManager;
         if(!weak)
         {
            this.notificationManager.observe(GaturroNotificationType.COUNTER_CHANGED,this.counterChanged);
         }
      }
      
      private function counterChanged(param1:com.qb9.gaturro.commons.manager.notificator.Notification) : void
      {
         if(param1.data.toString() == this.type)
         {
            changed();
         }
      }
      
      override public function setData(param1:*) : void
      {
         this.comparer = !!param1.comparer ? String(param1.comparer) : this.comparer;
         this.amount = param1.amount;
         this.type = param1.type;
         this.name = param1.name;
         if(this.counterManager)
         {
            this.setupCounter();
         }
      }
      
      private function onInstanceAdded(param1:ContextEvent) : void
      {
         if(param1.instanceType == GaturroCounterManager)
         {
            this.setupCounterManager();
            Context.instance.removeEventListener(ContextEvent.ADDED,this.onInstanceAdded);
         }
         if(param1.instanceType == NotificationManager && !weak)
         {
            this.setupNotificationManager();
            Context.instance.removeEventListener(ContextEvent.ADDED,this.onInstanceAdded);
         }
      }
      
      private function setupCounterManager() : void
      {
         this.counterManager = Context.instance.getByType(GaturroCounterManager) as GaturroCounterManager;
         if(this.type)
         {
            this.setupCounter();
         }
      }
      
      private function setupCounter() : void
      {
         this.counterManager.start(this.name,this.type);
      }
      
      private function setup() : void
      {
         if(Context.instance.hasByType(GaturroCounterManager))
         {
            this.setupCounterManager();
         }
         else if(!weak)
         {
            Context.instance.addEventListener(ContextEvent.ADDED,this.onInstanceAdded);
         }
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
         Context.instance.removeEventListener(ContextEvent.ADDED,this.onInstanceAdded);
         if(!weak)
         {
            this.notificationManager.unobserve(GaturroNotificationType.COUNTER_CHANGED,this.counterChanged);
         }
      }
   }
}

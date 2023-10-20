package com.qb9.gaturro.constraint
{
   import com.qb9.gaturro.commons.constraint.AbstractConstraint;
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.event.ContextEvent;
   import com.qb9.gaturro.commons.manager.notificator.Notification;
   import com.qb9.gaturro.commons.manager.notificator.NotificationManager;
   import com.qb9.gaturro.globals.server;
   import com.qb9.gaturro.notifier.GaturroNotificationType;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class StartDateConstraint extends AbstractConstraint
   {
       
      
      private var timeOutId:uint;
      
      private var notificatorManager:NotificationManager;
      
      private var date:Date;
      
      public function StartDateConstraint(param1:Boolean)
      {
         super(param1);
         this.setup();
      }
      
      private function onEndTimeout() : void
      {
         clearTimeout(this.timeOutId);
         changed();
      }
      
      override public function accomplish(param1:* = null) : Boolean
      {
         if(!server || !server.serverTimeReady)
         {
            return false;
         }
         var _loc2_:* = server.time > this.date.getTime();
         return doInvert(_loc2_);
      }
      
      private function onManagerAdded(param1:ContextEvent) : void
      {
         if(param1.instanceType == NotificationManager)
         {
            this.listenNotification();
            Context.instance.removeEventListener(ContextEvent.ADDED,this.onManagerAdded);
         }
      }
      
      private function onChanged(param1:com.qb9.gaturro.commons.manager.notificator.Notification) : void
      {
         changed();
      }
      
      private function listenNotification() : void
      {
         this.notificatorManager = Context.instance.getByType(NotificationManager) as NotificationManager;
         this.notificatorManager.observe(GaturroNotificationType.SETTED_SERVER_TIME,this.onChanged);
      }
      
      override public function setData(param1:*) : void
      {
         var _loc2_:String = String(param1.date);
         this.date = new Date(Date.parse(_loc2_));
         var _loc3_:Boolean = server != null && Boolean(server.serverTimeReady);
         if(_loc3_)
         {
            this.setupRemainingTime();
         }
      }
      
      private function setup() : void
      {
         if(!weak)
         {
            if(Context.instance.hasByType(NotificationManager))
            {
               this.listenNotification();
            }
            else
            {
               Context.instance.addEventListener(ContextEvent.ADDED,this.onManagerAdded);
            }
         }
      }
      
      private function setupRemainingTime() : void
      {
         var _loc1_:Number = NaN;
         clearTimeout(this.timeOutId);
         if(!this.accomplish())
         {
            _loc1_ = this.date.getTime() - server.time;
            if(_loc1_ <= 0 || isNaN(_loc1_))
            {
               trace("StartDateConstraint > setupRemainingTime > server.time: " + server.time);
               throw new Error("Couldn\'t be negative time. Providing = " + this.date + " // Server = " + new Date(server.time));
            }
            this.timeOutId = setTimeout(this.onEndTimeout,_loc1_);
         }
      }
      
      override public function dispose() : void
      {
         clearTimeout(this.timeOutId);
         if(this.notificatorManager)
         {
            this.notificatorManager.unobserve(GaturroNotificationType.SETTED_SERVER_TIME,this.onChanged);
         }
         Context.instance.removeEventListener(ContextEvent.ADDED,this.onManagerAdded);
         super.dispose();
      }
   }
}

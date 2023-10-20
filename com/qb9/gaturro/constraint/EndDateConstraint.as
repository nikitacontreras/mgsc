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
   
   public class EndDateConstraint extends AbstractConstraint
   {
       
      
      private var timeOutId:uint;
      
      private var notificatorManager:NotificationManager;
      
      private var date:Date;
      
      public function EndDateConstraint(param1:Boolean)
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
         var _loc2_:* = server.time < this.date.getTime();
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
         this.setupRemainingTime();
         changed();
      }
      
      private function listenNotification() : void
      {
         if(!weak)
         {
            this.notificatorManager = Context.instance.getByType(NotificationManager) as NotificationManager;
            this.notificatorManager.observe(GaturroNotificationType.SETTED_SERVER_TIME,this.onChanged);
         }
      }
      
      override public function setData(param1:*) : void
      {
         var _loc2_:String = String(param1.date);
         this.date = new Date(Date.parse(_loc2_));
         if(server != null && Boolean(server.serverTimeReady))
         {
            this.setupRemainingTime();
         }
      }
      
      private function setup() : void
      {
         if(Context.instance.hasByType(NotificationManager))
         {
            this.listenNotification();
         }
         else if(!weak)
         {
            Context.instance.addEventListener(ContextEvent.ADDED,this.onManagerAdded);
         }
      }
      
      private function setupRemainingTime() : void
      {
         clearTimeout(this.timeOutId);
         var _loc1_:Number = this.date.getTime() - server.time;
         if(_loc1_ > 0)
         {
            this.timeOutId = setTimeout(this.onEndTimeout,_loc1_);
         }
      }
      
      override public function dispose() : void
      {
         if(!weak)
         {
            this.notificatorManager.unobserve(GaturroNotificationType.SETTED_SERVER_TIME,this.onChanged);
         }
         clearTimeout(this.timeOutId);
         Context.instance.removeEventListener(ContextEvent.ADDED,this.onManagerAdded);
         super.dispose();
      }
   }
}

package com.qb9.gaturro.view.world
{
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.net.mail.GaturroMailer;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.reports.InfoReportQueue;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class BackstageRoomView extends GaturroRoomView
   {
       
      
      private var userTimer:Timer;
      
      private var timeCount:int = 0;
      
      private var userStatus:String;
      
      public function BackstageRoomView(param1:GaturroRoom, param2:InfoReportQueue, param3:GaturroMailer, param4:WhiteListNode)
      {
         super(param1,param2,param3,param4);
      }
      
      override protected function finalInit() : void
      {
         super.finalInit();
         if(this.userStatus == "finalizado")
         {
            this.userTimer = new Timer(1000);
            this.userTimer.addEventListener(TimerEvent.TIMER,this.onUserTimer);
            this.userTimer.start();
         }
      }
      
      private function onUserTimer(param1:TimerEvent) : void
      {
         ++this.timeCount;
         if(this.timeCount >= 120)
         {
            this.userTimer.stop();
            this.userTimer.removeEventListener(TimerEvent.TIMER,this.onUserTimer);
            this.userTimer = null;
            api.setSession("escenarioVipStatus","publico");
         }
      }
      
      override protected function whenReady() : void
      {
         super.whenReady();
         this.userStatus = api.getSession("escenarioVipStatus") as String;
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}

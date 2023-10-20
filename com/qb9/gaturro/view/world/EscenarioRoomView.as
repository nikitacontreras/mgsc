package com.qb9.gaturro.view.world
{
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.net.mail.GaturroMailer;
   import com.qb9.gaturro.view.gui.actions.CelebrateButton;
   import com.qb9.gaturro.view.gui.actions.PhotoButton;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.reports.InfoReportQueue;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import flash.display.DisplayObject;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   
   public class EscenarioRoomView extends GaturroRoomView
   {
       
      
      private var timeCount:int = 0;
      
      private var photoButton:PhotoButton;
      
      private var userStatus:String;
      
      private var celebrateButton:CelebrateButton;
      
      private var userTimer:Timer;
      
      public function EscenarioRoomView(param1:GaturroRoom, param2:InfoReportQueue, param3:GaturroMailer, param4:WhiteListNode)
      {
         super(param1,param2,param3,param4);
      }
      
      override protected function finalInit() : void
      {
         super.finalInit();
         if(this.userStatus != "playing")
         {
            this.celebrateButton = new CelebrateButton(gRoom,room.userAvatar);
            gui.dance_ph.addChild(this.celebrateButton);
         }
         if(this.userStatus == "playing")
         {
            api.showModal("TIENES 3 MINUTOS PARA LUCIRTE FRENTE AL PÚBLICO","information");
            this.userTimer = new Timer(1000);
            this.userTimer.addEventListener(TimerEvent.TIMER,this.onUserTimer);
            this.userTimer.start();
            api.trackEvent("ESCENARIO:EMPIEZA",api.user.username);
         }
      }
      
      override protected function whenReady() : void
      {
         super.whenReady();
         this.setTodayFeature();
         this.userStatus = api.getSession("escenarioVipStatus") as String;
      }
      
      private function setTodayFeature() : void
      {
         var _loc2_:Date = null;
         var _loc1_:Object = api.getSession("escenarioVip");
         if(!_loc1_)
         {
            _loc2_ = new Date(api.serverTime);
            api.setSession("escenarioVip","kpop");
            _loc1_ = "kpop";
         }
         switch(_loc1_)
         {
            case "teatro":
            case "payasos":
            case "standUp":
         }
      }
      
      private function onUserTimer(param1:TimerEvent) : void
      {
         ++this.timeCount;
         if(this.timeCount >= 180)
         {
            this.userTimer.stop();
            this.userTimer.removeEventListener(TimerEvent.TIMER,this.onUserTimer);
            api.showModal("SE ACABÓ TU TIEMPO","information");
            setTimeout(this.finishPerformance,1500);
            this.userTimer = null;
            api.trackEvent("ESCENARIO:TERMINA",api.user.username);
         }
      }
      
      private function finishPerformance() : void
      {
         api.setSession("escenarioVipStatus","finalizado");
         api.changeRoomXY(51688699,12,12);
      }
      
      override protected function createOtherSceneObject(param1:RoomSceneObject) : DisplayObject
      {
         return super.createOtherSceneObject(param1);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(this.userTimer)
         {
            this.userTimer.stop();
            this.userTimer.removeEventListener(TimerEvent.TIMER,this.onUserTimer);
            this.userTimer = null;
         }
      }
   }
}

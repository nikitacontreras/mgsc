package com.qb9.gaturro.view.world
{
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.event.ContextEvent;
   import com.qb9.gaturro.commons.manager.notificator.Notification;
   import com.qb9.gaturro.commons.manager.notificator.NotificationManager;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.manager.board.BoardTournamentManager;
   import com.qb9.gaturro.manager.board.TournamentData;
   import com.qb9.gaturro.manager.counter.GaturroCounterManager;
   import com.qb9.gaturro.notifier.GaturroNotificationType;
   import com.qb9.gaturro.service.torneo.EliminatoriaRoomUtil;
   import com.qb9.gaturro.view.components.banner.boca.BocaPenales;
   import com.qb9.gaturro.view.world.elements.NpcRoomSceneObjectView;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.reports.InfoReportQueue;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import com.qb9.mambo.net.mail.Mailer;
   import com.qb9.mambo.world.avatars.Avatar;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   
   public class TorneoRoomView extends GaturroRoomView
   {
      
      public static const TOURNAMENT_PRIZE_TAKEN:String = "tournamentPrizeTaken";
      
      public static const USER_LEADERBOARD_ATTR:String = "leaderBoardPenales";
       
      
      private var notificationManager:NotificationManager;
      
      private var counterManager:GaturroCounterManager;
      
      private var _leaderboardAnterior:MovieClip;
      
      private var _eliminatoriaRoomUtil:EliminatoriaRoomUtil;
      
      private var _npcLeaderBoard:NpcRoomSceneObjectView;
      
      private var boardManager:BoardTournamentManager;
      
      private var _ranking:Array;
      
      private var _leaderboard:MovieClip;
      
      public function TorneoRoomView(param1:GaturroRoom, param2:TaskContainer, param3:InfoReportQueue, param4:Mailer, param5:WhiteListNode)
      {
         super(param1,param3,param4,param5);
         this.boardManager = new BoardTournamentManager();
      }
      
      private function readingNPCsData() : void
      {
      }
      
      private function giveCopita(param1:int) : void
      {
         api.setProfileAttribute(TorneoRoomView.TOURNAMENT_PRIZE_TAKEN,true);
         api.giveUser("torneo2017/props.copa" + param1,1);
      }
      
      private function setupNotificationManager() : void
      {
         this.notificationManager = Context.instance.getByType(NotificationManager) as NotificationManager;
         this.notificationManager.observe(GaturroNotificationType.COUNTER_CHANGED,this.onWinChange);
      }
      
      private function checkUserWeek() : void
      {
         var _loc1_:Date = new Date();
         var _loc2_:int = this.counterManager.getAmount(BocaPenales.USER_ATTR_PENALES);
         var _loc3_:int = api.getProfileAttribute(TorneoRoomView.USER_LEADERBOARD_ATTR) as int;
         var _loc4_:int = _loc1_.day;
         if(_loc3_ != _loc4_)
         {
            this.counterManager.reset(BocaPenales.USER_ATTR_PENALES);
            api.setProfileAttribute(TorneoRoomView.USER_LEADERBOARD_ATTR,_loc4_);
         }
      }
      
      private function setupView() : void
      {
         this.buildRanking();
         this.boardManager.updateCallback = this.onRankingChanged;
         if(this.boardManager.hasWinners())
         {
         }
         this.checkIfImWinner();
         this.buildRankingLastWeek();
      }
      
      private function trySetupNotification() : void
      {
         if(Context.instance.hasByType(NotificationManager))
         {
            this.setupNotificationManager();
         }
         else
         {
            Context.instance.addEventListener(ContextEvent.ADDED,this.onManagerAdded);
         }
      }
      
      private function onManagerAdded(param1:ContextEvent) : void
      {
         if(param1.instanceType == NotificationManager)
         {
            this.setupNotificationManager();
            Context.instance.removeEventListener(ContextEvent.ADDED,this.onManagerAdded);
         }
      }
      
      private function displayRanking() : void
      {
         var _loc2_:TournamentData = null;
         var _loc1_:int = 0;
         while(_loc1_ < 10)
         {
            _loc2_ = this._ranking[_loc1_];
            this._leaderboard["ranking_" + _loc1_].rankText.text = _loc2_.user;
            this._leaderboard["ranking_" + _loc1_].rankPoint.text = _loc2_.point;
            _loc1_++;
         }
      }
      
      override protected function createOtherSceneObject(param1:RoomSceneObject) : DisplayObject
      {
         var _loc2_:DisplayObject = super.createOtherSceneObject(param1);
         if(_loc2_ is NpcRoomSceneObjectView)
         {
            this.captureNPC(_loc2_ as NpcRoomSceneObjectView);
         }
         return _loc2_;
      }
      
      private function onWinChange(param1:com.qb9.gaturro.commons.manager.notificator.Notification) : void
      {
         var _loc2_:int = 0;
         if(BocaPenales.USER_ATTR_PENALES == param1.data)
         {
            _loc2_ = this.counterManager.getAmount(param1.data as String);
            this.boardManager.processPoint(_loc2_);
            this.buildRanking();
         }
      }
      
      private function onRankingChanged(param1:Array) : void
      {
         this._leaderboard = background["layer2"]["leaderboard"];
         this._ranking = param1;
         this.displayRanking();
      }
      
      override protected function finalInit() : void
      {
         super.finalInit();
         this._eliminatoriaRoomUtil = new EliminatoriaRoomUtil();
         this.trySetupNotification();
         this.setupCounter();
         this.checkUserWeek();
         this.setupView();
      }
      
      private function buildRanking() : void
      {
         this._leaderboard = background["layer2"]["leaderboard"];
         this._ranking = this.boardManager.getRanking();
         this.displayRanking();
      }
      
      public function forceCleanRank() : void
      {
         this.boardManager.forceClean();
      }
      
      private function checkIfImWinner() : void
      {
         var _loc1_:int = this.boardManager.AmIWinner();
         if(_loc1_ != -1)
         {
            if(!api.getProfileAttribute(TorneoRoomView.TOURNAMENT_PRIZE_TAKEN) as Boolean)
            {
               this.giveCopita(_loc1_);
               api.instantiateBannerModal("BocaTorneoInscripcion");
            }
            api.setSession("posicionTorneo",_loc1_);
         }
      }
      
      private function buildRankingLastWeek() : void
      {
         var _loc3_:TournamentData = null;
         this._leaderboardAnterior = background["layer2"]["leaderboardAnterior"];
         var _loc1_:Array = this.boardManager.getWinnerList();
         var _loc2_:int = 0;
         while(_loc2_ < 3)
         {
            _loc3_ = _loc1_[_loc2_];
            this._leaderboardAnterior["ranking_" + _loc2_].rankText.text = _loc3_.user;
            this._leaderboardAnterior["ranking_" + _loc2_].rankPoint.text = _loc3_.point;
            _loc2_++;
         }
      }
      
      override protected function createAvatar(param1:Avatar) : DisplayObject
      {
         return super.createAvatar(param1);
      }
      
      private function captureNPC(param1:NpcRoomSceneObjectView) : void
      {
         if(param1.object.name.indexOf("torneo2017/props.partidoHolder_so") != -1)
         {
            this.boardManager.setTarget(param1.object);
         }
      }
      
      private function onAddedCounter(param1:ContextEvent) : void
      {
         if(param1.instanceType == GaturroCounterManager)
         {
            Context.instance.removeEventListener(ContextEvent.ADDED,this.onAddedCounter);
            this.counterManager = Context.instance.getByType(GaturroCounterManager) as GaturroCounterManager;
         }
      }
      
      private function setupCounter() : void
      {
         if(Context.instance.hasByType(GaturroCounterManager))
         {
            this.counterManager = Context.instance.getByType(GaturroCounterManager) as GaturroCounterManager;
         }
         else
         {
            Context.instance.addEventListener(ContextEvent.ADDED,this.onAddedCounter);
         }
      }
   }
}

package com.qb9.gaturro.view.world
{
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.gaturro.commons.iterator.IIterator;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.manager.cinema.CinemaManager;
   import com.qb9.gaturro.manager.team.Team;
   import com.qb9.gaturro.manager.team.TeamDefinition;
   import com.qb9.gaturro.manager.team.TeamManager;
   import com.qb9.gaturro.model.config.cinema.CinemaMovieDefinition;
   import com.qb9.gaturro.service.pocket.PocketServiceManager;
   import com.qb9.gaturro.user.settings.UserSettings;
   import com.qb9.gaturro.user.settings.UserSettingsEvent;
   import com.qb9.gaturro.view.world.avatars.Gaturro;
   import com.qb9.gaturro.view.world.elements.HolderRoomSceneObjectView;
   import com.qb9.gaturro.view.world.elements.NpcRoomSceneObjectView;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.reports.InfoReportQueue;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import com.qb9.mambo.net.mail.Mailer;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import fl.video.FLVPlayback;
   import fl.video.VideoEvent;
   import fl.video.VideoState;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class ConvencionGatuberRoomView extends GaturroRoomView
   {
       
      
      private var layer2:MovieClip;
      
      private var currentVideo:CinemaMovieDefinition;
      
      private var teamManager:TeamManager;
      
      private var randomVideoID:uint;
      
      private var _tagVideos:String = "NEW_GATUBERS";
      
      private var flvPlayback:FLVPlayback;
      
      private var _playTimeOut:uint;
      
      private const INTEGRA_VIDEO_OFFSET:uint = 9;
      
      private var cinemaTimeoutID:uint;
      
      private var cineManager:CinemaManager;
      
      private const TOTAL_VIDEOS:uint = 4;
      
      private var _allVideos:Object;
      
      private var videoWall:NpcRoomSceneObjectView;
      
      private var connection_error:Boolean = false;
      
      private var _currentVideoIndex:int = 0;
      
      private var _videoRequest:PocketServiceManager;
      
      private var scoreWall:MovieClip;
      
      public function ConvencionGatuberRoomView(param1:GaturroRoom, param2:TaskContainer, param3:InfoReportQueue, param4:Mailer, param5:WhiteListNode)
      {
         var room:GaturroRoom = param1;
         var tasks:TaskContainer = param2;
         var reports:InfoReportQueue = param3;
         var mailer:Mailer = param4;
         var iphoneWhitelist:WhiteListNode = param5;
         super(room,reports,mailer,iphoneWhitelist);
         FLVPlayback.prototype.myPlay = function(param1:Object = null):void
         {
            if(Boolean(param1) || this.state != VideoState.CONNECTION_ERROR)
            {
               trace("CROTOTYPE");
               this.playWhenEnoughDownloaded();
               connection_error = false;
            }
            else
            {
               trace("CONNECTION_ERROR");
               connection_error = true;
            }
         };
      }
      
      private function onSettingChanged(param1:UserSettingsEvent) : void
      {
         if(param1.data.key == UserSettings.MUSIC_KEY || param1.data.key == UserSettings.SOUND_LEVEL)
         {
            this.flvPlayback.volume = !!api.userSettings.getValue(UserSettings.MUSIC_KEY) ? 1 * api.userSettings.getValue(UserSettings.SOUND_LEVEL) / 100 : 0;
         }
      }
      
      private function onLikeVideo(param1:MouseEvent) : void
      {
      }
      
      private function setupControlRemote() : void
      {
         this.scoreWall.menuSelector.remoteControl.gatuberName.text = this._allVideos[this._currentVideoIndex].title;
         (this.scoreWall.menuSelector.remoteControl.backButton as MovieClip).addEventListener(MouseEvent.CLICK,this.onBack);
         (this.scoreWall.menuSelector.remoteControl.nextButton as MovieClip).addEventListener(MouseEvent.CLICK,this.onNext);
      }
      
      private function refreshAllPlayButtons() : void
      {
      }
      
      private function onPlayVideo(param1:MouseEvent) : void
      {
      }
      
      private function setCurrentVideo() : void
      {
      }
      
      private function onCertainPoints(param1:Team) : void
      {
      }
      
      private function completedRequestVideo(param1:Event) : void
      {
         this._allVideos = this._videoRequest.requestedData;
         this._currentVideoIndex = this.randomInt(this._allVideos.length - 1);
         this.setupControlRemote();
         this.playVideo();
      }
      
      override public function freeze() : void
      {
      }
      
      override public function dispose() : void
      {
         if(this.teamManager)
         {
            this.disposeButtons();
         }
         clearTimeout(this._playTimeOut);
         if(!this.connection_error)
         {
            this.flvPlayback.stop();
         }
         this.flvPlayback.removeEventListener(VideoEvent.STATE_CHANGE,this.onStateChanged);
         this.flvPlayback.removeEventListener(VideoEvent.COMPLETE,this.onVideoCompleted);
         this.flvPlayback = null;
         super.dispose();
      }
      
      private function onGuiIconClick(param1:MouseEvent) : void
      {
         if(this.scoreWall.currentLabel == "closed")
         {
            this.scoreWall.gotoAndPlay("opens");
         }
         else
         {
            this.scoreWall.gotoAndPlay("closes");
         }
      }
      
      private function setupHideButtons() : void
      {
         this.scoreWall.guiIcon.addEventListener(MouseEvent.CLICK,this.onGuiIconClick);
      }
      
      private function randomInt(param1:int, param2:int = 0) : int
      {
         return int(param2 + Math.random() * param1);
      }
      
      override protected function finalInit() : void
      {
         super.finalInit();
         this.layer2 = (background as MovieClip).layer2;
         this.scoreWall = this.layer2.scoreWall;
         api.setAvatarAttribute(Gaturro.TRANSPORT_KEY,"");
         this._videoRequest = new PocketServiceManager();
         this._videoRequest.buildRequest("POST","http://service.mundogaturro.com/?r=service/media/&t=" + this._tagVideos);
         this._videoRequest.addEventListener(Event.COMPLETE,this.completedRequestVideo);
      }
      
      private function playVideo() : void
      {
         if(this.connection_error)
         {
            return;
         }
         if(Boolean(this.flvPlayback) && (this.layer2.videoWallPh as MovieClip).getChildAt(0) == this.flvPlayback)
         {
            (this.layer2.videoWallPh as MovieClip).removeChild(this.flvPlayback);
            this.flvPlayback.stop();
            this.flvPlayback.volume = 0;
            this.flvPlayback.removeEventListener(VideoEvent.STATE_CHANGE,this.onStateChanged);
            this.flvPlayback.removeEventListener(VideoEvent.COMPLETE,this.onVideoCompleted);
         }
         this.flvPlayback = new FLVPlayback();
         this.flvPlayback.bufferTime = 3;
         this.flvPlayback.volume = !!api.userSettings.getValue(UserSettings.MUSIC_KEY) ? 1 * api.userSettings.getValue(UserSettings.SOUND_LEVEL) / 100 : 0;
         api.userSettings.addEventListener(UserSettingsEvent.SETTING_CHANGED,this.onSettingChanged);
         this.layer2.videoWallPh.addChild(this.flvPlayback);
         this.flvPlayback.addEventListener(VideoEvent.STATE_CHANGE,this.onStateChanged);
         this.flvPlayback.addEventListener(VideoEvent.COMPLETE,this.onVideoCompleted);
         this.flvPlayback.source = this._allVideos[this._currentVideoIndex].path;
         this.flvPlayback.visible = false;
         setTimeout(this.playVideoOnTime,1000);
      }
      
      private function onHideClick(param1:MouseEvent) : void
      {
         this.scoreWall.gotoAndPlay("closes");
      }
      
      private function onVideoCompleted(param1:VideoEvent) : void
      {
         this.onNext(null);
      }
      
      override protected function createOtherSceneObject(param1:RoomSceneObject) : DisplayObject
      {
         var _loc3_:NpcRoomSceneObjectView = null;
         var _loc4_:String = null;
         var _loc2_:DisplayObject = super.createOtherSceneObject(param1);
         if(_loc2_ is NpcRoomSceneObjectView)
         {
            _loc3_ = _loc2_ as NpcRoomSceneObjectView;
            _loc4_ = _loc3_.object.name;
            _loc2_.scaleY = 0.6;
            _loc2_.scaleX = 0.6;
         }
         else if(_loc2_ is HolderRoomSceneObjectView)
         {
         }
         return _loc2_;
      }
      
      private function onStateChanged(param1:VideoEvent) : void
      {
         trace("---------->     CinemaBanner > onStateChanged > e.state = [" + param1.state + "]");
         this.flvPlayback.visible = param1.state == VideoState.PLAYING;
      }
      
      private function playVideoOnTime() : void
      {
         if(api && api.room.id == this.room.id && Boolean(this.flvPlayback))
         {
            Object(this.flvPlayback).myPlay();
         }
      }
      
      private function onBack(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         clearTimeout(this._playTimeOut);
         --this._currentVideoIndex;
         if(this._currentVideoIndex < 0)
         {
            this._currentVideoIndex = this._allVideos.length - 1;
         }
         this.scoreWall.menuSelector.remoteControl.gatuberName.text = this._allVideos[this._currentVideoIndex].title;
         setTimeout(function():void
         {
            playVideo();
         },2000);
      }
      
      override public function unfreeze() : void
      {
      }
      
      private function onNext(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         clearTimeout(this._playTimeOut);
         ++this._currentVideoIndex;
         if(this._currentVideoIndex >= this._allVideos.length)
         {
            this._currentVideoIndex = 0;
         }
         this.scoreWall.menuSelector.remoteControl.gatuberName.text = this._allVideos[this._currentVideoIndex].title;
         this._playTimeOut = setTimeout(function():void
         {
            playVideo();
         },2000);
      }
      
      private function disposeButtons() : void
      {
         var _loc2_:TeamDefinition = null;
         var _loc1_:IIterator = this.teamManager.getTeamList("videos");
         while(_loc1_.next())
         {
            _loc2_ = _loc1_.current();
            this.scoreWall[_loc2_.name].playButton.removeEventListener(MouseEvent.CLICK,this.onPlayVideo);
            this.scoreWall[_loc2_.name].likeButton.removeEventListener(MouseEvent.CLICK,this.onLikeVideo);
         }
      }
      
      private function setupScoreWall() : void
      {
      }
   }
}

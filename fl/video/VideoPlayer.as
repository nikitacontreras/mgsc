package fl.video
{
   import flash.events.*;
   import flash.geom.Rectangle;
   import flash.media.*;
   import flash.net.*;
   import flash.utils.*;
   
   public class VideoPlayer extends Video
   {
      
      public static const VERSION:String = "2.1.0.23";
      
      public static const SHORT_VERSION:String = "2.1";
      
      flvplayback_internal static var BUFFER_EMPTY:String = "bufferEmpty";
      
      flvplayback_internal static var BUFFER_FULL:String = "bufferFull";
      
      flvplayback_internal static var BUFFER_FLUSH:String = "bufferFlush";
      
      public static var iNCManagerClass:Object = "fl.video.NCManager";
      
      public static var netStreamClientClass:Object = VideoPlayerClient;
      
      public static const DEFAULT_UPDATE_TIME_INTERVAL:Number = 250;
      
      public static const DEFAULT_UPDATE_PROGRESS_INTERVAL:Number = 250;
      
      public static const DEFAULT_IDLE_TIMEOUT_INTERVAL:Number = 300000;
      
      flvplayback_internal static const AUTO_RESIZE_INTERVAL:Number = 100;
      
      flvplayback_internal static const DEFAULT_AUTO_RESIZE_PLAYHEAD_TIMEOUT:Number = 0.5;
      
      flvplayback_internal static const DEFAULT_AUTO_RESIZE_METADATA_DELAY_MAX:Number = 5;
      
      flvplayback_internal static const FINISH_AUTO_RESIZE_INTERVAL:Number = 250;
      
      flvplayback_internal static const RTMP_DO_STOP_AT_END_INTERVAL:Number = 500;
      
      flvplayback_internal static const RTMP_DO_SEEK_INTERVAL:Number = 100;
      
      flvplayback_internal static const HTTP_DO_SEEK_INTERVAL:Number = 250;
      
      flvplayback_internal static const DEFAULT_HTTP_DO_SEEK_MAX_COUNT:Number = 4;
      
      flvplayback_internal static const HTTP_DELAYED_BUFFERING_INTERVAL:Number = 100;
      
      flvplayback_internal static const DEFAULT_LAST_UPDATE_TIME_STUCK_COUNT_MAX:int = 10;
       
      
      protected var _state:String;
      
      flvplayback_internal var _cachedState:String;
      
      flvplayback_internal var _bufferState:String;
      
      flvplayback_internal var _sawPlayStop:Boolean;
      
      flvplayback_internal var _cachedPlayheadTime:Number;
      
      protected var _metadata:Object;
      
      protected var _registrationX:Number;
      
      protected var _registrationY:Number;
      
      protected var _registrationWidth:Number;
      
      protected var _registrationHeight:Number;
      
      flvplayback_internal var _startingPlay:Boolean;
      
      flvplayback_internal var _lastSeekTime:Number;
      
      flvplayback_internal var _invalidSeekTime:Boolean;
      
      flvplayback_internal var _invalidSeekRecovery:Boolean;
      
      flvplayback_internal var _readyDispatched:Boolean;
      
      flvplayback_internal var _autoResizeDone:Boolean;
      
      flvplayback_internal var _lastUpdateTime:Number;
      
      flvplayback_internal var lastUpdateTimeStuckCount:Number;
      
      flvplayback_internal var _sawSeekNotify:Boolean;
      
      protected var _ncMgr:fl.video.INCManager;
      
      protected var _ns:NetStream;
      
      flvplayback_internal var _currentPos:Number;
      
      flvplayback_internal var _atEnd:Boolean;
      
      flvplayback_internal var _atEndCheckPlayhead:Number;
      
      protected var _streamLength:Number;
      
      protected var _align:String;
      
      protected var _scaleMode:String;
      
      protected var _autoPlay:Boolean;
      
      protected var _autoRewind:Boolean;
      
      protected var _contentPath:String;
      
      protected var _bufferTime:Number;
      
      protected var _isLive:Boolean;
      
      protected var _volume:Number;
      
      protected var _soundTransform:SoundTransform;
      
      protected var __visible:Boolean;
      
      flvplayback_internal var _hiddenForResize:Boolean;
      
      flvplayback_internal var _hiddenForResizeMetadataDelay:Number;
      
      flvplayback_internal var _resizeImmediatelyOnMetadata:Boolean;
      
      flvplayback_internal var _hiddenRewindPlayheadTime:Number;
      
      protected var _videoWidth:int;
      
      protected var _videoHeight:int;
      
      flvplayback_internal var _prevVideoWidth:int;
      
      flvplayback_internal var _prevVideoHeight:int;
      
      flvplayback_internal var oldBounds:Rectangle;
      
      flvplayback_internal var oldRegistrationBounds:Rectangle;
      
      flvplayback_internal var _updateTimeTimer:Timer;
      
      flvplayback_internal var _updateProgressTimer:Timer;
      
      flvplayback_internal var _idleTimeoutTimer:Timer;
      
      flvplayback_internal var _autoResizeTimer:Timer;
      
      flvplayback_internal var _rtmpDoStopAtEndTimer:Timer;
      
      flvplayback_internal var _rtmpDoSeekTimer:Timer;
      
      flvplayback_internal var _httpDoSeekTimer:Timer;
      
      flvplayback_internal var _httpDoSeekCount:Number;
      
      flvplayback_internal var _finishAutoResizeTimer:Timer;
      
      flvplayback_internal var _delayedBufferingTimer:Timer;
      
      flvplayback_internal var waitingForEnough:Boolean;
      
      flvplayback_internal var baselineProgressTime:Number;
      
      flvplayback_internal var startProgressTime:Number;
      
      flvplayback_internal var totalDownloadTime:Number;
      
      flvplayback_internal var totalProgressTime:Number;
      
      flvplayback_internal var autoResizePlayheadTimeout:Number = 0.5;
      
      flvplayback_internal var autoResizeMetadataDelayMax:Number = 5;
      
      flvplayback_internal var httpDoSeekMaxCount:Number = 4;
      
      flvplayback_internal var lastUpdateTimeStuckCountMax:int = 10;
      
      flvplayback_internal var _cmdQueue:Array;
      
      public function VideoPlayer(param1:int = 320, param2:int = 240)
      {
         super(param1,param2);
         this._registrationX = x;
         this._registrationY = y;
         this._registrationWidth = param1;
         this._registrationHeight = param2;
         this._state = VideoState.DISCONNECTED;
         this.flvplayback_internal::_cachedState = this._state;
         this.flvplayback_internal::_bufferState = flvplayback_internal::BUFFER_EMPTY;
         this.flvplayback_internal::_sawPlayStop = false;
         this.flvplayback_internal::_cachedPlayheadTime = 0;
         this._metadata = null;
         this.flvplayback_internal::_startingPlay = false;
         this.flvplayback_internal::_invalidSeekTime = false;
         this.flvplayback_internal::_invalidSeekRecovery = false;
         this.flvplayback_internal::_currentPos = 0;
         this.flvplayback_internal::_atEnd = false;
         this._streamLength = 0;
         this.flvplayback_internal::_cmdQueue = new Array();
         this.flvplayback_internal::_readyDispatched = false;
         this.flvplayback_internal::_autoResizeDone = false;
         this.flvplayback_internal::_lastUpdateTime = NaN;
         this.flvplayback_internal::lastUpdateTimeStuckCount = 0;
         this.flvplayback_internal::_sawSeekNotify = false;
         this.flvplayback_internal::_hiddenForResize = false;
         this.flvplayback_internal::_hiddenForResizeMetadataDelay = 0;
         this.flvplayback_internal::_resizeImmediatelyOnMetadata = false;
         this._videoWidth = -1;
         this._videoHeight = -1;
         this.flvplayback_internal::_prevVideoWidth = 0;
         this.flvplayback_internal::_prevVideoHeight = 0;
         this.flvplayback_internal::_updateTimeTimer = new Timer(DEFAULT_UPDATE_TIME_INTERVAL);
         this.flvplayback_internal::_updateTimeTimer.addEventListener(TimerEvent.TIMER,this.flvplayback_internal::doUpdateTime);
         this.flvplayback_internal::_updateProgressTimer = new Timer(DEFAULT_UPDATE_PROGRESS_INTERVAL);
         this.flvplayback_internal::_updateProgressTimer.addEventListener(TimerEvent.TIMER,this.flvplayback_internal::doUpdateProgress);
         this.flvplayback_internal::_idleTimeoutTimer = new Timer(DEFAULT_IDLE_TIMEOUT_INTERVAL,1);
         this.flvplayback_internal::_idleTimeoutTimer.addEventListener(TimerEvent.TIMER,this.flvplayback_internal::doIdleTimeout);
         this.flvplayback_internal::_autoResizeTimer = new Timer(flvplayback_internal::AUTO_RESIZE_INTERVAL);
         this.flvplayback_internal::_autoResizeTimer.addEventListener(TimerEvent.TIMER,this.flvplayback_internal::doAutoResize);
         this.flvplayback_internal::_rtmpDoStopAtEndTimer = new Timer(flvplayback_internal::RTMP_DO_STOP_AT_END_INTERVAL);
         this.flvplayback_internal::_rtmpDoStopAtEndTimer.addEventListener(TimerEvent.TIMER,this.flvplayback_internal::rtmpDoStopAtEnd);
         this.flvplayback_internal::_rtmpDoSeekTimer = new Timer(flvplayback_internal::RTMP_DO_SEEK_INTERVAL);
         this.flvplayback_internal::_rtmpDoSeekTimer.addEventListener(TimerEvent.TIMER,this.flvplayback_internal::rtmpDoSeek);
         this.flvplayback_internal::_httpDoSeekTimer = new Timer(flvplayback_internal::HTTP_DO_SEEK_INTERVAL);
         this.flvplayback_internal::_httpDoSeekTimer.addEventListener(TimerEvent.TIMER,this.flvplayback_internal::httpDoSeek);
         this.flvplayback_internal::_httpDoSeekCount = 0;
         this.flvplayback_internal::_finishAutoResizeTimer = new Timer(flvplayback_internal::FINISH_AUTO_RESIZE_INTERVAL,1);
         this.flvplayback_internal::_finishAutoResizeTimer.addEventListener(TimerEvent.TIMER,this.flvplayback_internal::finishAutoResize);
         this.flvplayback_internal::_delayedBufferingTimer = new Timer(flvplayback_internal::HTTP_DELAYED_BUFFERING_INTERVAL);
         this.flvplayback_internal::_delayedBufferingTimer.addEventListener(TimerEvent.TIMER,this.flvplayback_internal::doDelayedBuffering);
         this._isLive = false;
         this._align = VideoAlign.CENTER;
         this._scaleMode = VideoScaleMode.MAINTAIN_ASPECT_RATIO;
         this._autoPlay = true;
         this._autoRewind = false;
         this._bufferTime = 0.1;
         this._soundTransform = new SoundTransform();
         this._volume = this._soundTransform.volume;
         this.__visible = true;
         this._contentPath = "";
         this.flvplayback_internal::waitingForEnough = false;
         this.flvplayback_internal::baselineProgressTime = NaN;
         this.flvplayback_internal::startProgressTime = NaN;
         this.flvplayback_internal::totalDownloadTime = NaN;
         this.flvplayback_internal::totalProgressTime = NaN;
      }
      
      public function setSize(param1:Number, param2:Number) : void
      {
         super.width = this._registrationWidth = param1;
         super.height = this._registrationHeight = param2;
         switch(this._scaleMode)
         {
            case VideoScaleMode.MAINTAIN_ASPECT_RATIO:
            case VideoScaleMode.NO_SCALE:
               this.flvplayback_internal::startAutoResize();
               break;
            default:
               super.x = this._registrationX;
               super.y = this._registrationY;
         }
      }
      
      public function setScale(param1:Number, param2:Number) : void
      {
         super.scaleX = param1;
         super.scaleY = param2;
         this._registrationWidth = width;
         this._registrationHeight = height;
         switch(this._scaleMode)
         {
            case VideoScaleMode.MAINTAIN_ASPECT_RATIO:
            case VideoScaleMode.NO_SCALE:
               this.flvplayback_internal::startAutoResize();
               break;
            default:
               super.x = this._registrationX;
               super.y = this._registrationY;
         }
      }
      
      public function play(param1:String = null, param2:Number = NaN, param3:Boolean = false) : void
      {
         if(param1 != null)
         {
            if(this._state == VideoState.flvplayback_internal::EXEC_QUEUED_CMD)
            {
               this._state = this.flvplayback_internal::_cachedState;
            }
            else
            {
               if(!this.stateResponsive && this._state != VideoState.DISCONNECTED && this._state != VideoState.CONNECTION_ERROR)
               {
                  this.flvplayback_internal::queueCmd(QueuedCommand.PLAY,param1,param3,param2);
                  return;
               }
               this.flvplayback_internal::execQueuedCmds();
            }
            this._autoPlay = true;
            this.flvplayback_internal::_load(param1,param2,param3);
            return;
         }
         if(!this.flvplayback_internal::isXnOK())
         {
            if(this._state == VideoState.CONNECTION_ERROR || this._ncMgr == null || this._ncMgr.netConnection == null)
            {
               throw new VideoError(VideoError.NO_CONNECTION);
            }
            this.flvplayback_internal::flushQueuedCmds();
            this.flvplayback_internal::queueCmd(QueuedCommand.PLAY);
            this.flvplayback_internal::setState(VideoState.LOADING);
            this.flvplayback_internal::_cachedState = VideoState.LOADING;
            this._ncMgr.reconnect();
            return;
         }
         if(this._state == VideoState.flvplayback_internal::EXEC_QUEUED_CMD)
         {
            this._state = this.flvplayback_internal::_cachedState;
         }
         else
         {
            if(!this.stateResponsive)
            {
               this.flvplayback_internal::queueCmd(QueuedCommand.PLAY);
               return;
            }
            this.flvplayback_internal::execQueuedCmds();
         }
         if(this._ns == null)
         {
            this.flvplayback_internal::_createStream();
         }
         switch(this._state)
         {
            case VideoState.BUFFERING:
               if(this._ncMgr.isRTMP)
               {
                  this.flvplayback_internal::_play(0);
                  if(this.flvplayback_internal::_atEnd)
                  {
                     this.flvplayback_internal::_atEnd = false;
                     this.flvplayback_internal::_currentPos = 0;
                     this.flvplayback_internal::setState(VideoState.REWINDING);
                  }
                  else if(this.flvplayback_internal::_currentPos > 0)
                  {
                     this.flvplayback_internal::_seek(this.flvplayback_internal::_currentPos);
                     this.flvplayback_internal::_currentPos = 0;
                  }
               }
            case VideoState.PLAYING:
               return;
            case VideoState.STOPPED:
               if(this._ncMgr.isRTMP)
               {
                  if(this._isLive)
                  {
                     this.flvplayback_internal::_play(-1);
                     this.flvplayback_internal::setState(VideoState.BUFFERING);
                     break;
                  }
                  this.flvplayback_internal::_play(0);
                  if(this.flvplayback_internal::_atEnd)
                  {
                     this.flvplayback_internal::_atEnd = false;
                     this.flvplayback_internal::_currentPos = 0;
                     this._state = VideoState.BUFFERING;
                     this.flvplayback_internal::setState(VideoState.REWINDING);
                     break;
                  }
                  if(this.flvplayback_internal::_currentPos > 0)
                  {
                     this.flvplayback_internal::_seek(this.flvplayback_internal::_currentPos);
                     this.flvplayback_internal::_currentPos = 0;
                     this.flvplayback_internal::setState(VideoState.BUFFERING);
                     break;
                  }
                  this.flvplayback_internal::setState(VideoState.BUFFERING);
                  break;
               }
               this.flvplayback_internal::_pause(false);
               if(this.flvplayback_internal::_atEnd)
               {
                  this.flvplayback_internal::_atEnd = false;
                  this.flvplayback_internal::_seek(0);
                  this._state = VideoState.BUFFERING;
                  this.flvplayback_internal::setState(VideoState.REWINDING);
                  break;
               }
               if(this.flvplayback_internal::_bufferState == flvplayback_internal::BUFFER_EMPTY)
               {
                  this.flvplayback_internal::setState(VideoState.BUFFERING);
                  break;
               }
               this.flvplayback_internal::setState(VideoState.PLAYING);
               break;
            case VideoState.PAUSED:
               this.flvplayback_internal::_pause(false);
               if(!this._ncMgr.isRTMP)
               {
                  if(this.flvplayback_internal::_bufferState == flvplayback_internal::BUFFER_EMPTY)
                  {
                     this.flvplayback_internal::setState(VideoState.BUFFERING);
                     break;
                  }
                  this.flvplayback_internal::setState(VideoState.PLAYING);
                  break;
               }
               this.flvplayback_internal::setState(VideoState.BUFFERING);
               break;
         }
      }
      
      public function playWhenEnoughDownloaded() : void
      {
         if(this._ncMgr != null && this._ncMgr.isRTMP)
         {
            this.play();
            return;
         }
         if(!this.flvplayback_internal::isXnOK())
         {
            throw new VideoError(VideoError.NO_CONNECTION);
         }
         if(this._state == VideoState.flvplayback_internal::EXEC_QUEUED_CMD)
         {
            this._state = this.flvplayback_internal::_cachedState;
         }
         else
         {
            if(!this.stateResponsive)
            {
               this.flvplayback_internal::queueCmd(QueuedCommand.PLAY_WHEN_ENOUGH);
               return;
            }
            this.flvplayback_internal::execQueuedCmds();
         }
         this.flvplayback_internal::waitingForEnough = true;
         this.flvplayback_internal::checkReadyForPlay(this.bytesLoaded,this.bytesTotal);
      }
      
      public function load(param1:String, param2:Number = NaN, param3:Boolean = false) : void
      {
         if(param1 == null)
         {
            throw new VideoError(VideoError.NULL_URL_LOAD);
         }
         if(this._state == VideoState.flvplayback_internal::EXEC_QUEUED_CMD)
         {
            this._state = this.flvplayback_internal::_cachedState;
         }
         else
         {
            if(!this.stateResponsive && this._state != VideoState.DISCONNECTED && this._state != VideoState.CONNECTION_ERROR)
            {
               this.flvplayback_internal::queueCmd(QueuedCommand.LOAD,param1,param3,param2);
               return;
            }
            this.flvplayback_internal::execQueuedCmds();
         }
         this._autoPlay = false;
         this.flvplayback_internal::_load(param1,param2,param3);
      }
      
      flvplayback_internal function _load(param1:String, param2:Number, param3:Boolean) : void
      {
         this.flvplayback_internal::_prevVideoWidth = super.videoWidth;
         this.flvplayback_internal::_prevVideoHeight = super.videoHeight;
         this.flvplayback_internal::_autoResizeDone = false;
         this.flvplayback_internal::_cachedPlayheadTime = 0;
         this.flvplayback_internal::_bufferState = flvplayback_internal::BUFFER_EMPTY;
         this.flvplayback_internal::_sawPlayStop = false;
         this._metadata = null;
         this.flvplayback_internal::_startingPlay = false;
         this.flvplayback_internal::_invalidSeekTime = false;
         this.flvplayback_internal::_invalidSeekRecovery = false;
         this._isLive = param3;
         this._contentPath = param1;
         this.flvplayback_internal::_currentPos = 0;
         this._streamLength = isNaN(param2) || param2 <= 0 ? NaN : param2;
         this.flvplayback_internal::_atEnd = false;
         this.flvplayback_internal::_readyDispatched = false;
         this.flvplayback_internal::_lastUpdateTime = NaN;
         this.flvplayback_internal::lastUpdateTimeStuckCount = 0;
         this.flvplayback_internal::_sawSeekNotify = false;
         this.flvplayback_internal::waitingForEnough = false;
         this.flvplayback_internal::baselineProgressTime = NaN;
         this.flvplayback_internal::startProgressTime = NaN;
         this.flvplayback_internal::totalDownloadTime = NaN;
         this.flvplayback_internal::totalProgressTime = NaN;
         this.flvplayback_internal::_httpDoSeekCount = 0;
         this.flvplayback_internal::_updateTimeTimer.reset();
         this.flvplayback_internal::_updateProgressTimer.reset();
         this.flvplayback_internal::_idleTimeoutTimer.reset();
         this.flvplayback_internal::_autoResizeTimer.reset();
         this.flvplayback_internal::_rtmpDoStopAtEndTimer.reset();
         this.flvplayback_internal::_rtmpDoSeekTimer.reset();
         this.flvplayback_internal::_httpDoSeekTimer.reset();
         this.flvplayback_internal::_finishAutoResizeTimer.reset();
         this.flvplayback_internal::_delayedBufferingTimer.reset();
         this.flvplayback_internal::closeNS(false);
         if(this._ncMgr == null)
         {
            this.flvplayback_internal::createINCManager();
         }
         var _loc4_:Boolean = this._ncMgr.connectToURL(this._contentPath);
         this.flvplayback_internal::setState(VideoState.LOADING);
         this.flvplayback_internal::_cachedState = VideoState.LOADING;
         if(_loc4_)
         {
            this.flvplayback_internal::_createStream();
            this.flvplayback_internal::_setUpStream();
         }
         if(!this._ncMgr.isRTMP)
         {
            this.flvplayback_internal::_updateProgressTimer.start();
         }
      }
      
      public function pause() : void
      {
         if(!this.flvplayback_internal::isXnOK())
         {
            if(this._state == VideoState.CONNECTION_ERROR || this._ncMgr == null || this._ncMgr.netConnection == null)
            {
               throw new VideoError(VideoError.NO_CONNECTION);
            }
            return;
         }
         if(this._state == VideoState.flvplayback_internal::EXEC_QUEUED_CMD)
         {
            this._state = this.flvplayback_internal::_cachedState;
         }
         else
         {
            if(!this.stateResponsive)
            {
               this.flvplayback_internal::queueCmd(QueuedCommand.PAUSE);
               return;
            }
            this.flvplayback_internal::execQueuedCmds();
         }
         if(this._state == VideoState.PAUSED || this._state == VideoState.STOPPED || this._ns == null)
         {
            return;
         }
         this.flvplayback_internal::_pause(true);
         this.flvplayback_internal::setState(VideoState.PAUSED);
      }
      
      public function stop() : void
      {
         if(!this.flvplayback_internal::isXnOK())
         {
            if(this._state == VideoState.CONNECTION_ERROR || this._ncMgr == null || this._ncMgr.netConnection == null)
            {
               throw new VideoError(VideoError.NO_CONNECTION);
            }
            return;
         }
         if(this._state == VideoState.flvplayback_internal::EXEC_QUEUED_CMD)
         {
            this._state = this.flvplayback_internal::_cachedState;
         }
         else
         {
            if(!this.stateResponsive)
            {
               this.flvplayback_internal::queueCmd(QueuedCommand.STOP);
               return;
            }
            this.flvplayback_internal::execQueuedCmds();
         }
         if(this._state == VideoState.STOPPED || this._ns == null)
         {
            return;
         }
         if(this._ncMgr.isRTMP)
         {
            if(this._autoRewind && !this._isLive)
            {
               this.flvplayback_internal::_currentPos = 0;
               this.flvplayback_internal::_play(0,0);
               this._state = VideoState.STOPPED;
               this.flvplayback_internal::setState(VideoState.REWINDING);
            }
            else
            {
               this.flvplayback_internal::closeNS(true);
               this.flvplayback_internal::setState(VideoState.STOPPED);
            }
         }
         else
         {
            this.flvplayback_internal::_pause(true);
            if(this._autoRewind)
            {
               this.flvplayback_internal::_seek(0);
               this._state = VideoState.STOPPED;
               this.flvplayback_internal::setState(VideoState.REWINDING);
            }
            else
            {
               this.flvplayback_internal::setState(VideoState.STOPPED);
            }
         }
      }
      
      public function seek(param1:Number) : void
      {
         if(this.flvplayback_internal::_invalidSeekTime)
         {
            return;
         }
         if(isNaN(param1) || param1 < 0)
         {
            throw new VideoError(VideoError.INVALID_SEEK);
         }
         if(!this.flvplayback_internal::isXnOK())
         {
            if(this._state == VideoState.CONNECTION_ERROR || this._ncMgr == null || this._ncMgr.netConnection == null)
            {
               throw new VideoError(VideoError.NO_CONNECTION);
            }
            this.flvplayback_internal::flushQueuedCmds();
            this.flvplayback_internal::queueCmd(QueuedCommand.SEEK,null,false,param1);
            this.flvplayback_internal::setState(VideoState.LOADING);
            this.flvplayback_internal::_cachedState = VideoState.LOADING;
            this._ncMgr.reconnect();
            return;
         }
         if(this._state == VideoState.flvplayback_internal::EXEC_QUEUED_CMD)
         {
            this._state = this.flvplayback_internal::_cachedState;
         }
         else
         {
            if(!this.stateResponsive)
            {
               this.flvplayback_internal::queueCmd(QueuedCommand.SEEK,null,false,param1);
               return;
            }
            this.flvplayback_internal::execQueuedCmds();
         }
         if(this._ns == null)
         {
            this.flvplayback_internal::_createStream();
         }
         if(this.flvplayback_internal::_atEnd && param1 < this.playheadTime)
         {
            this.flvplayback_internal::_atEnd = false;
         }
         switch(this._state)
         {
            case VideoState.PLAYING:
               this._state = VideoState.BUFFERING;
            case VideoState.BUFFERING:
            case VideoState.PAUSED:
               this.flvplayback_internal::_seek(param1);
               this.flvplayback_internal::setState(VideoState.SEEKING);
               break;
            case VideoState.STOPPED:
               if(this._ncMgr.isRTMP)
               {
                  this.flvplayback_internal::_play(0);
                  this.flvplayback_internal::_pause(true);
               }
               this.flvplayback_internal::_seek(param1);
               this._state = VideoState.PAUSED;
               this.flvplayback_internal::setState(VideoState.SEEKING);
         }
      }
      
      public function close() : void
      {
         this.flvplayback_internal::closeNS(true);
         if(this._ncMgr != null && this._ncMgr.isRTMP)
         {
            this._ncMgr.close();
         }
         this.flvplayback_internal::setState(VideoState.DISCONNECTED);
         dispatchEvent(new fl.video.VideoEvent(fl.video.VideoEvent.CLOSE,false,false,this._state,this.playheadTime));
      }
      
      override public function set scaleX(param1:Number) : void
      {
         super.scaleX = param1;
         this._registrationWidth = width;
         switch(this._scaleMode)
         {
            case VideoScaleMode.MAINTAIN_ASPECT_RATIO:
            case VideoScaleMode.NO_SCALE:
               this.flvplayback_internal::startAutoResize();
         }
      }
      
      override public function set scaleY(param1:Number) : void
      {
         super.scaleY = param1;
         this._registrationHeight = height;
         switch(this._scaleMode)
         {
            case VideoScaleMode.MAINTAIN_ASPECT_RATIO:
            case VideoScaleMode.NO_SCALE:
               this.flvplayback_internal::startAutoResize();
         }
      }
      
      override public function set x(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         if(this.x != param1)
         {
            _loc2_ = param1 - this.x;
            super.x = param1;
            this._registrationX += _loc2_;
         }
      }
      
      override public function set y(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         if(this.y != param1)
         {
            _loc2_ = param1 - this.y;
            super.y = param1;
            this._registrationY += _loc2_;
         }
      }
      
      override public function set width(param1:Number) : void
      {
         super.width = this._registrationWidth = param1;
         switch(this._scaleMode)
         {
            case VideoScaleMode.MAINTAIN_ASPECT_RATIO:
            case VideoScaleMode.NO_SCALE:
               this.flvplayback_internal::startAutoResize();
               break;
            default:
               super.width = param1;
         }
      }
      
      override public function set height(param1:Number) : void
      {
         super.height = this._registrationHeight = param1;
         switch(this._scaleMode)
         {
            case VideoScaleMode.MAINTAIN_ASPECT_RATIO:
            case VideoScaleMode.NO_SCALE:
               this.flvplayback_internal::startAutoResize();
               break;
            default:
               super.height = param1;
         }
      }
      
      public function get registrationX() : Number
      {
         return this._registrationX;
      }
      
      public function set registrationX(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         if(this._registrationX != param1)
         {
            _loc2_ = param1 - this._registrationX;
            this._registrationX = param1;
            this.x += _loc2_;
         }
      }
      
      public function get registrationY() : Number
      {
         return this._registrationY;
      }
      
      public function set registrationY(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         if(this._registrationY != param1)
         {
            _loc2_ = param1 - this._registrationY;
            this._registrationY = param1;
            this.y += _loc2_;
         }
      }
      
      public function get registrationWidth() : Number
      {
         return this._registrationWidth;
      }
      
      public function set registrationWidth(param1:Number) : void
      {
         this.width = param1;
      }
      
      public function get registrationHeight() : Number
      {
         return this._registrationHeight;
      }
      
      public function set registrationHeight(param1:Number) : void
      {
         this.height = param1;
      }
      
      override public function get videoWidth() : int
      {
         if(this._videoWidth > 0)
         {
            return this._videoWidth;
         }
         if(this._metadata != null && !isNaN(this._metadata.width) && !isNaN(this._metadata.height))
         {
            if(this._metadata.width == this._metadata.height && this.flvplayback_internal::_readyDispatched)
            {
               return super.videoWidth;
            }
            return int(this._metadata.width);
         }
         if(this.flvplayback_internal::_readyDispatched)
         {
            return super.videoWidth;
         }
         return -1;
      }
      
      override public function get videoHeight() : int
      {
         if(this._videoHeight > 0)
         {
            return this._videoHeight;
         }
         if(this._metadata != null && !isNaN(this._metadata.width) && !isNaN(this._metadata.height))
         {
            if(this._metadata.width == this._metadata.height && this.flvplayback_internal::_readyDispatched)
            {
               return super.videoHeight;
            }
            return int(this._metadata.height);
         }
         if(this.flvplayback_internal::_readyDispatched)
         {
            return super.videoHeight;
         }
         return -1;
      }
      
      override public function get visible() : Boolean
      {
         if(!this.flvplayback_internal::_hiddenForResize)
         {
            this.__visible = super.visible;
         }
         return this.__visible;
      }
      
      override public function set visible(param1:Boolean) : void
      {
         this.__visible = param1;
         if(!this.flvplayback_internal::_hiddenForResize)
         {
            super.visible = this.__visible;
         }
      }
      
      public function get align() : String
      {
         return this._align;
      }
      
      public function set align(param1:String) : void
      {
         if(this._align != param1)
         {
            switch(param1)
            {
               case VideoAlign.CENTER:
               case VideoAlign.TOP:
               case VideoAlign.LEFT:
               case VideoAlign.BOTTOM:
               case VideoAlign.RIGHT:
               case VideoAlign.TOP_LEFT:
               case VideoAlign.TOP_RIGHT:
               case VideoAlign.BOTTOM_LEFT:
               case VideoAlign.BOTTOM_RIGHT:
                  this._align = param1;
                  switch(this._scaleMode)
                  {
                     case VideoScaleMode.MAINTAIN_ASPECT_RATIO:
                     case VideoScaleMode.NO_SCALE:
                        this.flvplayback_internal::startAutoResize();
                  }
                  break;
               default:
                  return;
            }
         }
      }
      
      public function get scaleMode() : String
      {
         return this._scaleMode;
      }
      
      public function set scaleMode(param1:String) : void
      {
         if(this._scaleMode != param1)
         {
            switch(param1)
            {
               case VideoScaleMode.MAINTAIN_ASPECT_RATIO:
               case VideoScaleMode.NO_SCALE:
               case VideoScaleMode.EXACT_FIT:
                  if(this._scaleMode == VideoScaleMode.EXACT_FIT && this.flvplayback_internal::_resizeImmediatelyOnMetadata && (this._videoWidth < 0 || this._videoHeight < 0))
                  {
                     this.flvplayback_internal::_resizeImmediatelyOnMetadata = false;
                  }
                  this._scaleMode = param1;
                  this.flvplayback_internal::startAutoResize();
                  break;
               default:
                  return;
            }
         }
      }
      
      public function get autoRewind() : Boolean
      {
         return this._autoRewind;
      }
      
      public function set autoRewind(param1:Boolean) : void
      {
         this._autoRewind = param1;
      }
      
      public function get playheadTime() : Number
      {
         var _loc1_:Number = this._ns == null ? this.flvplayback_internal::_currentPos : this._ns.time;
         if(this._metadata != null && this._metadata.audiodelay != undefined)
         {
            _loc1_ -= this._metadata.audiodelay;
            if(_loc1_ < 0)
            {
               _loc1_ = 0;
            }
         }
         return _loc1_;
      }
      
      public function set playheadTime(param1:Number) : void
      {
         this.seek(param1);
      }
      
      public function get source() : String
      {
         return this._contentPath;
      }
      
      public function get volume() : Number
      {
         return this.soundTransform.volume;
      }
      
      public function set volume(param1:Number) : void
      {
         var _loc2_:SoundTransform = this.soundTransform;
         _loc2_.volume = param1;
         this.soundTransform = _loc2_;
      }
      
      public function get soundTransform() : SoundTransform
      {
         if(this._ns != null)
         {
            this._soundTransform = this._ns.soundTransform;
         }
         var _loc1_:SoundTransform = new SoundTransform();
         _loc1_.volume = this.flvplayback_internal::_hiddenForResize ? this._volume : this._soundTransform.volume;
         _loc1_.leftToLeft = this._soundTransform.leftToLeft;
         _loc1_.leftToRight = this._soundTransform.leftToRight;
         _loc1_.rightToLeft = this._soundTransform.rightToLeft;
         _loc1_.rightToRight = this._soundTransform.rightToRight;
         return _loc1_;
      }
      
      public function set soundTransform(param1:SoundTransform) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(this.flvplayback_internal::_hiddenForResize)
         {
            this._volume = param1.volume;
         }
         this._soundTransform = new SoundTransform();
         this._soundTransform.volume = this.flvplayback_internal::_hiddenForResize ? 0 : param1.volume;
         this._soundTransform.leftToLeft = param1.leftToLeft;
         this._soundTransform.leftToRight = param1.leftToRight;
         this._soundTransform.rightToLeft = param1.rightToLeft;
         this._soundTransform.rightToRight = param1.rightToRight;
         if(this._ns != null)
         {
            this._ns.soundTransform = this._soundTransform;
         }
      }
      
      public function get isRTMP() : Boolean
      {
         if(this._ncMgr == null)
         {
            return false;
         }
         return this._ncMgr.isRTMP;
      }
      
      public function get isLive() : Boolean
      {
         return this._isLive;
      }
      
      public function get state() : String
      {
         return this._state;
      }
      
      public function get stateResponsive() : Boolean
      {
         switch(this._state)
         {
            case VideoState.STOPPED:
            case VideoState.PLAYING:
            case VideoState.PAUSED:
            case VideoState.BUFFERING:
               return true;
            default:
               return false;
         }
      }
      
      public function get bytesLoaded() : uint
      {
         if(this._ns == null || this._ncMgr.isRTMP)
         {
            return uint.MIN_VALUE;
         }
         return this._ns.bytesLoaded;
      }
      
      public function get bytesTotal() : uint
      {
         if(this._ns == null || this._ncMgr.isRTMP)
         {
            return uint.MAX_VALUE;
         }
         return this._ns.bytesTotal;
      }
      
      public function get totalTime() : Number
      {
         return this._streamLength;
      }
      
      public function get bufferTime() : Number
      {
         if(this._ns != null)
         {
            this._bufferTime = this._ns.bufferTime;
         }
         return this._bufferTime;
      }
      
      public function set bufferTime(param1:Number) : void
      {
         this._bufferTime = param1;
         if(this._ns != null)
         {
            this._ns.bufferTime = this._bufferTime;
         }
      }
      
      public function get idleTimeout() : Number
      {
         return this.flvplayback_internal::_idleTimeoutTimer.delay;
      }
      
      public function set idleTimeout(param1:Number) : void
      {
         this.flvplayback_internal::_idleTimeoutTimer.delay = param1;
      }
      
      public function get playheadUpdateInterval() : Number
      {
         return this.flvplayback_internal::_updateTimeTimer.delay;
      }
      
      public function set playheadUpdateInterval(param1:Number) : void
      {
         this.flvplayback_internal::_updateTimeTimer.delay = param1;
      }
      
      public function get progressInterval() : Number
      {
         return this.flvplayback_internal::_updateProgressTimer.delay;
      }
      
      public function set progressInterval(param1:Number) : void
      {
         this.flvplayback_internal::_updateProgressTimer.delay = param1;
      }
      
      public function get ncMgr() : fl.video.INCManager
      {
         if(this._ncMgr == null)
         {
            this.flvplayback_internal::createINCManager();
         }
         return this._ncMgr;
      }
      
      public function get netConnection() : NetConnection
      {
         if(this._ncMgr != null)
         {
            return this._ncMgr.netConnection;
         }
         return null;
      }
      
      public function get netStream() : NetStream
      {
         return this._ns;
      }
      
      public function get metadata() : Object
      {
         return this._metadata;
      }
      
      flvplayback_internal function doUpdateTime(param1:TimerEvent = null) : void
      {
         var _loc2_:Number = this.playheadTime;
         if(_loc2_ != this.flvplayback_internal::_atEndCheckPlayhead)
         {
            this.flvplayback_internal::_atEndCheckPlayhead = NaN;
         }
         switch(this._state)
         {
            case VideoState.STOPPED:
            case VideoState.PAUSED:
            case VideoState.DISCONNECTED:
            case VideoState.CONNECTION_ERROR:
               this.flvplayback_internal::_updateTimeTimer.stop();
               break;
            case VideoState.PLAYING:
            case VideoState.BUFFERING:
               if(this._ncMgr != null && !this._ncMgr.isRTMP && this.flvplayback_internal::_lastUpdateTime == _loc2_ && this._ns != null && this._ns.bytesLoaded == this._ns.bytesTotal)
               {
                  if(this.flvplayback_internal::lastUpdateTimeStuckCount > this.flvplayback_internal::lastUpdateTimeStuckCountMax)
                  {
                     this.flvplayback_internal::lastUpdateTimeStuckCount = 0;
                     this.flvplayback_internal::httpDoStopAtEnd();
                  }
                  else
                  {
                     ++this.flvplayback_internal::lastUpdateTimeStuckCount;
                  }
               }
         }
         if(this.flvplayback_internal::_lastUpdateTime != _loc2_)
         {
            dispatchEvent(new fl.video.VideoEvent(fl.video.VideoEvent.PLAYHEAD_UPDATE,false,false,this._state,_loc2_));
            this.flvplayback_internal::_lastUpdateTime = _loc2_;
            this.flvplayback_internal::lastUpdateTimeStuckCount = 0;
         }
      }
      
      flvplayback_internal function doUpdateProgress(param1:TimerEvent) : void
      {
         if(this._ns == null)
         {
            return;
         }
         var _loc2_:uint = this._ns.bytesLoaded;
         var _loc3_:uint = this._ns.bytesTotal;
         if(_loc3_ < uint.MAX_VALUE)
         {
            dispatchEvent(new VideoProgressEvent(VideoProgressEvent.PROGRESS,false,false,_loc2_,_loc3_));
         }
         if(this._state == VideoState.DISCONNECTED || this._state == VideoState.CONNECTION_ERROR || _loc2_ >= _loc3_)
         {
            this.flvplayback_internal::_updateProgressTimer.stop();
         }
         this.flvplayback_internal::checkEnoughDownloaded(_loc2_,_loc3_);
      }
      
      flvplayback_internal function checkEnoughDownloaded(param1:uint, param2:uint) : void
      {
         if(param1 == 0 || param2 == uint.MAX_VALUE)
         {
            return;
         }
         if(isNaN(this.totalTime) || this.totalTime <= 0)
         {
            if(this.flvplayback_internal::waitingForEnough && this.stateResponsive)
            {
               this.flvplayback_internal::waitingForEnough = false;
               this.flvplayback_internal::_cachedState = this._state;
               this._state = VideoState.flvplayback_internal::EXEC_QUEUED_CMD;
               this.play();
               this.flvplayback_internal::execQueuedCmds();
            }
            return;
         }
         if(param1 >= param2)
         {
            if(this.flvplayback_internal::waitingForEnough)
            {
               this.flvplayback_internal::waitingForEnough = false;
               this.flvplayback_internal::_cachedState = this._state;
               this._state = VideoState.flvplayback_internal::EXEC_QUEUED_CMD;
               this.play();
               this.flvplayback_internal::execQueuedCmds();
            }
            return;
         }
         if(isNaN(this.flvplayback_internal::baselineProgressTime))
         {
            this.flvplayback_internal::baselineProgressTime = param1 / param2 * this.totalTime;
         }
         if(isNaN(this.flvplayback_internal::startProgressTime))
         {
            this.flvplayback_internal::startProgressTime = getTimer();
         }
         else
         {
            this.flvplayback_internal::totalDownloadTime = (getTimer() - this.flvplayback_internal::startProgressTime) / 1000;
            this.flvplayback_internal::totalProgressTime = param1 / param2 * this.totalTime;
            if(this.flvplayback_internal::waitingForEnough)
            {
               this.flvplayback_internal::checkReadyForPlay(param1,param2);
            }
         }
      }
      
      flvplayback_internal function checkReadyForPlay(param1:uint, param2:uint) : void
      {
         var _loc3_:Number = NaN;
         if(param1 >= param2)
         {
            this.flvplayback_internal::waitingForEnough = false;
            this.flvplayback_internal::_cachedState = this._state;
            this._state = VideoState.flvplayback_internal::EXEC_QUEUED_CMD;
            this.play();
            this.flvplayback_internal::execQueuedCmds();
            return;
         }
         if(isNaN(this.flvplayback_internal::baselineProgressTime))
         {
            return;
         }
         if(isNaN(this.totalTime) || this.totalTime < 0)
         {
            this.flvplayback_internal::waitingForEnough = false;
            this.flvplayback_internal::_cachedState = this._state;
            this._state = VideoState.flvplayback_internal::EXEC_QUEUED_CMD;
            this.play();
            this.flvplayback_internal::execQueuedCmds();
         }
         else if(this.flvplayback_internal::totalDownloadTime > 1.5)
         {
            _loc3_ = (this.flvplayback_internal::totalProgressTime - this.flvplayback_internal::baselineProgressTime) / this.flvplayback_internal::totalDownloadTime;
            if(this.totalTime - this.playheadTime > (this.totalTime - this.flvplayback_internal::totalProgressTime) / _loc3_)
            {
               this.flvplayback_internal::waitingForEnough = false;
               this.flvplayback_internal::_cachedState = this._state;
               this._state = VideoState.flvplayback_internal::EXEC_QUEUED_CMD;
               this.play();
               this.flvplayback_internal::execQueuedCmds();
            }
         }
      }
      
      flvplayback_internal function rtmpNetStatus(param1:NetStatusEvent) : void
      {
         if(this._state == VideoState.CONNECTION_ERROR)
         {
            return;
         }
         loop0:
         switch(param1.info.code)
         {
            case "NetStream.Play.Stop":
               if(this.flvplayback_internal::_startingPlay)
               {
                  return;
               }
               switch(this._state)
               {
                  case VideoState.RESIZING:
                     if(this.flvplayback_internal::_hiddenForResize)
                     {
                        this.flvplayback_internal::finishAutoResize();
                        break loop0;
                     }
                     break loop0;
                  case VideoState.LOADING:
                  case VideoState.STOPPED:
                  case VideoState.PAUSED:
                     break loop0;
                  default:
                     this.flvplayback_internal::_sawPlayStop = true;
                     if(!this.flvplayback_internal::_rtmpDoStopAtEndTimer.running && (this.flvplayback_internal::_bufferState == flvplayback_internal::BUFFER_FLUSH || this._ns.bufferTime <= 0.1 && this._ns.bufferLength <= 0.1))
                     {
                        this.flvplayback_internal::_cachedPlayheadTime = this.playheadTime;
                        this.flvplayback_internal::_rtmpDoStopAtEndTimer.reset();
                        this.flvplayback_internal::_rtmpDoStopAtEndTimer.start();
                        break loop0;
                     }
               }
               break;
            case "NetStream.Buffer.Empty":
               switch(this.flvplayback_internal::_bufferState)
               {
                  case flvplayback_internal::BUFFER_FULL:
                     if(this.flvplayback_internal::_sawPlayStop)
                     {
                        this.flvplayback_internal::rtmpDoStopAtEnd();
                        break;
                     }
                     if(this._state == VideoState.PLAYING)
                     {
                        this.flvplayback_internal::setState(VideoState.BUFFERING);
                        break;
                     }
                     break;
               }
               this.flvplayback_internal::_bufferState = flvplayback_internal::BUFFER_EMPTY;
               this.flvplayback_internal::_sawPlayStop = false;
               break;
            case "NetStream.Buffer.Flush":
               if(this.flvplayback_internal::_sawSeekNotify && this._state == VideoState.SEEKING)
               {
                  this.flvplayback_internal::_bufferState = flvplayback_internal::BUFFER_EMPTY;
                  this.flvplayback_internal::_sawPlayStop = false;
                  this.flvplayback_internal::setStateFromCachedState(false);
                  this.flvplayback_internal::doUpdateTime();
                  this.flvplayback_internal::execQueuedCmds();
               }
               if(!this.flvplayback_internal::_rtmpDoStopAtEndTimer.running && this.flvplayback_internal::_sawPlayStop && (this.flvplayback_internal::_bufferState == flvplayback_internal::BUFFER_EMPTY || this._ns.bufferTime <= 0.1 && this._ns.bufferLength <= 0.1))
               {
                  this.flvplayback_internal::_cachedPlayheadTime = this.playheadTime;
                  this.flvplayback_internal::_rtmpDoStopAtEndTimer.reset();
                  this.flvplayback_internal::_rtmpDoStopAtEndTimer.start();
               }
               switch(this.flvplayback_internal::_bufferState)
               {
                  case flvplayback_internal::BUFFER_EMPTY:
                     if(!this.flvplayback_internal::_hiddenForResize)
                     {
                        if(this._state == VideoState.LOADING && this.flvplayback_internal::_cachedState == VideoState.PLAYING || this._state == VideoState.BUFFERING)
                        {
                           this.flvplayback_internal::setState(VideoState.PLAYING);
                        }
                        else if(this.flvplayback_internal::_cachedState == VideoState.BUFFERING)
                        {
                           this.flvplayback_internal::_cachedState = VideoState.PLAYING;
                        }
                     }
                     this.flvplayback_internal::_bufferState = flvplayback_internal::BUFFER_FLUSH;
                     break loop0;
                  default:
                     if(this._state == VideoState.BUFFERING)
                     {
                        this.flvplayback_internal::setStateFromCachedState();
                        break loop0;
                     }
               }
               break;
            case "NetStream.Buffer.Full":
               if(this.flvplayback_internal::_sawSeekNotify && this._state == VideoState.SEEKING)
               {
                  this.flvplayback_internal::_bufferState = flvplayback_internal::BUFFER_EMPTY;
                  this.flvplayback_internal::_sawPlayStop = false;
                  this.flvplayback_internal::setStateFromCachedState(false);
                  this.flvplayback_internal::doUpdateTime();
                  this.flvplayback_internal::execQueuedCmds();
               }
               switch(this.flvplayback_internal::_bufferState)
               {
                  case flvplayback_internal::BUFFER_EMPTY:
                     this.flvplayback_internal::_bufferState = flvplayback_internal::BUFFER_FULL;
                     if(!this.flvplayback_internal::_hiddenForResize)
                     {
                        if(this._state == VideoState.LOADING && this.flvplayback_internal::_cachedState == VideoState.PLAYING || this._state == VideoState.BUFFERING)
                        {
                           this.flvplayback_internal::setState(VideoState.PLAYING);
                        }
                        else if(this.flvplayback_internal::_cachedState == VideoState.BUFFERING)
                        {
                           this.flvplayback_internal::_cachedState = VideoState.PLAYING;
                        }
                        if(this.flvplayback_internal::_rtmpDoStopAtEndTimer.running)
                        {
                           this.flvplayback_internal::_sawPlayStop = true;
                           this.flvplayback_internal::_rtmpDoStopAtEndTimer.reset();
                           break;
                        }
                        break;
                     }
                     break;
                  case flvplayback_internal::BUFFER_FLUSH:
                     this.flvplayback_internal::_bufferState = flvplayback_internal::BUFFER_FULL;
                     if(this.flvplayback_internal::_rtmpDoStopAtEndTimer.running)
                     {
                        this.flvplayback_internal::_sawPlayStop = true;
                        this.flvplayback_internal::_rtmpDoStopAtEndTimer.reset();
                        break;
                     }
               }
               if(this._state == VideoState.BUFFERING)
               {
                  this.flvplayback_internal::setStateFromCachedState();
                  break;
               }
               break;
            case "NetStream.Pause.Notify":
               if(this._state == VideoState.RESIZING && this.flvplayback_internal::_hiddenForResize)
               {
                  this.flvplayback_internal::finishAutoResize();
                  break;
               }
               break;
            case "NetStream.Unpause.Notify":
               if(this._state == VideoState.PAUSED)
               {
                  this._state = VideoState.PLAYING;
                  this.flvplayback_internal::setState(VideoState.BUFFERING);
                  break;
               }
               this.flvplayback_internal::_cachedState = VideoState.PLAYING;
               break;
            case "NetStream.Play.Start":
               this.flvplayback_internal::_rtmpDoStopAtEndTimer.reset();
               this.flvplayback_internal::_bufferState = flvplayback_internal::BUFFER_EMPTY;
               this.flvplayback_internal::_sawPlayStop = false;
               if(this.flvplayback_internal::_startingPlay)
               {
                  this.flvplayback_internal::_startingPlay = false;
                  this.flvplayback_internal::_cachedPlayheadTime = this.playheadTime;
                  break;
               }
               if(this._state == VideoState.PLAYING)
               {
                  this.flvplayback_internal::setState(VideoState.BUFFERING);
                  break;
               }
               break;
            case "NetStream.Play.Reset":
               this.flvplayback_internal::_rtmpDoStopAtEndTimer.reset();
               if(this._state == VideoState.REWINDING)
               {
                  this.flvplayback_internal::_rtmpDoSeekTimer.reset();
                  if(this.playheadTime == 0 || this.playheadTime < this.flvplayback_internal::_cachedPlayheadTime)
                  {
                     this.flvplayback_internal::setStateFromCachedState();
                     break;
                  }
                  this.flvplayback_internal::_cachedPlayheadTime = this.playheadTime;
                  this.flvplayback_internal::_rtmpDoSeekTimer.start();
                  break;
               }
               break;
            case "NetStream.Seek.Notify":
               if(this.playheadTime != this.flvplayback_internal::_cachedPlayheadTime)
               {
                  this.flvplayback_internal::setStateFromCachedState(false);
                  this.flvplayback_internal::doUpdateTime();
                  this.flvplayback_internal::execQueuedCmds();
                  break;
               }
               this.flvplayback_internal::_sawSeekNotify = true;
               this.flvplayback_internal::_rtmpDoSeekTimer.start();
               break;
            case "Netstream.Play.UnpublishNotify":
            case "Netstream.Play.PublishNotify":
               break;
            case "NetStream.Play.StreamNotFound":
               this.flvplayback_internal::closeNS(false);
               if(!this._ncMgr.connectAgain())
               {
                  this.flvplayback_internal::setState(VideoState.CONNECTION_ERROR);
                  break;
               }
               break;
            case "NetStream.Play.Failed":
            case "NetStream.Failed":
            case "NetStream.Play.FileStructureInvalid":
            case "NetStream.Play.NoSupportedTrackFound":
               this.flvplayback_internal::setState(VideoState.CONNECTION_ERROR);
         }
      }
      
      flvplayback_internal function httpNetStatus(param1:NetStatusEvent) : void
      {
         switch(param1.info.code)
         {
            case "NetStream.Play.Stop":
               this.flvplayback_internal::_delayedBufferingTimer.reset();
               if(this.flvplayback_internal::_invalidSeekTime)
               {
                  this.flvplayback_internal::_invalidSeekTime = false;
                  this.flvplayback_internal::_invalidSeekRecovery = true;
                  this.flvplayback_internal::setState(this.flvplayback_internal::_cachedState);
                  this.seek(this.playheadTime);
                  break;
               }
               switch(this._state)
               {
                  case VideoState.SEEKING:
                     this.flvplayback_internal::httpDoSeek(null);
                     break;
                  case VideoState.PLAYING:
                  case VideoState.BUFFERING:
               }
               this.flvplayback_internal::httpDoStopAtEnd();
               break;
            case "NetStream.Seek.InvalidTime":
               if(this.flvplayback_internal::_invalidSeekRecovery)
               {
                  this.flvplayback_internal::_invalidSeekTime = false;
                  this.flvplayback_internal::_invalidSeekRecovery = false;
                  this.flvplayback_internal::setState(this.flvplayback_internal::_cachedState);
                  this.seek(0);
                  break;
               }
               this.flvplayback_internal::_invalidSeekTime = true;
               this.flvplayback_internal::_httpDoSeekCount = 0;
               this.flvplayback_internal::_httpDoSeekTimer.start();
               break;
            case "NetStream.Buffer.Empty":
               this.flvplayback_internal::_bufferState = flvplayback_internal::BUFFER_EMPTY;
               if(this._state == VideoState.PLAYING)
               {
                  this.flvplayback_internal::_delayedBufferingTimer.reset();
                  this.flvplayback_internal::_delayedBufferingTimer.start();
                  break;
               }
               break;
            case "NetStream.Buffer.Full":
            case "NetStream.Buffer.Flush":
               this.flvplayback_internal::_delayedBufferingTimer.reset();
               this.flvplayback_internal::_bufferState = flvplayback_internal::BUFFER_FULL;
               if(!this.flvplayback_internal::_hiddenForResize)
               {
                  if(this._state == VideoState.LOADING && this.flvplayback_internal::_cachedState == VideoState.PLAYING || this._state == VideoState.BUFFERING)
                  {
                     this.flvplayback_internal::setState(VideoState.PLAYING);
                     break;
                  }
                  if(this.flvplayback_internal::_cachedState == VideoState.BUFFERING)
                  {
                     this.flvplayback_internal::_cachedState = VideoState.PLAYING;
                     break;
                  }
                  break;
               }
               break;
            case "NetStream.Seek.Notify":
               this.flvplayback_internal::_invalidSeekRecovery = false;
               switch(this._state)
               {
                  case VideoState.SEEKING:
                  case VideoState.REWINDING:
                     this.flvplayback_internal::_httpDoSeekCount = 0;
                     this.flvplayback_internal::_httpDoSeekTimer.start();
               }
               break;
            case "NetStream.Play.StreamNotFound":
            case "NetStream.Play.FileStructureInvalid":
            case "NetStream.Play.NoSupportedTrackFound":
               this.flvplayback_internal::setState(VideoState.CONNECTION_ERROR);
         }
      }
      
      public function ncConnected() : void
      {
         if(this._ncMgr == null || this._ncMgr.netConnection == null)
         {
            this.flvplayback_internal::setState(VideoState.CONNECTION_ERROR);
         }
         else if(this._ns == null)
         {
            this.flvplayback_internal::_createStream();
            this.flvplayback_internal::_setUpStream();
         }
      }
      
      public function ncReconnected() : void
      {
         if(this._ncMgr == null || this._ncMgr.netConnection == null)
         {
            this.flvplayback_internal::setState(VideoState.CONNECTION_ERROR);
         }
         else
         {
            this._ns = null;
            this._state = VideoState.STOPPED;
            this.flvplayback_internal::execQueuedCmds();
         }
      }
      
      flvplayback_internal function onMetaData(param1:Object) : void
      {
         if(this._metadata != null)
         {
            return;
         }
         this._metadata = param1;
         if(isNaN(this._streamLength))
         {
            this._streamLength = param1.duration;
         }
         if(this.flvplayback_internal::_resizeImmediatelyOnMetadata && Boolean(this._ns.client.ready))
         {
            this.flvplayback_internal::_resizeImmediatelyOnMetadata = false;
            this.flvplayback_internal::_autoResizeTimer.reset();
            this.flvplayback_internal::_autoResizeDone = false;
            this.flvplayback_internal::doAutoResize();
         }
         dispatchEvent(new MetadataEvent(MetadataEvent.METADATA_RECEIVED,false,false,param1));
      }
      
      flvplayback_internal function onCuePoint(param1:Object) : void
      {
         if(!this.flvplayback_internal::_hiddenForResize || !isNaN(this.flvplayback_internal::_hiddenRewindPlayheadTime) && this.playheadTime < this.flvplayback_internal::_hiddenRewindPlayheadTime)
         {
            dispatchEvent(new MetadataEvent(MetadataEvent.CUE_POINT,false,false,param1));
         }
      }
      
      flvplayback_internal function setState(param1:String, param2:Boolean = true) : void
      {
         if(param1 == this._state)
         {
            return;
         }
         this.flvplayback_internal::_hiddenRewindPlayheadTime = NaN;
         this.flvplayback_internal::_cachedState = this._state;
         this.flvplayback_internal::_cachedPlayheadTime = this.playheadTime;
         this._state = param1;
         var _loc3_:String = this._state;
         dispatchEvent(new fl.video.VideoEvent(fl.video.VideoEvent.STATE_CHANGE,false,false,_loc3_,this.playheadTime));
         if(!this.flvplayback_internal::_readyDispatched)
         {
            switch(_loc3_)
            {
               case VideoState.STOPPED:
               case VideoState.PLAYING:
               case VideoState.PAUSED:
               case VideoState.BUFFERING:
                  this.flvplayback_internal::_readyDispatched = true;
                  dispatchEvent(new fl.video.VideoEvent(fl.video.VideoEvent.READY,false,false,_loc3_,this.playheadTime));
            }
         }
         switch(this.flvplayback_internal::_cachedState)
         {
            case VideoState.REWINDING:
               dispatchEvent(new fl.video.VideoEvent(fl.video.VideoEvent.AUTO_REWOUND,false,false,_loc3_,this.playheadTime));
               if(this._ncMgr.isRTMP && _loc3_ == VideoState.STOPPED)
               {
                  this.flvplayback_internal::closeNS();
                  break;
               }
         }
         switch(_loc3_)
         {
            case VideoState.STOPPED:
            case VideoState.PAUSED:
               if(this._ncMgr.isRTMP)
               {
                  this.flvplayback_internal::_idleTimeoutTimer.reset();
                  this.flvplayback_internal::_idleTimeoutTimer.start();
                  break;
               }
               break;
            case VideoState.SEEKING:
            case VideoState.REWINDING:
               this.flvplayback_internal::_bufferState = flvplayback_internal::BUFFER_EMPTY;
               this.flvplayback_internal::_sawPlayStop = false;
               this.flvplayback_internal::_idleTimeoutTimer.reset();
               break;
            case VideoState.PLAYING:
            case VideoState.BUFFERING:
               this.flvplayback_internal::_updateTimeTimer.start();
               this.flvplayback_internal::_idleTimeoutTimer.reset();
               break;
            case VideoState.LOADING:
            case VideoState.RESIZING:
               this.flvplayback_internal::_idleTimeoutTimer.reset();
         }
         if(param2)
         {
            this.flvplayback_internal::execQueuedCmds();
         }
      }
      
      flvplayback_internal function setStateFromCachedState(param1:Boolean = true) : void
      {
         switch(this.flvplayback_internal::_cachedState)
         {
            case VideoState.PLAYING:
            case VideoState.PAUSED:
            case VideoState.BUFFERING:
               this.flvplayback_internal::setState(this.flvplayback_internal::_cachedState,param1);
               break;
            default:
               this.flvplayback_internal::setState(VideoState.STOPPED,param1);
         }
      }
      
      flvplayback_internal function createINCManager() : void
      {
         var theClass:Class = null;
         try
         {
            if(iNCManagerClass is String)
            {
               theClass = Class(getDefinitionByName(String(iNCManagerClass)));
            }
            else if(iNCManagerClass is Class)
            {
               theClass = Class(iNCManagerClass);
            }
         }
         catch(e:Error)
         {
            theClass = null;
         }
         if(theClass == null)
         {
            throw new VideoError(VideoError.INCMANAGER_CLASS_UNSET,iNCManagerClass == null ? "null" : String(iNCManagerClass.toString()));
         }
         this._ncMgr = new theClass();
         this._ncMgr.videoPlayer = this;
      }
      
      flvplayback_internal function createNetStreamClient() : Object
      {
         var theClass:Class = null;
         var theInst:Object = null;
         try
         {
            if(netStreamClientClass is String)
            {
               theClass = Class(getDefinitionByName(String(netStreamClientClass)));
            }
            else if(netStreamClientClass is Class)
            {
               theClass = Class(netStreamClientClass);
            }
            if(theClass != null)
            {
               theInst = new theClass(this);
            }
         }
         catch(e:Error)
         {
            theClass = null;
            theInst = null;
         }
         if(theInst == null)
         {
            throw new VideoError(VideoError.NETSTREAM_CLIENT_CLASS_UNSET,netStreamClientClass == null ? "null" : String(netStreamClientClass.toString()));
         }
         return theInst;
      }
      
      flvplayback_internal function rtmpDoStopAtEnd(param1:TimerEvent = null) : void
      {
         if(this.flvplayback_internal::_rtmpDoStopAtEndTimer.running)
         {
            switch(this._state)
            {
               case VideoState.DISCONNECTED:
               case VideoState.CONNECTION_ERROR:
                  this.flvplayback_internal::_rtmpDoStopAtEndTimer.reset();
                  return;
               default:
                  if(!(param1 == null || this.flvplayback_internal::_cachedPlayheadTime == this.playheadTime))
                  {
                     this.flvplayback_internal::_cachedPlayheadTime = this.playheadTime;
                     return;
                  }
                  this.flvplayback_internal::_rtmpDoStopAtEndTimer.reset();
            }
         }
         if(this.flvplayback_internal::_atEndCheckPlayhead == this.playheadTime && this.flvplayback_internal::_atEndCheckPlayhead != this.flvplayback_internal::_lastSeekTime && !this._isLive && this.playheadTime != 0)
         {
            this.flvplayback_internal::_atEnd = false;
            this.flvplayback_internal::_currentPos = 0;
            this.flvplayback_internal::_play(0);
            return;
         }
         this.flvplayback_internal::_atEndCheckPlayhead = NaN;
         this.flvplayback_internal::_bufferState = flvplayback_internal::BUFFER_EMPTY;
         this.flvplayback_internal::_sawPlayStop = false;
         this.flvplayback_internal::_atEnd = true;
         this.flvplayback_internal::setState(VideoState.STOPPED);
         if(this._state != VideoState.STOPPED)
         {
            return;
         }
         this.flvplayback_internal::doUpdateTime();
         if(this._state != VideoState.STOPPED)
         {
            return;
         }
         dispatchEvent(new fl.video.VideoEvent(fl.video.VideoEvent.COMPLETE,false,false,this._state,this.playheadTime));
         if(this._state != VideoState.STOPPED)
         {
            return;
         }
         if(this._autoRewind && !this._isLive && this.playheadTime != 0)
         {
            this.flvplayback_internal::_atEnd = false;
            this.flvplayback_internal::_currentPos = 0;
            this.flvplayback_internal::_play(0,0);
            this.flvplayback_internal::setState(VideoState.REWINDING);
         }
         else
         {
            this.flvplayback_internal::closeNS();
         }
      }
      
      flvplayback_internal function rtmpDoSeek(param1:TimerEvent) : void
      {
         if(this._state != VideoState.REWINDING && this._state != VideoState.SEEKING)
         {
            this.flvplayback_internal::_rtmpDoSeekTimer.reset();
            this.flvplayback_internal::_sawSeekNotify = false;
         }
         else if(this.playheadTime != this.flvplayback_internal::_cachedPlayheadTime)
         {
            this.flvplayback_internal::_rtmpDoSeekTimer.reset();
            this.flvplayback_internal::_sawSeekNotify = false;
            this.flvplayback_internal::setStateFromCachedState(false);
            this.flvplayback_internal::doUpdateTime();
            this.flvplayback_internal::_lastSeekTime = this.playheadTime;
            this.flvplayback_internal::execQueuedCmds();
         }
      }
      
      flvplayback_internal function httpDoStopAtEnd() : void
      {
         if(this.flvplayback_internal::_atEndCheckPlayhead == this.playheadTime && this.flvplayback_internal::_atEndCheckPlayhead != this.flvplayback_internal::_lastUpdateTime && this.playheadTime != 0)
         {
            this.flvplayback_internal::_atEnd = false;
            this.flvplayback_internal::_seek(0);
            return;
         }
         this.flvplayback_internal::_atEndCheckPlayhead = NaN;
         this.flvplayback_internal::_atEnd = true;
         if(isNaN(this._streamLength))
         {
            this._streamLength = this._ns.time;
         }
         this.flvplayback_internal::_pause(true);
         this.flvplayback_internal::setState(VideoState.STOPPED);
         if(this._state != VideoState.STOPPED)
         {
            return;
         }
         this.flvplayback_internal::doUpdateTime();
         if(this._state != VideoState.STOPPED)
         {
            return;
         }
         dispatchEvent(new fl.video.VideoEvent(fl.video.VideoEvent.COMPLETE,false,false,this._state,this.playheadTime));
         if(this._state != VideoState.STOPPED)
         {
            return;
         }
         if(this._autoRewind)
         {
            this.flvplayback_internal::_atEnd = false;
            this.flvplayback_internal::_pause(true);
            this.flvplayback_internal::_seek(0);
            this.flvplayback_internal::setState(VideoState.REWINDING);
         }
      }
      
      flvplayback_internal function httpDoSeek(param1:TimerEvent) : void
      {
         var _loc2_:Boolean = this._state == VideoState.REWINDING || this._state == VideoState.SEEKING;
         if(_loc2_ && this.flvplayback_internal::_httpDoSeekCount < this.flvplayback_internal::httpDoSeekMaxCount && (this.flvplayback_internal::_cachedPlayheadTime == this.playheadTime || this.flvplayback_internal::_invalidSeekTime))
         {
            ++this.flvplayback_internal::_httpDoSeekCount;
            return;
         }
         this.flvplayback_internal::_httpDoSeekCount = 0;
         this.flvplayback_internal::_httpDoSeekTimer.reset();
         if(!_loc2_)
         {
            return;
         }
         this.flvplayback_internal::setStateFromCachedState(false);
         if(this.flvplayback_internal::_invalidSeekTime)
         {
            this.flvplayback_internal::_invalidSeekTime = false;
            this.flvplayback_internal::_invalidSeekRecovery = true;
            this.seek(this.playheadTime);
         }
         else
         {
            this.flvplayback_internal::doUpdateTime();
            this.flvplayback_internal::_lastSeekTime = this.playheadTime;
            this.flvplayback_internal::execQueuedCmds();
         }
      }
      
      flvplayback_internal function closeNS(param1:Boolean = false) : void
      {
         if(this._ns != null)
         {
            if(param1)
            {
               this.flvplayback_internal::doUpdateTime();
               this.flvplayback_internal::_currentPos = this._ns.time;
            }
            this.flvplayback_internal::_updateTimeTimer.reset();
            this.flvplayback_internal::_updateProgressTimer.reset();
            this.flvplayback_internal::_idleTimeoutTimer.reset();
            this.flvplayback_internal::_autoResizeTimer.reset();
            this.flvplayback_internal::_rtmpDoStopAtEndTimer.reset();
            this.flvplayback_internal::_rtmpDoSeekTimer.reset();
            this.flvplayback_internal::_httpDoSeekTimer.reset();
            this.flvplayback_internal::_finishAutoResizeTimer.reset();
            this.flvplayback_internal::_delayedBufferingTimer.reset();
            this._ns.removeEventListener(NetStatusEvent.NET_STATUS,this.flvplayback_internal::rtmpNetStatus);
            this._ns.removeEventListener(NetStatusEvent.NET_STATUS,this.flvplayback_internal::httpNetStatus);
            this._ns.close();
            this._ns = null;
         }
      }
      
      flvplayback_internal function doDelayedBuffering(param1:TimerEvent) : void
      {
         switch(this._state)
         {
            case VideoState.LOADING:
            case VideoState.RESIZING:
               break;
            case VideoState.PLAYING:
               this.flvplayback_internal::_delayedBufferingTimer.reset();
               if(!isNaN(this.totalTime) && this.totalTime > 0 && this.bytesLoaded > 0 && this.bytesLoaded < uint.MAX_VALUE && this.bytesLoaded < this.bytesTotal)
               {
                  this.pause();
                  if(this._state == VideoState.PAUSED)
                  {
                     this.flvplayback_internal::waitingForEnough = true;
                     this.playWhenEnoughDownloaded();
                     break;
                  }
                  break;
               }
               this.flvplayback_internal::setState(VideoState.BUFFERING);
               break;
            default:
               this.flvplayback_internal::_delayedBufferingTimer.reset();
         }
      }
      
      flvplayback_internal function _pause(param1:Boolean) : void
      {
         this.flvplayback_internal::_atEndCheckPlayhead = this.playheadTime;
         this.flvplayback_internal::_rtmpDoStopAtEndTimer.reset();
         if(param1)
         {
            this._ns.pause();
         }
         else
         {
            this._ns.resume();
         }
      }
      
      flvplayback_internal function _play(param1:int = 0, param2:int = -1) : void
      {
         this.flvplayback_internal::waitingForEnough = false;
         this.flvplayback_internal::_rtmpDoStopAtEndTimer.reset();
         this.flvplayback_internal::_startingPlay = true;
         this._ns.play(this._ncMgr.streamName,this._isLive ? -1 : param1,param2);
      }
      
      flvplayback_internal function _seek(param1:Number) : void
      {
         this.flvplayback_internal::_rtmpDoStopAtEndTimer.reset();
         if(this._metadata != null && this._metadata.audiodelay != undefined && (isNaN(this._streamLength) || param1 + this._metadata.audiodelay < this._streamLength))
         {
            param1 += this._metadata.audiodelay;
         }
         this._ns.seek(param1);
         this.flvplayback_internal::_lastSeekTime = param1;
         this.flvplayback_internal::_invalidSeekTime = false;
         this.flvplayback_internal::_bufferState = flvplayback_internal::BUFFER_EMPTY;
         this.flvplayback_internal::_sawPlayStop = false;
         this.flvplayback_internal::_sawSeekNotify = false;
      }
      
      flvplayback_internal function isXnOK() : Boolean
      {
         if(this._state == VideoState.LOADING)
         {
            return true;
         }
         if(this._state == VideoState.CONNECTION_ERROR)
         {
            return false;
         }
         if(this._state != VideoState.DISCONNECTED)
         {
            if(this._ncMgr == null || this._ncMgr.netConnection == null || this._ncMgr.isRTMP && !this._ncMgr.netConnection.connected)
            {
               this.flvplayback_internal::setState(VideoState.DISCONNECTED);
               return false;
            }
            return true;
         }
         return false;
      }
      
      flvplayback_internal function startAutoResize() : void
      {
         switch(this._state)
         {
            case VideoState.DISCONNECTED:
            case VideoState.CONNECTION_ERROR:
               return;
            default:
               if(this._ns == null)
               {
                  return;
               }
               this.flvplayback_internal::_autoResizeDone = false;
               if(this.stateResponsive && (super.videoWidth != 0 || super.videoHeight != 0 || this.flvplayback_internal::_bufferState == flvplayback_internal::BUFFER_FULL || this.flvplayback_internal::_bufferState == flvplayback_internal::BUFFER_FLUSH || this._ns.time > this.flvplayback_internal::autoResizePlayheadTimeout))
               {
                  this.flvplayback_internal::doAutoResize();
               }
               else
               {
                  this.flvplayback_internal::_autoResizeTimer.reset();
                  this.flvplayback_internal::_autoResizeTimer.start();
               }
               return;
         }
      }
      
      flvplayback_internal function doAutoResize(param1:TimerEvent = null) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         if(this.flvplayback_internal::_autoResizeTimer.running)
         {
            switch(this._state)
            {
               case VideoState.RESIZING:
               case VideoState.LOADING:
                  break;
               case VideoState.DISCONNECTED:
               case VideoState.CONNECTION_ERROR:
                  this.flvplayback_internal::_autoResizeTimer.reset();
                  return;
               default:
                  if(!this.stateResponsive)
                  {
                     return;
                  }
                  break;
            }
            if(!(super.videoWidth != this.flvplayback_internal::_prevVideoWidth || super.videoHeight != this.flvplayback_internal::_prevVideoHeight || this.flvplayback_internal::_bufferState == flvplayback_internal::BUFFER_FULL || this.flvplayback_internal::_bufferState == flvplayback_internal::BUFFER_FLUSH || this._ns.time > this.flvplayback_internal::autoResizePlayheadTimeout))
            {
               return;
            }
            if(this.flvplayback_internal::_hiddenForResize && !this._ns.client.ready && this.flvplayback_internal::_hiddenForResizeMetadataDelay < this.flvplayback_internal::autoResizeMetadataDelayMax)
            {
               ++this.flvplayback_internal::_hiddenForResizeMetadataDelay;
               return;
            }
            this.flvplayback_internal::_autoResizeTimer.reset();
         }
         if(this.flvplayback_internal::_autoResizeDone)
         {
            this.flvplayback_internal::setState(this.flvplayback_internal::_cachedState);
            return;
         }
         this.flvplayback_internal::oldBounds = new Rectangle(x,y,width,height);
         this.flvplayback_internal::oldRegistrationBounds = new Rectangle(this.registrationX,this.registrationY,this.registrationWidth,this.registrationHeight);
         this.flvplayback_internal::_autoResizeDone = true;
         var _loc2_:Boolean = this.flvplayback_internal::_readyDispatched;
         this.flvplayback_internal::_readyDispatched = true;
         _loc3_ = this.videoWidth;
         _loc4_ = this.videoHeight;
         this.flvplayback_internal::_readyDispatched = _loc2_;
         switch(this._scaleMode)
         {
            case VideoScaleMode.NO_SCALE:
               super.width = Math.round(_loc3_);
               super.height = Math.round(_loc4_);
               break;
            case VideoScaleMode.EXACT_FIT:
               super.width = this.registrationWidth;
               super.height = this.registrationHeight;
               break;
            case VideoScaleMode.MAINTAIN_ASPECT_RATIO:
            default:
               _loc5_ = _loc3_ * this._registrationHeight / _loc4_;
               if((_loc6_ = _loc4_ * this._registrationWidth / _loc3_) < this._registrationHeight)
               {
                  super.width = this._registrationWidth;
                  super.height = _loc6_;
                  break;
               }
               if(_loc5_ < this._registrationWidth)
               {
                  super.width = _loc5_;
                  super.height = this._registrationHeight;
                  break;
               }
               super.width = this._registrationWidth;
               super.height = this._registrationHeight;
               break;
         }
         switch(this._align)
         {
            case VideoAlign.CENTER:
            case VideoAlign.TOP:
            case VideoAlign.BOTTOM:
            default:
               super.x = Math.round(this._registrationX + (this._registrationWidth - width) / 2);
               break;
            case VideoAlign.LEFT:
            case VideoAlign.TOP_LEFT:
            case VideoAlign.BOTTOM_LEFT:
               super.x = Math.round(this._registrationX);
               break;
            case VideoAlign.RIGHT:
            case VideoAlign.TOP_RIGHT:
            case VideoAlign.BOTTOM_RIGHT:
               super.x = Math.round(this._registrationX + (this._registrationWidth - width));
         }
         switch(this._align)
         {
            case VideoAlign.CENTER:
            case VideoAlign.LEFT:
            case VideoAlign.RIGHT:
            default:
               super.y = Math.round(this._registrationY + (this._registrationHeight - height) / 2);
               break;
            case VideoAlign.TOP:
            case VideoAlign.TOP_LEFT:
            case VideoAlign.TOP_RIGHT:
               super.y = Math.round(this._registrationY);
               break;
            case VideoAlign.BOTTOM:
            case VideoAlign.BOTTOM_LEFT:
            case VideoAlign.BOTTOM_RIGHT:
               super.y = Math.round(this._registrationY + (this._registrationHeight - height));
         }
         if(this.flvplayback_internal::_hiddenForResize)
         {
            this.flvplayback_internal::_hiddenRewindPlayheadTime = this.playheadTime;
            if(this._state == VideoState.LOADING)
            {
               this.flvplayback_internal::_cachedState = VideoState.PLAYING;
            }
            if(!this._ncMgr.isRTMP)
            {
               this.flvplayback_internal::_pause(true);
               this.flvplayback_internal::_seek(0);
               this.flvplayback_internal::_finishAutoResizeTimer.reset();
               this.flvplayback_internal::_finishAutoResizeTimer.start();
            }
            else if(!this._isLive)
            {
               this.flvplayback_internal::_currentPos = 0;
               this.flvplayback_internal::_play(0,0);
               this.flvplayback_internal::setState(VideoState.RESIZING);
            }
            else if(this._autoPlay)
            {
               this.flvplayback_internal::_finishAutoResizeTimer.reset();
               this.flvplayback_internal::_finishAutoResizeTimer.start();
            }
            else
            {
               this.flvplayback_internal::finishAutoResize();
            }
         }
         else
         {
            dispatchEvent(new AutoLayoutEvent(AutoLayoutEvent.AUTO_LAYOUT,false,false,this.flvplayback_internal::oldBounds,this.flvplayback_internal::oldRegistrationBounds));
         }
      }
      
      flvplayback_internal function finishAutoResize(param1:TimerEvent = null) : void
      {
         if(this.stateResponsive)
         {
            return;
         }
         this.flvplayback_internal::_hiddenForResize = false;
         super.visible = this.__visible;
         this.volume = this._volume;
         dispatchEvent(new AutoLayoutEvent(AutoLayoutEvent.AUTO_LAYOUT,false,false,this.flvplayback_internal::oldBounds,this.flvplayback_internal::oldRegistrationBounds));
         if(this._autoPlay)
         {
            if(this._ncMgr.isRTMP)
            {
               if(!this._isLive)
               {
                  this.flvplayback_internal::_currentPos = 0;
                  this.flvplayback_internal::_play(0);
               }
               if(this._state == VideoState.RESIZING)
               {
                  this.flvplayback_internal::setState(VideoState.LOADING);
                  this.flvplayback_internal::_cachedState = VideoState.PLAYING;
               }
            }
            else
            {
               this.flvplayback_internal::waitingForEnough = true;
               this.flvplayback_internal::_cachedState = this._state;
               this._state = VideoState.PAUSED;
               this.flvplayback_internal::checkReadyForPlay(this.bytesLoaded,this.bytesTotal);
               if(this.flvplayback_internal::waitingForEnough)
               {
                  this._state = this.flvplayback_internal::_cachedState;
                  this.flvplayback_internal::setState(VideoState.PAUSED);
               }
               else
               {
                  this.flvplayback_internal::_cachedState = VideoState.PLAYING;
               }
            }
         }
         else
         {
            this.flvplayback_internal::setState(VideoState.STOPPED);
         }
      }
      
      flvplayback_internal function _createStream() : void
      {
         this._ns = null;
         var _loc1_:NetStream = new NetStream(this._ncMgr.netConnection);
         if(this._ncMgr.isRTMP)
         {
            _loc1_.addEventListener(NetStatusEvent.NET_STATUS,this.flvplayback_internal::rtmpNetStatus);
         }
         else
         {
            _loc1_.addEventListener(NetStatusEvent.NET_STATUS,this.flvplayback_internal::httpNetStatus);
         }
         _loc1_.client = this.flvplayback_internal::createNetStreamClient();
         _loc1_.bufferTime = this._bufferTime;
         _loc1_.soundTransform = this.soundTransform;
         this._ns = _loc1_;
         attachNetStream(this._ns);
      }
      
      flvplayback_internal function _setUpStream() : void
      {
         if(!isNaN(this._ncMgr.streamLength) && this._ncMgr.streamLength >= 0)
         {
            this._streamLength = this._ncMgr.streamLength;
         }
         this._videoWidth = this._ncMgr.streamWidth >= 0 ? this._ncMgr.streamWidth : -1;
         this._videoHeight = this._ncMgr.streamHeight >= 0 ? this._ncMgr.streamHeight : -1;
         this.flvplayback_internal::_resizeImmediatelyOnMetadata = this._videoWidth >= 0 && this._videoHeight >= 0 || this._scaleMode == VideoScaleMode.EXACT_FIT;
         if(!this.flvplayback_internal::_hiddenForResize)
         {
            this.__visible = super.visible;
            super.visible = false;
            this._volume = this.volume;
            this.volume = 0;
            this.flvplayback_internal::_hiddenForResize = true;
         }
         this.flvplayback_internal::_hiddenForResizeMetadataDelay = 0;
         this.flvplayback_internal::_play(0);
         if(this.flvplayback_internal::_currentPos > 0)
         {
            this.flvplayback_internal::_seek(this.flvplayback_internal::_currentPos);
            this.flvplayback_internal::_currentPos = 0;
         }
         this.flvplayback_internal::_autoResizeTimer.reset();
         this.flvplayback_internal::_autoResizeTimer.start();
      }
      
      flvplayback_internal function doIdleTimeout(param1:TimerEvent) : void
      {
         this.close();
      }
      
      flvplayback_internal function flushQueuedCmds() : void
      {
         while(this.flvplayback_internal::_cmdQueue.length > 0)
         {
            this.flvplayback_internal::_cmdQueue.pop();
         }
      }
      
      flvplayback_internal function execQueuedCmds() : void
      {
         var nextCmd:Object = null;
         while(this.flvplayback_internal::_cmdQueue.length > 0 && (this.stateResponsive || this._state == VideoState.DISCONNECTED || this._state == VideoState.CONNECTION_ERROR) && (this.flvplayback_internal::_cmdQueue[0].url != null || this._state != VideoState.DISCONNECTED && this._state != VideoState.CONNECTION_ERROR))
         {
            try
            {
               nextCmd = this.flvplayback_internal::_cmdQueue.shift();
               this.flvplayback_internal::_cachedState = this._state;
               this._state = VideoState.flvplayback_internal::EXEC_QUEUED_CMD;
               switch(nextCmd.type)
               {
                  case QueuedCommand.PLAY:
                     this.play(nextCmd.url,nextCmd.time,nextCmd.isLive);
                     break;
                  case QueuedCommand.LOAD:
                     this.load(nextCmd.url,nextCmd.time,nextCmd.isLive);
                     break;
                  case QueuedCommand.PAUSE:
                     this.pause();
                     break;
                  case QueuedCommand.STOP:
                     this.stop();
                     break;
                  case QueuedCommand.SEEK:
                     this.seek(nextCmd.time);
                     break;
                  case QueuedCommand.PLAY_WHEN_ENOUGH:
                     this.playWhenEnoughDownloaded();
               }
            }
            finally
            {
               continue;
            }
            if(this._state == VideoState.flvplayback_internal::EXEC_QUEUED_CMD)
            {
               this._state = this.flvplayback_internal::_cachedState;
            }
            switch(§§pop())
            {
               case 0:
               default:
                  continue;
            }
         }
      }
      
      flvplayback_internal function queueCmd(param1:Number, param2:String = null, param3:Boolean = false, param4:Number = NaN) : void
      {
         this.flvplayback_internal::_cmdQueue.push(new QueuedCommand(param1,param2,param3,param4));
      }
   }
}

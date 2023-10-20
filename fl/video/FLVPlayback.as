package fl.video
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.Rectangle;
   import flash.media.*;
   import flash.net.*;
   import flash.utils.*;
   
   public class FLVPlayback extends Sprite
   {
      
      public static const VERSION:String = "2.1.0.23";
      
      public static const SHORT_VERSION:String = "2.1";
      
      flvplayback_internal static const DEFAULT_SKIN_SHOW_TIMER_INTERVAL:Number = 2000;
      
      flvplayback_internal static const skinShowTimerInterval:Number = flvplayback_internal::DEFAULT_SKIN_SHOW_TIMER_INTERVAL;
      
      public static const SEEK_TO_PREV_OFFSET_DEFAULT:Number = 1;
       
      
      public var boundingBox_mc:DisplayObject;
      
      protected var isLivePreview:Boolean;
      
      private var preview_mc:MovieClip;
      
      private var previewImage_mc:Loader;
      
      private var previewImageUrl:String;
      
      private var livePreviewWidth:Number;
      
      private var livePreviewHeight:Number;
      
      private var _componentInspectorSetting:Boolean;
      
      flvplayback_internal var videoPlayers:Array;
      
      flvplayback_internal var videoPlayerStates:Array;
      
      flvplayback_internal var videoPlayerStateDict:Dictionary;
      
      private var _activeVP:uint;
      
      private var _visibleVP:uint;
      
      private var _topVP:uint;
      
      flvplayback_internal var uiMgr:fl.video.UIManager;
      
      flvplayback_internal var cuePointMgrs:Array;
      
      flvplayback_internal var _firstStreamReady:Boolean;
      
      flvplayback_internal var _firstStreamShown:Boolean;
      
      flvplayback_internal var resizingNow:Boolean;
      
      flvplayback_internal var skinShowTimer:Timer;
      
      private var _align:String;
      
      private var _autoRewind:Boolean;
      
      private var _bufferTime:Number;
      
      private var _idleTimeout:Number;
      
      private var _aspectRatio:Boolean;
      
      private var _playheadUpdateInterval:Number;
      
      private var _progressInterval:Number;
      
      private var _origWidth:Number;
      
      private var _origHeight:Number;
      
      private var _scaleMode:String;
      
      private var _seekToPrevOffset:Number;
      
      private var _soundTransform:SoundTransform;
      
      private var _volume:Number;
      
      private var __forceNCMgr:fl.video.NCManager;
      
      public function FLVPlayback()
      {
         super();
         mouseEnabled = false;
         this.isLivePreview = parent != null && getQualifiedClassName(parent) == "fl.livepreview::LivePreviewParent";
         this.isLivePreview = false;
         this._componentInspectorSetting = false;
         var _loc1_:Number = rotation;
         rotation = 0;
         this._origWidth = super.width;
         this._origHeight = super.height;
         super.scaleX = 1;
         super.scaleY = 1;
         rotation = _loc1_;
         var _loc2_:VideoPlayer = new VideoPlayer(0,0);
         _loc2_.setSize(this._origWidth,this._origHeight);
         this.flvplayback_internal::videoPlayers = new Array();
         this.flvplayback_internal::videoPlayers[0] = _loc2_;
         this._align = _loc2_.align;
         this._autoRewind = _loc2_.autoRewind;
         this._scaleMode = _loc2_.scaleMode;
         this._bufferTime = _loc2_.bufferTime;
         this._idleTimeout = _loc2_.idleTimeout;
         this._playheadUpdateInterval = _loc2_.playheadUpdateInterval;
         this._progressInterval = _loc2_.progressInterval;
         this._soundTransform = _loc2_.soundTransform;
         this._volume = _loc2_.volume;
         this._seekToPrevOffset = SEEK_TO_PREV_OFFSET_DEFAULT;
         this.flvplayback_internal::_firstStreamReady = false;
         this.flvplayback_internal::_firstStreamShown = false;
         this.flvplayback_internal::resizingNow = false;
         if(this.flvplayback_internal::uiMgr == null)
         {
            this.flvplayback_internal::uiMgr = new fl.video.UIManager(this);
         }
         if(this.isLivePreview)
         {
            this.flvplayback_internal::uiMgr.visible = true;
         }
         this._activeVP = 0;
         this._visibleVP = 0;
         this._topVP = 0;
         this.flvplayback_internal::videoPlayerStates = new Array();
         this.flvplayback_internal::videoPlayerStateDict = new Dictionary(true);
         this.flvplayback_internal::cuePointMgrs = new Array();
         this.flvplayback_internal::createVideoPlayer(0);
         if(this.boundingBox_mc)
         {
            this.boundingBox_mc.visible = false;
            removeChild(this.boundingBox_mc);
            this.boundingBox_mc = null;
         }
         if(this.isLivePreview)
         {
            this.previewImageUrl = "";
            this.setSize(this._origWidth,this._origHeight);
         }
      }
      
      public function setSize(param1:Number, param2:Number) : void
      {
         var _loc6_:VideoPlayer = null;
         var _loc3_:Rectangle = new Rectangle(this.x,this.y,this.width,this.height);
         var _loc4_:Rectangle = new Rectangle(this.registrationX,this.registrationY,this.registrationWidth,this.registrationHeight);
         if(this.isLivePreview)
         {
            this.livePreviewWidth = param1;
            this.livePreviewHeight = param2;
            if(this.previewImage_mc != null)
            {
               this.previewImage_mc.width = param1;
               this.previewImage_mc.height = param2;
            }
            dispatchEvent(new LayoutEvent(LayoutEvent.LAYOUT,false,false,_loc3_,_loc4_));
            return;
         }
         this.flvplayback_internal::resizingNow = true;
         var _loc5_:int = 0;
         while(_loc5_ < this.flvplayback_internal::videoPlayers.length)
         {
            if((_loc6_ = this.flvplayback_internal::videoPlayers[_loc5_]) != null)
            {
               _loc6_.setSize(param1,param2);
            }
            _loc5_++;
         }
         this.flvplayback_internal::resizingNow = false;
         dispatchEvent(new LayoutEvent(LayoutEvent.LAYOUT,false,false,_loc3_,_loc4_));
      }
      
      public function setScale(param1:Number, param2:Number) : void
      {
         var _loc6_:VideoPlayer = null;
         var _loc3_:Rectangle = new Rectangle(this.x,this.y,this.width,this.height);
         var _loc4_:Rectangle = new Rectangle(this.registrationX,this.registrationY,this.registrationWidth,this.registrationHeight);
         this.flvplayback_internal::resizingNow = true;
         var _loc5_:int = 0;
         while(_loc5_ < this.flvplayback_internal::videoPlayers.length)
         {
            if((_loc6_ = this.flvplayback_internal::videoPlayers[_loc5_]) !== null)
            {
               _loc6_.setSize(this._origWidth * param1,this._origWidth * param2);
            }
            _loc5_++;
         }
         this.flvplayback_internal::resizingNow = false;
         dispatchEvent(new LayoutEvent(LayoutEvent.LAYOUT,false,false,_loc3_,_loc4_));
      }
      
      flvplayback_internal function handleAutoLayoutEvent(param1:AutoLayoutEvent) : void
      {
         var _loc4_:Rectangle = null;
         var _loc5_:Rectangle = null;
         var _loc2_:VideoPlayerState = this.flvplayback_internal::videoPlayerStateDict[param1.currentTarget];
         var _loc3_:AutoLayoutEvent = AutoLayoutEvent(param1.clone());
         _loc3_.oldBounds.x += super.x;
         _loc3_.oldBounds.y += super.y;
         _loc3_.oldRegistrationBounds.x += super.y;
         _loc3_.oldRegistrationBounds.y += super.y;
         _loc3_.vp = _loc2_.index;
         dispatchEvent(_loc3_);
         if(!this.flvplayback_internal::resizingNow && _loc2_.index == this._visibleVP)
         {
            _loc4_ = Rectangle(param1.oldBounds.clone());
            _loc5_ = Rectangle(param1.oldRegistrationBounds.clone());
            _loc4_.x += super.x;
            _loc4_.y += super.y;
            _loc5_.x += super.y;
            _loc5_.y += super.y;
            dispatchEvent(new LayoutEvent(LayoutEvent.LAYOUT,false,false,_loc4_,_loc5_));
         }
      }
      
      flvplayback_internal function handleMetadataEvent(param1:MetadataEvent) : void
      {
         var _loc2_:VideoPlayerState = this.flvplayback_internal::videoPlayerStateDict[param1.currentTarget];
         var _loc3_:CuePointManager = this.flvplayback_internal::cuePointMgrs[_loc2_.index];
         switch(param1.type)
         {
            case MetadataEvent.METADATA_RECEIVED:
               _loc3_.processFLVCuePoints(param1.info.cuePoints);
               break;
            case MetadataEvent.CUE_POINT:
               if(!_loc3_.isFLVCuePointEnabled(param1.info))
               {
                  return;
               }
               break;
         }
         var _loc4_:MetadataEvent;
         (_loc4_ = MetadataEvent(param1.clone())).vp = _loc2_.index;
         dispatchEvent(_loc4_);
      }
      
      flvplayback_internal function handleVideoProgressEvent(param1:VideoProgressEvent) : void
      {
         var _loc2_:VideoPlayerState = this.flvplayback_internal::videoPlayerStateDict[param1.currentTarget];
         var _loc3_:VideoProgressEvent = VideoProgressEvent(param1.clone());
         _loc3_.vp = _loc2_.index;
         dispatchEvent(_loc3_);
      }
      
      flvplayback_internal function handleVideoEvent(param1:fl.video.VideoEvent) : void
      {
         var _loc6_:Number = NaN;
         var _loc2_:VideoPlayerState = this.flvplayback_internal::videoPlayerStateDict[param1.currentTarget];
         var _loc3_:CuePointManager = this.flvplayback_internal::cuePointMgrs[_loc2_.index];
         var _loc4_:fl.video.VideoEvent;
         (_loc4_ = VideoEvent(param1.clone())).vp = _loc2_.index;
         var _loc5_:String = _loc2_.index == this._visibleVP && this.scrubbing ? VideoState.SEEKING : param1.state;
         loop0:
         switch(param1.type)
         {
            case fl.video.VideoEvent.AUTO_REWOUND:
               dispatchEvent(_loc4_);
               dispatchEvent(new fl.video.VideoEvent(fl.video.VideoEvent.REWIND,false,false,_loc5_,param1.playheadTime,_loc2_.index));
               _loc3_.resetASCuePointIndex(param1.playheadTime);
               break;
            case fl.video.VideoEvent.PLAYHEAD_UPDATE:
               _loc4_.state = _loc5_;
               dispatchEvent(_loc4_);
               if(!isNaN(_loc2_.preSeekTime) && param1.state != VideoState.SEEKING)
               {
                  _loc6_ = _loc2_.preSeekTime;
                  _loc2_.preSeekTime = NaN;
                  _loc3_.resetASCuePointIndex(param1.playheadTime);
                  dispatchEvent(new fl.video.VideoEvent(fl.video.VideoEvent.SEEKED,false,false,param1.state,param1.playheadTime,_loc2_.index));
                  if(_loc6_ < param1.playheadTime)
                  {
                     dispatchEvent(new fl.video.VideoEvent(fl.video.VideoEvent.FAST_FORWARD,false,false,param1.state,param1.playheadTime,_loc2_.index));
                  }
                  else if(_loc6_ > param1.playheadTime)
                  {
                     dispatchEvent(new fl.video.VideoEvent(fl.video.VideoEvent.REWIND,false,false,param1.state,param1.playheadTime,_loc2_.index));
                  }
               }
               _loc3_.dispatchASCuePoints();
               break;
            case fl.video.VideoEvent.STATE_CHANGE:
               if(_loc2_.index == this._visibleVP && this.scrubbing)
               {
                  break;
               }
               if(param1.state == VideoState.RESIZING)
               {
                  break;
               }
               if(_loc2_.prevState == VideoState.LOADING && _loc2_.autoPlay && param1.state == VideoState.STOPPED)
               {
                  return;
               }
               if(param1.state == VideoState.CONNECTION_ERROR && param1.vp == this._visibleVP && !this.flvplayback_internal::_firstStreamShown && this.flvplayback_internal::uiMgr.skinReady)
               {
                  this.flvplayback_internal::showFirstStream();
                  this.flvplayback_internal::uiMgr.visible = true;
                  if(this.flvplayback_internal::uiMgr.skin == "")
                  {
                     this.flvplayback_internal::uiMgr.flvplayback_internal::hookUpCustomComponents();
                  }
                  if(this.flvplayback_internal::skinShowTimer != null)
                  {
                     this.flvplayback_internal::skinShowTimer.reset();
                     this.flvplayback_internal::skinShowTimer = null;
                  }
               }
               _loc2_.prevState = param1.state;
               _loc4_.state = _loc5_;
               dispatchEvent(_loc4_);
               if(_loc2_.owner.state != param1.state)
               {
                  return;
               }
               switch(param1.state)
               {
                  case VideoState.BUFFERING:
                     dispatchEvent(new fl.video.VideoEvent(fl.video.VideoEvent.BUFFERING_STATE_ENTERED,false,false,_loc5_,param1.playheadTime,_loc2_.index));
                     break loop0;
                  case VideoState.PAUSED:
                     dispatchEvent(new fl.video.VideoEvent(fl.video.VideoEvent.PAUSED_STATE_ENTERED,false,false,_loc5_,param1.playheadTime,_loc2_.index));
                     break loop0;
                  case VideoState.PLAYING:
                     dispatchEvent(new fl.video.VideoEvent(fl.video.VideoEvent.PLAYING_STATE_ENTERED,false,false,_loc5_,param1.playheadTime,_loc2_.index));
                     break loop0;
                  case VideoState.STOPPED:
                     dispatchEvent(new fl.video.VideoEvent(fl.video.VideoEvent.STOPPED_STATE_ENTERED,false,false,_loc5_,param1.playheadTime,_loc2_.index));
               }
               break;
            case fl.video.VideoEvent.READY:
               if(!this.flvplayback_internal::_firstStreamReady)
               {
                  if(_loc2_.index == this._visibleVP)
                  {
                     this.flvplayback_internal::_firstStreamReady = true;
                     if(this.flvplayback_internal::uiMgr.skinReady && !this.flvplayback_internal::_firstStreamShown)
                     {
                        this.flvplayback_internal::uiMgr.visible = true;
                        if(this.flvplayback_internal::uiMgr.skin == "")
                        {
                           this.flvplayback_internal::uiMgr.flvplayback_internal::hookUpCustomComponents();
                        }
                        this.flvplayback_internal::showFirstStream();
                     }
                  }
               }
               else if(this.flvplayback_internal::_firstStreamShown && param1.state == VideoState.STOPPED && _loc2_.autoPlay)
               {
                  if(_loc2_.owner.isRTMP)
                  {
                     _loc2_.owner.play();
                  }
                  else
                  {
                     _loc2_.prevState = VideoState.STOPPED;
                     _loc2_.owner.playWhenEnoughDownloaded();
                  }
               }
               _loc4_.state = _loc5_;
               dispatchEvent(_loc4_);
               break;
            case fl.video.VideoEvent.CLOSE:
            case fl.video.VideoEvent.COMPLETE:
               _loc4_.state = _loc5_;
               dispatchEvent(_loc4_);
         }
      }
      
      public function load(param1:String, param2:Number = NaN, param3:Boolean = false) : void
      {
         if(param1 == null || param1.length == 0)
         {
            return;
         }
         if(param1 == this.source)
         {
            return;
         }
         this.autoPlay = false;
         this.totalTime = param2;
         this.isLive = param3;
         this.source = param1;
      }
      
      public function play(param1:String = null, param2:Number = NaN, param3:Boolean = false) : void
      {
         var _loc4_:VideoPlayerState = null;
         var _loc5_:VideoPlayer = null;
         if(param1 == null)
         {
            if(!this.flvplayback_internal::_firstStreamShown)
            {
               _loc4_ = this.flvplayback_internal::videoPlayerStates[this._activeVP];
               this.flvplayback_internal::queueCmd(_loc4_,QueuedCommand.PLAY);
            }
            else
            {
               (_loc5_ = this.flvplayback_internal::videoPlayers[this._activeVP]).play();
            }
         }
         else
         {
            if(param1 == this.source)
            {
               return;
            }
            this.autoPlay = true;
            this.totalTime = param2;
            this.isLive = param3;
            this.source = param1;
         }
      }
      
      public function playWhenEnoughDownloaded() : void
      {
         var _loc1_:VideoPlayerState = null;
         var _loc2_:VideoPlayer = null;
         if(!this.flvplayback_internal::_firstStreamShown)
         {
            _loc1_ = this.flvplayback_internal::videoPlayerStates[this._activeVP];
            this.flvplayback_internal::queueCmd(_loc1_,QueuedCommand.PLAY_WHEN_ENOUGH);
         }
         else
         {
            _loc2_ = this.flvplayback_internal::videoPlayers[this._activeVP];
            _loc2_.playWhenEnoughDownloaded();
         }
      }
      
      public function pause() : void
      {
         var _loc1_:VideoPlayerState = null;
         var _loc2_:VideoPlayer = null;
         if(!this.flvplayback_internal::_firstStreamShown)
         {
            _loc1_ = this.flvplayback_internal::videoPlayerStates[this._activeVP];
            this.flvplayback_internal::queueCmd(_loc1_,QueuedCommand.PAUSE);
         }
         else
         {
            _loc2_ = this.flvplayback_internal::videoPlayers[this._activeVP];
            _loc2_.pause();
         }
      }
      
      public function stop() : void
      {
         var _loc1_:VideoPlayerState = null;
         var _loc2_:VideoPlayer = null;
         if(!this.flvplayback_internal::_firstStreamShown)
         {
            _loc1_ = this.flvplayback_internal::videoPlayerStates[this._activeVP];
            this.flvplayback_internal::queueCmd(_loc1_,QueuedCommand.STOP);
         }
         else
         {
            _loc2_ = this.flvplayback_internal::videoPlayers[this._activeVP];
            _loc2_.stop();
         }
      }
      
      public function seek(param1:Number) : void
      {
         var _loc3_:VideoPlayer = null;
         var _loc2_:VideoPlayerState = this.flvplayback_internal::videoPlayerStates[this._activeVP];
         if(!this.flvplayback_internal::_firstStreamShown)
         {
            _loc2_.preSeekTime = 0;
            this.flvplayback_internal::queueCmd(_loc2_,QueuedCommand.SEEK,param1);
         }
         else
         {
            _loc2_.preSeekTime = this.playheadTime;
            _loc3_ = this.flvplayback_internal::videoPlayers[this._activeVP];
            _loc3_.seek(param1);
         }
      }
      
      public function seekSeconds(param1:Number) : void
      {
         this.seek(param1);
      }
      
      public function seekPercent(param1:Number) : void
      {
         var _loc2_:VideoPlayer = this.flvplayback_internal::videoPlayers[this._activeVP];
         if(isNaN(param1) || param1 < 0 || param1 > 100 || isNaN(_loc2_.totalTime) || _loc2_.totalTime <= 0)
         {
            throw new VideoError(VideoError.INVALID_SEEK);
         }
         this.seek(_loc2_.totalTime * param1 / 100);
      }
      
      public function get playheadPercentage() : Number
      {
         var _loc1_:VideoPlayer = this.flvplayback_internal::videoPlayers[this._activeVP];
         if(isNaN(_loc1_.totalTime))
         {
            return NaN;
         }
         return _loc1_.playheadTime / _loc1_.totalTime * 100;
      }
      
      public function set playheadPercentage(param1:Number) : void
      {
         this.seekPercent(param1);
      }
      
      public function set preview(param1:String) : void
      {
         trace("FLVPLAYBACK preview");
         if(!this.isLivePreview)
         {
            return;
         }
      }
      
      public function seekToNavCuePoint(param1:*) : void
      {
         var _loc2_:Object = null;
         if(param1 is String)
         {
            _loc2_ = {"name":String(param1)};
         }
         else if(param1 is Number)
         {
            _loc2_ = {"time":Number(param1)};
         }
         else
         {
            _loc2_ = param1;
         }
         if(_loc2_.name == undefined)
         {
            this.seekToNextNavCuePoint(_loc2_.time);
            return;
         }
         if(isNaN(_loc2_.time))
         {
            _loc2_.time = 0;
         }
         var _loc3_:Object = this.findNearestCuePoint(param1,CuePointType.NAVIGATION);
         while(_loc3_ != null && (_loc3_.time < _loc2_.time || !this.isFLVCuePointEnabled(_loc3_)))
         {
            _loc3_ = this.findNextCuePointWithName(_loc3_);
         }
         if(_loc3_ == null)
         {
            throw new VideoError(VideoError.INVALID_SEEK);
         }
         this.seek(_loc3_.time);
      }
      
      public function seekToNextNavCuePoint(param1:Number = NaN) : void
      {
         var _loc2_:VideoPlayer = this.flvplayback_internal::videoPlayers[this._activeVP];
         if(isNaN(param1) || param1 < 0)
         {
            param1 = _loc2_.playheadTime + 0.001;
         }
         var _loc3_:Object = this.findNearestCuePoint(param1,CuePointType.NAVIGATION);
         if(_loc3_ == null)
         {
            this.seek(_loc2_.totalTime);
            return;
         }
         var _loc4_:Number = Number(_loc3_.index);
         if(_loc3_.time < param1)
         {
            _loc4_++;
         }
         while(_loc4_ < _loc3_.array.length && !this.isFLVCuePointEnabled(_loc3_.array[_loc4_]))
         {
            _loc4_++;
         }
         if(_loc4_ >= _loc3_.array.length)
         {
            param1 = _loc2_.totalTime;
            if(_loc3_.array[_loc3_.array.length - 1].time > param1)
            {
               param1 = Number(_loc3_.array[_loc3_.array.length - 1]);
            }
            this.seek(param1);
         }
         else
         {
            this.seek(_loc3_.array[_loc4_].time);
         }
      }
      
      public function seekToPrevNavCuePoint(param1:Number = NaN) : void
      {
         var _loc4_:VideoPlayer = null;
         if(isNaN(param1) || param1 < 0)
         {
            param1 = (_loc4_ = this.flvplayback_internal::videoPlayers[this._activeVP]).playheadTime;
         }
         var _loc2_:Object = this.findNearestCuePoint(param1,CuePointType.NAVIGATION);
         if(_loc2_ == null)
         {
            this.seek(0);
            return;
         }
         var _loc3_:Number = Number(_loc2_.index);
         while(_loc3_ >= 0 && (!this.isFLVCuePointEnabled(_loc2_.array[_loc3_]) || _loc2_.array[_loc3_].time >= param1 - this._seekToPrevOffset))
         {
            _loc3_--;
         }
         if(_loc3_ < 0)
         {
            this.seek(0);
         }
         else
         {
            this.seek(_loc2_.array[_loc3_].time);
         }
      }
      
      public function addASCuePoint(param1:*, param2:String = null, param3:Object = null) : Object
      {
         var _loc4_:CuePointManager;
         return (_loc4_ = this.flvplayback_internal::cuePointMgrs[this._activeVP]).addASCuePoint(param1,param2,param3);
      }
      
      public function removeASCuePoint(param1:*) : Object
      {
         var _loc2_:CuePointManager = this.flvplayback_internal::cuePointMgrs[this._activeVP];
         return _loc2_.removeASCuePoint(param1);
      }
      
      public function findCuePoint(param1:*, param2:String = "all") : Object
      {
         var _loc3_:CuePointManager = this.flvplayback_internal::cuePointMgrs[this._activeVP];
         switch(param2)
         {
            case "event":
               return _loc3_.flvplayback_internal::getCuePoint(_loc3_.flvplayback_internal::eventCuePoints,false,param1);
            case "navigation":
               return _loc3_.flvplayback_internal::getCuePoint(_loc3_.flvplayback_internal::navCuePoints,false,param1);
            case "flv":
               return _loc3_.flvplayback_internal::getCuePoint(_loc3_.flvplayback_internal::flvCuePoints,false,param1);
            case "actionscript":
               return _loc3_.flvplayback_internal::getCuePoint(_loc3_.flvplayback_internal::asCuePoints,false,param1);
            case "all":
         }
         return _loc3_.flvplayback_internal::getCuePoint(_loc3_.flvplayback_internal::allCuePoints,false,param1);
      }
      
      public function findNearestCuePoint(param1:*, param2:String = "all") : Object
      {
         var _loc3_:CuePointManager = this.flvplayback_internal::cuePointMgrs[this._activeVP];
         switch(param2)
         {
            case "event":
               return _loc3_.flvplayback_internal::getCuePoint(_loc3_.flvplayback_internal::eventCuePoints,true,param1);
            case "navigation":
               return _loc3_.flvplayback_internal::getCuePoint(_loc3_.flvplayback_internal::navCuePoints,true,param1);
            case "flv":
               return _loc3_.flvplayback_internal::getCuePoint(_loc3_.flvplayback_internal::flvCuePoints,true,param1);
            case "actionscript":
               return _loc3_.flvplayback_internal::getCuePoint(_loc3_.flvplayback_internal::asCuePoints,true,param1);
            case "all":
         }
         return _loc3_.flvplayback_internal::getCuePoint(_loc3_.flvplayback_internal::allCuePoints,true,param1);
      }
      
      public function findNextCuePointWithName(param1:Object) : Object
      {
         var _loc2_:CuePointManager = this.flvplayback_internal::cuePointMgrs[this._activeVP];
         return _loc2_.flvplayback_internal::getNextCuePointWithName(param1);
      }
      
      public function setFLVCuePointEnabled(param1:Boolean, param2:*) : Number
      {
         var _loc3_:CuePointManager = this.flvplayback_internal::cuePointMgrs[this._activeVP];
         return _loc3_.setFLVCuePointEnabled(param1,param2);
      }
      
      public function isFLVCuePointEnabled(param1:*) : Boolean
      {
         var _loc2_:CuePointManager = this.flvplayback_internal::cuePointMgrs[this._activeVP];
         return _loc2_.isFLVCuePointEnabled(param1);
      }
      
      public function bringVideoPlayerToFront(param1:uint) : void
      {
         var vp:VideoPlayer;
         var moved:Boolean;
         var skinDepth:int = 0;
         var index:uint = param1;
         if(index == this._topVP)
         {
            return;
         }
         vp = this.flvplayback_internal::videoPlayers[index];
         if(vp == null)
         {
            this.flvplayback_internal::createVideoPlayer(index);
            vp = this.flvplayback_internal::videoPlayers[index];
         }
         moved = false;
         if(this.flvplayback_internal::uiMgr.flvplayback_internal::skin_mc != null)
         {
            try
            {
               skinDepth = getChildIndex(this.flvplayback_internal::uiMgr.flvplayback_internal::skin_mc);
               if(skinDepth > 0)
               {
                  setChildIndex(vp,skinDepth - 1);
                  moved = true;
               }
            }
            catch(err:Error)
            {
            }
         }
         if(!moved)
         {
            setChildIndex(vp,numChildren - 1);
         }
         this._topVP = index;
      }
      
      public function getVideoPlayer(param1:Number) : VideoPlayer
      {
         return this.flvplayback_internal::videoPlayers[param1];
      }
      
      public function closeVideoPlayer(param1:uint) : void
      {
         if(param1 == 0)
         {
            throw new VideoError(VideoError.DELETE_DEFAULT_PLAYER);
         }
         if(this.flvplayback_internal::videoPlayers[param1] == undefined)
         {
            return;
         }
         var _loc2_:VideoPlayer = this.flvplayback_internal::videoPlayers[param1];
         if(this._visibleVP == param1)
         {
            this.visibleVideoPlayerIndex = 0;
         }
         if(this._activeVP == param1)
         {
            this.activeVideoPlayerIndex = 0;
         }
         removeChild(_loc2_);
         _loc2_.close();
         delete this.flvplayback_internal::videoPlayers[param1];
         delete this.flvplayback_internal::videoPlayerStates[param1];
         delete this.flvplayback_internal::videoPlayerStateDict[_loc2_];
      }
      
      public function enterFullScreenDisplayState() : void
      {
         this.flvplayback_internal::uiMgr.enterFullScreenDisplayState();
      }
      
      public function set componentInspectorSetting(param1:Boolean) : void
      {
         this._componentInspectorSetting = param1;
      }
      
      public function get activeVideoPlayerIndex() : uint
      {
         return this._activeVP;
      }
      
      public function set activeVideoPlayerIndex(param1:uint) : void
      {
         if(this._activeVP == param1)
         {
            return;
         }
         this._activeVP = param1;
         if(this.flvplayback_internal::videoPlayers[this._activeVP] == undefined)
         {
            this.flvplayback_internal::createVideoPlayer(this._activeVP);
         }
      }
      
      public function get align() : String
      {
         var _loc1_:VideoPlayer = this.flvplayback_internal::videoPlayers[this._activeVP];
         return _loc1_.align;
      }
      
      public function set align(param1:String) : void
      {
         if(this._activeVP == 0)
         {
            this._align = param1;
         }
         var _loc2_:VideoPlayer = this.flvplayback_internal::videoPlayers[this._activeVP];
         _loc2_.align = param1;
      }
      
      public function get autoPlay() : Boolean
      {
         var _loc1_:VideoPlayerState = this.flvplayback_internal::videoPlayerStates[this._activeVP];
         return _loc1_.autoPlay;
      }
      
      public function set autoPlay(param1:Boolean) : void
      {
         var _loc2_:VideoPlayerState = this.flvplayback_internal::videoPlayerStates[this._activeVP];
         _loc2_.autoPlay = param1;
      }
      
      public function get autoRewind() : Boolean
      {
         var _loc1_:VideoPlayer = this.flvplayback_internal::videoPlayers[this._activeVP];
         return _loc1_.autoRewind;
      }
      
      public function set autoRewind(param1:Boolean) : void
      {
         if(this._activeVP == 0)
         {
            this._autoRewind = param1;
         }
         var _loc2_:VideoPlayer = this.flvplayback_internal::videoPlayers[this._activeVP];
         _loc2_.autoRewind = param1;
      }
      
      public function get bitrate() : Number
      {
         return this.ncMgr.bitrate;
      }
      
      public function set bitrate(param1:Number) : void
      {
         this.ncMgr.bitrate = param1;
      }
      
      public function get buffering() : Boolean
      {
         return this.state == VideoState.BUFFERING;
      }
      
      public function get bufferingBar() : Sprite
      {
         return this.flvplayback_internal::uiMgr.getControl(fl.video.UIManager.BUFFERING_BAR);
      }
      
      public function set bufferingBar(param1:Sprite) : void
      {
         this.flvplayback_internal::uiMgr.setControl(fl.video.UIManager.BUFFERING_BAR,param1);
      }
      
      public function get bufferingBarHidesAndDisablesOthers() : Boolean
      {
         return this.flvplayback_internal::uiMgr.bufferingBarHidesAndDisablesOthers;
      }
      
      public function set bufferingBarHidesAndDisablesOthers(param1:Boolean) : void
      {
         this.flvplayback_internal::uiMgr.bufferingBarHidesAndDisablesOthers = param1;
      }
      
      public function get backButton() : Sprite
      {
         return this.flvplayback_internal::uiMgr.getControl(fl.video.UIManager.BACK_BUTTON);
      }
      
      public function set backButton(param1:Sprite) : void
      {
         this.flvplayback_internal::uiMgr.setControl(fl.video.UIManager.BACK_BUTTON,param1);
      }
      
      public function get bufferTime() : Number
      {
         var _loc1_:VideoPlayer = this.flvplayback_internal::videoPlayers[this._activeVP];
         return _loc1_.bufferTime;
      }
      
      public function set bufferTime(param1:Number) : void
      {
         var _loc2_:VideoPlayer = this.flvplayback_internal::videoPlayers[this._activeVP];
         _loc2_.bufferTime = param1;
      }
      
      public function get bytesLoaded() : uint
      {
         var _loc1_:VideoPlayer = this.flvplayback_internal::videoPlayers[this._activeVP];
         return _loc1_.bytesLoaded;
      }
      
      public function get bytesTotal() : uint
      {
         var _loc1_:VideoPlayer = this.flvplayback_internal::videoPlayers[this._activeVP];
         return _loc1_.bytesTotal;
      }
      
      public function get source() : String
      {
         var _loc1_:VideoPlayerState = this.flvplayback_internal::videoPlayerStates[this._activeVP];
         if(_loc1_.isWaiting)
         {
            return _loc1_.url;
         }
         var _loc2_:VideoPlayer = this.flvplayback_internal::videoPlayers[this._activeVP];
         return _loc2_.source;
      }
      
      public function set source(param1:String) : void
      {
         var _loc2_:VideoPlayerState = null;
         var _loc3_:CuePointManager = null;
         if(this.isLivePreview)
         {
            return;
         }
         if(param1 == null)
         {
            param1 = "";
         }
         if(this._componentInspectorSetting)
         {
            _loc2_ = this.flvplayback_internal::videoPlayerStates[this._activeVP];
            _loc2_.url = param1;
            if(param1.length > 0)
            {
               _loc2_.isWaiting = true;
               addEventListener(Event.ENTER_FRAME,this.doContentPathConnect);
            }
         }
         else
         {
            if(this.source == param1)
            {
               return;
            }
            _loc3_ = this.flvplayback_internal::cuePointMgrs[this._activeVP];
            _loc3_.reset();
            _loc2_ = this.flvplayback_internal::videoPlayerStates[this._activeVP];
            _loc2_.url = param1;
            _loc2_.isWaiting = true;
            this.doContentPathConnect(this._activeVP);
         }
      }
      
      public function set cuePoints(param1:Array) : void
      {
         if(!this._componentInspectorSetting)
         {
            return;
         }
         this.flvplayback_internal::cuePointMgrs[0].processCuePointsProperty(param1);
      }
      
      public function get forwardButton() : Sprite
      {
         return this.flvplayback_internal::uiMgr.getControl(fl.video.UIManager.FORWARD_BUTTON);
      }
      
      public function set forwardButton(param1:Sprite) : void
      {
         this.flvplayback_internal::uiMgr.setControl(fl.video.UIManager.FORWARD_BUTTON,param1);
      }
      
      public function get fullScreenBackgroundColor() : uint
      {
         return this.flvplayback_internal::uiMgr.fullScreenBackgroundColor;
      }
      
      public function set fullScreenBackgroundColor(param1:uint) : void
      {
         this.flvplayback_internal::uiMgr.fullScreenBackgroundColor = param1;
      }
      
      public function get fullScreenButton() : Sprite
      {
         return this.flvplayback_internal::uiMgr.getControl(fl.video.UIManager.FULL_SCREEN_BUTTON);
      }
      
      public function set fullScreenButton(param1:Sprite) : void
      {
         this.flvplayback_internal::uiMgr.setControl(fl.video.UIManager.FULL_SCREEN_BUTTON,param1);
      }
      
      public function get fullScreenSkinDelay() : int
      {
         return this.flvplayback_internal::uiMgr.fullScreenSkinDelay;
      }
      
      public function set fullScreenSkinDelay(param1:int) : void
      {
         this.flvplayback_internal::uiMgr.fullScreenSkinDelay = param1;
      }
      
      public function get fullScreenTakeOver() : Boolean
      {
         return this.flvplayback_internal::uiMgr.fullScreenTakeOver;
      }
      
      public function set fullScreenTakeOver(param1:Boolean) : void
      {
         this.flvplayback_internal::uiMgr.fullScreenTakeOver = param1;
      }
      
      override public function get height() : Number
      {
         if(this.isLivePreview)
         {
            return this.livePreviewHeight;
         }
         var _loc1_:VideoPlayer = this.flvplayback_internal::videoPlayers[this._visibleVP];
         return _loc1_.height;
      }
      
      override public function set height(param1:Number) : void
      {
         var _loc5_:VideoPlayer = null;
         if(this.isLivePreview)
         {
            this.setSize(this.width,param1);
            return;
         }
         var _loc2_:Rectangle = new Rectangle(this.x,this.y,this.width,this.height);
         var _loc3_:Rectangle = new Rectangle(this.registrationX,this.registrationY,this.registrationWidth,this.registrationHeight);
         this.flvplayback_internal::resizingNow = true;
         var _loc4_:int = 0;
         while(_loc4_ < this.flvplayback_internal::videoPlayers.length)
         {
            if((_loc5_ = this.flvplayback_internal::videoPlayers[_loc4_]) != null)
            {
               _loc5_.height = param1;
            }
            _loc4_++;
         }
         this.flvplayback_internal::resizingNow = false;
         dispatchEvent(new LayoutEvent(LayoutEvent.LAYOUT,false,false,_loc2_,_loc3_));
      }
      
      public function get idleTimeout() : Number
      {
         var _loc1_:VideoPlayer = this.flvplayback_internal::videoPlayers[this._activeVP];
         return _loc1_.idleTimeout;
      }
      
      public function set idleTimeout(param1:Number) : void
      {
         if(this._activeVP == 0)
         {
            this._idleTimeout = param1;
         }
         var _loc2_:VideoPlayer = this.flvplayback_internal::videoPlayers[this._activeVP];
         _loc2_.idleTimeout = param1;
      }
      
      public function get isRTMP() : Boolean
      {
         if(this.isLivePreview)
         {
            return true;
         }
         var _loc1_:VideoPlayer = this.flvplayback_internal::videoPlayers[this._activeVP];
         return _loc1_.isRTMP;
      }
      
      public function get isLive() : Boolean
      {
         var _loc1_:VideoPlayerState = this.flvplayback_internal::videoPlayerStates[this._activeVP];
         if(_loc1_.isLiveSet)
         {
            return _loc1_.isLive;
         }
         var _loc2_:VideoPlayer = this.flvplayback_internal::videoPlayers[this._activeVP];
         return _loc2_.isLive;
      }
      
      public function set isLive(param1:Boolean) : void
      {
         var _loc2_:VideoPlayerState = this.flvplayback_internal::videoPlayerStates[this._activeVP];
         _loc2_.isLive = param1;
         _loc2_.isLiveSet = true;
      }
      
      public function get metadata() : Object
      {
         var _loc1_:VideoPlayer = this.flvplayback_internal::videoPlayers[this._activeVP];
         return _loc1_.metadata;
      }
      
      public function get metadataLoaded() : Boolean
      {
         var _loc1_:CuePointManager = this.flvplayback_internal::cuePointMgrs[this._activeVP];
         return _loc1_.metadataLoaded;
      }
      
      public function get muteButton() : Sprite
      {
         return this.flvplayback_internal::uiMgr.getControl(fl.video.UIManager.MUTE_BUTTON);
      }
      
      public function set muteButton(param1:Sprite) : void
      {
         this.flvplayback_internal::uiMgr.setControl(fl.video.UIManager.MUTE_BUTTON,param1);
      }
      
      public function get ncMgr() : INCManager
      {
         var _loc1_:VideoPlayer = this.flvplayback_internal::videoPlayers[this._activeVP];
         return _loc1_.ncMgr;
      }
      
      public function get pauseButton() : Sprite
      {
         return this.flvplayback_internal::uiMgr.getControl(fl.video.UIManager.PAUSE_BUTTON);
      }
      
      public function set pauseButton(param1:Sprite) : void
      {
         this.flvplayback_internal::uiMgr.setControl(fl.video.UIManager.PAUSE_BUTTON,param1);
      }
      
      public function get paused() : Boolean
      {
         return this.state == VideoState.PAUSED;
      }
      
      public function get playButton() : Sprite
      {
         return this.flvplayback_internal::uiMgr.getControl(fl.video.UIManager.PLAY_BUTTON);
      }
      
      public function set playButton(param1:Sprite) : void
      {
         this.flvplayback_internal::uiMgr.setControl(fl.video.UIManager.PLAY_BUTTON,param1);
      }
      
      public function get playheadTime() : Number
      {
         var _loc1_:VideoPlayer = this.flvplayback_internal::videoPlayers[this._activeVP];
         return _loc1_.playheadTime;
      }
      
      public function set playheadTime(param1:Number) : void
      {
         this.seek(param1);
      }
      
      public function get playheadUpdateInterval() : Number
      {
         var _loc1_:VideoPlayer = this.flvplayback_internal::videoPlayers[this._activeVP];
         return _loc1_.playheadUpdateInterval;
      }
      
      public function set playheadUpdateInterval(param1:Number) : void
      {
         if(this._activeVP == 0)
         {
            this._playheadUpdateInterval = param1;
         }
         var _loc2_:CuePointManager = this.flvplayback_internal::cuePointMgrs[this._activeVP];
         _loc2_.playheadUpdateInterval = param1;
         var _loc3_:VideoPlayer = this.flvplayback_internal::videoPlayers[this._activeVP];
         _loc3_.playheadUpdateInterval = param1;
      }
      
      public function get playing() : Boolean
      {
         return this.state == VideoState.PLAYING;
      }
      
      public function get playPauseButton() : Sprite
      {
         return this.flvplayback_internal::uiMgr.getControl(fl.video.UIManager.PLAY_PAUSE_BUTTON);
      }
      
      public function set playPauseButton(param1:Sprite) : void
      {
         this.flvplayback_internal::uiMgr.setControl(fl.video.UIManager.PLAY_PAUSE_BUTTON,param1);
      }
      
      public function get preferredHeight() : int
      {
         var _loc1_:VideoPlayer = this.flvplayback_internal::videoPlayers[this._activeVP];
         return _loc1_.videoHeight;
      }
      
      public function get preferredWidth() : int
      {
         var _loc1_:VideoPlayer = this.flvplayback_internal::videoPlayers[this._activeVP];
         return _loc1_.videoWidth;
      }
      
      public function get progressInterval() : Number
      {
         var _loc1_:VideoPlayer = this.flvplayback_internal::videoPlayers[this._activeVP];
         return _loc1_.progressInterval;
      }
      
      public function set progressInterval(param1:Number) : void
      {
         if(this._activeVP == 0)
         {
            this._progressInterval = param1;
         }
         var _loc2_:VideoPlayer = this.flvplayback_internal::videoPlayers[this._activeVP];
         _loc2_.progressInterval = param1;
      }
      
      public function get registrationX() : Number
      {
         return super.x;
      }
      
      public function set registrationX(param1:Number) : void
      {
         super.x = param1;
      }
      
      public function get registrationY() : Number
      {
         return super.y;
      }
      
      public function set registrationY(param1:Number) : void
      {
         super.y = param1;
      }
      
      public function get registrationWidth() : Number
      {
         var _loc1_:VideoPlayer = this.flvplayback_internal::videoPlayers[this._visibleVP];
         return _loc1_.registrationWidth;
      }
      
      public function set registrationWidth(param1:Number) : void
      {
         this.width = param1;
      }
      
      public function get registrationHeight() : Number
      {
         var _loc1_:VideoPlayer = this.flvplayback_internal::videoPlayers[this._visibleVP];
         return _loc1_.registrationHeight;
      }
      
      public function set registrationHeight(param1:Number) : void
      {
         this.height = param1;
      }
      
      public function get scaleMode() : String
      {
         var _loc1_:VideoPlayer = this.flvplayback_internal::videoPlayers[this._activeVP];
         return _loc1_.scaleMode;
      }
      
      public function set scaleMode(param1:String) : void
      {
         if(this._activeVP == 0)
         {
            this._scaleMode = param1;
         }
         var _loc2_:VideoPlayer = this.flvplayback_internal::videoPlayers[this._activeVP];
         _loc2_.scaleMode = param1;
      }
      
      override public function get scaleX() : Number
      {
         var _loc1_:VideoPlayer = this.flvplayback_internal::videoPlayers[this._visibleVP];
         return _loc1_.width / this._origWidth;
      }
      
      override public function set scaleX(param1:Number) : void
      {
         var _loc5_:VideoPlayer = null;
         var _loc2_:Rectangle = new Rectangle(this.x,this.y,this.width,this.height);
         var _loc3_:Rectangle = new Rectangle(this.registrationX,this.registrationY,this.registrationWidth,this.registrationHeight);
         this.flvplayback_internal::resizingNow = true;
         var _loc4_:int = 0;
         while(_loc4_ < this.flvplayback_internal::videoPlayers.length)
         {
            if((_loc5_ = this.flvplayback_internal::videoPlayers[_loc4_]) !== null)
            {
               _loc5_.width = this._origWidth * param1;
            }
            _loc4_++;
         }
         this.flvplayback_internal::resizingNow = false;
         dispatchEvent(new LayoutEvent(LayoutEvent.LAYOUT,false,false,_loc2_,_loc3_));
      }
      
      override public function get scaleY() : Number
      {
         var _loc1_:VideoPlayer = this.flvplayback_internal::videoPlayers[this._visibleVP];
         return _loc1_.height / this._origHeight;
      }
      
      override public function set scaleY(param1:Number) : void
      {
         var _loc5_:VideoPlayer = null;
         var _loc2_:Rectangle = new Rectangle(this.x,this.y,this.width,this.height);
         var _loc3_:Rectangle = new Rectangle(this.registrationX,this.registrationY,this.registrationWidth,this.registrationHeight);
         this.flvplayback_internal::resizingNow = true;
         var _loc4_:int = 0;
         while(_loc4_ < this.flvplayback_internal::videoPlayers.length)
         {
            if((_loc5_ = this.flvplayback_internal::videoPlayers[_loc4_]) !== null)
            {
               _loc5_.height = this._origHeight * param1;
            }
            _loc4_++;
         }
         this.flvplayback_internal::resizingNow = false;
         dispatchEvent(new LayoutEvent(LayoutEvent.LAYOUT,false,false,_loc2_,_loc3_));
      }
      
      public function get scrubbing() : Boolean
      {
         var _loc2_:ControlData = null;
         var _loc1_:Sprite = this.seekBar;
         if(_loc1_ != null)
         {
            _loc2_ = this.flvplayback_internal::uiMgr.ctrlDataDict[_loc1_];
            return _loc2_.isDragging;
         }
         return false;
      }
      
      public function get seekBar() : Sprite
      {
         return this.flvplayback_internal::uiMgr.getControl(fl.video.UIManager.SEEK_BAR);
      }
      
      public function set seekBar(param1:Sprite) : void
      {
         this.flvplayback_internal::uiMgr.setControl(fl.video.UIManager.SEEK_BAR,param1);
      }
      
      public function get seekBarInterval() : Number
      {
         return this.flvplayback_internal::uiMgr.seekBarInterval;
      }
      
      public function set seekBarInterval(param1:Number) : void
      {
         this.flvplayback_internal::uiMgr.seekBarInterval = param1;
      }
      
      public function get seekBarScrubTolerance() : Number
      {
         return this.flvplayback_internal::uiMgr.seekBarScrubTolerance;
      }
      
      public function set seekBarScrubTolerance(param1:Number) : void
      {
         this.flvplayback_internal::uiMgr.seekBarScrubTolerance = param1;
      }
      
      public function get seekToPrevOffset() : Number
      {
         return this._seekToPrevOffset;
      }
      
      public function set seekToPrevOffset(param1:Number) : void
      {
         this._seekToPrevOffset = param1;
      }
      
      public function get skin() : String
      {
         return this.flvplayback_internal::uiMgr.skin;
      }
      
      public function set skin(param1:String) : void
      {
         this.flvplayback_internal::uiMgr.skin = param1;
      }
      
      public function get skinAutoHide() : Boolean
      {
         return this.flvplayback_internal::uiMgr.skinAutoHide;
      }
      
      public function set skinAutoHide(param1:Boolean) : void
      {
         if(this.isLivePreview)
         {
            return;
         }
         this.flvplayback_internal::uiMgr.skinAutoHide = param1;
      }
      
      public function get skinBackgroundAlpha() : Number
      {
         return this.flvplayback_internal::uiMgr.skinBackgroundAlpha;
      }
      
      public function set skinBackgroundAlpha(param1:Number) : void
      {
         this.flvplayback_internal::uiMgr.skinBackgroundAlpha = param1;
      }
      
      public function get skinBackgroundColor() : uint
      {
         return this.flvplayback_internal::uiMgr.skinBackgroundColor;
      }
      
      public function set skinBackgroundColor(param1:uint) : void
      {
         this.flvplayback_internal::uiMgr.skinBackgroundColor = param1;
      }
      
      public function get skinFadeTime() : int
      {
         return this.flvplayback_internal::uiMgr.skinFadeTime;
      }
      
      public function set skinFadeTime(param1:int) : void
      {
         this.flvplayback_internal::uiMgr.skinFadeTime = param1;
      }
      
      public function get skinScaleMaximum() : Number
      {
         return this.flvplayback_internal::uiMgr.skinScaleMaximum;
      }
      
      public function set skinScaleMaximum(param1:Number) : void
      {
         this.flvplayback_internal::uiMgr.skinScaleMaximum = param1;
      }
      
      override public function get soundTransform() : SoundTransform
      {
         var _loc1_:VideoPlayer = this.flvplayback_internal::videoPlayers[this._visibleVP];
         var _loc2_:SoundTransform = _loc1_.soundTransform;
         if(this.scrubbing)
         {
            _loc2_.volume = this._volume;
         }
         return _loc2_;
      }
      
      override public function set soundTransform(param1:SoundTransform) : void
      {
         if(param1 == null)
         {
            return;
         }
         this._volume = param1.volume;
         this._soundTransform.volume = this.scrubbing ? 0 : param1.volume;
         this._soundTransform.leftToLeft = param1.leftToLeft;
         this._soundTransform.leftToRight = param1.leftToRight;
         this._soundTransform.rightToLeft = param1.rightToLeft;
         this._soundTransform.rightToRight = param1.rightToRight;
         var _loc2_:VideoPlayer = this.flvplayback_internal::videoPlayers[this._activeVP];
         _loc2_.soundTransform = this._soundTransform;
         dispatchEvent(new SoundEvent(SoundEvent.SOUND_UPDATE,false,false,_loc2_.soundTransform));
      }
      
      public function get state() : String
      {
         if(this.isLivePreview)
         {
            return VideoState.STOPPED;
         }
         var _loc1_:VideoPlayer = this.flvplayback_internal::videoPlayers[this._activeVP];
         if(this._activeVP == this._visibleVP && this.scrubbing)
         {
            return VideoState.SEEKING;
         }
         var _loc2_:String = _loc1_.state;
         if(_loc2_ == VideoState.RESIZING)
         {
            return VideoState.LOADING;
         }
         var _loc3_:VideoPlayerState = this.flvplayback_internal::videoPlayerStates[this._activeVP];
         if(_loc3_.prevState == VideoState.LOADING && _loc3_.autoPlay && _loc2_ == VideoState.STOPPED)
         {
            return VideoState.LOADING;
         }
         return _loc2_;
      }
      
      public function get stateResponsive() : Boolean
      {
         var _loc1_:VideoPlayer = this.flvplayback_internal::videoPlayers[this._activeVP];
         return _loc1_.stateResponsive;
      }
      
      public function get stopButton() : Sprite
      {
         return this.flvplayback_internal::uiMgr.getControl(fl.video.UIManager.STOP_BUTTON);
      }
      
      public function set stopButton(param1:Sprite) : void
      {
         this.flvplayback_internal::uiMgr.setControl(fl.video.UIManager.STOP_BUTTON,param1);
      }
      
      public function get stopped() : Boolean
      {
         return this.state == VideoState.STOPPED;
      }
      
      public function get totalTime() : Number
      {
         if(this.isLivePreview)
         {
            return 1;
         }
         var _loc1_:VideoPlayerState = this.flvplayback_internal::videoPlayerStates[this._activeVP];
         if(_loc1_.totalTimeSet)
         {
            return _loc1_.totalTime;
         }
         var _loc2_:VideoPlayer = this.flvplayback_internal::videoPlayers[this._activeVP];
         return _loc2_.totalTime;
      }
      
      public function set totalTime(param1:Number) : void
      {
         var _loc2_:VideoPlayerState = this.flvplayback_internal::videoPlayerStates[this._activeVP];
         _loc2_.totalTime = param1;
         _loc2_.totalTimeSet = true;
      }
      
      public function get visibleVideoPlayerIndex() : uint
      {
         return this._visibleVP;
      }
      
      public function set visibleVideoPlayerIndex(param1:uint) : void
      {
         var _loc5_:Rectangle = null;
         var _loc6_:Rectangle = null;
         if(this._visibleVP == param1)
         {
            return;
         }
         if(this.flvplayback_internal::videoPlayers[param1] == undefined)
         {
            this.flvplayback_internal::createVideoPlayer(param1);
         }
         var _loc2_:VideoPlayer = this.flvplayback_internal::videoPlayers[param1];
         var _loc3_:VideoPlayer = this.flvplayback_internal::videoPlayers[this._visibleVP];
         _loc3_.visible = false;
         _loc3_.volume = 0;
         this._visibleVP = param1;
         if(this.flvplayback_internal::_firstStreamShown)
         {
            this.flvplayback_internal::uiMgr.flvplayback_internal::setupSkinAutoHide(false);
            _loc2_.visible = true;
            this._soundTransform.volume = this.scrubbing ? 0 : this._volume;
            _loc2_.soundTransform = this._soundTransform;
         }
         else if((_loc2_.stateResponsive || _loc2_.state == VideoState.CONNECTION_ERROR || _loc2_.state == VideoState.DISCONNECTED) && this.flvplayback_internal::uiMgr.skinReady)
         {
            this.flvplayback_internal::uiMgr.visible = true;
            this.flvplayback_internal::uiMgr.flvplayback_internal::setupSkinAutoHide(false);
            this.flvplayback_internal::_firstStreamReady = true;
            if(this.flvplayback_internal::uiMgr.skin == "")
            {
               this.flvplayback_internal::uiMgr.flvplayback_internal::hookUpCustomComponents();
            }
            this.flvplayback_internal::showFirstStream();
         }
         if(_loc2_.height != _loc3_.height || _loc2_.width != _loc3_.width)
         {
            _loc5_ = new Rectangle(_loc3_.x + super.x,_loc3_.y + super.y,_loc3_.width,_loc3_.height);
            _loc6_ = new Rectangle(_loc3_.registrationX + super.x,_loc3_.registrationY + super.y,_loc3_.registrationWidth,_loc3_.registrationHeight);
            dispatchEvent(new LayoutEvent(LayoutEvent.LAYOUT,false,false,_loc5_,_loc6_));
         }
         var _loc4_:uint = this._activeVP;
         this._activeVP = this._visibleVP;
         this.flvplayback_internal::uiMgr.flvplayback_internal::handleIVPEvent(new fl.video.VideoEvent(fl.video.VideoEvent.STATE_CHANGE,false,false,this.state,this.playheadTime,this._visibleVP));
         this.flvplayback_internal::uiMgr.flvplayback_internal::handleIVPEvent(new fl.video.VideoEvent(fl.video.VideoEvent.PLAYHEAD_UPDATE,false,false,this.state,this.playheadTime,this._visibleVP));
         if(_loc2_.isRTMP)
         {
            this.flvplayback_internal::uiMgr.flvplayback_internal::handleIVPEvent(new fl.video.VideoEvent(fl.video.VideoEvent.READY,false,false,this.state,this.playheadTime,this._visibleVP));
         }
         else
         {
            this.flvplayback_internal::uiMgr.flvplayback_internal::handleIVPEvent(new VideoProgressEvent(VideoProgressEvent.PROGRESS,false,false,this.bytesLoaded,this.bytesTotal,this._visibleVP));
         }
         this._activeVP = _loc4_;
      }
      
      public function get volume() : Number
      {
         return this._volume;
      }
      
      public function set volume(param1:Number) : void
      {
         var _loc2_:VideoPlayer = null;
         if(this._volume == param1)
         {
            return;
         }
         this._volume = param1;
         if(!this.scrubbing)
         {
            _loc2_ = this.flvplayback_internal::videoPlayers[this._visibleVP];
            _loc2_.volume = this._volume;
         }
         dispatchEvent(new SoundEvent(SoundEvent.SOUND_UPDATE,false,false,_loc2_.soundTransform));
      }
      
      public function get volumeBar() : Sprite
      {
         return this.flvplayback_internal::uiMgr.getControl(fl.video.UIManager.VOLUME_BAR);
      }
      
      public function set volumeBar(param1:Sprite) : void
      {
         this.flvplayback_internal::uiMgr.setControl(fl.video.UIManager.VOLUME_BAR,param1);
      }
      
      public function get volumeBarInterval() : Number
      {
         return this.flvplayback_internal::uiMgr.volumeBarInterval;
      }
      
      public function set volumeBarInterval(param1:Number) : void
      {
         this.flvplayback_internal::uiMgr.volumeBarInterval = param1;
      }
      
      public function get volumeBarScrubTolerance() : Number
      {
         return this.flvplayback_internal::uiMgr.volumeBarScrubTolerance;
      }
      
      public function set volumeBarScrubTolerance(param1:Number) : void
      {
         this.flvplayback_internal::uiMgr.volumeBarScrubTolerance = param1;
      }
      
      override public function get width() : Number
      {
         if(this.isLivePreview)
         {
            return this.livePreviewWidth;
         }
         var _loc1_:VideoPlayer = this.flvplayback_internal::videoPlayers[this._visibleVP];
         return _loc1_.width;
      }
      
      override public function set width(param1:Number) : void
      {
         var _loc5_:VideoPlayer = null;
         if(this.isLivePreview)
         {
            this.setSize(param1,this.height);
            return;
         }
         var _loc2_:Rectangle = new Rectangle(this.x,this.y,this.width,this.height);
         var _loc3_:Rectangle = new Rectangle(this.registrationX,this.registrationY,this.registrationWidth,this.registrationHeight);
         this.flvplayback_internal::resizingNow = true;
         var _loc4_:int = 0;
         while(_loc4_ < this.flvplayback_internal::videoPlayers.length)
         {
            if((_loc5_ = this.flvplayback_internal::videoPlayers[_loc4_]) != null)
            {
               _loc5_.width = param1;
            }
            _loc4_++;
         }
         this.flvplayback_internal::resizingNow = false;
         dispatchEvent(new LayoutEvent(LayoutEvent.LAYOUT,false,false,_loc2_,_loc3_));
      }
      
      override public function get x() : Number
      {
         var _loc1_:VideoPlayer = this.flvplayback_internal::videoPlayers[this._visibleVP];
         return super.x + _loc1_.x;
      }
      
      override public function set x(param1:Number) : void
      {
         var _loc2_:VideoPlayer = this.flvplayback_internal::videoPlayers[this._visibleVP];
         super.x = param1 - _loc2_.x;
      }
      
      override public function get y() : Number
      {
         var _loc1_:VideoPlayer = this.flvplayback_internal::videoPlayers[this._visibleVP];
         return super.y + _loc1_.y;
      }
      
      override public function set y(param1:Number) : void
      {
         var _loc2_:VideoPlayer = this.flvplayback_internal::videoPlayers[this._visibleVP];
         super.y = param1 - _loc2_.y;
      }
      
      flvplayback_internal function createVideoPlayer(param1:Number) : void
      {
         var vp:VideoPlayer;
         var added:Boolean;
         var vpState:VideoPlayerState;
         var cpMgr:CuePointManager;
         var skinDepth:int = 0;
         var index:Number = param1;
         if(this.isLivePreview)
         {
            return;
         }
         vp = this.flvplayback_internal::videoPlayers[index];
         if(vp == null)
         {
            this.flvplayback_internal::videoPlayers[index] = vp = new VideoPlayer(0,0);
            vp.setSize(this.registrationWidth,this.registrationHeight);
         }
         vp.visible = false;
         vp.volume = 0;
         vp.name = String(index);
         added = false;
         if(this.flvplayback_internal::uiMgr.flvplayback_internal::skin_mc != null)
         {
            try
            {
               skinDepth = getChildIndex(this.flvplayback_internal::uiMgr.flvplayback_internal::skin_mc);
               if(skinDepth > 0)
               {
                  addChildAt(vp,skinDepth);
                  added = true;
               }
            }
            catch(err:Error)
            {
            }
         }
         if(!added)
         {
            addChild(vp);
         }
         this._topVP = index;
         vp.autoRewind = this._autoRewind;
         vp.scaleMode = this._scaleMode;
         vp.bufferTime = this._bufferTime;
         vp.idleTimeout = this._idleTimeout;
         vp.playheadUpdateInterval = this._playheadUpdateInterval;
         vp.progressInterval = this._progressInterval;
         vp.soundTransform = this._soundTransform;
         vpState = new VideoPlayerState(vp,index);
         this.flvplayback_internal::videoPlayerStates[index] = vpState;
         this.flvplayback_internal::videoPlayerStateDict[vp] = vpState;
         vp.addEventListener(AutoLayoutEvent.AUTO_LAYOUT,this.flvplayback_internal::handleAutoLayoutEvent);
         vp.addEventListener(MetadataEvent.CUE_POINT,this.flvplayback_internal::handleMetadataEvent);
         vp.addEventListener(MetadataEvent.METADATA_RECEIVED,this.flvplayback_internal::handleMetadataEvent);
         vp.addEventListener(VideoProgressEvent.PROGRESS,this.flvplayback_internal::handleVideoProgressEvent);
         vp.addEventListener(fl.video.VideoEvent.AUTO_REWOUND,this.flvplayback_internal::handleVideoEvent);
         vp.addEventListener(fl.video.VideoEvent.CLOSE,this.flvplayback_internal::handleVideoEvent);
         vp.addEventListener(fl.video.VideoEvent.COMPLETE,this.flvplayback_internal::handleVideoEvent);
         vp.addEventListener(fl.video.VideoEvent.PLAYHEAD_UPDATE,this.flvplayback_internal::handleVideoEvent);
         vp.addEventListener(fl.video.VideoEvent.STATE_CHANGE,this.flvplayback_internal::handleVideoEvent);
         vp.addEventListener(fl.video.VideoEvent.READY,this.flvplayback_internal::handleVideoEvent);
         cpMgr = new CuePointManager(this,index);
         this.flvplayback_internal::cuePointMgrs[index] = cpMgr;
         cpMgr.playheadUpdateInterval = this._playheadUpdateInterval;
      }
      
      private function createLivePreviewMovieClip() : void
      {
      }
      
      private function onCompletePreview(param1:Event) : void
      {
         var e:Event = param1;
         try
         {
            this.previewImage_mc.width = this.livePreviewWidth;
            this.previewImage_mc.height = this.livePreviewHeight;
         }
         catch(e:Error)
         {
         }
      }
      
      private function doContentPathConnect(param1:*) : void
      {
         if(this.isLivePreview)
         {
            return;
         }
         var _loc2_:int = 0;
         if(param1 is int)
         {
            _loc2_ = int(param1);
         }
         else
         {
            removeEventListener(Event.ENTER_FRAME,this.doContentPathConnect);
         }
         var _loc3_:VideoPlayer = this.flvplayback_internal::videoPlayers[_loc2_];
         var _loc4_:VideoPlayerState;
         if(!(_loc4_ = this.flvplayback_internal::videoPlayerStates[_loc2_]).isWaiting)
         {
            return;
         }
         if(_loc4_.autoPlay && this.flvplayback_internal::_firstStreamShown)
         {
            _loc3_.play(_loc4_.url,_loc4_.totalTime,_loc4_.isLive);
         }
         else
         {
            _loc3_.load(_loc4_.url,_loc4_.totalTime,_loc4_.isLive);
         }
         _loc4_.isLiveSet = false;
         _loc4_.totalTimeSet = false;
         _loc4_.isWaiting = false;
      }
      
      flvplayback_internal function showFirstStream() : void
      {
         var _loc3_:VideoPlayerState = null;
         var _loc4_:int = 0;
         this.flvplayback_internal::_firstStreamShown = true;
         var _loc1_:VideoPlayer = this.flvplayback_internal::videoPlayers[this._visibleVP];
         _loc1_.visible = true;
         if(!this.scrubbing)
         {
            this._soundTransform.volume = this._volume;
            _loc1_.soundTransform = this._soundTransform;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.flvplayback_internal::videoPlayers.length)
         {
            _loc1_ = this.flvplayback_internal::videoPlayers[_loc2_];
            if(_loc1_ != null)
            {
               _loc3_ = this.flvplayback_internal::videoPlayerStates[_loc2_];
               if(_loc1_.state == VideoState.STOPPED && _loc3_.autoPlay)
               {
                  if(_loc1_.isRTMP)
                  {
                     _loc1_.play();
                  }
                  else
                  {
                     _loc3_.prevState = VideoState.STOPPED;
                     _loc1_.playWhenEnoughDownloaded();
                  }
               }
               if(_loc3_.cmdQueue != null)
               {
                  _loc4_ = 0;
                  while(_loc4_ < _loc3_.cmdQueue.length)
                  {
                     switch(_loc3_.cmdQueue[_loc4_].type)
                     {
                        case QueuedCommand.PLAY:
                           _loc1_.play();
                           break;
                        case QueuedCommand.PAUSE:
                           _loc1_.pause();
                           break;
                        case QueuedCommand.STOP:
                           _loc1_.stop();
                           break;
                        case QueuedCommand.SEEK:
                           _loc1_.seek(_loc3_.cmdQueue[_loc4_].time);
                           break;
                        case QueuedCommand.PLAY_WHEN_ENOUGH:
                           _loc1_.playWhenEnoughDownloaded();
                           break;
                     }
                     _loc4_++;
                  }
                  _loc3_.cmdQueue = null;
               }
            }
            _loc2_++;
         }
      }
      
      flvplayback_internal function _scrubStart() : void
      {
         var _loc1_:Number = this.playheadTime;
         var _loc2_:VideoPlayer = this.flvplayback_internal::videoPlayers[this._visibleVP];
         this._volume = _loc2_.volume;
         _loc2_.volume = 0;
         dispatchEvent(new fl.video.VideoEvent(fl.video.VideoEvent.STATE_CHANGE,false,false,VideoState.SEEKING,_loc1_,this._visibleVP));
         dispatchEvent(new fl.video.VideoEvent(fl.video.VideoEvent.SCRUB_START,false,false,VideoState.SEEKING,_loc1_,this._visibleVP));
      }
      
      flvplayback_internal function _scrubFinish() : void
      {
         var _loc1_:Number = this.playheadTime;
         var _loc2_:String = this.state;
         var _loc3_:VideoPlayer = this.flvplayback_internal::videoPlayers[this._visibleVP];
         this._soundTransform.volume = this._volume;
         _loc3_.soundTransform = this._soundTransform;
         if(_loc2_ != VideoState.SEEKING)
         {
            dispatchEvent(new fl.video.VideoEvent(fl.video.VideoEvent.STATE_CHANGE,false,false,_loc2_,_loc1_,this._visibleVP));
         }
         dispatchEvent(new fl.video.VideoEvent(fl.video.VideoEvent.SCRUB_FINISH,false,false,_loc2_,_loc1_,this._visibleVP));
      }
      
      flvplayback_internal function skinError(param1:String) : void
      {
         if(this.isLivePreview)
         {
            return;
         }
         if(this.flvplayback_internal::_firstStreamReady && !this.flvplayback_internal::_firstStreamShown)
         {
            this.flvplayback_internal::showFirstStream();
         }
         dispatchEvent(new SkinErrorEvent(SkinErrorEvent.SKIN_ERROR,false,false,param1));
      }
      
      flvplayback_internal function skinLoaded() : void
      {
         if(this.isLivePreview)
         {
            return;
         }
         var _loc1_:VideoPlayer = this.flvplayback_internal::videoPlayers[this._visibleVP];
         if(this.flvplayback_internal::_firstStreamReady || _loc1_.state == VideoState.CONNECTION_ERROR || _loc1_.state == VideoState.DISCONNECTED)
         {
            this.flvplayback_internal::uiMgr.visible = true;
            if(!this.flvplayback_internal::_firstStreamShown)
            {
               this.flvplayback_internal::showFirstStream();
            }
         }
         else
         {
            if(this.flvplayback_internal::skinShowTimer != null)
            {
               this.flvplayback_internal::skinShowTimer.reset();
               this.flvplayback_internal::skinShowTimer = null;
            }
            this.flvplayback_internal::skinShowTimer = new Timer(flvplayback_internal::DEFAULT_SKIN_SHOW_TIMER_INTERVAL,1);
            this.flvplayback_internal::skinShowTimer.addEventListener(TimerEvent.TIMER,this.flvplayback_internal::showSkinNow);
            this.flvplayback_internal::skinShowTimer.start();
         }
         dispatchEvent(new fl.video.VideoEvent(fl.video.VideoEvent.SKIN_LOADED,false,false,this.state,this.playheadTime,this._visibleVP));
      }
      
      flvplayback_internal function showSkinNow(param1:TimerEvent) : void
      {
         this.flvplayback_internal::skinShowTimer = null;
         this.flvplayback_internal::uiMgr.visible = true;
      }
      
      flvplayback_internal function queueCmd(param1:VideoPlayerState, param2:Number, param3:Number = NaN) : void
      {
         if(param1.cmdQueue == null)
         {
            param1.cmdQueue = new Array();
         }
         param1.cmdQueue.push(new QueuedCommand(param2,null,false,param3));
      }
      
      public function assignTabIndexes(param1:int) : int
      {
         if(tabIndex)
         {
            tabEnabled = false;
            tabChildren = true;
            if(isNaN(param1))
            {
               param1 = tabIndex;
            }
         }
         return this.flvplayback_internal::uiMgr.flvplayback_internal::assignTabIndexes(param1);
      }
      
      public function get endTabIndex() : int
      {
         return this.flvplayback_internal::uiMgr.flvplayback_internal::endTabIndex;
      }
      
      public function get startTabIndex() : int
      {
         if(this.flvplayback_internal::uiMgr.flvplayback_internal::startTabIndex)
         {
            return this.flvplayback_internal::uiMgr.flvplayback_internal::startTabIndex;
         }
         if(tabIndex)
         {
            return tabIndex;
         }
         return this.flvplayback_internal::uiMgr.flvplayback_internal::startTabIndex;
      }
   }
}

package fl.video
{
   import flash.accessibility.Accessibility;
   import flash.accessibility.AccessibilityProperties;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.system.Capabilities;
   import flash.ui.Keyboard;
   import flash.utils.*;
   
   public class UIManager
   {
      
      public static const VERSION:String = "2.1.0.23";
      
      public static const SHORT_VERSION:String = "2.1";
      
      public static const PAUSE_BUTTON:int = 0;
      
      public static const PLAY_BUTTON:int = 1;
      
      public static const STOP_BUTTON:int = 2;
      
      public static const SEEK_BAR_HANDLE:int = 3;
      
      public static const SEEK_BAR_HIT:int = 4;
      
      public static const BACK_BUTTON:int = 5;
      
      public static const FORWARD_BUTTON:int = 6;
      
      public static const FULL_SCREEN_ON_BUTTON:int = 7;
      
      public static const FULL_SCREEN_OFF_BUTTON:int = 8;
      
      public static const MUTE_ON_BUTTON:int = 9;
      
      public static const MUTE_OFF_BUTTON:int = 10;
      
      public static const VOLUME_BAR_HANDLE:int = 11;
      
      public static const VOLUME_BAR_HIT:int = 12;
      
      public static const NUM_BUTTONS:int = 13;
      
      public static const PLAY_PAUSE_BUTTON:int = 13;
      
      public static const FULL_SCREEN_BUTTON:int = 14;
      
      public static const MUTE_BUTTON:int = 15;
      
      public static const BUFFERING_BAR:int = 16;
      
      public static const SEEK_BAR:int = 17;
      
      public static const VOLUME_BAR:int = 18;
      
      public static const NUM_CONTROLS:int = 19;
      
      public static const NORMAL_STATE:uint = 0;
      
      public static const OVER_STATE:uint = 1;
      
      public static const DOWN_STATE:uint = 2;
      
      public static const FULL_SCREEN_SOURCE_RECT_MIN_WIDTH:uint = 320;
      
      public static const FULL_SCREEN_SOURCE_RECT_MIN_HEIGHT:uint = 240;
      
      flvplayback_internal static const SKIN_AUTO_HIDE_INTERVAL:Number = 200;
      
      flvplayback_internal static const SKIN_FADING_INTERVAL:Number = 100;
      
      flvplayback_internal static const SKIN_FADING_MAX_TIME_DEFAULT:Number = 500;
      
      flvplayback_internal static const SKIN_AUTO_HIDE_MOTION_TIMEOUT_DEFAULT:Number = 3000;
      
      public static const VOLUME_BAR_INTERVAL_DEFAULT:Number = 250;
      
      public static const VOLUME_BAR_SCRUB_TOLERANCE_DEFAULT:Number = 0;
      
      public static const SEEK_BAR_INTERVAL_DEFAULT:Number = 250;
      
      public static const SEEK_BAR_SCRUB_TOLERANCE_DEFAULT:Number = 5;
      
      public static const BUFFERING_DELAY_INTERVAL_DEFAULT:Number = 1000;
      
      flvplayback_internal static var layoutNameToIndexMappings:Object = null;
      
      flvplayback_internal static var layoutNameArray:Array = ["pause_mc","play_mc","stop_mc",null,null,"back_mc","forward_mc",null,null,null,null,null,null,"playpause_mc","fullScreenToggle_mc","volumeMute_mc","bufferingBar_mc","seekBar_mc","volumeBar_mc","seekBarHandle_mc","seekBarHit_mc","seekBarProgress_mc","seekBarFullness_mc","volumeBarHandle_mc","volumeBarHit_mc","volumeBarProgress_mc","volumeBarFullness_mc","progressFill_mc"];
      
      flvplayback_internal static var skinClassPrefixes:Array = ["pauseButton","playButton","stopButton",null,null,"backButton","forwardButton","fullScreenButtonOn","fullScreenButtonOff","muteButtonOn","muteButtonOff",null,null,null,null,null,"bufferingBar","seekBar","volumeBar"];
      
      flvplayback_internal static var customComponentClassNames:Array = ["PauseButton","PlayButton","StopButton",null,null,"BackButton","ForwardButton",null,null,null,null,null,null,"PlayPauseButton","FullScreenButton","MuteButton","BufferingBar","SeekBar","VolumeBar"];
      
      public static const CAPTIONS_ON_BUTTON:Number = 28;
      
      public static const CAPTIONS_OFF_BUTTON:Number = 29;
      
      public static const SHOW_CONTROLS_BUTTON:Number = 30;
      
      public static const HIDE_CONTROLS_BUTTON:Number = 31;
      
      flvplayback_internal static var buttonSkinLinkageIDs:Array = ["upLinkageID","overLinkageID","downLinkageID"];
       
      
      flvplayback_internal var controls:Array;
      
      flvplayback_internal var delayedControls:Array;
      
      public var customClips:Array;
      
      public var ctrlDataDict:Dictionary;
      
      flvplayback_internal var skin_mc:Sprite;
      
      flvplayback_internal var skinLoader:Loader;
      
      flvplayback_internal var skinTemplate:Sprite;
      
      flvplayback_internal var layout_mc:Sprite;
      
      flvplayback_internal var border_mc:DisplayObject;
      
      flvplayback_internal var borderCopy:Sprite;
      
      flvplayback_internal var borderPrevRect:Rectangle;
      
      flvplayback_internal var borderScale9Rects:Array;
      
      flvplayback_internal var borderAlpha:Number;
      
      flvplayback_internal var borderColor:uint;
      
      flvplayback_internal var borderColorTransform:ColorTransform;
      
      flvplayback_internal var skinLoadDelayCount:uint;
      
      flvplayback_internal var placeholderLeft:Number;
      
      flvplayback_internal var placeholderRight:Number;
      
      flvplayback_internal var placeholderTop:Number;
      
      flvplayback_internal var placeholderBottom:Number;
      
      flvplayback_internal var videoLeft:Number;
      
      flvplayback_internal var videoRight:Number;
      
      flvplayback_internal var videoTop:Number;
      
      flvplayback_internal var videoBottom:Number;
      
      flvplayback_internal var _bufferingBarHides:Boolean;
      
      flvplayback_internal var _controlsEnabled:Boolean;
      
      flvplayback_internal var _skin:String;
      
      flvplayback_internal var _skinAutoHide:Boolean;
      
      flvplayback_internal var _skinFadingMaxTime:int;
      
      flvplayback_internal var _skinReady:Boolean;
      
      flvplayback_internal var __visible:Boolean;
      
      flvplayback_internal var _seekBarScrubTolerance:Number;
      
      flvplayback_internal var _skinScaleMaximum:Number;
      
      flvplayback_internal var _progressPercent:Number;
      
      flvplayback_internal var cachedSoundLevel:Number;
      
      flvplayback_internal var _lastVolumePos:Number;
      
      flvplayback_internal var _isMuted:Boolean;
      
      flvplayback_internal var _volumeBarTimer:Timer;
      
      flvplayback_internal var _volumeBarScrubTolerance:Number;
      
      flvplayback_internal var _vc:fl.video.FLVPlayback;
      
      flvplayback_internal var _bufferingDelayTimer:Timer;
      
      flvplayback_internal var _bufferingOn:Boolean;
      
      flvplayback_internal var _seekBarTimer:Timer;
      
      flvplayback_internal var _lastScrubPos:Number;
      
      flvplayback_internal var _playAfterScrub:Boolean;
      
      flvplayback_internal var _skinAutoHideTimer:Timer;
      
      flvplayback_internal var _skinFadingTimer:Timer;
      
      flvplayback_internal var _skinFadingIn:Boolean;
      
      flvplayback_internal var _skinFadeStartTime:int;
      
      flvplayback_internal var _skinAutoHideMotionTimeout:int;
      
      flvplayback_internal var _skinAutoHideMouseX:Number;
      
      flvplayback_internal var _skinAutoHideMouseY:Number;
      
      flvplayback_internal var _skinAutoHideLastMotionTime:int;
      
      flvplayback_internal var mouseCaptureCtrl:int;
      
      flvplayback_internal var fullScreenSourceRectMinWidth:uint;
      
      flvplayback_internal var fullScreenSourceRectMinHeight:uint;
      
      flvplayback_internal var fullScreenSourceRectMinAspectRatio:Number;
      
      flvplayback_internal var _fullScreen:Boolean;
      
      flvplayback_internal var _fullScreenTakeOver:Boolean;
      
      flvplayback_internal var _fullScreenBgColor:uint;
      
      flvplayback_internal var _fullScreenAccel:Boolean;
      
      flvplayback_internal var _fullScreenVideoWidth:Number;
      
      flvplayback_internal var _fullScreenVideoHeight:Number;
      
      flvplayback_internal var cacheStageAlign:String;
      
      flvplayback_internal var cacheStageScaleMode:String;
      
      flvplayback_internal var cacheStageBGColor:uint;
      
      flvplayback_internal var cacheFLVPlaybackParent:DisplayObjectContainer;
      
      flvplayback_internal var cacheFLVPlaybackIndex:int;
      
      flvplayback_internal var cacheFLVPlaybackLocation:Rectangle;
      
      flvplayback_internal var cacheFLVPlaybackScaleMode:Array;
      
      flvplayback_internal var cacheFLVPlaybackAlign:Array;
      
      flvplayback_internal var cacheSkinAutoHide:Boolean;
      
      flvplayback_internal var hitTarget_mc:Sprite;
      
      flvplayback_internal var accessibilityPropertyNames:Array;
      
      flvplayback_internal var startTabIndex:int;
      
      flvplayback_internal var endTabIndex:int;
      
      flvplayback_internal var focusRect:Boolean = true;
      
      public function UIManager(param1:fl.video.FLVPlayback)
      {
         var vc:fl.video.FLVPlayback = param1;
         this.flvplayback_internal::accessibilityPropertyNames = ["Pause","Play","Stop","Seek Bar",null,"Back","Forward","Go Full Screen","Exit Full Screen","Volume Mute On","Volume Mute Off","Volume",null,null,null,null,"Buffering",null,null,null,null,null,null,null,null,null,null,null,"Captions Off","Captions On","Show Video Player Controls","Hide Video Player Controls"];
         super();
         this.flvplayback_internal::_vc = vc;
         this.flvplayback_internal::_skin = null;
         this.flvplayback_internal::_skinAutoHide = false;
         this.flvplayback_internal::cacheSkinAutoHide = this.flvplayback_internal::_skinAutoHide;
         this.flvplayback_internal::_skinFadingMaxTime = flvplayback_internal::SKIN_FADING_MAX_TIME_DEFAULT;
         this.flvplayback_internal::_skinAutoHideMotionTimeout = flvplayback_internal::SKIN_AUTO_HIDE_MOTION_TIMEOUT_DEFAULT;
         this.flvplayback_internal::_skinReady = true;
         this.flvplayback_internal::__visible = false;
         this.flvplayback_internal::_bufferingBarHides = false;
         this.flvplayback_internal::_controlsEnabled = true;
         this.flvplayback_internal::_lastScrubPos = 0;
         this.flvplayback_internal::_lastVolumePos = 0;
         this.flvplayback_internal::cachedSoundLevel = this.flvplayback_internal::_vc.volume;
         this.flvplayback_internal::_isMuted = false;
         this.flvplayback_internal::controls = new Array();
         this.customClips = null;
         this.ctrlDataDict = new Dictionary(true);
         this.flvplayback_internal::skin_mc = null;
         this.flvplayback_internal::skinLoader = null;
         this.flvplayback_internal::skinTemplate = null;
         this.flvplayback_internal::layout_mc = null;
         this.flvplayback_internal::border_mc = null;
         this.flvplayback_internal::borderCopy = null;
         this.flvplayback_internal::borderPrevRect = null;
         this.flvplayback_internal::borderScale9Rects = null;
         this.flvplayback_internal::borderAlpha = 0.85;
         this.flvplayback_internal::borderColor = 4697035;
         this.flvplayback_internal::borderColorTransform = new ColorTransform(0,0,0,0,71,171,203,255 * this.flvplayback_internal::borderAlpha);
         this.flvplayback_internal::_seekBarScrubTolerance = SEEK_BAR_SCRUB_TOLERANCE_DEFAULT;
         this.flvplayback_internal::_volumeBarScrubTolerance = VOLUME_BAR_SCRUB_TOLERANCE_DEFAULT;
         this.flvplayback_internal::_bufferingOn = false;
         this.flvplayback_internal::mouseCaptureCtrl = -1;
         this.flvplayback_internal::_seekBarTimer = new Timer(SEEK_BAR_INTERVAL_DEFAULT);
         this.flvplayback_internal::_seekBarTimer.addEventListener(TimerEvent.TIMER,this.flvplayback_internal::seekBarListener);
         this.flvplayback_internal::_volumeBarTimer = new Timer(VOLUME_BAR_INTERVAL_DEFAULT);
         this.flvplayback_internal::_volumeBarTimer.addEventListener(TimerEvent.TIMER,this.flvplayback_internal::volumeBarListener);
         this.flvplayback_internal::_bufferingDelayTimer = new Timer(BUFFERING_DELAY_INTERVAL_DEFAULT,1);
         this.flvplayback_internal::_bufferingDelayTimer.addEventListener(TimerEvent.TIMER,this.flvplayback_internal::doBufferingDelay);
         this.flvplayback_internal::_skinAutoHideTimer = new Timer(flvplayback_internal::SKIN_AUTO_HIDE_INTERVAL);
         this.flvplayback_internal::_skinAutoHideTimer.addEventListener(TimerEvent.TIMER,this.flvplayback_internal::skinAutoHideHitTest);
         this.flvplayback_internal::_skinFadingTimer = new Timer(flvplayback_internal::SKIN_FADING_INTERVAL);
         this.flvplayback_internal::_skinFadingTimer.addEventListener(TimerEvent.TIMER,this.flvplayback_internal::skinFadeMore);
         this.flvplayback_internal::_vc.addEventListener(MetadataEvent.METADATA_RECEIVED,this.flvplayback_internal::handleIVPEvent);
         this.flvplayback_internal::_vc.addEventListener(fl.video.VideoEvent.PLAYHEAD_UPDATE,this.flvplayback_internal::handleIVPEvent);
         this.flvplayback_internal::_vc.addEventListener(VideoProgressEvent.PROGRESS,this.flvplayback_internal::handleIVPEvent);
         this.flvplayback_internal::_vc.addEventListener(fl.video.VideoEvent.STATE_CHANGE,this.flvplayback_internal::handleIVPEvent);
         this.flvplayback_internal::_vc.addEventListener(fl.video.VideoEvent.READY,this.flvplayback_internal::handleIVPEvent);
         this.flvplayback_internal::_vc.addEventListener(LayoutEvent.LAYOUT,this.flvplayback_internal::handleLayoutEvent);
         this.flvplayback_internal::_vc.addEventListener(AutoLayoutEvent.AUTO_LAYOUT,this.flvplayback_internal::handleLayoutEvent);
         this.flvplayback_internal::_vc.addEventListener(SoundEvent.SOUND_UPDATE,this.flvplayback_internal::handleSoundEvent);
         this.flvplayback_internal::_vc.addEventListener(Event.ADDED_TO_STAGE,this.flvplayback_internal::handleEvent);
         this.flvplayback_internal::_vc.addEventListener(Event.REMOVED_FROM_STAGE,this.flvplayback_internal::handleEvent);
         this.flvplayback_internal::fullScreenSourceRectMinWidth = FULL_SCREEN_SOURCE_RECT_MIN_WIDTH;
         this.flvplayback_internal::fullScreenSourceRectMinHeight = FULL_SCREEN_SOURCE_RECT_MIN_HEIGHT;
         this.flvplayback_internal::fullScreenSourceRectMinAspectRatio = FULL_SCREEN_SOURCE_RECT_MIN_WIDTH / FULL_SCREEN_SOURCE_RECT_MIN_HEIGHT;
         this.flvplayback_internal::_fullScreen = false;
         this.flvplayback_internal::_fullScreenTakeOver = Capabilities.os.indexOf("iPhone") < 0;
         this.flvplayback_internal::_fullScreenBgColor = 0;
         this.flvplayback_internal::_fullScreenAccel = false;
         if(this.flvplayback_internal::_vc.stage != null)
         {
            this.flvplayback_internal::_vc.stage.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,this.handleMouseFocusChangeEvent,false,0,true);
            try
            {
               this.flvplayback_internal::_fullScreen = this.flvplayback_internal::_vc.stage.displayState == StageDisplayState.FULL_SCREEN;
               this.flvplayback_internal::_vc.stage.addEventListener(FullScreenEvent.FULL_SCREEN,this.flvplayback_internal::handleFullScreenEvent,false,0,true);
            }
            catch(se:SecurityError)
            {
            }
         }
         if(flvplayback_internal::layoutNameToIndexMappings == null)
         {
            flvplayback_internal::initLayoutNameToIndexMappings();
         }
      }
      
      flvplayback_internal static function initLayoutNameToIndexMappings() : void
      {
         flvplayback_internal::layoutNameToIndexMappings = new Object();
         var _loc1_:int = 0;
         while(_loc1_ < flvplayback_internal::layoutNameArray.length)
         {
            if(flvplayback_internal::layoutNameArray[_loc1_] != null)
            {
               flvplayback_internal::layoutNameToIndexMappings[flvplayback_internal::layoutNameArray[_loc1_]] = _loc1_;
            }
            _loc1_++;
         }
      }
      
      flvplayback_internal static function getNumberPropSafe(param1:Object, param2:String) : Number
      {
         var numProp:* = undefined;
         var obj:Object = param1;
         var propName:String = param2;
         try
         {
            numProp = obj[propName];
            return Number(numProp);
         }
         catch(re:ReferenceError)
         {
            return NaN;
         }
      }
      
      flvplayback_internal static function getBooleanPropSafe(param1:Object, param2:String) : Boolean
      {
         var boolProp:* = undefined;
         var obj:Object = param1;
         var propName:String = param2;
         try
         {
            boolProp = obj[propName];
            return Boolean(boolProp);
         }
         catch(re:ReferenceError)
         {
            return false;
         }
      }
      
      flvplayback_internal function handleFullScreenEvent(param1:FullScreenEvent) : void
      {
         this.flvplayback_internal::_fullScreen = param1.fullScreen;
         this.flvplayback_internal::setEnabledAndVisibleForState(FULL_SCREEN_OFF_BUTTON,VideoState.PLAYING);
         this.flvplayback_internal::skinButtonControl(this.flvplayback_internal::controls[FULL_SCREEN_OFF_BUTTON]);
         this.flvplayback_internal::setEnabledAndVisibleForState(FULL_SCREEN_ON_BUTTON,VideoState.PLAYING);
         this.flvplayback_internal::skinButtonControl(this.flvplayback_internal::controls[FULL_SCREEN_ON_BUTTON]);
         if(this.flvplayback_internal::_fullScreen && this.flvplayback_internal::_fullScreenTakeOver)
         {
            this.flvplayback_internal::enterFullScreenTakeOver();
         }
         else if(!this.flvplayback_internal::_fullScreen)
         {
            this.flvplayback_internal::exitFullScreenTakeOver();
         }
      }
      
      flvplayback_internal function handleEvent(param1:Event) : void
      {
         var e:Event = param1;
         switch(e.type)
         {
            case Event.ADDED_TO_STAGE:
               this.flvplayback_internal::_fullScreen = false;
               if(this.flvplayback_internal::_vc.stage != null)
               {
                  try
                  {
                     this.flvplayback_internal::_fullScreen = this.flvplayback_internal::_vc.stage.displayState == StageDisplayState.FULL_SCREEN;
                     this.flvplayback_internal::_vc.stage.addEventListener(FullScreenEvent.FULL_SCREEN,this.flvplayback_internal::handleFullScreenEvent,false,0,true);
                  }
                  catch(se:SecurityError)
                  {
                  }
               }
               if(!this.flvplayback_internal::_fullScreen)
               {
                  this.flvplayback_internal::_fullScreenAccel = false;
               }
               this.flvplayback_internal::setEnabledAndVisibleForState(FULL_SCREEN_OFF_BUTTON,VideoState.PLAYING);
               this.flvplayback_internal::skinButtonControl(this.flvplayback_internal::controls[FULL_SCREEN_OFF_BUTTON]);
               this.flvplayback_internal::setEnabledAndVisibleForState(FULL_SCREEN_ON_BUTTON,VideoState.PLAYING);
               this.flvplayback_internal::skinButtonControl(this.flvplayback_internal::controls[FULL_SCREEN_ON_BUTTON]);
               if(this.flvplayback_internal::_fullScreen && this.flvplayback_internal::_fullScreenTakeOver)
               {
                  this.flvplayback_internal::enterFullScreenTakeOver();
               }
               else if(!this.flvplayback_internal::_fullScreen)
               {
                  this.flvplayback_internal::exitFullScreenTakeOver();
               }
               this.flvplayback_internal::layoutSkin();
               this.flvplayback_internal::setupSkinAutoHide(false);
               break;
            case Event.REMOVED_FROM_STAGE:
               this.flvplayback_internal::_vc.stage.removeEventListener(FullScreenEvent.FULL_SCREEN,this.flvplayback_internal::handleFullScreenEvent);
         }
      }
      
      flvplayback_internal function handleSoundEvent(param1:SoundEvent) : void
      {
         var _loc3_:ControlData = null;
         if(this.flvplayback_internal::_isMuted && param1.soundTransform.volume > 0)
         {
            this.flvplayback_internal::_isMuted = false;
            this.flvplayback_internal::setEnabledAndVisibleForState(MUTE_OFF_BUTTON,VideoState.PLAYING);
            this.flvplayback_internal::skinButtonControl(this.flvplayback_internal::controls[MUTE_OFF_BUTTON]);
            this.flvplayback_internal::setEnabledAndVisibleForState(MUTE_ON_BUTTON,VideoState.PLAYING);
            this.flvplayback_internal::skinButtonControl(this.flvplayback_internal::controls[MUTE_ON_BUTTON]);
         }
         var _loc2_:Sprite = this.flvplayback_internal::controls[VOLUME_BAR];
         if(_loc2_ != null)
         {
            _loc3_ = this.ctrlDataDict[_loc2_];
            _loc3_.percentage = (this.flvplayback_internal::_isMuted ? this.flvplayback_internal::cachedSoundLevel : param1.soundTransform.volume) * 100;
            if(_loc3_.percentage < 0)
            {
               _loc3_.percentage = 0;
            }
            else if(_loc3_.percentage > 100)
            {
               _loc3_.percentage = 100;
            }
            this.flvplayback_internal::positionHandle(_loc2_);
         }
      }
      
      flvplayback_internal function handleLayoutEvent(param1:LayoutEvent) : void
      {
         var _loc2_:int = 0;
         if(this.flvplayback_internal::_fullScreen && this.flvplayback_internal::_fullScreenTakeOver && this.flvplayback_internal::_fullScreenAccel && this.flvplayback_internal::_vc.stage != null)
         {
            if(this.flvplayback_internal::_vc.registrationX != 0 || this.flvplayback_internal::_vc.registrationY != 0 || this.flvplayback_internal::_vc.parent != this.flvplayback_internal::_vc.stage || this.flvplayback_internal::_fullScreenAccel && (this.flvplayback_internal::_vc.registrationWidth != this.flvplayback_internal::_vc.stage.fullScreenSourceRect.width || this.flvplayback_internal::_vc.registrationHeight != this.flvplayback_internal::_vc.stage.fullScreenSourceRect.height) || !this.flvplayback_internal::_fullScreenAccel && (this.flvplayback_internal::_vc.registrationWidth != this.flvplayback_internal::_vc.stage.stageWidth || this.flvplayback_internal::_vc.registrationHeight != this.flvplayback_internal::_vc.stage.stageHeight))
            {
               this.flvplayback_internal::_vc.stage.displayState = StageDisplayState.NORMAL;
               return;
            }
            _loc2_ = int(this.flvplayback_internal::_vc.activeVideoPlayerIndex);
            this.flvplayback_internal::_vc.activeVideoPlayerIndex = this.flvplayback_internal::_vc.visibleVideoPlayerIndex;
            if(this.flvplayback_internal::_vc.align != VideoAlign.CENTER)
            {
               this.flvplayback_internal::cacheFLVPlaybackAlign[this.flvplayback_internal::_vc.visibleVideoPlayerIndex] = this.flvplayback_internal::_vc.align;
               this.flvplayback_internal::_vc.align = VideoAlign.CENTER;
            }
            if(this.flvplayback_internal::_vc.scaleMode != VideoScaleMode.MAINTAIN_ASPECT_RATIO)
            {
               this.flvplayback_internal::cacheFLVPlaybackScaleMode[this.flvplayback_internal::_vc.visibleVideoPlayerIndex] = this.flvplayback_internal::_vc.scaleMode;
               this.flvplayback_internal::_vc.scaleMode = VideoScaleMode.MAINTAIN_ASPECT_RATIO;
               this.flvplayback_internal::_vc.activeVideoPlayerIndex = _loc2_;
               return;
            }
            this.flvplayback_internal::_vc.activeVideoPlayerIndex = _loc2_;
         }
         this.flvplayback_internal::layoutSkin();
         this.flvplayback_internal::setupSkinAutoHide(false);
      }
      
      flvplayback_internal function handleIVPEvent(param1:IVPEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:fl.video.VideoEvent = null;
         var _loc5_:Sprite = null;
         var _loc6_:ControlData = null;
         var _loc7_:VideoProgressEvent = null;
         var _loc8_:VideoPlayerState = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         if(param1.vp != this.flvplayback_internal::_vc.visibleVideoPlayerIndex)
         {
            return;
         }
         var _loc2_:uint = this.flvplayback_internal::_vc.activeVideoPlayerIndex;
         this.flvplayback_internal::_vc.activeVideoPlayerIndex = this.flvplayback_internal::_vc.visibleVideoPlayerIndex;
         switch(param1.type)
         {
            case fl.video.VideoEvent.STATE_CHANGE:
               if((_loc4_ = VideoEvent(param1)).state == VideoState.BUFFERING)
               {
                  if(!this.flvplayback_internal::_bufferingOn)
                  {
                     this.flvplayback_internal::_bufferingDelayTimer.reset();
                     this.flvplayback_internal::_bufferingDelayTimer.start();
                  }
               }
               else
               {
                  this.flvplayback_internal::_bufferingDelayTimer.reset();
                  this.flvplayback_internal::_bufferingOn = false;
               }
               if(_loc4_.state == VideoState.LOADING)
               {
                  this.flvplayback_internal::_progressPercent = this.flvplayback_internal::_vc.getVideoPlayer(param1.vp).isRTMP ? 100 : 0;
                  _loc3_ = SEEK_BAR;
                  while(_loc3_ <= VOLUME_BAR)
                  {
                     _loc5_ = this.flvplayback_internal::controls[_loc3_];
                     if(this.flvplayback_internal::controls[_loc3_] != null)
                     {
                        if((_loc6_ = this.ctrlDataDict[_loc5_]).progress_mc != null)
                        {
                           this.flvplayback_internal::positionBar(_loc5_,"progress",this.flvplayback_internal::_progressPercent);
                        }
                     }
                     _loc3_++;
                  }
               }
               _loc3_ = 0;
               while(_loc3_ < NUM_CONTROLS)
               {
                  if(this.flvplayback_internal::controls[_loc3_] != undefined)
                  {
                     this.flvplayback_internal::setEnabledAndVisibleForState(_loc3_,_loc4_.state);
                     if(_loc3_ < NUM_BUTTONS)
                     {
                        this.flvplayback_internal::skinButtonControl(this.flvplayback_internal::controls[_loc3_]);
                     }
                  }
                  _loc3_++;
               }
               break;
            case fl.video.VideoEvent.READY:
            case MetadataEvent.METADATA_RECEIVED:
               _loc3_ = 0;
               while(_loc3_ < NUM_CONTROLS)
               {
                  if(this.flvplayback_internal::controls[_loc3_] != undefined)
                  {
                     this.flvplayback_internal::setEnabledAndVisibleForState(_loc3_,this.flvplayback_internal::_vc.state);
                     if(_loc3_ < NUM_BUTTONS)
                     {
                        this.flvplayback_internal::skinButtonControl(this.flvplayback_internal::controls[_loc3_]);
                     }
                  }
                  _loc3_++;
               }
               if(this.flvplayback_internal::_vc.getVideoPlayer(param1.vp).isRTMP)
               {
                  this.flvplayback_internal::_progressPercent = 100;
                  _loc3_ = SEEK_BAR;
                  while(_loc3_ <= VOLUME_BAR)
                  {
                     if((_loc5_ = this.flvplayback_internal::controls[_loc3_]) != null)
                     {
                        if((_loc6_ = this.ctrlDataDict[_loc5_]).progress_mc != null)
                        {
                           this.flvplayback_internal::positionBar(_loc5_,"progress",this.flvplayback_internal::_progressPercent);
                        }
                     }
                     _loc3_++;
                  }
                  break;
               }
               break;
            case fl.video.VideoEvent.PLAYHEAD_UPDATE:
               if(this.flvplayback_internal::controls[SEEK_BAR] != undefined && !this.flvplayback_internal::_vc.isLive && !isNaN(this.flvplayback_internal::_vc.totalTime) && this.flvplayback_internal::_vc.getVideoPlayer(this.flvplayback_internal::_vc.visibleVideoPlayerIndex).state != VideoState.SEEKING)
               {
                  if((_loc10_ = (_loc4_ = VideoEvent(param1)).playheadTime / this.flvplayback_internal::_vc.totalTime * 100) < 0)
                  {
                     _loc10_ = 0;
                  }
                  else if(_loc10_ > 100)
                  {
                     _loc10_ = 100;
                  }
                  _loc5_ = this.flvplayback_internal::controls[SEEK_BAR];
                  (_loc6_ = this.ctrlDataDict[_loc5_]).percentage = _loc10_;
                  this.flvplayback_internal::positionHandle(_loc5_);
                  break;
               }
               break;
            case VideoProgressEvent.PROGRESS:
               _loc7_ = VideoProgressEvent(param1);
               this.flvplayback_internal::_progressPercent = _loc7_.bytesTotal <= 0 ? 100 : _loc7_.bytesLoaded / _loc7_.bytesTotal * 100;
               _loc9_ = (_loc8_ = this.flvplayback_internal::_vc.flvplayback_internal::videoPlayerStates[param1.vp]).minProgressPercent;
               if(!isNaN(_loc9_) && _loc9_ > this.flvplayback_internal::_progressPercent)
               {
                  this.flvplayback_internal::_progressPercent = _loc9_;
               }
               if(!isNaN(this.flvplayback_internal::_vc.totalTime))
               {
                  if((_loc11_ = this.flvplayback_internal::_vc.playheadTime / this.flvplayback_internal::_vc.totalTime * 100) > this.flvplayback_internal::_progressPercent)
                  {
                     this.flvplayback_internal::_progressPercent = _loc11_;
                     _loc8_.minProgressPercent = this.flvplayback_internal::_progressPercent;
                  }
               }
               _loc3_ = SEEK_BAR;
               while(_loc3_ <= VOLUME_BAR)
               {
                  if((_loc5_ = this.flvplayback_internal::controls[_loc3_]) != null)
                  {
                     if((_loc6_ = this.ctrlDataDict[_loc5_]).progress_mc != null)
                     {
                        this.flvplayback_internal::positionBar(_loc5_,"progress",this.flvplayback_internal::_progressPercent);
                     }
                  }
                  _loc3_++;
               }
         }
         this.flvplayback_internal::_vc.activeVideoPlayerIndex = _loc2_;
      }
      
      public function get bufferingBarHidesAndDisablesOthers() : Boolean
      {
         return this.flvplayback_internal::_bufferingBarHides;
      }
      
      public function set bufferingBarHidesAndDisablesOthers(param1:Boolean) : void
      {
         this.flvplayback_internal::_bufferingBarHides = param1;
      }
      
      public function get controlsEnabled() : Boolean
      {
         return this.flvplayback_internal::_controlsEnabled;
      }
      
      public function set controlsEnabled(param1:Boolean) : void
      {
         if(this.flvplayback_internal::_controlsEnabled == param1)
         {
            return;
         }
         this.flvplayback_internal::_controlsEnabled = param1;
         var _loc2_:int = 0;
         while(_loc2_ < NUM_BUTTONS)
         {
            this.flvplayback_internal::skinButtonControl(this.flvplayback_internal::controls[_loc2_]);
            _loc2_++;
         }
      }
      
      public function get fullScreenBackgroundColor() : uint
      {
         return this.flvplayback_internal::_fullScreenBgColor;
      }
      
      public function set fullScreenBackgroundColor(param1:uint) : void
      {
         if(this.flvplayback_internal::_fullScreenBgColor != param1)
         {
            this.flvplayback_internal::_fullScreenBgColor = param1;
            if(!this.flvplayback_internal::_vc)
            {
            }
         }
      }
      
      public function get fullScreenSkinDelay() : int
      {
         return this.flvplayback_internal::_skinAutoHideMotionTimeout;
      }
      
      public function set fullScreenSkinDelay(param1:int) : void
      {
         this.flvplayback_internal::_skinAutoHideMotionTimeout = param1;
      }
      
      public function get fullScreenTakeOver() : Boolean
      {
         return this.flvplayback_internal::_fullScreenTakeOver;
      }
      
      public function set fullScreenTakeOver(param1:Boolean) : void
      {
         var v:Boolean = param1;
         if(this.flvplayback_internal::_fullScreenTakeOver != v)
         {
            this.flvplayback_internal::_fullScreenTakeOver = v;
            if(this.flvplayback_internal::_fullScreenTakeOver)
            {
               this.flvplayback_internal::enterFullScreenTakeOver();
            }
            else
            {
               if(this.flvplayback_internal::_vc.stage != null && this.flvplayback_internal::_fullScreen && this.flvplayback_internal::_fullScreenAccel)
               {
                  try
                  {
                     this.flvplayback_internal::_vc.stage.displayState = StageDisplayState.NORMAL;
                  }
                  catch(se:SecurityError)
                  {
                  }
               }
               this.flvplayback_internal::exitFullScreenTakeOver();
            }
         }
      }
      
      public function get skin() : String
      {
         return this.flvplayback_internal::_skin;
      }
      
      public function set skin(param1:String) : void
      {
         var _loc2_:String = null;
         if(param1 == null)
         {
            this.flvplayback_internal::removeSkin();
            this.flvplayback_internal::_skin = null;
            this.flvplayback_internal::_skinReady = true;
         }
         else
         {
            _loc2_ = String(param1);
            if(param1 == this.flvplayback_internal::_skin)
            {
               return;
            }
            this.flvplayback_internal::removeSkin();
            this.flvplayback_internal::_skin = String(param1);
            this.flvplayback_internal::_skinReady = this.flvplayback_internal::_skin == "";
            if(!this.flvplayback_internal::_skinReady)
            {
               this.flvplayback_internal::downloadSkin();
            }
         }
      }
      
      public function get skinAutoHide() : Boolean
      {
         return this.flvplayback_internal::_skinAutoHide;
      }
      
      public function set skinAutoHide(param1:Boolean) : void
      {
         if(param1 == this.flvplayback_internal::_skinAutoHide)
         {
            return;
         }
         this.flvplayback_internal::_skinAutoHide = param1;
         this.flvplayback_internal::cacheSkinAutoHide = param1;
         this.flvplayback_internal::setupSkinAutoHide(true);
      }
      
      public function get skinBackgroundAlpha() : Number
      {
         return this.flvplayback_internal::borderAlpha;
      }
      
      public function set skinBackgroundAlpha(param1:Number) : void
      {
         if(this.flvplayback_internal::borderAlpha != param1)
         {
            this.flvplayback_internal::borderAlpha = param1;
            this.flvplayback_internal::borderColorTransform.alphaOffset = 255 * param1;
            this.flvplayback_internal::borderPrevRect = null;
            this.flvplayback_internal::layoutSkin();
         }
      }
      
      public function get skinBackgroundColor() : uint
      {
         return this.flvplayback_internal::borderColor;
      }
      
      public function set skinBackgroundColor(param1:uint) : void
      {
         if(this.flvplayback_internal::borderColor != param1)
         {
            this.flvplayback_internal::borderColor = param1;
            this.flvplayback_internal::borderColorTransform.redOffset = this.flvplayback_internal::borderColor >> 16 & 255;
            this.flvplayback_internal::borderColorTransform.greenOffset = this.flvplayback_internal::borderColor >> 8 & 255;
            this.flvplayback_internal::borderColorTransform.blueOffset = this.flvplayback_internal::borderColor & 255;
            this.flvplayback_internal::borderPrevRect = null;
            this.flvplayback_internal::layoutSkin();
         }
      }
      
      public function get skinFadeTime() : int
      {
         return this.flvplayback_internal::_skinFadingMaxTime;
      }
      
      public function set skinFadeTime(param1:int) : void
      {
         this.flvplayback_internal::_skinFadingMaxTime = param1;
      }
      
      public function get skinReady() : Boolean
      {
         return this.flvplayback_internal::_skinReady;
      }
      
      public function get seekBarInterval() : Number
      {
         return this.flvplayback_internal::_seekBarTimer.delay;
      }
      
      public function set seekBarInterval(param1:Number) : void
      {
         if(this.flvplayback_internal::_seekBarTimer.delay == param1)
         {
            return;
         }
         this.flvplayback_internal::_seekBarTimer.delay = param1;
      }
      
      public function get volumeBarInterval() : Number
      {
         return this.flvplayback_internal::_volumeBarTimer.delay;
      }
      
      public function set volumeBarInterval(param1:Number) : void
      {
         if(this.flvplayback_internal::_volumeBarTimer.delay == param1)
         {
            return;
         }
         this.flvplayback_internal::_volumeBarTimer.delay = param1;
      }
      
      public function get bufferingDelayInterval() : Number
      {
         return this.flvplayback_internal::_bufferingDelayTimer.delay;
      }
      
      public function set bufferingDelayInterval(param1:Number) : void
      {
         if(this.flvplayback_internal::_bufferingDelayTimer.delay == param1)
         {
            return;
         }
         this.flvplayback_internal::_bufferingDelayTimer.delay = param1;
      }
      
      public function get volumeBarScrubTolerance() : Number
      {
         return this.flvplayback_internal::_volumeBarScrubTolerance;
      }
      
      public function set volumeBarScrubTolerance(param1:Number) : void
      {
         this.flvplayback_internal::_volumeBarScrubTolerance = param1;
      }
      
      public function get seekBarScrubTolerance() : Number
      {
         return this.flvplayback_internal::_seekBarScrubTolerance;
      }
      
      public function set seekBarScrubTolerance(param1:Number) : void
      {
         this.flvplayback_internal::_seekBarScrubTolerance = param1;
      }
      
      public function get skinScaleMaximum() : Number
      {
         return this.flvplayback_internal::_skinScaleMaximum;
      }
      
      public function set skinScaleMaximum(param1:Number) : void
      {
         this.flvplayback_internal::_skinScaleMaximum = param1;
      }
      
      public function get visible() : Boolean
      {
         return this.flvplayback_internal::__visible;
      }
      
      public function set visible(param1:Boolean) : void
      {
         if(this.flvplayback_internal::__visible == param1)
         {
            return;
         }
         this.flvplayback_internal::__visible = param1;
         if(!this.flvplayback_internal::__visible)
         {
            this.flvplayback_internal::skin_mc.visible = false;
         }
         else
         {
            this.flvplayback_internal::setupSkinAutoHide(false);
         }
      }
      
      public function getControl(param1:int) : Sprite
      {
         return this.flvplayback_internal::controls[param1];
      }
      
      public function setControl(param1:int, param2:Sprite) : void
      {
         var ctrlData:ControlData;
         var index:int = param1;
         var ctrl:Sprite = param2;
         if(ctrl == this.flvplayback_internal::controls[index])
         {
            return;
         }
         if(ctrl)
         {
            ctrl.tabEnabled = false;
         }
         switch(index)
         {
            case PAUSE_BUTTON:
            case PLAY_BUTTON:
               this.flvplayback_internal::resetPlayPause();
               break;
            case PLAY_PAUSE_BUTTON:
               if(ctrl == null || ctrl.parent != this.flvplayback_internal::skin_mc)
               {
                  this.flvplayback_internal::resetPlayPause();
               }
               if(ctrl != null)
               {
                  this.setControl(PAUSE_BUTTON,Sprite(ctrl.getChildByName("pause_mc")));
                  this.setControl(PLAY_BUTTON,Sprite(ctrl.getChildByName("play_mc")));
                  break;
               }
               break;
            case FULL_SCREEN_BUTTON:
               if(ctrl != null)
               {
                  this.setControl(FULL_SCREEN_ON_BUTTON,Sprite(ctrl.getChildByName("on_mc")));
                  this.setControl(FULL_SCREEN_OFF_BUTTON,Sprite(ctrl.getChildByName("off_mc")));
                  break;
               }
               break;
            case MUTE_BUTTON:
               if(ctrl != null)
               {
                  this.setControl(MUTE_ON_BUTTON,Sprite(ctrl.getChildByName("on_mc")));
                  this.setControl(MUTE_OFF_BUTTON,Sprite(ctrl.getChildByName("off_mc")));
                  break;
               }
         }
         if(this.flvplayback_internal::controls[index] != null)
         {
            try
            {
               delete this.flvplayback_internal::controls[index]["uiMgr"];
            }
            catch(re:ReferenceError)
            {
            }
            if(index < NUM_BUTTONS)
            {
               this.flvplayback_internal::removeButtonListeners(this.flvplayback_internal::controls[index]);
            }
            delete this.ctrlDataDict[this.flvplayback_internal::controls[index]];
            delete this.flvplayback_internal::controls[index];
         }
         if(ctrl == null)
         {
            return;
         }
         ctrlData = this.ctrlDataDict[ctrl];
         if(ctrlData == null)
         {
            ctrlData = new ControlData(this,ctrl,null,index);
            this.ctrlDataDict[ctrl] = ctrlData;
         }
         else
         {
            ctrlData.index = index;
         }
         if(index >= NUM_BUTTONS)
         {
            this.flvplayback_internal::controls[index] = ctrl;
            switch(index)
            {
               case SEEK_BAR:
                  this.flvplayback_internal::addBarControl(ctrl);
                  break;
               case VOLUME_BAR:
                  this.flvplayback_internal::addBarControl(ctrl);
                  ctrlData.percentage = this.flvplayback_internal::_vc.volume * 100;
                  break;
               case BUFFERING_BAR:
                  if(ctrl.parent == this.flvplayback_internal::skin_mc)
                  {
                     this.flvplayback_internal::finishAddBufferingBar();
                     break;
                  }
                  ctrl.addEventListener(Event.ENTER_FRAME,this.flvplayback_internal::finishAddBufferingBar);
                  break;
            }
            this.flvplayback_internal::setEnabledAndVisibleForState(index,this.flvplayback_internal::_vc.state);
         }
         else
         {
            this.flvplayback_internal::controls[index] = ctrl;
            this.flvplayback_internal::addButtonControl(ctrl);
         }
      }
      
      flvplayback_internal function resetPlayPause() : void
      {
         if(this.flvplayback_internal::controls[PLAY_PAUSE_BUTTON] == undefined)
         {
            return;
         }
         var _loc1_:int = PAUSE_BUTTON;
         while(_loc1_ <= PLAY_BUTTON)
         {
            this.flvplayback_internal::removeButtonListeners(this.flvplayback_internal::controls[_loc1_]);
            delete this.ctrlDataDict[this.flvplayback_internal::controls[_loc1_]];
            delete this.flvplayback_internal::controls[_loc1_];
            _loc1_++;
         }
         delete this.ctrlDataDict[this.flvplayback_internal::controls[PLAY_PAUSE_BUTTON]];
         delete this.flvplayback_internal::controls[PLAY_PAUSE_BUTTON];
      }
      
      flvplayback_internal function addButtonControl(param1:Sprite) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc2_:ControlData = this.ctrlDataDict[param1];
         param1.buttonMode = true;
         param1.tabEnabled = true;
         param1.tabChildren = true;
         param1.focusRect = this.flvplayback_internal::focusRect;
         param1.accessibilityProperties = new AccessibilityProperties();
         param1.accessibilityProperties.forceSimple = true;
         param1.accessibilityProperties.silent = true;
         if(this.flvplayback_internal::accessibilityPropertyNames[_loc2_.index] != null)
         {
            param1.accessibilityProperties.name = this.flvplayback_internal::accessibilityPropertyNames[_loc2_.index];
            param1.accessibilityProperties.silent = false;
         }
         if(_loc2_.index == VOLUME_BAR_HIT || _loc2_.index == SEEK_BAR_HIT)
         {
            param1.buttonMode = false;
            param1.tabEnabled = false;
            param1.tabChildren = false;
            param1.focusRect = false;
            param1.accessibilityProperties.silent = true;
         }
         if(_loc2_.index == VOLUME_BAR_HANDLE || _loc2_.index == SEEK_BAR_HANDLE)
         {
            param1.graphics.moveTo(0,-18);
            param1.graphics.lineStyle(0,0,0);
            param1.graphics.lineTo(0,-18);
            param1.buttonMode = false;
            param1.focusRect = true;
            param1.accessibilityProperties.silent = false;
            this.flvplayback_internal::configureBarAccessibility(_loc2_.index);
         }
         param1.mouseChildren = false;
         var _loc3_:int = int(this.flvplayback_internal::_vc.activeVideoPlayerIndex);
         this.flvplayback_internal::_vc.activeVideoPlayerIndex = this.flvplayback_internal::_vc.visibleVideoPlayerIndex;
         _loc2_.state = NORMAL_STATE;
         this.flvplayback_internal::setEnabledAndVisibleForState(_loc2_.index,this.flvplayback_internal::_vc.state);
         param1.addEventListener(MouseEvent.ROLL_OVER,this.flvplayback_internal::handleButtonEvent);
         param1.addEventListener(MouseEvent.ROLL_OUT,this.flvplayback_internal::handleButtonEvent);
         param1.addEventListener(MouseEvent.MOUSE_DOWN,this.flvplayback_internal::handleButtonEvent);
         param1.addEventListener(MouseEvent.CLICK,this.flvplayback_internal::handleButtonEvent);
         param1.addEventListener(KeyboardEvent.KEY_DOWN,this.flvplayback_internal::handleKeyEvent);
         param1.addEventListener(KeyboardEvent.KEY_UP,this.flvplayback_internal::handleKeyEvent);
         param1.addEventListener(FocusEvent.FOCUS_IN,this.flvplayback_internal::handleFocusEvent);
         param1.addEventListener(FocusEvent.FOCUS_OUT,this.flvplayback_internal::handleFocusEvent);
         if(param1.parent == this.flvplayback_internal::skin_mc)
         {
            this.flvplayback_internal::skinButtonControl(param1);
         }
         else
         {
            param1.addEventListener(Event.ENTER_FRAME,this.flvplayback_internal::skinButtonControl);
         }
         this.flvplayback_internal::_vc.activeVideoPlayerIndex = _loc3_;
      }
      
      flvplayback_internal function handleButtonEvent(param1:MouseEvent) : void
      {
         var topLevel:DisplayObject = null;
         var e:MouseEvent = param1;
         var ctrlData:ControlData = this.ctrlDataDict[e.currentTarget];
         switch(e.type)
         {
            case MouseEvent.ROLL_OVER:
               ctrlData.state = OVER_STATE;
               break;
            case MouseEvent.ROLL_OUT:
               ctrlData.state = NORMAL_STATE;
               break;
            case MouseEvent.MOUSE_DOWN:
               ctrlData.state = DOWN_STATE;
               this.flvplayback_internal::mouseCaptureCtrl = ctrlData.index;
               switch(this.flvplayback_internal::mouseCaptureCtrl)
               {
                  case SEEK_BAR_HANDLE:
                  case SEEK_BAR_HIT:
                  case VOLUME_BAR_HANDLE:
                  case VOLUME_BAR_HIT:
                     this.flvplayback_internal::dispatchMessage(ctrlData.index);
               }
               topLevel = this.flvplayback_internal::_vc.stage;
               try
               {
                  topLevel.addEventListener(MouseEvent.MOUSE_DOWN,this.flvplayback_internal::captureMouseEvent,true,0,true);
               }
               catch(se:SecurityError)
               {
                  topLevel = flvplayback_internal::_vc.root;
                  topLevel.addEventListener(MouseEvent.MOUSE_DOWN,flvplayback_internal::captureMouseEvent,true,0,true);
               }
               topLevel.addEventListener(MouseEvent.MOUSE_OUT,this.flvplayback_internal::captureMouseEvent,true,0,true);
               topLevel.addEventListener(MouseEvent.MOUSE_OVER,this.flvplayback_internal::captureMouseEvent,true,0,true);
               topLevel.addEventListener(MouseEvent.MOUSE_UP,this.flvplayback_internal::handleMouseUp,false,0,true);
               topLevel.addEventListener(MouseEvent.ROLL_OUT,this.flvplayback_internal::captureMouseEvent,true,0,true);
               topLevel.addEventListener(MouseEvent.ROLL_OVER,this.flvplayback_internal::captureMouseEvent,true,0,true);
               break;
            case MouseEvent.CLICK:
               switch(this.flvplayback_internal::mouseCaptureCtrl)
               {
                  case SEEK_BAR_HANDLE:
                  case SEEK_BAR_HIT:
                  case VOLUME_BAR_HANDLE:
                  case VOLUME_BAR_HIT:
                  case FULL_SCREEN_OFF_BUTTON:
                  case FULL_SCREEN_ON_BUTTON:
                     break;
                  default:
                     this.flvplayback_internal::dispatchMessage(ctrlData.index);
               }
               return;
         }
         this.flvplayback_internal::skinButtonControl(e.currentTarget);
      }
      
      flvplayback_internal function captureMouseEvent(param1:MouseEvent) : void
      {
         param1.stopPropagation();
      }
      
      flvplayback_internal function handleMouseUp(param1:MouseEvent) : void
      {
         var _loc3_:ControlData = null;
         var _loc2_:Sprite = this.flvplayback_internal::controls[this.flvplayback_internal::mouseCaptureCtrl];
         if(_loc2_ != null)
         {
            _loc3_ = this.ctrlDataDict[_loc2_];
            _loc3_.state = _loc2_.hitTestPoint(param1.stageX,param1.stageY,true) ? OVER_STATE : NORMAL_STATE;
            this.flvplayback_internal::skinButtonControl(_loc2_);
            switch(this.flvplayback_internal::mouseCaptureCtrl)
            {
               case SEEK_BAR_HANDLE:
               case SEEK_BAR_HIT:
                  this.flvplayback_internal::handleRelease(SEEK_BAR);
                  break;
               case VOLUME_BAR_HANDLE:
               case VOLUME_BAR_HIT:
                  this.flvplayback_internal::handleRelease(VOLUME_BAR);
                  break;
               case FULL_SCREEN_OFF_BUTTON:
               case FULL_SCREEN_ON_BUTTON:
                  this.flvplayback_internal::dispatchMessage(_loc3_.index);
            }
         }
         param1.currentTarget.removeEventListener(MouseEvent.MOUSE_DOWN,this.flvplayback_internal::captureMouseEvent,true);
         param1.currentTarget.removeEventListener(MouseEvent.MOUSE_OUT,this.flvplayback_internal::captureMouseEvent,true);
         param1.currentTarget.removeEventListener(MouseEvent.MOUSE_OVER,this.flvplayback_internal::captureMouseEvent,true);
         param1.currentTarget.removeEventListener(MouseEvent.MOUSE_UP,this.flvplayback_internal::handleMouseUp);
         param1.currentTarget.removeEventListener(MouseEvent.ROLL_OUT,this.flvplayback_internal::captureMouseEvent,true);
         param1.currentTarget.removeEventListener(MouseEvent.ROLL_OVER,this.flvplayback_internal::captureMouseEvent,true);
      }
      
      flvplayback_internal function removeButtonListeners(param1:Sprite) : void
      {
         if(param1 == null)
         {
            return;
         }
         param1.removeEventListener(MouseEvent.ROLL_OVER,this.flvplayback_internal::handleButtonEvent);
         param1.removeEventListener(MouseEvent.ROLL_OUT,this.flvplayback_internal::handleButtonEvent);
         param1.removeEventListener(MouseEvent.MOUSE_DOWN,this.flvplayback_internal::handleButtonEvent);
         param1.removeEventListener(MouseEvent.CLICK,this.flvplayback_internal::handleButtonEvent);
         param1.removeEventListener(Event.ENTER_FRAME,this.flvplayback_internal::skinButtonControl);
      }
      
      flvplayback_internal function downloadSkin() : void
      {
         if(this.flvplayback_internal::skinLoader == null)
         {
            this.flvplayback_internal::skinLoader = new Loader();
            this.flvplayback_internal::skinLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.flvplayback_internal::handleLoad);
            this.flvplayback_internal::skinLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.flvplayback_internal::handleLoadErrorEvent);
            this.flvplayback_internal::skinLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.flvplayback_internal::handleLoadErrorEvent);
         }
         this.flvplayback_internal::skinLoader.load(new URLRequest(this.flvplayback_internal::_skin));
      }
      
      flvplayback_internal function handleLoadErrorEvent(param1:ErrorEvent) : void
      {
         this.flvplayback_internal::_skinReady = true;
         this.flvplayback_internal::_vc.flvplayback_internal::skinError(param1.toString());
      }
      
      flvplayback_internal function handleLoad(param1:Event) : void
      {
         var i:int = 0;
         var dispObj:DisplayObject = null;
         var index:Number = NaN;
         var e:Event = param1;
         try
         {
            this.flvplayback_internal::skin_mc = new Sprite();
            if(e != null)
            {
               this.flvplayback_internal::skinTemplate = Sprite(this.flvplayback_internal::skinLoader.content);
            }
            this.flvplayback_internal::layout_mc = this.flvplayback_internal::skinTemplate;
            this.customClips = new Array();
            this.flvplayback_internal::delayedControls = new Array();
            i = 0;
            while(i < this.flvplayback_internal::layout_mc.numChildren)
            {
               dispObj = this.flvplayback_internal::layout_mc.getChildAt(i);
               index = Number(flvplayback_internal::layoutNameToIndexMappings[dispObj.name]);
               if(!isNaN(index))
               {
                  this.flvplayback_internal::setSkin(int(index),dispObj);
               }
               else if(dispObj.name != "video_mc")
               {
                  this.flvplayback_internal::setCustomClip(dispObj);
               }
               i++;
            }
            this.flvplayback_internal::skinLoadDelayCount = 0;
            this.flvplayback_internal::_vc.addEventListener(Event.ENTER_FRAME,this.flvplayback_internal::finishLoad);
         }
         catch(err:Error)
         {
            flvplayback_internal::_vc.flvplayback_internal::skinError(err.message);
            flvplayback_internal::removeSkin();
         }
      }
      
      flvplayback_internal function finishLoad(param1:Event) : void
      {
         var i:int = 0;
         var cachedActivePlayerIndex:int = 0;
         var state:String = null;
         var j:int = 0;
         var e:Event = param1;
         try
         {
            ++this.flvplayback_internal::skinLoadDelayCount;
            if(this.flvplayback_internal::skinLoadDelayCount < 2)
            {
               return;
            }
            this.flvplayback_internal::_vc.removeEventListener(Event.ENTER_FRAME,this.flvplayback_internal::finishLoad);
            this.flvplayback_internal::focusRect = this.flvplayback_internal::isFocusRectActive();
            i = 0;
            while(i < NUM_CONTROLS)
            {
               if(this.flvplayback_internal::delayedControls[i] != undefined)
               {
                  this.setControl(i,this.flvplayback_internal::delayedControls[i]);
               }
               i++;
            }
            if(this.flvplayback_internal::_fullScreenTakeOver)
            {
               this.flvplayback_internal::enterFullScreenTakeOver();
            }
            else
            {
               this.flvplayback_internal::exitFullScreenTakeOver();
            }
            this.flvplayback_internal::layoutSkin();
            this.flvplayback_internal::setupSkinAutoHide(false);
            this.flvplayback_internal::skin_mc.visible = this.flvplayback_internal::__visible;
            this.flvplayback_internal::_vc.addChild(this.flvplayback_internal::skin_mc);
            this.flvplayback_internal::_skinReady = true;
            this.flvplayback_internal::_vc.flvplayback_internal::skinLoaded();
            cachedActivePlayerIndex = int(this.flvplayback_internal::_vc.activeVideoPlayerIndex);
            this.flvplayback_internal::_vc.activeVideoPlayerIndex = this.flvplayback_internal::_vc.visibleVideoPlayerIndex;
            state = this.flvplayback_internal::_vc.state;
            j = 0;
            while(j < NUM_CONTROLS)
            {
               if(this.flvplayback_internal::controls[j] != undefined)
               {
                  this.flvplayback_internal::setEnabledAndVisibleForState(j,state);
                  if(j < NUM_BUTTONS)
                  {
                     this.flvplayback_internal::skinButtonControl(this.flvplayback_internal::controls[j]);
                  }
               }
               j++;
            }
            this.flvplayback_internal::_vc.activeVideoPlayerIndex = cachedActivePlayerIndex;
         }
         catch(err:Error)
         {
            flvplayback_internal::_vc.flvplayback_internal::skinError(err.message);
            flvplayback_internal::removeSkin();
         }
      }
      
      flvplayback_internal function layoutSkin() : void
      {
         var video_mc:DisplayObject;
         var i:int = 0;
         var borderRect:Rectangle = null;
         var forceSkinAutoHide:Boolean = false;
         var minWidth:Number = NaN;
         var vidWidth:Number = NaN;
         var minHeight:Number = NaN;
         var vidHeight:Number = NaN;
         if(this.flvplayback_internal::layout_mc == null)
         {
            return;
         }
         if(this.flvplayback_internal::skinLoadDelayCount < 2)
         {
            return;
         }
         video_mc = this.flvplayback_internal::layout_mc["video_mc"];
         if(video_mc == null)
         {
            throw new Error("No layout_mc.video_mc");
         }
         this.flvplayback_internal::placeholderLeft = video_mc.x;
         this.flvplayback_internal::placeholderRight = video_mc.x + video_mc.width;
         this.flvplayback_internal::placeholderTop = video_mc.y;
         this.flvplayback_internal::placeholderBottom = video_mc.y + video_mc.height;
         this.flvplayback_internal::videoLeft = this.flvplayback_internal::_vc.x - this.flvplayback_internal::_vc.registrationX;
         this.flvplayback_internal::videoRight = this.flvplayback_internal::videoLeft + this.flvplayback_internal::_vc.width;
         this.flvplayback_internal::videoTop = this.flvplayback_internal::_vc.y - this.flvplayback_internal::_vc.registrationY;
         this.flvplayback_internal::videoBottom = this.flvplayback_internal::videoTop + this.flvplayback_internal::_vc.height;
         if(this.flvplayback_internal::_fullScreen && this.flvplayback_internal::_fullScreenTakeOver && this.flvplayback_internal::border_mc != null)
         {
            borderRect = this.flvplayback_internal::calcLayoutControl(this.flvplayback_internal::border_mc);
            forceSkinAutoHide = false;
            if(borderRect.width > 0 && borderRect.height > 0)
            {
               if(borderRect.x < 0)
               {
                  this.flvplayback_internal::placeholderLeft += this.flvplayback_internal::videoLeft - borderRect.x;
                  forceSkinAutoHide = true;
               }
               if(borderRect.x + borderRect.width > this.flvplayback_internal::_vc.registrationWidth)
               {
                  this.flvplayback_internal::placeholderRight += borderRect.x + borderRect.width - this.flvplayback_internal::videoRight;
                  forceSkinAutoHide = true;
               }
               if(borderRect.y < 0)
               {
                  this.flvplayback_internal::placeholderTop += this.flvplayback_internal::videoTop - borderRect.y;
                  forceSkinAutoHide = true;
               }
               if(borderRect.y + borderRect.height > this.flvplayback_internal::_vc.registrationHeight)
               {
                  this.flvplayback_internal::placeholderBottom += borderRect.y + borderRect.height - this.flvplayback_internal::videoBottom;
                  forceSkinAutoHide = true;
               }
               if(forceSkinAutoHide)
               {
                  this.flvplayback_internal::_skinAutoHide = true;
                  this.flvplayback_internal::setupSkinAutoHide(true);
               }
            }
         }
         try
         {
            if(!isNaN(this.flvplayback_internal::layout_mc["minWidth"]))
            {
               minWidth = Number(this.flvplayback_internal::layout_mc["minWidth"]);
               vidWidth = this.flvplayback_internal::videoRight - this.flvplayback_internal::videoLeft;
               if(minWidth > 0 && minWidth > vidWidth)
               {
                  this.flvplayback_internal::videoLeft -= (minWidth - vidWidth) / 2;
                  this.flvplayback_internal::videoRight = minWidth + this.flvplayback_internal::videoLeft;
               }
            }
         }
         catch(re1:ReferenceError)
         {
         }
         try
         {
            if(!isNaN(this.flvplayback_internal::layout_mc["minHeight"]))
            {
               minHeight = Number(this.flvplayback_internal::layout_mc["minHeight"]);
               vidHeight = this.flvplayback_internal::videoBottom - this.flvplayback_internal::videoTop;
               if(minHeight > 0 && minHeight > vidHeight)
               {
                  this.flvplayback_internal::videoTop -= (minHeight - vidHeight) / 2;
                  this.flvplayback_internal::videoBottom = minHeight + this.flvplayback_internal::videoTop;
               }
            }
         }
         catch(re2:ReferenceError)
         {
         }
         i = 0;
         while(i < this.customClips.length)
         {
            this.flvplayback_internal::layoutControl(this.customClips[i]);
            if(this.customClips[i] == this.flvplayback_internal::border_mc)
            {
               this.flvplayback_internal::bitmapCopyBorder();
            }
            i++;
         }
         i = 0;
         while(i < NUM_CONTROLS)
         {
            this.flvplayback_internal::layoutControl(this.flvplayback_internal::controls[i]);
            i++;
         }
      }
      
      flvplayback_internal function bitmapCopyBorder() : void
      {
         var _loc2_:BitmapData = null;
         var _loc3_:Matrix = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Rectangle = null;
         var _loc7_:int = 0;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:int = 0;
         var _loc11_:Bitmap = null;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         if(this.flvplayback_internal::border_mc == null || this.flvplayback_internal::borderCopy == null)
         {
            return;
         }
         var _loc1_:Rectangle = this.flvplayback_internal::border_mc.getBounds(this.flvplayback_internal::skin_mc);
         if(this.flvplayback_internal::borderPrevRect == null || !this.flvplayback_internal::borderPrevRect.equals(_loc1_))
         {
            this.flvplayback_internal::borderCopy.x = _loc1_.x;
            this.flvplayback_internal::borderCopy.y = _loc1_.y;
            _loc3_ = new Matrix(this.flvplayback_internal::border_mc.scaleX,0,0,this.flvplayback_internal::border_mc.scaleY,0,0);
            if(this.flvplayback_internal::borderScale9Rects == null)
            {
               _loc2_ = new BitmapData(_loc1_.width,_loc1_.height,true,0);
               _loc2_.draw(this.flvplayback_internal::border_mc,_loc3_,this.flvplayback_internal::borderColorTransform);
               Bitmap(this.flvplayback_internal::borderCopy.getChildAt(0)).bitmapData = _loc2_;
            }
            else
            {
               _loc4_ = 0;
               _loc5_ = 0;
               _loc6_ = new Rectangle(0,0,0,0);
               _loc7_ = 0;
               _loc8_ = 0;
               if(this.flvplayback_internal::borderScale9Rects[3] != null)
               {
                  _loc8_ += this.flvplayback_internal::borderScale9Rects[3].width;
               }
               if(this.flvplayback_internal::borderScale9Rects[5] != null)
               {
                  _loc8_ += this.flvplayback_internal::borderScale9Rects[5].width;
               }
               _loc9_ = 0;
               if(this.flvplayback_internal::borderScale9Rects[1] != null)
               {
                  _loc9_ += this.flvplayback_internal::borderScale9Rects[1].height;
               }
               if(this.flvplayback_internal::borderScale9Rects[7] != null)
               {
                  _loc9_ += this.flvplayback_internal::borderScale9Rects[7].height;
               }
               _loc10_ = 0;
               while(_loc10_ < this.flvplayback_internal::borderScale9Rects.length)
               {
                  if(_loc10_ % 3 == 0)
                  {
                     _loc4_ = 0;
                     _loc5_ += _loc6_.height;
                  }
                  if(this.flvplayback_internal::borderScale9Rects[_loc10_] != null)
                  {
                     _loc6_ = Rectangle(this.flvplayback_internal::borderScale9Rects[_loc10_]).clone();
                     _loc3_.a = 1;
                     if(_loc10_ == 1 || _loc10_ == 4 || _loc10_ == 7)
                     {
                        _loc12_ = (_loc1_.width - _loc8_) / _loc6_.width;
                        _loc6_.x *= _loc12_;
                        _loc6_.width *= _loc12_;
                        _loc6_.width = Math.round(_loc6_.width);
                        _loc3_.a *= _loc12_;
                     }
                     _loc3_.tx = -_loc6_.x;
                     _loc6_.x = 0;
                     _loc3_.d = 1;
                     if(_loc10_ >= 3 && _loc10_ <= 5)
                     {
                        _loc13_ = (_loc1_.height - _loc9_) / _loc6_.height;
                        _loc6_.y *= _loc13_;
                        _loc6_.height *= _loc13_;
                        _loc6_.height = Math.round(_loc6_.height);
                        _loc3_.d *= _loc13_;
                     }
                     _loc3_.ty = -_loc6_.y;
                     _loc6_.y = 0;
                     _loc2_ = new BitmapData(_loc6_.width,_loc6_.height,true,0);
                     _loc2_.draw(this.flvplayback_internal::border_mc,_loc3_,this.flvplayback_internal::borderColorTransform,null,_loc6_,false);
                     _loc11_ = Bitmap(this.flvplayback_internal::borderCopy.getChildAt(_loc7_));
                     _loc7_++;
                     _loc11_.bitmapData = _loc2_;
                     _loc11_.x = _loc4_;
                     _loc11_.y = _loc5_;
                     _loc4_ += _loc6_.width;
                  }
                  _loc10_++;
               }
            }
            this.flvplayback_internal::borderPrevRect = _loc1_;
         }
      }
      
      flvplayback_internal function layoutControl(param1:DisplayObject) : void
      {
         var _loc4_:Sprite = null;
         var _loc5_:Rectangle = null;
         if(param1 == null)
         {
            return;
         }
         var _loc2_:ControlData = this.ctrlDataDict[param1];
         if(_loc2_ == null)
         {
            return;
         }
         if(_loc2_.avatar == null)
         {
            return;
         }
         var _loc3_:Rectangle = this.flvplayback_internal::calcLayoutControl(param1);
         param1.x = _loc3_.x;
         param1.y = _loc3_.y;
         param1.width = _loc3_.width;
         param1.height = _loc3_.height;
         switch(_loc2_.index)
         {
            case SEEK_BAR:
            case VOLUME_BAR:
               if(_loc2_.hit_mc != null && _loc2_.hit_mc.parent == this.flvplayback_internal::skin_mc)
               {
                  _loc4_ = _loc2_.hit_mc;
                  _loc5_ = this.flvplayback_internal::calcLayoutControl(_loc4_);
                  _loc4_.x = _loc5_.x;
                  _loc4_.y = _loc5_.y;
                  _loc4_.width = _loc5_.width;
                  _loc4_.height = _loc5_.height;
               }
               if(_loc2_.progress_mc != null)
               {
                  if(isNaN(this.flvplayback_internal::_progressPercent))
                  {
                     this.flvplayback_internal::_progressPercent = this.flvplayback_internal::_vc.isRTMP ? 100 : 0;
                  }
                  this.flvplayback_internal::positionBar(Sprite(param1),"progress",this.flvplayback_internal::_progressPercent);
               }
               this.flvplayback_internal::positionHandle(Sprite(param1));
               break;
            case BUFFERING_BAR:
               this.flvplayback_internal::positionMaskedFill(param1,100);
         }
      }
      
      flvplayback_internal function calcLayoutControl(param1:DisplayObject) : Rectangle
      {
         var ctrlData:ControlData;
         var anchorRight:Boolean;
         var anchorLeft:Boolean;
         var anchorTop:Boolean;
         var anchorBottom:Boolean;
         var ctrl:DisplayObject = param1;
         var rect:Rectangle = new Rectangle();
         if(ctrl == null)
         {
            return rect;
         }
         ctrlData = this.ctrlDataDict[ctrl];
         if(ctrlData == null)
         {
            return rect;
         }
         if(ctrlData.avatar == null)
         {
            return rect;
         }
         anchorRight = false;
         anchorLeft = true;
         anchorTop = false;
         anchorBottom = true;
         try
         {
            anchorRight = Boolean(ctrlData.avatar["anchorRight"]);
         }
         catch(re1:ReferenceError)
         {
            anchorRight = false;
         }
         try
         {
            anchorLeft = Boolean(ctrlData.avatar["anchorLeft"]);
         }
         catch(re1:ReferenceError)
         {
            anchorLeft = true;
         }
         try
         {
            anchorTop = Boolean(ctrlData.avatar["anchorTop"]);
         }
         catch(re1:ReferenceError)
         {
            anchorTop = false;
         }
         try
         {
            anchorBottom = Boolean(ctrlData.avatar["anchorBottom"]);
         }
         catch(re1:ReferenceError)
         {
            anchorBottom = true;
         }
         if(anchorRight)
         {
            if(anchorLeft)
            {
               rect.x = ctrlData.avatar.x - this.flvplayback_internal::placeholderLeft + this.flvplayback_internal::videoLeft;
               rect.width = ctrlData.avatar.x + ctrlData.avatar.width - this.flvplayback_internal::placeholderRight + this.flvplayback_internal::videoRight - rect.x;
               ctrlData.origWidth = NaN;
            }
            else
            {
               rect.x = ctrlData.avatar.x - this.flvplayback_internal::placeholderRight + this.flvplayback_internal::videoRight;
               rect.width = ctrl.width;
            }
         }
         else
         {
            rect.x = ctrlData.avatar.x - this.flvplayback_internal::placeholderLeft + this.flvplayback_internal::videoLeft;
            rect.width = ctrl.width;
         }
         if(anchorTop)
         {
            if(anchorBottom)
            {
               rect.y = ctrlData.avatar.y - this.flvplayback_internal::placeholderTop + this.flvplayback_internal::videoTop;
               rect.height = ctrlData.avatar.y + ctrlData.avatar.height - this.flvplayback_internal::placeholderBottom + this.flvplayback_internal::videoBottom - rect.y;
               ctrlData.origHeight = NaN;
            }
            else
            {
               rect.y = ctrlData.avatar.y - this.flvplayback_internal::placeholderTop + this.flvplayback_internal::videoTop;
               rect.height = ctrl.height;
            }
         }
         else
         {
            rect.y = ctrlData.avatar.y - this.flvplayback_internal::placeholderBottom + this.flvplayback_internal::videoBottom;
            rect.height = ctrl.height;
         }
         try
         {
            if(ctrl["layoutSelf"] is Function)
            {
               rect = ctrl["layoutSelf"](rect);
            }
         }
         catch(re3:ReferenceError)
         {
         }
         return rect;
      }
      
      flvplayback_internal function removeSkin() : void
      {
         var i:int = 0;
         if(this.flvplayback_internal::skinLoader != null)
         {
            try
            {
               this.flvplayback_internal::skinLoader.close();
            }
            catch(e1:Error)
            {
            }
            this.flvplayback_internal::skinLoader = null;
         }
         if(this.flvplayback_internal::skin_mc != null)
         {
            i = 0;
            while(i < NUM_CONTROLS)
            {
               if(this.flvplayback_internal::controls[i] != undefined)
               {
                  if(i < NUM_BUTTONS)
                  {
                     this.flvplayback_internal::removeButtonListeners(this.flvplayback_internal::controls[i]);
                  }
                  delete this.ctrlDataDict[this.flvplayback_internal::controls[i]];
                  delete this.flvplayback_internal::controls[i];
               }
               i++;
            }
            try
            {
               this.flvplayback_internal::skin_mc.parent.removeChild(this.flvplayback_internal::skin_mc);
            }
            catch(e2:Error)
            {
            }
            this.flvplayback_internal::skin_mc = null;
         }
         this.flvplayback_internal::skinTemplate = null;
         this.flvplayback_internal::layout_mc = null;
         this.flvplayback_internal::border_mc = null;
         this.flvplayback_internal::borderCopy = null;
         this.flvplayback_internal::borderPrevRect = null;
         this.flvplayback_internal::borderScale9Rects = null;
      }
      
      flvplayback_internal function setCustomClip(param1:DisplayObject) : void
      {
         var ctrlData:ControlData;
         var scale9Grid:Rectangle = null;
         var diff:Number = NaN;
         var numBorderBitmaps:int = 0;
         var i:int = 0;
         var lastXDim:Number = NaN;
         var floorLastXDim:Number = NaN;
         var lastYDim:Number = NaN;
         var floorLastYDim:Number = NaN;
         var newRect:Rectangle = null;
         var dispObj:DisplayObject = param1;
         var dCopy:DisplayObject = new dispObj["constructor"]();
         this.flvplayback_internal::skin_mc.addChild(dCopy);
         ctrlData = new ControlData(this,dCopy,null,-1);
         this.ctrlDataDict[dCopy] = ctrlData;
         ctrlData.avatar = dispObj;
         this.customClips.push(dCopy);
         dCopy.accessibilityProperties = new AccessibilityProperties();
         dCopy.accessibilityProperties.silent = true;
         if(dispObj.name == "border_mc")
         {
            this.flvplayback_internal::border_mc = dCopy;
            try
            {
               this.flvplayback_internal::borderCopy = !!ctrlData.avatar["colorMe"] ? new Sprite() : null;
            }
            catch(re:ReferenceError)
            {
               flvplayback_internal::borderCopy = null;
            }
            if(this.flvplayback_internal::borderCopy != null)
            {
               this.flvplayback_internal::border_mc.visible = false;
               scale9Grid = this.flvplayback_internal::border_mc.scale9Grid;
               scale9Grid.x = Math.round(scale9Grid.x);
               scale9Grid.y = Math.round(scale9Grid.y);
               scale9Grid.width = Math.round(scale9Grid.width);
               diff = scale9Grid.x + scale9Grid.width - this.flvplayback_internal::border_mc.scale9Grid.right;
               if(diff > 0.5)
               {
                  --scale9Grid.width;
               }
               else if(diff < -0.5)
               {
                  ++scale9Grid.width;
               }
               scale9Grid.height = Math.round(scale9Grid.height);
               diff = scale9Grid.y + scale9Grid.height - this.flvplayback_internal::border_mc.scale9Grid.bottom;
               if(diff > 0.5)
               {
                  --scale9Grid.height;
               }
               else if(diff < -0.5)
               {
                  ++scale9Grid.height;
               }
               if(scale9Grid != null)
               {
                  this.flvplayback_internal::borderScale9Rects = new Array();
                  lastXDim = this.flvplayback_internal::border_mc.width - (scale9Grid.x + scale9Grid.width);
                  floorLastXDim = Math.floor(lastXDim);
                  if(lastXDim - floorLastXDim < 0.05)
                  {
                     lastXDim = floorLastXDim;
                  }
                  else
                  {
                     lastXDim = floorLastXDim + 1;
                  }
                  lastYDim = this.flvplayback_internal::border_mc.height - (scale9Grid.y + scale9Grid.height);
                  floorLastYDim = Math.floor(lastYDim);
                  if(lastYDim - floorLastYDim < 0.05)
                  {
                     lastYDim = floorLastYDim;
                  }
                  else
                  {
                     lastYDim = floorLastYDim + 1;
                  }
                  newRect = new Rectangle(0,0,scale9Grid.x,scale9Grid.y);
                  this.flvplayback_internal::borderScale9Rects.push(newRect.width < 1 || newRect.height < 1 ? null : newRect);
                  newRect = new Rectangle(scale9Grid.x,0,scale9Grid.width,scale9Grid.y);
                  this.flvplayback_internal::borderScale9Rects.push(newRect.width < 1 || newRect.height < 1 ? null : newRect);
                  newRect = new Rectangle(scale9Grid.x + scale9Grid.width,0,lastXDim,scale9Grid.y);
                  this.flvplayback_internal::borderScale9Rects.push(newRect.width < 1 || newRect.height < 1 ? null : newRect);
                  newRect = new Rectangle(0,scale9Grid.y,scale9Grid.x,scale9Grid.height);
                  this.flvplayback_internal::borderScale9Rects.push(newRect.width < 1 || newRect.height < 1 ? null : newRect);
                  newRect = new Rectangle(scale9Grid.x,scale9Grid.y,scale9Grid.width,scale9Grid.height);
                  this.flvplayback_internal::borderScale9Rects.push(newRect.width < 1 || newRect.height < 1 ? null : newRect);
                  newRect = new Rectangle(scale9Grid.x + scale9Grid.width,scale9Grid.y,lastXDim,scale9Grid.height);
                  this.flvplayback_internal::borderScale9Rects.push(newRect.width < 1 || newRect.height < 1 ? null : newRect);
                  newRect = new Rectangle(0,scale9Grid.y + scale9Grid.height,scale9Grid.x,lastYDim);
                  this.flvplayback_internal::borderScale9Rects.push(newRect.width < 1 || newRect.height < 1 ? null : newRect);
                  newRect = new Rectangle(scale9Grid.x,scale9Grid.y + scale9Grid.height,scale9Grid.width,lastYDim);
                  this.flvplayback_internal::borderScale9Rects.push(newRect.width < 1 || newRect.height < 1 ? null : newRect);
                  newRect = new Rectangle(scale9Grid.x + scale9Grid.width,scale9Grid.y + scale9Grid.height,lastXDim,lastYDim);
                  this.flvplayback_internal::borderScale9Rects.push(newRect.width < 1 || newRect.height < 1 ? null : newRect);
                  i = 0;
                  while(i < this.flvplayback_internal::borderScale9Rects.length)
                  {
                     if(this.flvplayback_internal::borderScale9Rects[i] != null)
                     {
                        break;
                     }
                     i++;
                  }
                  if(i >= this.flvplayback_internal::borderScale9Rects.length)
                  {
                     this.flvplayback_internal::borderScale9Rects = null;
                  }
               }
               numBorderBitmaps = this.flvplayback_internal::borderScale9Rects == null ? 1 : 9;
               i = 0;
               while(i < numBorderBitmaps)
               {
                  if(this.flvplayback_internal::borderScale9Rects == null || this.flvplayback_internal::borderScale9Rects[i] != null)
                  {
                     this.flvplayback_internal::borderCopy.addChild(new Bitmap());
                  }
                  i++;
               }
               this.flvplayback_internal::borderCopy.accessibilityProperties = new AccessibilityProperties();
               this.flvplayback_internal::borderCopy.accessibilityProperties.silent = true;
               this.flvplayback_internal::skin_mc.addChild(this.flvplayback_internal::borderCopy);
               this.flvplayback_internal::borderPrevRect = null;
            }
         }
      }
      
      flvplayback_internal function setSkin(param1:int, param2:DisplayObject) : void
      {
         var _loc3_:Sprite = null;
         var _loc4_:ControlData = null;
         var _loc5_:String = null;
         if(param1 >= NUM_CONTROLS)
         {
            return;
         }
         if(param1 < NUM_BUTTONS)
         {
            _loc3_ = this.flvplayback_internal::setupButtonSkin(param1,param2);
            this.flvplayback_internal::skin_mc.addChild(_loc3_);
            _loc4_ = this.ctrlDataDict[_loc3_];
         }
         else
         {
            switch(param1)
            {
               case PLAY_PAUSE_BUTTON:
                  _loc3_ = this.flvplayback_internal::setTwoButtonHolderSkin(param1,PLAY_BUTTON,"play_mc",PAUSE_BUTTON,"pause_mc",param2);
                  _loc4_ = this.ctrlDataDict[_loc3_];
                  break;
               case FULL_SCREEN_BUTTON:
                  _loc3_ = this.flvplayback_internal::setTwoButtonHolderSkin(param1,FULL_SCREEN_ON_BUTTON,"on_mc",FULL_SCREEN_OFF_BUTTON,"off_mc",param2);
                  _loc4_ = this.ctrlDataDict[_loc3_];
                  break;
               case MUTE_BUTTON:
                  _loc3_ = this.flvplayback_internal::setTwoButtonHolderSkin(param1,MUTE_ON_BUTTON,"on_mc",MUTE_OFF_BUTTON,"off_mc",param2);
                  _loc4_ = this.ctrlDataDict[_loc3_];
                  break;
               case SEEK_BAR:
               case VOLUME_BAR:
                  _loc5_ = String(flvplayback_internal::skinClassPrefixes[param1]);
                  _loc3_ = Sprite(this.flvplayback_internal::createSkin(this.flvplayback_internal::skinTemplate,_loc5_));
                  if(_loc3_ != null)
                  {
                     this.flvplayback_internal::skin_mc.addChild(_loc3_);
                     _loc4_ = new ControlData(this,_loc3_,null,param1);
                     this.ctrlDataDict[_loc3_] = _loc4_;
                     _loc4_.progress_mc = this.flvplayback_internal::setupBarSkinPart(_loc3_,param2,this.flvplayback_internal::skinTemplate,_loc5_ + "Progress","progress_mc");
                     _loc4_.fullness_mc = this.flvplayback_internal::setupBarSkinPart(_loc3_,param2,this.flvplayback_internal::skinTemplate,_loc5_ + "Fullness","fullness_mc");
                     _loc4_.hit_mc = Sprite(this.flvplayback_internal::setupBarSkinPart(_loc3_,param2,this.flvplayback_internal::skinTemplate,_loc5_ + "Hit","hit_mc"));
                     _loc4_.handle_mc = Sprite(this.flvplayback_internal::setupBarSkinPart(_loc3_,param2,this.flvplayback_internal::skinTemplate,_loc5_ + "Handle","handle_mc",true));
                     _loc3_.width = param2.width;
                     _loc3_.height = param2.height;
                     _loc3_.accessibilityProperties = new AccessibilityProperties();
                     _loc3_.accessibilityProperties.silent = true;
                     break;
                  }
                  break;
               case BUFFERING_BAR:
                  _loc5_ = String(flvplayback_internal::skinClassPrefixes[param1]);
                  _loc3_ = Sprite(this.flvplayback_internal::createSkin(this.flvplayback_internal::skinTemplate,_loc5_));
                  if(_loc3_ != null)
                  {
                     this.flvplayback_internal::skin_mc.addChild(_loc3_);
                     _loc4_ = new ControlData(this,_loc3_,null,param1);
                     this.ctrlDataDict[_loc3_] = _loc4_;
                     _loc4_.fill_mc = this.flvplayback_internal::setupBarSkinPart(_loc3_,param2,this.flvplayback_internal::skinTemplate,_loc5_ + "Fill","fill_mc");
                     _loc3_.width = param2.width;
                     _loc3_.height = param2.height;
                     _loc4_.fill_mc.accessibilityProperties = new AccessibilityProperties();
                     _loc4_.fill_mc.accessibilityProperties.silent = true;
                     _loc3_.accessibilityProperties = new AccessibilityProperties();
                     _loc3_.accessibilityProperties.silent = true;
                     break;
                  }
            }
         }
         _loc4_.avatar = param2;
         this.ctrlDataDict[_loc3_] = _loc4_;
         this.flvplayback_internal::delayedControls[param1] = _loc3_;
      }
      
      flvplayback_internal function setTwoButtonHolderSkin(param1:int, param2:int, param3:String, param4:int, param5:String, param6:DisplayObject) : Sprite
      {
         var _loc7_:Sprite = null;
         var _loc8_:Sprite = null;
         var _loc9_:ControlData = null;
         _loc8_ = new Sprite();
         _loc9_ = new ControlData(this,_loc8_,null,param1);
         this.ctrlDataDict[_loc8_] = _loc9_;
         this.flvplayback_internal::skin_mc.addChild(_loc8_);
         (_loc7_ = this.flvplayback_internal::setupButtonSkin(param2,param6)).name = param3;
         _loc7_.visible = true;
         _loc8_.addChild(_loc7_);
         (_loc7_ = this.flvplayback_internal::setupButtonSkin(param4,param6)).name = param5;
         _loc7_.visible = false;
         _loc8_.addChild(_loc7_);
         return _loc8_;
      }
      
      flvplayback_internal function setupButtonSkin(param1:int, param2:DisplayObject) : Sprite
      {
         var _loc3_:String = String(flvplayback_internal::skinClassPrefixes[param1]);
         if(_loc3_ == null)
         {
            return null;
         }
         var _loc4_:Sprite = new Sprite();
         var _loc5_:ControlData = new ControlData(this,_loc4_,null,param1);
         this.ctrlDataDict[_loc4_] = _loc5_;
         _loc5_.state_mc = new Array();
         _loc5_.state_mc[NORMAL_STATE] = this.flvplayback_internal::setupButtonSkinState(_loc4_,this.flvplayback_internal::skinTemplate,_loc3_ + "NormalState");
         _loc5_.state_mc[NORMAL_STATE].visible = true;
         _loc5_.state_mc[OVER_STATE] = this.flvplayback_internal::setupButtonSkinState(_loc4_,this.flvplayback_internal::skinTemplate,_loc3_ + "OverState",_loc5_.state_mc[NORMAL_STATE]);
         _loc5_.state_mc[DOWN_STATE] = this.flvplayback_internal::setupButtonSkinState(_loc4_,this.flvplayback_internal::skinTemplate,_loc3_ + "DownState",_loc5_.state_mc[NORMAL_STATE]);
         _loc5_.disabled_mc = this.flvplayback_internal::setupButtonSkinState(_loc4_,this.flvplayback_internal::skinTemplate,_loc3_ + "DisabledState",_loc5_.state_mc[NORMAL_STATE]);
         if(param2 is InteractiveObject)
         {
            _loc4_.tabIndex = InteractiveObject(param2).tabIndex;
         }
         return _loc4_;
      }
      
      flvplayback_internal function setupButtonSkinState(param1:Sprite, param2:Sprite, param3:String, param4:DisplayObject = null) : DisplayObject
      {
         var stateSkin:DisplayObject = null;
         var ctrl:Sprite = param1;
         var definitionHolder:Sprite = param2;
         var skinName:String = param3;
         var defaultSkin:DisplayObject = param4;
         try
         {
            stateSkin = this.flvplayback_internal::createSkin(definitionHolder,skinName);
         }
         catch(ve:VideoError)
         {
            if(defaultSkin == null)
            {
               throw ve;
            }
            stateSkin = null;
         }
         if(stateSkin != null)
         {
            stateSkin.visible = false;
            ctrl.addChild(stateSkin);
         }
         else if(defaultSkin != null)
         {
            stateSkin = defaultSkin;
         }
         return stateSkin;
      }
      
      flvplayback_internal function setupBarSkinPart(param1:Sprite, param2:DisplayObject, param3:Sprite, param4:String, param5:String, param6:Boolean = false) : DisplayObject
      {
         var part:DisplayObject = null;
         var partAvatar:DisplayObject = null;
         var ctrlData:ControlData = null;
         var partData:ControlData = null;
         var ctrl:Sprite = param1;
         var avatar:DisplayObject = param2;
         var definitionHolder:Sprite = param3;
         var skinName:String = param4;
         var partName:String = param5;
         var required:Boolean = param6;
         try
         {
            part = ctrl[partName];
         }
         catch(re:ReferenceError)
         {
            part = null;
         }
         if(part == null)
         {
            try
            {
               part = this.flvplayback_internal::createSkin(definitionHolder,skinName);
            }
            catch(ve:VideoError)
            {
               if(required)
               {
                  throw ve;
               }
            }
            if(part != null)
            {
               this.flvplayback_internal::skin_mc.addChild(part);
               part.x = ctrl.x;
               part.y = ctrl.y;
               partAvatar = this.flvplayback_internal::layout_mc.getChildByName(skinName + "_mc");
               if(partAvatar != null)
               {
                  if(partName == "hit_mc")
                  {
                     ctrlData = this.ctrlDataDict[ctrl];
                     partData = new ControlData(this,part,this.flvplayback_internal::controls[ctrlData.index],-1);
                     partData.avatar = partAvatar;
                     this.ctrlDataDict[part] = partData;
                  }
                  else
                  {
                     part.x += partAvatar.x - avatar.x;
                     part.y += partAvatar.y - avatar.y;
                     part.width = partAvatar.width;
                     part.height = partAvatar.height;
                  }
                  if(part is InteractiveObject && partAvatar is InteractiveObject)
                  {
                     InteractiveObject(part).tabIndex = InteractiveObject(partAvatar).tabIndex;
                  }
               }
            }
         }
         if(required && part == null)
         {
            throw new VideoError(VideoError.MISSING_SKIN_STYLE,skinName);
         }
         if(part != null)
         {
            part.accessibilityProperties = new AccessibilityProperties();
            part.accessibilityProperties.silent = true;
         }
         return part;
      }
      
      flvplayback_internal function createSkin(param1:DisplayObject, param2:String) : DisplayObject
      {
         var stateSkinDesc:* = undefined;
         var theClass:Class = null;
         var definitionHolder:DisplayObject = param1;
         var skinName:String = param2;
         try
         {
            stateSkinDesc = definitionHolder[skinName];
            if(stateSkinDesc is String)
            {
               try
               {
                  theClass = Class(definitionHolder.loaderInfo.applicationDomain.getDefinition(stateSkinDesc));
               }
               catch(err1:Error)
               {
                  theClass = Class(getDefinitionByName(stateSkinDesc));
               }
               return DisplayObject(new theClass());
            }
            if(stateSkinDesc is Class)
            {
               return new stateSkinDesc();
            }
            if(stateSkinDesc is DisplayObject)
            {
               return stateSkinDesc;
            }
         }
         catch(err2:Error)
         {
            throw new VideoError(VideoError.MISSING_SKIN_STYLE,skinName);
         }
         return null;
      }
      
      flvplayback_internal function skinButtonControl(param1:Object) : void
      {
         var ctrlData:ControlData;
         var ctrl:Sprite = null;
         var e:Event = null;
         var ctrlOrEvent:Object = param1;
         if(ctrlOrEvent == null)
         {
            return;
         }
         if(ctrlOrEvent is Event)
         {
            e = Event(ctrlOrEvent);
            ctrl = Sprite(e.currentTarget);
            ctrl.removeEventListener(Event.ENTER_FRAME,this.flvplayback_internal::skinButtonControl);
         }
         else
         {
            ctrl = Sprite(ctrlOrEvent);
         }
         ctrlData = this.ctrlDataDict[ctrl];
         if(ctrlData == null)
         {
            return;
         }
         try
         {
            if(ctrl["placeholder_mc"] != undefined)
            {
               ctrl.removeChild(ctrl["placeholder_mc"]);
               ctrl["placeholder_mc"] = null;
            }
         }
         catch(re:ReferenceError)
         {
         }
         if(ctrlData.state_mc == null)
         {
            ctrlData.state_mc = new Array();
         }
         if(ctrlData.state_mc[NORMAL_STATE] == undefined)
         {
            ctrlData.state_mc[NORMAL_STATE] = this.flvplayback_internal::setupButtonSkinState(ctrl,ctrl,flvplayback_internal::buttonSkinLinkageIDs[NORMAL_STATE],null);
         }
         if(ctrlData.enabled && this.flvplayback_internal::_controlsEnabled)
         {
            if(ctrlData.state_mc[ctrlData.state] == undefined)
            {
               ctrlData.state_mc[ctrlData.state] = this.flvplayback_internal::setupButtonSkinState(ctrl,ctrl,flvplayback_internal::buttonSkinLinkageIDs[ctrlData.state],ctrlData.state_mc[NORMAL_STATE]);
            }
            if(ctrlData.state_mc[ctrlData.state] != ctrlData.currentState_mc)
            {
               if(ctrlData.currentState_mc != null)
               {
                  ctrlData.currentState_mc.visible = false;
               }
               ctrlData.currentState_mc = ctrlData.state_mc[ctrlData.state];
               ctrlData.currentState_mc.visible = true;
            }
            this.flvplayback_internal::applySkinState(ctrlData,ctrlData.state_mc[ctrlData.state]);
         }
         else
         {
            ctrlData.state = NORMAL_STATE;
            if(ctrlData.disabled_mc == null)
            {
               ctrlData.disabled_mc = this.flvplayback_internal::setupButtonSkinState(ctrl,ctrl,"disabledLinkageID",ctrlData.state_mc[NORMAL_STATE]);
            }
            this.flvplayback_internal::applySkinState(ctrlData,ctrlData.disabled_mc);
         }
      }
      
      flvplayback_internal function applySkinState(param1:ControlData, param2:DisplayObject) : void
      {
         if(param2 != param1.currentState_mc)
         {
            if(param1.currentState_mc != null)
            {
               param1.currentState_mc.visible = false;
            }
            param1.currentState_mc = param2;
            param1.currentState_mc.visible = true;
         }
      }
      
      flvplayback_internal function addBarControl(param1:Sprite) : void
      {
         var _loc2_:ControlData = this.ctrlDataDict[param1];
         _loc2_.isDragging = false;
         _loc2_.percentage = 0;
         if(param1.parent == this.flvplayback_internal::skin_mc && this.flvplayback_internal::skin_mc != null)
         {
            this.flvplayback_internal::finishAddBarControl(param1);
         }
         else
         {
            param1.addEventListener(Event.REMOVED_FROM_STAGE,this.flvplayback_internal::cleanupHandle);
            param1.addEventListener(Event.ENTER_FRAME,this.flvplayback_internal::finishAddBarControl);
         }
      }
      
      flvplayback_internal function finishAddBarControl(param1:Object) : void
      {
         var ctrlData:ControlData;
         var ctrl:Sprite = null;
         var e:Event = null;
         var ctrlOrEvent:Object = param1;
         if(ctrlOrEvent == null)
         {
            return;
         }
         if(ctrlOrEvent is Event)
         {
            e = Event(ctrlOrEvent);
            ctrl = Sprite(e.currentTarget);
            ctrl.removeEventListener(Event.ENTER_FRAME,this.flvplayback_internal::finishAddBarControl);
         }
         else
         {
            ctrl = Sprite(ctrlOrEvent);
         }
         ctrlData = this.ctrlDataDict[ctrl];
         try
         {
            if(ctrl["addBarControl"] is Function)
            {
               ctrl["addBarControl"]();
            }
         }
         catch(re:ReferenceError)
         {
         }
         ctrlData.origWidth = ctrl.width;
         ctrlData.origHeight = ctrl.height;
         this.flvplayback_internal::fixUpBar(ctrl,"progress",ctrl,"progress_mc");
         this.flvplayback_internal::calcBarMargins(ctrl,"progress",false);
         if(ctrlData.progress_mc != null)
         {
            this.flvplayback_internal::fixUpBar(ctrl,"progressBarFill",ctrlData.progress_mc,"fill_mc");
            this.flvplayback_internal::calcBarMargins(ctrlData.progress_mc,"fill",false);
            this.flvplayback_internal::calcBarMargins(ctrlData.progress_mc,"mask",false);
            if(isNaN(this.flvplayback_internal::_progressPercent))
            {
               this.flvplayback_internal::_progressPercent = this.flvplayback_internal::_vc.isRTMP ? 100 : 0;
            }
            this.flvplayback_internal::positionBar(ctrl,"progress",this.flvplayback_internal::_progressPercent);
         }
         this.flvplayback_internal::fixUpBar(ctrl,"fullness",ctrl,"fullness_mc");
         this.flvplayback_internal::calcBarMargins(ctrl,"fullness",false);
         if(ctrlData.fullness_mc != null)
         {
            this.flvplayback_internal::fixUpBar(ctrl,"fullnessBarFill",ctrlData.fullness_mc,"fill_mc");
            this.flvplayback_internal::calcBarMargins(ctrlData.fullness_mc,"fill",false);
            this.flvplayback_internal::calcBarMargins(ctrlData.fullness_mc,"mask",false);
         }
         this.flvplayback_internal::fixUpBar(ctrl,"hit",ctrl,"hit_mc");
         this.flvplayback_internal::fixUpBar(ctrl,"handle",ctrl,"handle_mc");
         this.flvplayback_internal::calcBarMargins(ctrl,"handle",true);
         switch(ctrlData.index)
         {
            case SEEK_BAR:
               this.setControl(SEEK_BAR_HANDLE,ctrlData.handle_mc);
               if(ctrlData.hit_mc != null)
               {
                  this.setControl(SEEK_BAR_HIT,ctrlData.hit_mc);
                  break;
               }
               break;
            case VOLUME_BAR:
               this.setControl(VOLUME_BAR_HANDLE,ctrlData.handle_mc);
               if(ctrlData.hit_mc != null)
               {
                  this.setControl(VOLUME_BAR_HIT,ctrlData.hit_mc);
                  break;
               }
         }
         this.flvplayback_internal::positionHandle(ctrl);
         ctrl.accessibilityProperties = new AccessibilityProperties();
         ctrl.accessibilityProperties.silent = true;
      }
      
      flvplayback_internal function cleanupHandle(param1:Object) : void
      {
         var e:Event = null;
         var ctrl:Sprite = null;
         var ctrlData:ControlData = null;
         var ctrlOrEvent:Object = param1;
         try
         {
            if(ctrlOrEvent is Event)
            {
               e = Event(ctrlOrEvent);
            }
            ctrl = e == null ? Sprite(ctrlOrEvent) : Sprite(e.currentTarget);
            ctrlData = this.ctrlDataDict[ctrl];
            if(ctrlData == null || e == null)
            {
               ctrl.removeEventListener(Event.REMOVED_FROM_STAGE,this.flvplayback_internal::cleanupHandle,false);
               if(ctrlData == null)
               {
                  return;
               }
            }
            ctrl.removeEventListener(Event.ENTER_FRAME,this.flvplayback_internal::finishAddBarControl);
            if(ctrlData.handle_mc != null)
            {
               if(ctrlData.handle_mc.parent != null)
               {
                  ctrlData.handle_mc.parent.removeChild(ctrlData.handle_mc);
               }
               delete this.ctrlDataDict[ctrlData.handle_mc];
               ctrlData.handle_mc = null;
            }
            if(ctrlData.hit_mc != null)
            {
               if(ctrlData.hit_mc.parent != null)
               {
                  ctrlData.hit_mc.parent.removeChild(ctrlData.hit_mc);
               }
               delete this.ctrlDataDict[ctrlData.hit_mc];
               ctrlData.hit_mc = null;
            }
         }
         catch(err:Error)
         {
         }
      }
      
      flvplayback_internal function fixUpBar(param1:DisplayObject, param2:String, param3:DisplayObject, param4:String) : void
      {
         var barData:ControlData;
         var bar:DisplayObject = null;
         var definitionHolder:DisplayObject = param1;
         var propPrefix:String = param2;
         var ctrl:DisplayObject = param3;
         var name:String = param4;
         var ctrlData:ControlData = this.ctrlDataDict[ctrl];
         if(ctrlData[name] != null)
         {
            return;
         }
         try
         {
            bar = ctrl[name];
         }
         catch(re:ReferenceError)
         {
            bar = null;
         }
         if(bar == null)
         {
            try
            {
               bar = this.flvplayback_internal::createSkin(definitionHolder,propPrefix + "LinkageID");
            }
            catch(ve:VideoError)
            {
               bar = null;
            }
            if(bar == null)
            {
               return;
            }
            if(ctrl.parent != null)
            {
               if(flvplayback_internal::getBooleanPropSafe(ctrl,propPrefix + "Below"))
               {
                  ctrl.parent.addChildAt(bar,ctrl.parent.getChildIndex(ctrl));
               }
               else
               {
                  ctrl.parent.addChild(bar);
               }
            }
         }
         ctrlData[name] = bar;
         barData = this.ctrlDataDict[bar];
         if(barData == null)
         {
            barData = new ControlData(this,bar,ctrl,-1);
            this.ctrlDataDict[bar] = barData;
         }
      }
      
      flvplayback_internal function calcBarMargins(param1:DisplayObject, param2:String, param3:Boolean) : void
      {
         var ctrlData:ControlData;
         var bar:DisplayObject;
         var barData:ControlData;
         var ctrl:DisplayObject = param1;
         var type:String = param2;
         var symmetricMargins:Boolean = param3;
         if(ctrl == null)
         {
            return;
         }
         ctrlData = this.ctrlDataDict[ctrl];
         bar = ctrlData[type + "_mc"];
         if(bar == null)
         {
            try
            {
               bar = ctrl[type + "_mc"];
            }
            catch(re:ReferenceError)
            {
               bar = null;
            }
            if(bar == null)
            {
               return;
            }
            ctrlData[type + "_mc"] = bar;
         }
         barData = this.ctrlDataDict[bar];
         if(barData == null)
         {
            barData = new ControlData(this,bar,ctrl,-1);
            this.ctrlDataDict[bar] = barData;
         }
         barData.leftMargin = flvplayback_internal::getNumberPropSafe(ctrl,type + "LeftMargin");
         if(isNaN(barData.leftMargin) && bar.parent == ctrl.parent)
         {
            barData.leftMargin = bar.x - ctrl.x;
         }
         barData.rightMargin = flvplayback_internal::getNumberPropSafe(ctrl,type + "RightMargin");
         if(isNaN(barData.rightMargin))
         {
            if(symmetricMargins)
            {
               barData.rightMargin = barData.leftMargin;
            }
            else if(bar.parent == ctrl.parent)
            {
               barData.rightMargin = ctrl.width - bar.width - bar.x + ctrl.x;
            }
         }
         barData.topMargin = flvplayback_internal::getNumberPropSafe(ctrl,type + "TopMargin");
         if(isNaN(barData.topMargin) && bar.parent == ctrl.parent)
         {
            barData.topMargin = bar.y - ctrl.y;
         }
         barData.bottomMargin = flvplayback_internal::getNumberPropSafe(ctrl,type + "BottomMargin");
         if(isNaN(barData.bottomMargin))
         {
            if(symmetricMargins)
            {
               barData.bottomMargin = barData.topMargin;
            }
            else if(bar.parent == ctrl.parent)
            {
               barData.bottomMargin = ctrl.height - bar.height - bar.y + ctrl.y;
            }
         }
         barData.origX = flvplayback_internal::getNumberPropSafe(ctrl,type + "X");
         if(isNaN(barData.origX))
         {
            if(bar.parent == ctrl.parent)
            {
               barData.origX = bar.x - ctrl.x;
            }
            else if(bar.parent == ctrl)
            {
               barData.origX = bar.x;
            }
         }
         barData.origY = flvplayback_internal::getNumberPropSafe(ctrl,type + "Y");
         if(isNaN(barData.origY))
         {
            if(bar.parent == ctrl.parent)
            {
               barData.origY = bar.y - ctrl.y;
            }
            else if(bar.parent == ctrl)
            {
               barData.origY = bar.y;
            }
         }
         barData.origWidth = bar.width;
         barData.origHeight = bar.height;
         barData.origScaleX = bar.scaleX;
         barData.origScaleY = bar.scaleY;
      }
      
      flvplayback_internal function finishAddBufferingBar(param1:Event = null) : void
      {
         if(param1 != null)
         {
            param1.currentTarget.removeEventListener(Event.ENTER_FRAME,this.flvplayback_internal::finishAddBufferingBar);
         }
         var _loc2_:Sprite = this.flvplayback_internal::controls[BUFFERING_BAR];
         this.flvplayback_internal::calcBarMargins(_loc2_,"fill",true);
         this.flvplayback_internal::fixUpBar(_loc2_,"fill",_loc2_,"fill_mc");
         this.flvplayback_internal::positionMaskedFill(_loc2_,100);
      }
      
      flvplayback_internal function positionMaskedFill(param1:DisplayObject, param2:Number) : void
      {
         var fill:DisplayObject;
         var mask:DisplayObject;
         var fillData:ControlData;
         var maskData:ControlData;
         var ctrlData:ControlData = null;
         var slideReveal:Boolean = false;
         var maskSprite:Sprite = null;
         var barData:ControlData = null;
         var ctrl:DisplayObject = param1;
         var percent:Number = param2;
         if(ctrl == null)
         {
            return;
         }
         ctrlData = this.ctrlDataDict[ctrl];
         fill = ctrlData.fill_mc;
         if(fill == null)
         {
            return;
         }
         mask = ctrlData.mask_mc;
         if(ctrlData.mask_mc == null)
         {
            try
            {
               ctrlData.mask_mc = mask = ctrl["mask_mc"];
            }
            catch(re:ReferenceError)
            {
               ctrlData.mask_mc = null;
            }
            if(ctrlData.mask_mc == null)
            {
               maskSprite = new Sprite();
               ctrlData.mask_mc = mask = maskSprite;
               maskSprite.graphics.beginFill(16777215);
               maskSprite.graphics.drawRect(0,0,1,1);
               maskSprite.graphics.endFill();
               barData = this.ctrlDataDict[fill];
               maskSprite.x = barData.origX;
               maskSprite.y = barData.origY;
               maskSprite.width = barData.origWidth;
               maskSprite.height = barData.origHeight;
               maskSprite.visible = false;
               fill.parent.addChild(maskSprite);
               fill.mask = maskSprite;
            }
            if(ctrlData.mask_mc != null)
            {
               this.flvplayback_internal::calcBarMargins(ctrl,"mask",true);
            }
         }
         fillData = this.ctrlDataDict[fill];
         maskData = this.ctrlDataDict[mask];
         try
         {
            slideReveal = Boolean(fill["slideReveal"]);
         }
         catch(re:ReferenceError)
         {
            slideReveal = false;
         }
         if(fill.parent == ctrl)
         {
            if(slideReveal)
            {
               fill.x = maskData.origX - fillData.origWidth + fillData.origWidth * percent / 100;
            }
            else
            {
               mask.width = fillData.origWidth * percent / 100;
            }
         }
         else if(fill.parent == ctrl.parent)
         {
            if(slideReveal)
            {
               mask.x = ctrl.x + maskData.leftMargin;
               mask.y = ctrl.y + maskData.topMargin;
               mask.width = ctrl.width - maskData.rightMargin - maskData.leftMargin;
               mask.height = ctrl.height - maskData.topMargin - maskData.bottomMargin;
               fill.x = mask.x - fillData.origWidth + maskData.origWidth * percent / 100;
               fill.y = ctrl.y + fillData.topMargin;
            }
            else
            {
               fill.x = ctrl.x + fillData.leftMargin;
               fill.y = ctrl.y + fillData.topMargin;
               mask.x = fill.x;
               mask.y = fill.y;
               mask.width = (ctrl.width - fillData.rightMargin - fillData.leftMargin) * percent / 100;
               mask.height = ctrl.height - fillData.topMargin - fillData.bottomMargin;
            }
         }
      }
      
      flvplayback_internal function startHandleDrag(param1:Sprite) : void
      {
         var ctrlData:ControlData;
         var handle:Sprite;
         var handleData:ControlData;
         var theY:Number;
         var theWidth:Number;
         var bounds:Rectangle;
         var ctrl:Sprite = param1;
         if(ctrl == null)
         {
            return;
         }
         ctrlData = this.ctrlDataDict[ctrl];
         try
         {
            if(ctrl["startHandleDrag"] is Function && Boolean(ctrl["startHandleDrag"]()))
            {
               ctrlData.isDragging = true;
               return;
            }
         }
         catch(re:ReferenceError)
         {
         }
         handle = ctrlData.handle_mc;
         if(handle == null)
         {
            return;
         }
         handleData = this.ctrlDataDict[handle];
         theY = ctrl.y + handleData.origY;
         theWidth = isNaN(ctrlData.origWidth) ? ctrl.width : ctrlData.origWidth;
         bounds = new Rectangle(ctrl.x + handleData.leftMargin,theY,theWidth - handleData.rightMargin,0);
         handle.startDrag(false,bounds);
         ctrlData.isDragging = true;
         handle.focusRect = false;
         handle.stage.focus = handle;
      }
      
      flvplayback_internal function stopHandleDrag(param1:Sprite) : void
      {
         var ctrlData:ControlData;
         var handle:Sprite;
         var ctrl:Sprite = param1;
         if(ctrl == null)
         {
            return;
         }
         ctrlData = this.ctrlDataDict[ctrl];
         try
         {
            if(ctrl["stopHandleDrag"] is Function && Boolean(ctrl["stopHandleDrag"]()))
            {
               ctrlData.isDragging = false;
               return;
            }
         }
         catch(re:ReferenceError)
         {
         }
         handle = ctrlData.handle_mc;
         if(handle == null)
         {
            return;
         }
         handle.stopDrag();
         ctrlData.isDragging = false;
         handle.stage.focus = handle;
      }
      
      flvplayback_internal function positionHandle(param1:Sprite) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(param1["positionHandle"] is Function && Boolean(param1["positionHandle"]()))
         {
            return;
         }
         var _loc2_:ControlData = this.ctrlDataDict[param1];
         var _loc3_:Sprite = _loc2_.handle_mc;
         if(_loc3_ == null)
         {
            return;
         }
         var _loc4_:ControlData = this.ctrlDataDict[_loc3_];
         var _loc5_:Number;
         var _loc6_:Number = (_loc5_ = isNaN(_loc2_.origWidth) ? param1.width : _loc2_.origWidth) - _loc4_.rightMargin - _loc4_.leftMargin;
         _loc3_.x = param1.x + _loc4_.leftMargin + _loc6_ * _loc2_.percentage / 100;
         _loc3_.y = param1.y + _loc4_.origY;
         if(_loc2_.fullness_mc != null)
         {
            this.flvplayback_internal::positionBar(param1,"fullness",_loc2_.percentage);
         }
      }
      
      flvplayback_internal function positionBar(param1:Sprite, param2:String, param3:Number) : void
      {
         var ctrlData:ControlData;
         var bar:DisplayObject;
         var barData:ControlData;
         var ctrl:Sprite = param1;
         var type:String = param2;
         var percent:Number = param3;
         try
         {
            if(ctrl["positionBar"] is Function && Boolean(ctrl["positionBar"](type,percent)))
            {
               return;
            }
         }
         catch(re2:ReferenceError)
         {
         }
         ctrlData = this.ctrlDataDict[ctrl];
         bar = ctrlData[type + "_mc"];
         if(bar == null)
         {
            return;
         }
         barData = this.ctrlDataDict[bar];
         if(bar.parent == ctrl)
         {
            if(barData.fill_mc == null)
            {
               bar.scaleX = barData.origScaleX * percent / 100;
            }
            else
            {
               this.flvplayback_internal::positionMaskedFill(bar,percent);
            }
         }
         else
         {
            bar.x = ctrl.x + barData.leftMargin;
            bar.y = ctrl.y + barData.origY;
            if(barData.fill_mc == null)
            {
               bar.width = (ctrl.width - barData.leftMargin - barData.rightMargin) * percent / 100;
            }
            else
            {
               this.flvplayback_internal::positionMaskedFill(bar,percent);
            }
         }
      }
      
      flvplayback_internal function calcPercentageFromHandle(param1:Sprite) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc2_:ControlData = this.ctrlDataDict[param1];
         if(param1["calcPercentageFromHandle"] is Function && Boolean(param1["calcPercentageFromHandle"]()))
         {
            if(_loc2_.percentage < 0)
            {
               _loc2_.percentage = 0;
            }
            if(_loc2_.percentage > 100)
            {
               _loc2_.percentage = 100;
            }
            return;
         }
         var _loc3_:Sprite = _loc2_.handle_mc;
         if(_loc3_ == null)
         {
            return;
         }
         var _loc4_:ControlData = this.ctrlDataDict[_loc3_];
         var _loc5_:Number;
         var _loc6_:Number = (_loc5_ = isNaN(_loc2_.origWidth) ? param1.width : _loc2_.origWidth) - _loc4_.rightMargin - _loc4_.leftMargin;
         var _loc7_:Number = _loc3_.x - (param1.x + _loc4_.leftMargin);
         _loc2_.percentage = _loc7_ / _loc6_ * 100;
         if(_loc2_.percentage < 0)
         {
            _loc2_.percentage = 0;
         }
         if(_loc2_.percentage > 100)
         {
            _loc2_.percentage = 100;
         }
         if(_loc2_.fullness_mc != null)
         {
            this.flvplayback_internal::positionBar(param1,"fullness",_loc2_.percentage);
         }
      }
      
      flvplayback_internal function handleRelease(param1:int) : void
      {
         var _loc2_:int = int(this.flvplayback_internal::_vc.activeVideoPlayerIndex);
         this.flvplayback_internal::_vc.activeVideoPlayerIndex = this.flvplayback_internal::_vc.visibleVideoPlayerIndex;
         if(param1 == SEEK_BAR)
         {
            this.flvplayback_internal::seekBarListener(null);
         }
         else if(param1 == VOLUME_BAR)
         {
            this.flvplayback_internal::volumeBarListener(null);
         }
         this.flvplayback_internal::stopHandleDrag(this.flvplayback_internal::controls[param1]);
         this.flvplayback_internal::_vc.activeVideoPlayerIndex = _loc2_;
         if(param1 == SEEK_BAR)
         {
            this.flvplayback_internal::_vc.flvplayback_internal::_scrubFinish();
         }
      }
      
      flvplayback_internal function seekBarListener(param1:TimerEvent) : void
      {
         var _loc2_:int = int(this.flvplayback_internal::_vc.activeVideoPlayerIndex);
         this.flvplayback_internal::_vc.activeVideoPlayerIndex = this.flvplayback_internal::_vc.visibleVideoPlayerIndex;
         var _loc3_:Sprite = this.flvplayback_internal::controls[SEEK_BAR];
         if(_loc3_ == null)
         {
            return;
         }
         var _loc4_:ControlData = this.ctrlDataDict[_loc3_];
         this.flvplayback_internal::calcPercentageFromHandle(_loc3_);
         var _loc5_:Number = _loc4_.percentage;
         if(param1 == null)
         {
            this.flvplayback_internal::_seekBarTimer.stop();
            if(_loc5_ != this.flvplayback_internal::_lastScrubPos)
            {
               this.flvplayback_internal::_vc.seekPercent(_loc5_);
            }
            this.flvplayback_internal::_vc.addEventListener(fl.video.VideoEvent.PLAYHEAD_UPDATE,this.flvplayback_internal::handleIVPEvent);
            if(this.flvplayback_internal::_playAfterScrub)
            {
               this.flvplayback_internal::_vc.play();
            }
         }
         else if(this.flvplayback_internal::_vc.getVideoPlayer(this.flvplayback_internal::_vc.visibleVideoPlayerIndex).state != VideoState.SEEKING)
         {
            if(this.flvplayback_internal::_seekBarScrubTolerance <= 0 || Math.abs(_loc5_ - this.flvplayback_internal::_lastScrubPos) > this.flvplayback_internal::_seekBarScrubTolerance || _loc5_ < this.flvplayback_internal::_seekBarScrubTolerance || _loc5_ > 100 - this.flvplayback_internal::_seekBarScrubTolerance)
            {
               if(_loc5_ != this.flvplayback_internal::_lastScrubPos)
               {
                  this.flvplayback_internal::_lastScrubPos = _loc5_;
                  this.flvplayback_internal::_vc.seekPercent(_loc5_);
               }
            }
         }
         this.flvplayback_internal::_vc.activeVideoPlayerIndex = _loc2_;
      }
      
      flvplayback_internal function volumeBarListener(param1:TimerEvent) : void
      {
         var _loc2_:Sprite = this.flvplayback_internal::controls[VOLUME_BAR];
         if(_loc2_ == null)
         {
            return;
         }
         var _loc3_:ControlData = this.ctrlDataDict[_loc2_];
         this.flvplayback_internal::calcPercentageFromHandle(_loc2_);
         var _loc4_:Number = _loc3_.percentage;
         var _loc5_:*;
         if(_loc5_ = param1 == null)
         {
            this.flvplayback_internal::_volumeBarTimer.stop();
            this.flvplayback_internal::_vc.addEventListener(SoundEvent.SOUND_UPDATE,this.flvplayback_internal::handleSoundEvent);
         }
         if(_loc5_ || this.flvplayback_internal::_volumeBarScrubTolerance <= 0 || Math.abs(_loc4_ - this.flvplayback_internal::_lastVolumePos) > this.flvplayback_internal::_volumeBarScrubTolerance || _loc4_ < this.flvplayback_internal::_volumeBarScrubTolerance || _loc4_ > 100 - this.flvplayback_internal::_volumeBarScrubTolerance)
         {
            if(_loc4_ != this.flvplayback_internal::_lastVolumePos)
            {
               if(this.flvplayback_internal::_isMuted)
               {
                  this.flvplayback_internal::cachedSoundLevel = _loc4_ / 100;
               }
               else
               {
                  this.flvplayback_internal::_vc.volume = _loc4_ / 100;
               }
               this.flvplayback_internal::_lastVolumePos = _loc4_;
            }
         }
      }
      
      flvplayback_internal function doBufferingDelay(param1:TimerEvent) : void
      {
         this.flvplayback_internal::_bufferingDelayTimer.reset();
         var _loc2_:int = int(this.flvplayback_internal::_vc.activeVideoPlayerIndex);
         this.flvplayback_internal::_vc.activeVideoPlayerIndex = this.flvplayback_internal::_vc.visibleVideoPlayerIndex;
         if(this.flvplayback_internal::_vc.state == VideoState.BUFFERING)
         {
            this.flvplayback_internal::_bufferingOn = true;
            this.flvplayback_internal::handleIVPEvent(new fl.video.VideoEvent(fl.video.VideoEvent.STATE_CHANGE,false,false,VideoState.BUFFERING,NaN,this.flvplayback_internal::_vc.visibleVideoPlayerIndex));
         }
         this.flvplayback_internal::_vc.activeVideoPlayerIndex = _loc2_;
      }
      
      flvplayback_internal function dispatchMessage(param1:int) : void
      {
         var cachedActivePlayerIndex:int;
         var ctrl:Sprite = null;
         var ctrlData:ControlData = null;
         var handle:Sprite = null;
         var index:int = param1;
         if(index == SEEK_BAR_HANDLE || index == SEEK_BAR_HIT)
         {
            this.flvplayback_internal::_vc.flvplayback_internal::_scrubStart();
         }
         cachedActivePlayerIndex = int(this.flvplayback_internal::_vc.activeVideoPlayerIndex);
         this.flvplayback_internal::_vc.activeVideoPlayerIndex = this.flvplayback_internal::_vc.visibleVideoPlayerIndex;
         switch(index)
         {
            case PAUSE_BUTTON:
               this.flvplayback_internal::_vc.pause();
               break;
            case PLAY_BUTTON:
               this.flvplayback_internal::_vc.play();
               break;
            case STOP_BUTTON:
               this.flvplayback_internal::_vc.stop();
               break;
            case SEEK_BAR_HIT:
            case SEEK_BAR_HANDLE:
               ctrl = this.flvplayback_internal::controls[SEEK_BAR];
               ctrlData = this.ctrlDataDict[ctrl];
               this.flvplayback_internal::calcPercentageFromHandle(ctrl);
               this.flvplayback_internal::_lastScrubPos = ctrlData.percentage;
               if(index == SEEK_BAR_HIT)
               {
                  handle = this.flvplayback_internal::controls[SEEK_BAR_HANDLE];
                  handle.x = handle.parent.mouseX;
                  handle.y = handle.parent.mouseY;
               }
               this.flvplayback_internal::_vc.removeEventListener(fl.video.VideoEvent.PLAYHEAD_UPDATE,this.flvplayback_internal::handleIVPEvent);
               if(this.flvplayback_internal::_vc.playing || this.flvplayback_internal::_vc.buffering)
               {
                  this.flvplayback_internal::_playAfterScrub = true;
               }
               else if(this.flvplayback_internal::_vc.state != VideoState.SEEKING)
               {
                  this.flvplayback_internal::_playAfterScrub = false;
               }
               this.flvplayback_internal::_seekBarTimer.start();
               this.flvplayback_internal::startHandleDrag(ctrl);
               this.flvplayback_internal::_vc.pause();
               break;
            case VOLUME_BAR_HIT:
            case VOLUME_BAR_HANDLE:
               ctrl = this.flvplayback_internal::controls[VOLUME_BAR];
               ctrlData = this.ctrlDataDict[ctrl];
               this.flvplayback_internal::calcPercentageFromHandle(ctrl);
               this.flvplayback_internal::_lastVolumePos = ctrlData.percentage;
               if(index == VOLUME_BAR_HIT)
               {
                  handle = this.flvplayback_internal::controls[VOLUME_BAR_HANDLE];
                  handle.x = handle.parent.mouseX;
                  handle.y = handle.parent.mouseY;
               }
               this.flvplayback_internal::_vc.removeEventListener(SoundEvent.SOUND_UPDATE,this.flvplayback_internal::handleSoundEvent);
               this.flvplayback_internal::_volumeBarTimer.start();
               this.flvplayback_internal::startHandleDrag(ctrl);
               break;
            case BACK_BUTTON:
               this.flvplayback_internal::_vc.seekToPrevNavCuePoint();
               break;
            case FORWARD_BUTTON:
               this.flvplayback_internal::_vc.seekToNextNavCuePoint();
               break;
            case MUTE_ON_BUTTON:
               if(!this.flvplayback_internal::_isMuted)
               {
                  this.flvplayback_internal::_isMuted = true;
                  this.flvplayback_internal::cachedSoundLevel = this.flvplayback_internal::_vc.volume;
                  this.flvplayback_internal::_vc.volume = 0;
                  this.flvplayback_internal::setEnabledAndVisibleForState(MUTE_OFF_BUTTON,VideoState.PLAYING);
                  this.flvplayback_internal::skinButtonControl(this.flvplayback_internal::controls[MUTE_OFF_BUTTON]);
                  this.flvplayback_internal::setEnabledAndVisibleForState(MUTE_ON_BUTTON,VideoState.PLAYING);
                  this.flvplayback_internal::skinButtonControl(this.flvplayback_internal::controls[MUTE_ON_BUTTON]);
                  break;
               }
               break;
            case MUTE_OFF_BUTTON:
               if(this.flvplayback_internal::_isMuted)
               {
                  this.flvplayback_internal::_isMuted = false;
                  this.flvplayback_internal::_vc.volume = this.flvplayback_internal::cachedSoundLevel;
                  this.flvplayback_internal::setEnabledAndVisibleForState(MUTE_OFF_BUTTON,VideoState.PLAYING);
                  this.flvplayback_internal::skinButtonControl(this.flvplayback_internal::controls[MUTE_OFF_BUTTON]);
                  this.flvplayback_internal::setEnabledAndVisibleForState(MUTE_ON_BUTTON,VideoState.PLAYING);
                  this.flvplayback_internal::skinButtonControl(this.flvplayback_internal::controls[MUTE_ON_BUTTON]);
                  break;
               }
               break;
            case FULL_SCREEN_ON_BUTTON:
               if(!this.flvplayback_internal::_fullScreen && this.flvplayback_internal::_vc.stage != null)
               {
                  this.enterFullScreenDisplayState();
                  this.flvplayback_internal::setEnabledAndVisibleForState(FULL_SCREEN_OFF_BUTTON,VideoState.PLAYING);
                  this.flvplayback_internal::skinButtonControl(this.flvplayback_internal::controls[FULL_SCREEN_OFF_BUTTON]);
                  this.flvplayback_internal::setEnabledAndVisibleForState(FULL_SCREEN_ON_BUTTON,VideoState.PLAYING);
                  this.flvplayback_internal::skinButtonControl(this.flvplayback_internal::controls[FULL_SCREEN_ON_BUTTON]);
                  break;
               }
               break;
            case FULL_SCREEN_OFF_BUTTON:
               if(this.flvplayback_internal::_fullScreen && this.flvplayback_internal::_vc.stage != null)
               {
                  try
                  {
                     this.flvplayback_internal::_vc.stage.displayState = StageDisplayState.NORMAL;
                  }
                  catch(se:SecurityError)
                  {
                  }
                  this.flvplayback_internal::setEnabledAndVisibleForState(FULL_SCREEN_OFF_BUTTON,VideoState.PLAYING);
                  this.flvplayback_internal::skinButtonControl(this.flvplayback_internal::controls[FULL_SCREEN_OFF_BUTTON]);
                  this.flvplayback_internal::setEnabledAndVisibleForState(FULL_SCREEN_ON_BUTTON,VideoState.PLAYING);
                  this.flvplayback_internal::skinButtonControl(this.flvplayback_internal::controls[FULL_SCREEN_ON_BUTTON]);
                  break;
               }
               break;
            default:
               throw new Error("Unknown ButtonControl");
         }
         this.flvplayback_internal::_vc.activeVideoPlayerIndex = cachedActivePlayerIndex;
      }
      
      flvplayback_internal function setEnabledAndVisibleForState(param1:int, param2:String) : void
      {
         var _loc6_:ControlData = null;
         var _loc7_:Boolean = false;
         var _loc8_:ControlData = null;
         var _loc9_:ControlData = null;
         var _loc10_:ControlData = null;
         var _loc11_:ControlData = null;
         var _loc3_:int = int(this.flvplayback_internal::_vc.activeVideoPlayerIndex);
         this.flvplayback_internal::_vc.activeVideoPlayerIndex = this.flvplayback_internal::_vc.visibleVideoPlayerIndex;
         var _loc4_:String;
         if((_loc4_ = param2) == VideoState.BUFFERING && !this.flvplayback_internal::_bufferingOn)
         {
            _loc4_ = VideoState.PLAYING;
         }
         var _loc5_:Sprite;
         if((_loc5_ = this.flvplayback_internal::controls[param1]) == null)
         {
            return;
         }
         if((_loc6_ = this.ctrlDataDict[_loc5_]) == null)
         {
            return;
         }
         loop0:
         switch(param1)
         {
            case VOLUME_BAR:
            case VOLUME_BAR_HANDLE:
            case VOLUME_BAR_HIT:
               _loc6_.enabled = true;
               break;
            case FULL_SCREEN_ON_BUTTON:
               _loc6_.enabled = !this.flvplayback_internal::_fullScreen;
               if(this.flvplayback_internal::controls[FULL_SCREEN_BUTTON] != undefined)
               {
                  _loc5_.visible = _loc6_.enabled;
                  break;
               }
               break;
            case FULL_SCREEN_OFF_BUTTON:
               _loc6_.enabled = this.flvplayback_internal::_fullScreen;
               if(this.flvplayback_internal::controls[FULL_SCREEN_BUTTON] != undefined)
               {
                  _loc5_.visible = _loc6_.enabled;
                  break;
               }
               break;
            case MUTE_ON_BUTTON:
               _loc6_.enabled = !this.flvplayback_internal::_isMuted;
               if(this.flvplayback_internal::controls[MUTE_BUTTON] != undefined)
               {
                  _loc5_.visible = _loc6_.enabled;
                  break;
               }
               break;
            case MUTE_OFF_BUTTON:
               _loc6_.enabled = this.flvplayback_internal::_isMuted;
               if(this.flvplayback_internal::controls[MUTE_BUTTON] != undefined)
               {
                  _loc5_.visible = _loc6_.enabled;
                  break;
               }
               break;
            default:
               switch(_loc4_)
               {
                  case VideoState.LOADING:
                  case VideoState.CONNECTION_ERROR:
                     _loc6_.enabled = false;
                     break loop0;
                  case VideoState.DISCONNECTED:
                     _loc6_.enabled = this.flvplayback_internal::_vc.source != null && this.flvplayback_internal::_vc.source != "";
                     break loop0;
                  case VideoState.SEEKING:
                     break loop0;
                  default:
                     _loc6_.enabled = true;
               }
         }
         loop2:
         switch(param1)
         {
            case SEEK_BAR:
               switch(_loc4_)
               {
                  case VideoState.STOPPED:
                  case VideoState.PLAYING:
                  case VideoState.PAUSED:
                  case VideoState.REWINDING:
                  case VideoState.SEEKING:
                     _loc6_.enabled = true;
                     break;
                  case VideoState.BUFFERING:
                     _loc6_.enabled = !this.flvplayback_internal::_bufferingBarHides || this.flvplayback_internal::controls[BUFFERING_BAR] == undefined;
                     break;
                  default:
                     _loc6_.enabled = false;
               }
               if(_loc6_.enabled)
               {
                  _loc6_.enabled = !isNaN(this.flvplayback_internal::_vc.totalTime);
               }
               if(_loc6_.handle_mc != null)
               {
                  (_loc8_ = this.ctrlDataDict[_loc6_.handle_mc]).enabled = _loc6_.enabled;
                  _loc6_.handle_mc.visible = _loc8_.enabled;
               }
               if(_loc6_.hit_mc != null)
               {
                  (_loc9_ = this.ctrlDataDict[_loc6_.hit_mc]).enabled = _loc6_.enabled;
                  _loc6_.hit_mc.visible = _loc9_.enabled;
               }
               _loc7_ = !this.flvplayback_internal::_bufferingBarHides || _loc6_.enabled || this.flvplayback_internal::controls[BUFFERING_BAR] == undefined || !this.flvplayback_internal::controls[BUFFERING_BAR].visible;
               _loc5_.visible = _loc7_;
               if(_loc6_.progress_mc != null)
               {
                  _loc6_.progress_mc.visible = _loc7_;
                  if((_loc10_ = this.ctrlDataDict[_loc6_.progress_mc]).fill_mc != null)
                  {
                     _loc10_.fill_mc.visible = _loc7_;
                  }
               }
               if(_loc6_.fullness_mc != null)
               {
                  _loc6_.fullness_mc.visible = _loc7_;
                  if((_loc11_ = this.ctrlDataDict[_loc6_.fullness_mc]).fill_mc != null)
                  {
                     _loc11_.fill_mc.visible = _loc7_;
                     break;
                  }
                  break;
               }
               break;
            case BUFFERING_BAR:
               switch(_loc4_)
               {
                  case VideoState.STOPPED:
                  case VideoState.PLAYING:
                  case VideoState.PAUSED:
                  case VideoState.REWINDING:
                  case VideoState.SEEKING:
                     _loc6_.enabled = false;
                     break;
                  default:
                     _loc6_.enabled = true;
               }
               _loc5_.visible = _loc6_.enabled;
               if(_loc6_.fill_mc != null)
               {
                  _loc6_.fill_mc.visible = _loc6_.enabled;
                  break;
               }
               break;
            case PAUSE_BUTTON:
               switch(_loc4_)
               {
                  case VideoState.DISCONNECTED:
                  case VideoState.STOPPED:
                  case VideoState.PAUSED:
                  case VideoState.REWINDING:
                     _loc6_.enabled = false;
                     break;
                  case VideoState.PLAYING:
                     _loc6_.enabled = true;
                     break;
                  case VideoState.BUFFERING:
                     _loc6_.enabled = !this.flvplayback_internal::_bufferingBarHides || this.flvplayback_internal::controls[BUFFERING_BAR] == undefined;
               }
               if(this.flvplayback_internal::controls[PLAY_PAUSE_BUTTON] != undefined)
               {
                  _loc5_.visible = _loc6_.enabled;
                  break;
               }
               break;
            case PLAY_BUTTON:
               switch(_loc4_)
               {
                  case VideoState.PLAYING:
                     _loc6_.enabled = false;
                     break;
                  case VideoState.STOPPED:
                  case VideoState.PAUSED:
                     _loc6_.enabled = true;
                     break;
                  case VideoState.BUFFERING:
                     _loc6_.enabled = !this.flvplayback_internal::_bufferingBarHides || this.flvplayback_internal::controls[BUFFERING_BAR] == undefined;
               }
               if(this.flvplayback_internal::controls[PLAY_PAUSE_BUTTON] != undefined)
               {
                  _loc5_.visible = !this.flvplayback_internal::controls[PAUSE_BUTTON].visible;
                  break;
               }
               break;
            case STOP_BUTTON:
               switch(_loc4_)
               {
                  case VideoState.DISCONNECTED:
                  case VideoState.STOPPED:
                     _loc6_.enabled = false;
                     _loc5_.tabEnabled = false;
                     break loop2;
                  case VideoState.PAUSED:
                  case VideoState.PLAYING:
                  case VideoState.BUFFERING:
                     _loc6_.enabled = true;
                     _loc5_.tabEnabled = true;
               }
               break;
            case BACK_BUTTON:
            case FORWARD_BUTTON:
               switch(_loc4_)
               {
                  case VideoState.BUFFERING:
                     _loc6_.enabled = !this.flvplayback_internal::_bufferingBarHides || this.flvplayback_internal::controls[BUFFERING_BAR] == undefined;
                     _loc5_.tabEnabled = !this.flvplayback_internal::_bufferingBarHides || this.flvplayback_internal::controls[BUFFERING_BAR] == undefined;
               }
         }
         _loc5_.mouseEnabled = _loc6_.enabled;
         this.flvplayback_internal::_vc.activeVideoPlayerIndex = _loc3_;
      }
      
      flvplayback_internal function setupSkinAutoHide(param1:Boolean) : void
      {
         var uiMgr:UIManager = null;
         var clickHandler:Function = null;
         var doFade:Boolean = param1;
         if(this.flvplayback_internal::_skinAutoHide && this.flvplayback_internal::skin_mc != null)
         {
            if(!this.flvplayback_internal::hitTarget_mc)
            {
               this.flvplayback_internal::hitTarget_mc = new Sprite();
               this.flvplayback_internal::hitTarget_mc.accessibilityProperties = new AccessibilityProperties();
               this.flvplayback_internal::hitTarget_mc.accessibilityProperties.name = this.flvplayback_internal::accessibilityPropertyNames[SHOW_CONTROLS_BUTTON];
               this.customClips.push(this.flvplayback_internal::hitTarget_mc);
               uiMgr = this;
               clickHandler = function(param1:*):void
               {
                  if(param1.type == FocusEvent.FOCUS_IN)
                  {
                     uiMgr.flvplayback_internal::_skinAutoHide = false;
                  }
                  else if(param1.type == MouseEvent.CLICK)
                  {
                     uiMgr.flvplayback_internal::_skinAutoHide = !uiMgr.flvplayback_internal::_skinAutoHide;
                  }
                  uiMgr.flvplayback_internal::setupSkinAutoHide(true);
                  if(uiMgr.flvplayback_internal::_skinAutoHide)
                  {
                     param1.target.accessibilityProperties.name = flvplayback_internal::accessibilityPropertyNames[SHOW_CONTROLS_BUTTON];
                  }
                  else
                  {
                     param1.target.accessibilityProperties.name = flvplayback_internal::accessibilityPropertyNames[HIDE_CONTROLS_BUTTON];
                  }
                  if(Accessibility.active)
                  {
                     Accessibility.updateProperties();
                  }
               };
               this.flvplayback_internal::hitTarget_mc.useHandCursor = false;
               this.flvplayback_internal::hitTarget_mc.buttonMode = true;
               this.flvplayback_internal::hitTarget_mc.tabEnabled = true;
               this.flvplayback_internal::hitTarget_mc.tabChildren = true;
               this.flvplayback_internal::hitTarget_mc.focusRect = true;
               this.flvplayback_internal::hitTarget_mc.addEventListener(FocusEvent.FOCUS_IN,clickHandler);
               this.flvplayback_internal::hitTarget_mc.addEventListener(MouseEvent.CLICK,clickHandler);
               this.flvplayback_internal::hitTarget_mc.accessibilityProperties.silent = this.flvplayback_internal::_fullScreen;
               this.flvplayback_internal::hitTarget_mc.tabEnabled = !this.flvplayback_internal::_fullScreen;
               if(Accessibility.active)
               {
                  Accessibility.updateProperties();
               }
               this.flvplayback_internal::_vc.addChild(this.flvplayback_internal::hitTarget_mc);
            }
            this.flvplayback_internal::hitTarget_mc.graphics.clear();
            this.flvplayback_internal::hitTarget_mc.graphics.lineStyle(0,16711680,0);
            this.flvplayback_internal::hitTarget_mc.graphics.drawRect(0,0,this.flvplayback_internal::_vc.width,this.flvplayback_internal::_vc.height);
            this.flvplayback_internal::skinAutoHideHitTest(null,doFade);
            this.flvplayback_internal::_skinAutoHideTimer.start();
         }
         else
         {
            if(this.flvplayback_internal::skin_mc != null)
            {
               if(doFade && this.flvplayback_internal::_skinFadingMaxTime > 0 && (!this.flvplayback_internal::skin_mc.visible || this.flvplayback_internal::skin_mc.alpha < 1) && this.flvplayback_internal::__visible)
               {
                  this.flvplayback_internal::_skinFadingTimer.stop();
                  this.flvplayback_internal::_skinFadeStartTime = getTimer();
                  this.flvplayback_internal::_skinFadingIn = true;
                  if(this.flvplayback_internal::skin_mc.alpha == 1)
                  {
                     this.flvplayback_internal::skin_mc.alpha = 0;
                  }
                  this.flvplayback_internal::_skinFadingTimer.start();
               }
               else if(this.flvplayback_internal::_skinFadingMaxTime <= 0)
               {
                  this.flvplayback_internal::_skinFadingTimer.stop();
                  this.flvplayback_internal::skin_mc.alpha = 1;
               }
               this.flvplayback_internal::skin_mc.visible = this.flvplayback_internal::__visible;
            }
            this.flvplayback_internal::_skinAutoHideTimer.stop();
         }
      }
      
      flvplayback_internal function skinAutoHideHitTest(param1:TimerEvent, param2:Boolean = true) : void
      {
         var visibleVP:VideoPlayer = null;
         var hit:Boolean = false;
         var e:TimerEvent = param1;
         var doFade:Boolean = param2;
         try
         {
            if(!this.flvplayback_internal::__visible)
            {
               this.flvplayback_internal::skin_mc.visible = false;
               if(this.flvplayback_internal::hitTarget_mc)
               {
                  this.flvplayback_internal::hitTarget_mc.accessibilityProperties.name = this.flvplayback_internal::accessibilityPropertyNames[SHOW_CONTROLS_BUTTON];
               }
            }
            else if(this.flvplayback_internal::_vc.stage != null)
            {
               visibleVP = this.flvplayback_internal::_vc.getVideoPlayer(this.flvplayback_internal::_vc.visibleVideoPlayerIndex);
               hit = visibleVP.hitTestPoint(this.flvplayback_internal::_vc.stage.mouseX,this.flvplayback_internal::_vc.stage.mouseY,true);
               if(this.flvplayback_internal::_fullScreen && this.flvplayback_internal::_fullScreenTakeOver && e != null)
               {
                  if(this.flvplayback_internal::_vc.stage.mouseX == this.flvplayback_internal::_skinAutoHideMouseX && this.flvplayback_internal::_vc.stage.mouseY == this.flvplayback_internal::_skinAutoHideMouseY)
                  {
                     if(getTimer() - this.flvplayback_internal::_skinAutoHideLastMotionTime > this.flvplayback_internal::_skinAutoHideMotionTimeout)
                     {
                        hit = false;
                     }
                  }
                  else
                  {
                     this.flvplayback_internal::_skinAutoHideLastMotionTime = getTimer();
                     this.flvplayback_internal::_skinAutoHideMouseX = this.flvplayback_internal::_vc.stage.mouseX;
                     this.flvplayback_internal::_skinAutoHideMouseY = this.flvplayback_internal::_vc.stage.mouseY;
                  }
               }
               if(!hit && this.flvplayback_internal::border_mc != null)
               {
                  hit = this.flvplayback_internal::border_mc.hitTestPoint(this.flvplayback_internal::_vc.stage.mouseX,this.flvplayback_internal::_vc.stage.mouseY,true);
                  if(hit && this.flvplayback_internal::_fullScreen && this.flvplayback_internal::_fullScreenTakeOver)
                  {
                     this.flvplayback_internal::_skinAutoHideLastMotionTime = getTimer();
                  }
               }
               if(!doFade || this.flvplayback_internal::_skinFadingMaxTime <= 0)
               {
                  this.flvplayback_internal::_skinFadingTimer.stop();
                  this.flvplayback_internal::skin_mc.visible = hit;
                  this.flvplayback_internal::skin_mc.alpha = 1;
               }
               else if(!(hit && this.flvplayback_internal::skin_mc.visible && (!this.flvplayback_internal::_skinFadingTimer.running || this.flvplayback_internal::_skinFadingIn) || !hit && (!this.flvplayback_internal::skin_mc.visible || this.flvplayback_internal::_skinFadingTimer.running && !this.flvplayback_internal::_skinFadingIn)))
               {
                  this.flvplayback_internal::_skinFadingTimer.stop();
                  this.flvplayback_internal::_skinFadingIn = hit;
                  if(this.flvplayback_internal::_skinFadingIn && this.flvplayback_internal::skin_mc.alpha == 1)
                  {
                     this.flvplayback_internal::skin_mc.alpha = 0;
                  }
                  this.flvplayback_internal::_skinFadeStartTime = getTimer();
                  this.flvplayback_internal::_skinFadingTimer.start();
                  this.flvplayback_internal::skin_mc.visible = true;
               }
               if(this.flvplayback_internal::hitTarget_mc)
               {
                  this.flvplayback_internal::hitTarget_mc.accessibilityProperties.name = hit ? String(this.flvplayback_internal::accessibilityPropertyNames[HIDE_CONTROLS_BUTTON]) : String(this.flvplayback_internal::accessibilityPropertyNames[SHOW_CONTROLS_BUTTON]);
               }
            }
         }
         catch(se:SecurityError)
         {
            flvplayback_internal::_skinAutoHideTimer.stop();
            flvplayback_internal::_skinFadingTimer.stop();
            flvplayback_internal::skin_mc.visible = flvplayback_internal::__visible;
            flvplayback_internal::skin_mc.alpha = 1;
            if(flvplayback_internal::hitTarget_mc)
            {
               flvplayback_internal::hitTarget_mc.accessibilityProperties.name = flvplayback_internal::accessibilityPropertyNames[HIDE_CONTROLS_BUTTON];
            }
         }
         if(Boolean(this.flvplayback_internal::hitTarget_mc) && Capabilities.hasAccessibility)
         {
            Accessibility.updateProperties();
         }
      }
      
      flvplayback_internal function skinFadeMore(param1:TimerEvent) : void
      {
         var _loc2_:Number = NaN;
         if(!this.flvplayback_internal::_skinFadingIn && this.flvplayback_internal::skin_mc.alpha <= 0.5 || this.flvplayback_internal::_skinFadingIn && this.flvplayback_internal::skin_mc.alpha >= 0.95)
         {
            this.flvplayback_internal::skin_mc.visible = this.flvplayback_internal::_skinFadingIn;
            this.flvplayback_internal::skin_mc.alpha = 1;
            this.flvplayback_internal::_skinFadingTimer.stop();
         }
         else
         {
            _loc2_ = (getTimer() - this.flvplayback_internal::_skinFadeStartTime) / this.flvplayback_internal::_skinFadingMaxTime;
            if(!this.flvplayback_internal::_skinFadingIn)
            {
               _loc2_ = 1 - _loc2_;
            }
            if(_loc2_ < 0)
            {
               _loc2_ = 0;
            }
            else if(_loc2_ > 1)
            {
               _loc2_ = 1;
            }
            this.flvplayback_internal::skin_mc.alpha = _loc2_;
         }
      }
      
      public function enterFullScreenDisplayState() : void
      {
         var theRect:Rectangle = null;
         var vp:VideoPlayer = null;
         var effectiveWidth:int = 0;
         var effectiveHeight:int = 0;
         var videoAspectRatio:Number = NaN;
         var screenAspectRatio:Number = NaN;
         var effectiveMinWidth:int = 0;
         var effectiveMinHeight:int = 0;
         var skinScaleMinWidth:int = 0;
         var skinScaleMinHeight:int = 0;
         if(!this.flvplayback_internal::_fullScreen && this.flvplayback_internal::_vc.stage != null)
         {
            if(this.flvplayback_internal::_fullScreenTakeOver)
            {
               try
               {
                  theRect = this.flvplayback_internal::_vc.stage.fullScreenSourceRect;
                  this.flvplayback_internal::_fullScreenAccel = true;
                  vp = this.flvplayback_internal::_vc.getVideoPlayer(this.flvplayback_internal::_vc.visibleVideoPlayerIndex);
                  effectiveWidth = vp.videoWidth;
                  effectiveHeight = vp.videoHeight;
                  videoAspectRatio = effectiveWidth / effectiveHeight;
                  screenAspectRatio = this.flvplayback_internal::_vc.stage.fullScreenWidth / this.flvplayback_internal::_vc.stage.fullScreenHeight;
                  if(videoAspectRatio > screenAspectRatio)
                  {
                     effectiveHeight = effectiveWidth / screenAspectRatio;
                  }
                  else if(videoAspectRatio < screenAspectRatio)
                  {
                     effectiveWidth = effectiveHeight * screenAspectRatio;
                  }
                  effectiveMinWidth = int(this.flvplayback_internal::fullScreenSourceRectMinWidth);
                  effectiveMinHeight = int(this.flvplayback_internal::fullScreenSourceRectMinHeight);
                  if(this.flvplayback_internal::fullScreenSourceRectMinAspectRatio > screenAspectRatio)
                  {
                     effectiveMinHeight = effectiveMinWidth / screenAspectRatio;
                  }
                  else if(this.flvplayback_internal::fullScreenSourceRectMinAspectRatio < screenAspectRatio)
                  {
                     effectiveMinWidth = effectiveMinHeight * screenAspectRatio;
                  }
                  skinScaleMinWidth = this.flvplayback_internal::_vc.stage.fullScreenWidth / this.flvplayback_internal::_skinScaleMaximum;
                  skinScaleMinHeight = this.flvplayback_internal::_vc.stage.fullScreenHeight / this.flvplayback_internal::_skinScaleMaximum;
                  if(effectiveMinWidth < skinScaleMinWidth || effectiveMinHeight < skinScaleMinHeight)
                  {
                     effectiveMinWidth = skinScaleMinWidth;
                     effectiveMinHeight = skinScaleMinHeight;
                  }
                  if(effectiveWidth < effectiveMinWidth || effectiveHeight < effectiveMinHeight)
                  {
                     effectiveWidth = effectiveMinWidth;
                     effectiveHeight = effectiveMinHeight;
                  }
                  this.flvplayback_internal::_vc.stage.fullScreenSourceRect = new Rectangle(0,0,effectiveWidth,effectiveHeight);
                  this.flvplayback_internal::_vc.stage.displayState = StageDisplayState.FULL_SCREEN;
               }
               catch(re:ReferenceError)
               {
                  flvplayback_internal::_fullScreenAccel = false;
               }
               catch(re:SecurityError)
               {
                  flvplayback_internal::_fullScreenAccel = false;
               }
            }
            try
            {
               this.flvplayback_internal::_vc.stage.displayState = StageDisplayState.FULL_SCREEN;
            }
            catch(se:SecurityError)
            {
            }
         }
      }
      
      flvplayback_internal function enterFullScreenTakeOver() : void
      {
         var i:int = 0;
         var fullScreenBG:Sprite = null;
         var vp:VideoPlayer = null;
         if(!this.flvplayback_internal::_fullScreen || this.flvplayback_internal::cacheFLVPlaybackParent != null)
         {
            return;
         }
         this.flvplayback_internal::_vc.removeEventListener(LayoutEvent.LAYOUT,this.flvplayback_internal::handleLayoutEvent);
         this.flvplayback_internal::_vc.removeEventListener(AutoLayoutEvent.AUTO_LAYOUT,this.flvplayback_internal::handleLayoutEvent);
         this.flvplayback_internal::_vc.removeEventListener(Event.ADDED_TO_STAGE,this.flvplayback_internal::handleEvent);
         this.flvplayback_internal::_vc.stage.removeEventListener(FullScreenEvent.FULL_SCREEN,this.flvplayback_internal::handleFullScreenEvent);
         try
         {
            this.flvplayback_internal::cacheFLVPlaybackScaleMode = new Array();
            this.flvplayback_internal::cacheFLVPlaybackAlign = new Array();
            i = 0;
            while(i < this.flvplayback_internal::_vc.flvplayback_internal::videoPlayers.length)
            {
               vp = this.flvplayback_internal::_vc.flvplayback_internal::videoPlayers[i] as VideoPlayer;
               if(vp != null)
               {
                  this.flvplayback_internal::cacheFLVPlaybackScaleMode[i] = vp.scaleMode;
                  this.flvplayback_internal::cacheFLVPlaybackAlign[i] = vp.align;
               }
               i++;
            }
            this.flvplayback_internal::cacheFLVPlaybackParent = this.flvplayback_internal::_vc.parent;
            this.flvplayback_internal::cacheFLVPlaybackIndex = this.flvplayback_internal::_vc.parent.getChildIndex(this.flvplayback_internal::_vc);
            this.flvplayback_internal::cacheFLVPlaybackLocation = new Rectangle(this.flvplayback_internal::_vc.registrationX,this.flvplayback_internal::_vc.registrationY,this.flvplayback_internal::_vc.registrationWidth,this.flvplayback_internal::_vc.registrationHeight);
            if(!this.flvplayback_internal::_fullScreenAccel)
            {
               this.flvplayback_internal::cacheStageAlign = this.flvplayback_internal::_vc.stage.align;
               this.flvplayback_internal::cacheStageScaleMode = this.flvplayback_internal::_vc.stage.scaleMode;
               this.flvplayback_internal::_vc.stage.align = StageAlign.TOP_LEFT;
               this.flvplayback_internal::_vc.stage.scaleMode = StageScaleMode.NO_SCALE;
            }
            this.flvplayback_internal::_vc.align = VideoAlign.CENTER;
            this.flvplayback_internal::_vc.scaleMode = VideoScaleMode.MAINTAIN_ASPECT_RATIO;
            this.flvplayback_internal::_vc.registrationX = 0;
            this.flvplayback_internal::_vc.registrationY = 0;
            if(this.flvplayback_internal::_fullScreenAccel)
            {
               this.flvplayback_internal::_vc.setSize(this.flvplayback_internal::_vc.stage.fullScreenSourceRect.width,this.flvplayback_internal::_vc.stage.fullScreenSourceRect.height);
            }
            else
            {
               this.flvplayback_internal::_vc.setSize(this.flvplayback_internal::_vc.stage.stageWidth,this.flvplayback_internal::_vc.stage.stageHeight);
            }
            if(this.flvplayback_internal::_vc.stage != this.flvplayback_internal::_vc.parent)
            {
               this.flvplayback_internal::_vc.stage.addChild(this.flvplayback_internal::_vc);
            }
            else
            {
               this.flvplayback_internal::_vc.stage.setChildIndex(this.flvplayback_internal::_vc,this.flvplayback_internal::_vc.stage.numChildren - 1);
            }
            fullScreenBG = Sprite(this.flvplayback_internal::_vc.getChildByName("fullScreenBG"));
            if(fullScreenBG == null)
            {
               fullScreenBG = new Sprite();
               fullScreenBG.name = "fullScreenBG";
               this.flvplayback_internal::_vc.addChildAt(fullScreenBG,0);
            }
            else
            {
               this.flvplayback_internal::_vc.setChildIndex(fullScreenBG,0);
            }
            fullScreenBG.graphics.beginFill(this.flvplayback_internal::_fullScreenBgColor);
            if(this.flvplayback_internal::_fullScreenAccel)
            {
               fullScreenBG.graphics.drawRect(0,0,this.flvplayback_internal::_vc.stage.fullScreenSourceRect.width,this.flvplayback_internal::_vc.stage.fullScreenSourceRect.height);
            }
            else
            {
               fullScreenBG.graphics.drawRect(0,0,this.flvplayback_internal::_vc.stage.stageWidth,this.flvplayback_internal::_vc.stage.stageHeight);
            }
            this.flvplayback_internal::layoutSkin();
            this.flvplayback_internal::setupSkinAutoHide(false);
            if(this.flvplayback_internal::hitTarget_mc != null)
            {
               this.flvplayback_internal::hitTarget_mc.graphics.clear();
               this.flvplayback_internal::hitTarget_mc.graphics.lineStyle(0,0,0);
               if(this.flvplayback_internal::_fullScreenAccel)
               {
                  this.flvplayback_internal::hitTarget_mc.graphics.drawRect(0,0,this.flvplayback_internal::_vc.stage.fullScreenSourceRect.width,this.flvplayback_internal::_vc.stage.fullScreenSourceRect.height);
               }
               else
               {
                  this.flvplayback_internal::hitTarget_mc.graphics.drawRect(0,0,this.flvplayback_internal::_vc.stage.stageWidth,this.flvplayback_internal::_vc.stage.stageHeight);
               }
            }
         }
         catch(err:Error)
         {
            flvplayback_internal::cacheFLVPlaybackParent = null;
         }
         this.flvplayback_internal::_vc.addEventListener(LayoutEvent.LAYOUT,this.flvplayback_internal::handleLayoutEvent);
         this.flvplayback_internal::_vc.addEventListener(AutoLayoutEvent.AUTO_LAYOUT,this.flvplayback_internal::handleLayoutEvent);
         this.flvplayback_internal::_vc.addEventListener(Event.ADDED_TO_STAGE,this.flvplayback_internal::handleEvent);
         this.flvplayback_internal::_vc.stage.addEventListener(FullScreenEvent.FULL_SCREEN,this.flvplayback_internal::handleFullScreenEvent,false,0,true);
      }
      
      flvplayback_internal function exitFullScreenTakeOver() : void
      {
         var fullScreenBG:Sprite = null;
         var cacheActiveIndex:int = 0;
         var i:int = 0;
         var vp:VideoPlayer = null;
         if(this.flvplayback_internal::cacheFLVPlaybackParent == null)
         {
            return;
         }
         this.flvplayback_internal::_vc.removeEventListener(Event.ADDED_TO_STAGE,this.flvplayback_internal::handleEvent);
         this.flvplayback_internal::_vc.stage.removeEventListener(FullScreenEvent.FULL_SCREEN,this.flvplayback_internal::handleFullScreenEvent);
         try
         {
            if(this.flvplayback_internal::_fullScreenAccel)
            {
               this.flvplayback_internal::_vc.stage.fullScreenSourceRect = new Rectangle(0,0,-1,-1);
            }
            else
            {
               this.flvplayback_internal::_vc.stage.align = this.flvplayback_internal::cacheStageAlign;
               this.flvplayback_internal::_vc.stage.scaleMode = this.flvplayback_internal::cacheStageScaleMode;
            }
            fullScreenBG = Sprite(this.flvplayback_internal::_vc.getChildByName("fullScreenBG"));
            if(fullScreenBG != null)
            {
               this.flvplayback_internal::_vc.removeChild(fullScreenBG);
            }
            if(this.flvplayback_internal::hitTarget_mc != null)
            {
               this.flvplayback_internal::hitTarget_mc.graphics.clear();
               this.flvplayback_internal::hitTarget_mc.graphics.lineStyle(0,0,0);
               this.flvplayback_internal::hitTarget_mc.graphics.drawRect(0,0,this.flvplayback_internal::_vc.width,this.flvplayback_internal::_vc.height);
            }
            if(this.flvplayback_internal::_vc.parent != this.flvplayback_internal::cacheFLVPlaybackParent)
            {
               this.flvplayback_internal::cacheFLVPlaybackParent.addChildAt(this.flvplayback_internal::_vc,this.flvplayback_internal::cacheFLVPlaybackIndex);
            }
            else
            {
               this.flvplayback_internal::cacheFLVPlaybackParent.setChildIndex(this.flvplayback_internal::_vc,this.flvplayback_internal::cacheFLVPlaybackIndex);
            }
            cacheActiveIndex = int(this.flvplayback_internal::_vc.activeVideoPlayerIndex);
            i = 0;
            while(i < this.flvplayback_internal::_vc.flvplayback_internal::videoPlayers.length)
            {
               vp = this.flvplayback_internal::_vc.flvplayback_internal::videoPlayers[i] as VideoPlayer;
               if(vp != null)
               {
                  this.flvplayback_internal::_vc.activeVideoPlayerIndex = i;
                  if(this.flvplayback_internal::cacheFLVPlaybackScaleMode[i] != undefined)
                  {
                     this.flvplayback_internal::_vc.scaleMode = this.flvplayback_internal::cacheFLVPlaybackScaleMode[i];
                  }
                  if(this.flvplayback_internal::cacheFLVPlaybackAlign[i])
                  {
                     this.flvplayback_internal::_vc.align = this.flvplayback_internal::cacheFLVPlaybackAlign[i];
                  }
               }
               i++;
            }
            this.flvplayback_internal::_vc.activeVideoPlayerIndex = cacheActiveIndex;
            this.flvplayback_internal::_vc.registrationX = this.flvplayback_internal::cacheFLVPlaybackLocation.x;
            this.flvplayback_internal::_vc.registrationY = this.flvplayback_internal::cacheFLVPlaybackLocation.y;
            this.flvplayback_internal::_vc.setSize(this.flvplayback_internal::cacheFLVPlaybackLocation.width,this.flvplayback_internal::cacheFLVPlaybackLocation.height);
         }
         catch(err:Error)
         {
         }
         this.flvplayback_internal::_vc.addEventListener(Event.ADDED_TO_STAGE,this.flvplayback_internal::handleEvent);
         this.flvplayback_internal::_vc.stage.addEventListener(FullScreenEvent.FULL_SCREEN,this.flvplayback_internal::handleFullScreenEvent,false,0,true);
         this.flvplayback_internal::_fullScreen = false;
         this.flvplayback_internal::_fullScreenAccel = false;
         this.flvplayback_internal::cacheStageAlign = null;
         this.flvplayback_internal::cacheStageScaleMode = null;
         this.flvplayback_internal::cacheFLVPlaybackParent = null;
         this.flvplayback_internal::cacheFLVPlaybackIndex = 0;
         this.flvplayback_internal::cacheFLVPlaybackLocation = null;
         this.flvplayback_internal::cacheFLVPlaybackScaleMode = null;
         this.flvplayback_internal::cacheFLVPlaybackAlign = null;
         if(this.flvplayback_internal::_skinAutoHide != this.flvplayback_internal::cacheSkinAutoHide)
         {
            this.flvplayback_internal::_skinAutoHide = this.flvplayback_internal::cacheSkinAutoHide;
            this.flvplayback_internal::setupSkinAutoHide(false);
         }
      }
      
      flvplayback_internal function hookUpCustomComponents() : void
      {
         var searchHash:Object;
         var doTheSearch:Boolean;
         var i:int = 0;
         var dispObj:DisplayObject = null;
         var name:String = null;
         var index:int = 0;
         var ctrl:Sprite = null;
         this.flvplayback_internal::focusRect = this.flvplayback_internal::isFocusRectActive();
         searchHash = new Object();
         doTheSearch = false;
         i = 0;
         while(i < NUM_CONTROLS)
         {
            if(this.flvplayback_internal::controls[i] == null)
            {
               searchHash[flvplayback_internal::customComponentClassNames[i]] = i;
               doTheSearch = true;
            }
            i++;
         }
         if(!doTheSearch)
         {
            return;
         }
         i = 0;
         for(; i < this.flvplayback_internal::_vc.parent.numChildren; i++)
         {
            dispObj = this.flvplayback_internal::_vc.parent.getChildAt(i);
            name = getQualifiedClassName(dispObj);
            if(searchHash[name] != undefined)
            {
               if(typeof searchHash[name] == "number")
               {
                  index = int(searchHash[name]);
                  try
                  {
                     ctrl = Sprite(dispObj);
                     if((index >= NUM_BUTTONS || ctrl["placeholder_mc"] is DisplayObject) && ctrl["uiMgr"] == null)
                     {
                        this.setControl(index,ctrl);
                        searchHash[name] = ctrl;
                     }
                  }
                  catch(err:Error)
                  {
                     continue;
                  }
               }
            }
         }
      }
      
      flvplayback_internal function configureBarAccessibility(param1:int) : void
      {
         switch(param1)
         {
            case SEEK_BAR_HANDLE:
               SeekBarAccImpl.createAccessibilityImplementation(this.flvplayback_internal::controls[SEEK_BAR_HANDLE]);
               break;
            case VOLUME_BAR_HANDLE:
               VolumeBarAccImpl.createAccessibilityImplementation(this.flvplayback_internal::controls[VOLUME_BAR_HANDLE]);
         }
      }
      
      flvplayback_internal function handleKeyEvent(param1:KeyboardEvent) : void
      {
         var ctrlData:ControlData = null;
         var focusControl:InteractiveObject = null;
         var percent:Number = NaN;
         var nearestCuePoint:Object = null;
         var nextCuePoint:Object = null;
         var wasMuted:Boolean = false;
         var num:Number = NaN;
         var ctrl:Sprite = null;
         var setFocusedControl:Function = null;
         var event:KeyboardEvent = param1;
         ctrlData = this.ctrlDataDict[event.currentTarget];
         var k:int = int(event.keyCode);
         var ka:int = int(event.charCode);
         var kaBool:Boolean = ka >= 48 && ka <= 57;
         ka = int(String.fromCharCode(event.charCode));
         loop0:
         switch(event.type)
         {
            case KeyboardEvent.KEY_DOWN:
               switch(event.target)
               {
                  case this.flvplayback_internal::controls[SEEK_BAR_HANDLE]:
                  case this.flvplayback_internal::controls[VOLUME_BAR_HANDLE]:
                     if(k != Keyboard.TAB && (k == Keyboard.UP || k == Keyboard.DOWN || k == Keyboard.LEFT || k == Keyboard.RIGHT || k == Keyboard.PAGE_UP || k == Keyboard.PAGE_DOWN || k == Keyboard.HOME || k == Keyboard.END || !isNaN(ka) && kaBool))
                     {
                        focusControl = event.target as InteractiveObject;
                        focusControl.stage.focus = focusControl;
                        if(event.target == this.flvplayback_internal::controls[SEEK_BAR_HANDLE])
                        {
                           percent = this.flvplayback_internal::_vc.playheadPercentage;
                           nearestCuePoint = this.flvplayback_internal::_vc.findNearestCuePoint(this.flvplayback_internal::_vc.playheadTime);
                           if(k == Keyboard.LEFT || k == Keyboard.DOWN)
                           {
                              percent -= this.flvplayback_internal::_vc.seekBarScrubTolerance * 2;
                              this.flvplayback_internal::_vc.playheadPercentage = Math.max(percent,0);
                              break;
                           }
                           if(k == Keyboard.RIGHT || k == Keyboard.UP)
                           {
                              if(this.flvplayback_internal::_vc.playheadPercentage >= 99)
                              {
                                 return;
                              }
                              if(nearestCuePoint != null && nearestCuePoint.index < (nearestCuePoint.array as Array).length - 1)
                              {
                                 try
                                 {
                                    nextCuePoint = this.flvplayback_internal::_vc.findCuePoint(nearestCuePoint.array[nearestCuePoint.index + 1]);
                                    if(Boolean(nextCuePoint) && this.flvplayback_internal::_vc.isFLVCuePointEnabled(nextCuePoint))
                                    {
                                       if(isNaN(Number(this.flvplayback_internal::_vc.metadata.videocodecid)))
                                       {
                                          this.flvplayback_internal::_vc.playheadPercentage = Math.max(nextCuePoint.time / this.flvplayback_internal::_vc.totalTime * 100,Math.min(99,this.flvplayback_internal::_vc.playheadPercentage + this.flvplayback_internal::_vc.seekBarScrubTolerance * 2));
                                       }
                                       else
                                       {
                                          this.flvplayback_internal::_vc.playheadTime = nextCuePoint.time;
                                       }
                                    }
                                 }
                                 catch(err:Error)
                                 {
                                    break;
                                 }
                                 break;
                              }
                              percent += this.flvplayback_internal::_vc.seekBarScrubTolerance;
                              this.flvplayback_internal::_vc.playheadPercentage = Math.min(99,percent);
                              break;
                           }
                           if(k == Keyboard.PAGE_UP || k == Keyboard.HOME)
                           {
                              this.flvplayback_internal::_vc.playheadPercentage = 0;
                              break;
                           }
                           if(k == Keyboard.PAGE_DOWN || k == Keyboard.END)
                           {
                              this.flvplayback_internal::_vc.playheadPercentage = 99;
                              break;
                           }
                           break;
                        }
                        wasMuted = this.flvplayback_internal::_isMuted;
                        num = this.flvplayback_internal::_isMuted ? Math.round(this.flvplayback_internal::cachedSoundLevel * 1000) / 100 : Math.round(this.flvplayback_internal::_vc.volume * 1000) / 100;
                        if(k == Keyboard.LEFT || k == Keyboard.DOWN)
                        {
                           if(Math.floor(num) != num)
                           {
                              this.flvplayback_internal::_vc.volume = Math.floor(num) / 10;
                           }
                           else
                           {
                              this.flvplayback_internal::_vc.volume = Math.max(0,(num - 1) / 10);
                           }
                        }
                        else if(k == Keyboard.RIGHT || k == Keyboard.UP)
                        {
                           if(Math.round(num) != num)
                           {
                              this.flvplayback_internal::_vc.volume = Math.round(num) / 10;
                           }
                           else
                           {
                              this.flvplayback_internal::_vc.volume = Math.min(1,(num + 1) / 10);
                           }
                        }
                        else if(k == Keyboard.PAGE_UP || k == Keyboard.HOME)
                        {
                           this.flvplayback_internal::_vc.volume = 1;
                        }
                        else if(k == Keyboard.PAGE_DOWN || k == Keyboard.END)
                        {
                           this.flvplayback_internal::_vc.volume = 0;
                        }
                        else if(!isNaN(ka) && kaBool)
                        {
                           this.flvplayback_internal::_vc.volume = Math.min(1,(ka + 1) / 10);
                        }
                        this.flvplayback_internal::cachedSoundLevel = this.flvplayback_internal::_vc.volume;
                        if(wasMuted)
                        {
                           this.flvplayback_internal::_isMuted = true;
                           this.flvplayback_internal::cachedSoundLevel = this.flvplayback_internal::_vc.volume;
                           this.flvplayback_internal::_vc.volume = 0;
                           this.flvplayback_internal::setEnabledAndVisibleForState(MUTE_OFF_BUTTON,VideoState.PLAYING);
                           this.flvplayback_internal::skinButtonControl(this.flvplayback_internal::controls[MUTE_OFF_BUTTON]);
                           this.flvplayback_internal::setEnabledAndVisibleForState(MUTE_ON_BUTTON,VideoState.PLAYING);
                           this.flvplayback_internal::skinButtonControl(this.flvplayback_internal::controls[MUTE_ON_BUTTON]);
                           break;
                        }
                        break;
                     }
                     break;
                  case this.flvplayback_internal::controls[PAUSE_BUTTON]:
                     if(k == Keyboard.SPACE || k == Keyboard.ENTER)
                     {
                        ctrlData.state = DOWN_STATE;
                        if(!event.target.focusRect)
                        {
                           this.flvplayback_internal::dispatchMessage(ctrlData.index);
                        }
                        focusControl = this.flvplayback_internal::controls[PLAY_BUTTON] as InteractiveObject;
                        break;
                     }
                     break;
                  case this.flvplayback_internal::controls[PLAY_BUTTON]:
                     if(k == Keyboard.SPACE || k == Keyboard.ENTER)
                     {
                        ctrlData.state = DOWN_STATE;
                        if(!event.target.focusRect)
                        {
                           this.flvplayback_internal::dispatchMessage(ctrlData.index);
                        }
                        focusControl = this.flvplayback_internal::controls[PAUSE_BUTTON] as InteractiveObject;
                        break;
                     }
                     break;
                  case this.flvplayback_internal::controls[STOP_BUTTON]:
                  case this.flvplayback_internal::controls[BACK_BUTTON]:
                  case this.flvplayback_internal::controls[FORWARD_BUTTON]:
                     if(k == Keyboard.SPACE || k == Keyboard.ENTER)
                     {
                        ctrlData.state = DOWN_STATE;
                        event.target.tabEnabled = true;
                        if(!event.target.focusRect)
                        {
                           this.flvplayback_internal::dispatchMessage(ctrlData.index);
                        }
                        focusControl = event.target as InteractiveObject;
                        break;
                     }
                     break;
                  case this.flvplayback_internal::controls[MUTE_ON_BUTTON]:
                     if(k == Keyboard.SPACE || k == Keyboard.ENTER)
                     {
                        ctrlData.state = DOWN_STATE;
                        if(!event.target.focusRect)
                        {
                           this.flvplayback_internal::dispatchMessage(ctrlData.index);
                        }
                        focusControl = this.flvplayback_internal::controls[MUTE_OFF_BUTTON] as InteractiveObject;
                        break;
                     }
                     break;
                  case this.flvplayback_internal::controls[MUTE_OFF_BUTTON]:
                     if(k == Keyboard.SPACE || k == Keyboard.ENTER)
                     {
                        ctrlData.state = DOWN_STATE;
                        if(!event.target.focusRect)
                        {
                           this.flvplayback_internal::dispatchMessage(ctrlData.index);
                        }
                        focusControl = this.flvplayback_internal::controls[MUTE_ON_BUTTON] as InteractiveObject;
                        break;
                     }
                     break;
                  case this.flvplayback_internal::controls[FULL_SCREEN_ON_BUTTON]:
                     if(k == Keyboard.SPACE || k == Keyboard.ENTER)
                     {
                        ctrlData.state = DOWN_STATE;
                        this.flvplayback_internal::dispatchMessage(FULL_SCREEN_ON_BUTTON);
                        break;
                     }
                     break;
                  case this.flvplayback_internal::controls[FULL_SCREEN_OFF_BUTTON]:
                     if(k == Keyboard.SPACE || k == Keyboard.ENTER)
                     {
                        ctrlData.state = DOWN_STATE;
                        this.flvplayback_internal::dispatchMessage(FULL_SCREEN_OFF_BUTTON);
                        break;
                     }
               }
               this.flvplayback_internal::skinButtonControl(event.currentTarget);
               break;
            case KeyboardEvent.KEY_UP:
               switch(event.target)
               {
                  case this.flvplayback_internal::controls[SEEK_BAR_HANDLE]:
                  case this.flvplayback_internal::controls[VOLUME_BAR_HANDLE]:
                     if(k != Keyboard.TAB && (k == Keyboard.UP || k == Keyboard.DOWN || k == Keyboard.LEFT || k == Keyboard.RIGHT || k == Keyboard.PAGE_UP || k == Keyboard.PAGE_DOWN || k == Keyboard.HOME || k == Keyboard.END))
                     {
                        focusControl = event.target as InteractiveObject;
                        focusControl.stage.focus = focusControl;
                        break loop0;
                     }
                     break loop0;
                  default:
                     ctrlData.state = OVER_STATE;
               }
         }
         if(focusControl != null)
         {
            if(focusControl.visible)
            {
               ctrlData.state = NORMAL_STATE;
               if(!focusControl.tabEnabled)
               {
                  focusControl.tabEnabled = true;
               }
               focusControl.stage.focus = focusControl;
            }
            else
            {
               ctrl = event.currentTarget as Sprite;
               setFocusedControl = function(param1:Event):void
               {
                  if(param1.target.visible)
                  {
                     ctrlData.state = NORMAL_STATE;
                     if(!param1.target.tabEnabled)
                     {
                        param1.target.tabEnabled = true;
                     }
                     param1.target.stage.focus = param1.target;
                     param1.target.removeEventListener(Event.ENTER_FRAME,setFocusedControl);
                  }
               };
               focusControl.addEventListener(Event.ENTER_FRAME,setFocusedControl);
            }
         }
      }
      
      flvplayback_internal function handleFocusEvent(param1:FocusEvent) : void
      {
         var _loc2_:ControlData = this.ctrlDataDict[param1.currentTarget];
         if(_loc2_ == null)
         {
            return;
         }
         switch(param1.type)
         {
            case FocusEvent.FOCUS_IN:
               switch(param1.target)
               {
                  case this.flvplayback_internal::controls[SEEK_BAR_HANDLE]:
                  case this.flvplayback_internal::controls[VOLUME_BAR_HANDLE]:
                     param1.target.focusRect = false;
               }
               _loc2_.state = OVER_STATE;
               break;
            case FocusEvent.FOCUS_OUT:
               switch(param1.target)
               {
                  case this.flvplayback_internal::controls[SEEK_BAR_HANDLE]:
                  case this.flvplayback_internal::controls[VOLUME_BAR_HANDLE]:
                     param1.target.focusRect = true;
                     break;
                  case this.flvplayback_internal::controls[STOP_BUTTON]:
                     if(!_loc2_.enabled)
                     {
                        param1.target.tabEnabled = false;
                        break;
                     }
               }
               _loc2_.state = NORMAL_STATE;
         }
         this.flvplayback_internal::skinButtonControl(param1.currentTarget);
      }
      
      flvplayback_internal function assignTabIndexes(param1:int) : int
      {
         var sortByPosition:Function;
         var controlsSlice:Array = null;
         var customSlice:Array = null;
         var sortedControls:Array = null;
         var i:int = 0;
         var ctrl:Sprite = null;
         var startTabbing:int = param1;
         if(startTabbing)
         {
            this.flvplayback_internal::startTabIndex = startTabbing;
            this.flvplayback_internal::endTabIndex = this.flvplayback_internal::startTabIndex + 1;
         }
         else
         {
            if(!this.flvplayback_internal::_vc.tabIndex)
            {
               return this.flvplayback_internal::endTabIndex;
            }
            this.flvplayback_internal::startTabIndex = this.flvplayback_internal::_vc.tabIndex;
            this.flvplayback_internal::endTabIndex = this.flvplayback_internal::startTabIndex + 1;
         }
         sortByPosition = function(param1:DisplayObject, param2:DisplayObject):int
         {
            var _loc3_:Rectangle = param1.getBounds(flvplayback_internal::_vc);
            var _loc4_:Rectangle = param2.getBounds(flvplayback_internal::_vc);
            if(_loc3_.x > _loc4_.x)
            {
               return 1;
            }
            if(_loc3_.x < _loc4_.x)
            {
               return -1;
            }
            if(_loc3_.y > _loc4_.y)
            {
               return -1;
            }
            if(_loc3_.y < _loc4_.y)
            {
               return 1;
            }
            return 0;
         };
         try
         {
            controlsSlice = this.flvplayback_internal::controls.slice();
            if(Boolean(this.customClips) && this.customClips.length > 0)
            {
               customSlice = this.customClips.slice();
            }
            sortedControls = !customSlice ? controlsSlice : controlsSlice.concat(customSlice);
            sortedControls.sort(sortByPosition);
            while(i < sortedControls.length)
            {
               ctrl = sortedControls[i] as Sprite;
               ctrl.tabIndex = ++this.flvplayback_internal::endTabIndex;
               if(!ctrl.tabEnabled)
               {
                  ctrl.tabEnabled = false;
               }
               i++;
            }
         }
         catch(err:Error)
         {
         }
         return ++this.flvplayback_internal::endTabIndex;
      }
      
      flvplayback_internal function isFocusRectActive() : Boolean
      {
         var i:int = 0;
         var doc:DisplayObjectContainer = null;
         var child:DisplayObject = null;
         var classReference:Class = null;
         var c:* = undefined;
         var o:InteractiveObject = this.flvplayback_internal::_vc.parent;
         while(o)
         {
            if(o is DisplayObjectContainer)
            {
               doc = DisplayObjectContainer(o);
            }
            i = 0;
            for(; i < doc.numChildren; i++)
            {
               try
               {
                  child = doc.getChildAt(i) as DisplayObject;
                  classReference = getDefinitionByName("fl.core.UIComponent") as Class;
                  if(child != null && child != this.flvplayback_internal::_vc && child is classReference)
                  {
                     c = child as classReference;
                     if(c.focusManager.showFocusIndicator)
                     {
                        return false;
                     }
                     break;
                  }
               }
               catch(e:Error)
               {
                  continue;
               }
            }
            o = o.parent;
         }
         return true;
      }
      
      private function handleMouseFocusChangeEvent(param1:FocusEvent) : void
      {
         var index:int;
         var currentFocus:InteractiveObject;
         var focusControl:InteractiveObject;
         var ctrlData:ControlData = null;
         var focusCtrlData:ControlData = null;
         var ctrl:Sprite = null;
         var setFocusedControl:Function = null;
         var event:FocusEvent = param1;
         try
         {
            ctrlData = this.ctrlDataDict[event.relatedObject];
         }
         catch(error:ReferenceError)
         {
         }
         if(ctrlData == null)
         {
            return;
         }
         index = ctrlData.index;
         currentFocus = event.target.stage.focus as InteractiveObject;
         focusControl = null;
         switch(index)
         {
            case PLAY_BUTTON:
               focusControl = this.flvplayback_internal::controls[PAUSE_BUTTON] as InteractiveObject;
               break;
            case PAUSE_BUTTON:
               focusControl = this.flvplayback_internal::controls[PLAY_BUTTON] as InteractiveObject;
               break;
            case STOP_BUTTON:
            case BACK_BUTTON:
            case FORWARD_BUTTON:
            case SEEK_BAR_HANDLE:
            case VOLUME_BAR_HANDLE:
               focusControl = this.flvplayback_internal::controls[event.relatedObject] as InteractiveObject;
               break;
            case SEEK_BAR_HIT:
               focusControl = this.flvplayback_internal::controls[SEEK_BAR_HANDLE] as InteractiveObject;
               break;
            case VOLUME_BAR_HIT:
               focusControl = this.flvplayback_internal::controls[VOLUME_BAR_HANDLE] as InteractiveObject;
               break;
            case MUTE_ON_BUTTON:
               focusControl = this.flvplayback_internal::controls[MUTE_OFF_BUTTON] as InteractiveObject;
               break;
            case MUTE_OFF_BUTTON:
               focusControl = this.flvplayback_internal::controls[MUTE_ON_BUTTON] as InteractiveObject;
               break;
            case FULL_SCREEN_ON_BUTTON:
               focusControl = this.flvplayback_internal::controls[FULL_SCREEN_OFF_BUTTON] as InteractiveObject;
               break;
            case FULL_SCREEN_OFF_BUTTON:
               focusControl = this.flvplayback_internal::controls[FULL_SCREEN_ON_BUTTON] as InteractiveObject;
         }
         if(focusControl != null)
         {
            try
            {
               focusCtrlData = this.ctrlDataDict[focusControl];
               focusCtrlData.cachedFocusRect = focusControl.focusRect;
            }
            catch(error:ReferenceError)
            {
            }
            focusControl.focusRect = false;
            if(focusControl.visible)
            {
               focusControl.stage.focus = focusControl;
               focusControl.focusRect = focusCtrlData.cachedFocusRect;
            }
            else
            {
               ctrl = event.currentTarget as Sprite;
               setFocusedControl = function(param1:Event):void
               {
                  if(param1.target.visible)
                  {
                     param1.target.stage.focus = param1.target;
                     param1.target.focusRect = focusCtrlData.cachedFocusRect;
                     param1.target.removeEventListener(Event.ENTER_FRAME,setFocusedControl);
                  }
               };
               focusControl.addEventListener(Event.ENTER_FRAME,setFocusedControl);
            }
         }
      }
   }
}

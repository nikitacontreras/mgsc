package fl.video
{
   import flash.events.NetStatusEvent;
   import flash.events.TimerEvent;
   import flash.net.*;
   import flash.utils.Timer;
   
   public class NCManager implements INCManager
   {
      
      public static const VERSION:String = "2.1.0.23";
      
      public static const SHORT_VERSION:String = "2.1";
       
      
      flvplayback_internal var _owner:fl.video.VideoPlayer;
      
      flvplayback_internal var _contentPath:String;
      
      flvplayback_internal var _protocol:String;
      
      flvplayback_internal var _serverName:String;
      
      flvplayback_internal var _portNumber:String;
      
      flvplayback_internal var _wrappedURL:String;
      
      flvplayback_internal var _appName:String;
      
      flvplayback_internal var _streamName:String;
      
      flvplayback_internal var _streamLength:Number;
      
      flvplayback_internal var _streamWidth:int;
      
      flvplayback_internal var _streamHeight:int;
      
      flvplayback_internal var _streams:Array;
      
      flvplayback_internal var _isRTMP:Boolean;
      
      flvplayback_internal var _smilMgr:fl.video.SMILManager;
      
      flvplayback_internal var _fpadMgr:fl.video.FPADManager;
      
      flvplayback_internal var _fpadZone:Number;
      
      flvplayback_internal var _objectEncoding:uint;
      
      flvplayback_internal var _proxyType:String;
      
      flvplayback_internal var _bitrate:Number;
      
      public var fallbackServerName:String;
      
      flvplayback_internal var _timeoutTimer:Timer;
      
      public const DEFAULT_TIMEOUT:uint = 60000;
      
      flvplayback_internal var _payload:Number;
      
      flvplayback_internal var _autoSenseBW:Boolean;
      
      flvplayback_internal var _nc:NetConnection;
      
      flvplayback_internal var _ncUri:String;
      
      flvplayback_internal var _ncConnected:Boolean;
      
      flvplayback_internal var _tryNC:Array;
      
      flvplayback_internal var _tryNCTimer:Timer;
      
      flvplayback_internal var _connTypeCounter:uint;
      
      public function NCManager()
      {
         super();
         this.flvplayback_internal::_fpadZone = NaN;
         this.flvplayback_internal::_objectEncoding = ObjectEncoding.AMF0;
         this.flvplayback_internal::_proxyType = "best";
         this.flvplayback_internal::_timeoutTimer = new Timer(this.DEFAULT_TIMEOUT);
         this.flvplayback_internal::_timeoutTimer.addEventListener(TimerEvent.TIMER,this.flvplayback_internal::_onFMSConnectTimeOut);
         this.flvplayback_internal::_tryNCTimer = new Timer(1500,1);
         this.flvplayback_internal::_tryNCTimer.addEventListener(TimerEvent.TIMER,this.flvplayback_internal::nextConnect);
         this.flvplayback_internal::initNCInfo();
         this.flvplayback_internal::initOtherInfo();
         this.flvplayback_internal::_nc = null;
         this.flvplayback_internal::_ncConnected = false;
      }
      
      flvplayback_internal static function stripFrontAndBackWhiteSpace(param1:String) : String
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = uint(param1.length);
         var _loc4_:int = 0;
         var _loc5_:int = int(_loc3_);
         _loc2_ = 0;
         for(; _loc2_ < _loc3_; _loc2_++)
         {
            switch(param1.charCodeAt(_loc2_))
            {
               case 9:
               case 10:
               case 13:
               case 32:
                  continue;
               default:
                  _loc4_ = int(_loc2_);
            }
         }
         _loc2_ = _loc3_;
         for(; _loc2_ >= 0; _loc2_--)
         {
            switch(param1.charCodeAt(_loc2_))
            {
               case 9:
               case 10:
               case 13:
               case 32:
                  continue;
               default:
                  _loc5_ = _loc2_ + 1;
            }
         }
         if(_loc5_ <= _loc4_)
         {
            return "";
         }
         return param1.slice(_loc4_,_loc5_);
      }
      
      flvplayback_internal function initNCInfo() : void
      {
         this.flvplayback_internal::_isRTMP = false;
         this.flvplayback_internal::_serverName = null;
         this.flvplayback_internal::_wrappedURL = null;
         this.flvplayback_internal::_portNumber = null;
         this.flvplayback_internal::_appName = null;
      }
      
      flvplayback_internal function initOtherInfo() : void
      {
         this.flvplayback_internal::_contentPath = null;
         this.flvplayback_internal::_streamName = null;
         this.flvplayback_internal::_streamWidth = -1;
         this.flvplayback_internal::_streamHeight = -1;
         this.flvplayback_internal::_streamLength = NaN;
         this.flvplayback_internal::_streams = null;
         this.flvplayback_internal::_autoSenseBW = false;
         this.flvplayback_internal::_payload = 0;
         this.flvplayback_internal::_connTypeCounter = 0;
         this.flvplayback_internal::cleanConns();
      }
      
      public function get timeout() : uint
      {
         return this.flvplayback_internal::_timeoutTimer.delay;
      }
      
      public function set timeout(param1:uint) : void
      {
         this.flvplayback_internal::_timeoutTimer.delay = param1;
      }
      
      public function get bitrate() : Number
      {
         return this.flvplayback_internal::_bitrate;
      }
      
      public function set bitrate(param1:Number) : void
      {
         if(!this.flvplayback_internal::_isRTMP)
         {
            this.flvplayback_internal::_bitrate = param1;
         }
      }
      
      public function get videoPlayer() : fl.video.VideoPlayer
      {
         return this.flvplayback_internal::_owner;
      }
      
      public function set videoPlayer(param1:fl.video.VideoPlayer) : void
      {
         this.flvplayback_internal::_owner = param1;
      }
      
      public function get netConnection() : NetConnection
      {
         return this.flvplayback_internal::_nc;
      }
      
      public function get streamName() : String
      {
         return this.flvplayback_internal::_streamName;
      }
      
      public function get isRTMP() : Boolean
      {
         return this.flvplayback_internal::_isRTMP;
      }
      
      public function get streamLength() : Number
      {
         return this.flvplayback_internal::_streamLength;
      }
      
      public function get streamWidth() : int
      {
         return this.flvplayback_internal::_streamWidth;
      }
      
      public function get streamHeight() : int
      {
         return this.flvplayback_internal::_streamHeight;
      }
      
      public function getProperty(param1:String) : *
      {
         switch(param1)
         {
            case "fallbackServerName":
               return this.fallbackServerName;
            case "fpadZone":
               return this.flvplayback_internal::_fpadZone;
            case "objectEncoding":
               return this.flvplayback_internal::_objectEncoding;
            case "proxyType":
               return this.flvplayback_internal::_proxyType;
            default:
               throw new VideoError(VideoError.UNSUPPORTED_PROPERTY,param1);
         }
      }
      
      public function setProperty(param1:String, param2:*) : void
      {
         switch(param1)
         {
            case "fallbackServerName":
               this.fallbackServerName = String(param2);
               break;
            case "fpadZone":
               this.flvplayback_internal::_fpadZone = Number(param2);
               break;
            case "objectEncoding":
               this.flvplayback_internal::_objectEncoding = uint(param2);
               break;
            case "proxyType":
               this.flvplayback_internal::_proxyType = String(param2);
               break;
            default:
               throw new VideoError(VideoError.UNSUPPORTED_PROPERTY,param1);
         }
      }
      
      public function connectToURL(param1:String) : Boolean
      {
         var parseResults:ParseResults;
         var canReuse:Boolean = false;
         var name:String = null;
         var url:String = param1;
         this.flvplayback_internal::initOtherInfo();
         this.flvplayback_internal::_contentPath = url;
         if(this.flvplayback_internal::_contentPath == null || this.flvplayback_internal::_contentPath == "")
         {
            throw new VideoError(VideoError.INVALID_SOURCE);
         }
         parseResults = this.flvplayback_internal::parseURL(this.flvplayback_internal::_contentPath);
         if(parseResults.streamName == null || parseResults.streamName == "")
         {
            throw new VideoError(VideoError.INVALID_SOURCE,url);
         }
         if(parseResults.isRTMP)
         {
            canReuse = this.flvplayback_internal::canReuseOldConnection(parseResults);
            this.flvplayback_internal::_isRTMP = true;
            this.flvplayback_internal::_protocol = parseResults.protocol;
            this.flvplayback_internal::_streamName = parseResults.streamName;
            this.flvplayback_internal::_serverName = parseResults.serverName;
            this.flvplayback_internal::_wrappedURL = parseResults.wrappedURL;
            this.flvplayback_internal::_portNumber = parseResults.portNumber;
            this.flvplayback_internal::_appName = parseResults.appName;
            if(this.flvplayback_internal::_appName == null || this.flvplayback_internal::_appName == "" || this.flvplayback_internal::_streamName == null || this.flvplayback_internal::_streamName == "")
            {
               throw new VideoError(VideoError.INVALID_SOURCE,url);
            }
            this.flvplayback_internal::_autoSenseBW = this.flvplayback_internal::_streamName.indexOf(",") >= 0;
            return canReuse || this.flvplayback_internal::connectRTMP();
         }
         name = parseResults.streamName;
         if(name.indexOf("?") < 0 && (name.length < 4 || name.slice(-4).toLowerCase() != ".txt") && (name.length < 4 || name.slice(-4).toLowerCase() != ".xml") && (name.length < 5 || name.slice(-5).toLowerCase() != ".smil"))
         {
            canReuse = this.flvplayback_internal::canReuseOldConnection(parseResults);
            this.flvplayback_internal::_isRTMP = false;
            this.flvplayback_internal::_streamName = name;
            return canReuse || this.flvplayback_internal::connectHTTP();
         }
         if(name.indexOf("/fms/fpad") >= 0)
         {
            try
            {
               return this.flvplayback_internal::connectFPAD(name);
            }
            catch(err:Error)
            {
            }
         }
         this.flvplayback_internal::_smilMgr = new fl.video.SMILManager(this);
         return this.flvplayback_internal::_smilMgr.flvplayback_internal::connectXML(name);
      }
      
      public function connectAgain() : Boolean
      {
         var _loc1_:int = this.flvplayback_internal::_appName.indexOf("/");
         if(_loc1_ < 0)
         {
            _loc1_ = this.flvplayback_internal::_streamName.indexOf("/");
            if(_loc1_ >= 0)
            {
               this.flvplayback_internal::_appName += "/";
               this.flvplayback_internal::_appName += this.flvplayback_internal::_streamName.slice(0,_loc1_);
               this.flvplayback_internal::_streamName = this.flvplayback_internal::_streamName.slice(_loc1_ + 1);
            }
            return false;
         }
         var _loc2_:* = this.flvplayback_internal::_appName.slice(_loc1_ + 1);
         _loc2_ += "/";
         _loc2_ += this.flvplayback_internal::_streamName;
         this.flvplayback_internal::_streamName = _loc2_;
         this.flvplayback_internal::_appName = this.flvplayback_internal::_appName.slice(0,_loc1_);
         this.close();
         this.flvplayback_internal::_payload = 0;
         this.flvplayback_internal::_connTypeCounter = 0;
         this.flvplayback_internal::cleanConns();
         this.flvplayback_internal::connectRTMP();
         return true;
      }
      
      public function reconnect() : void
      {
         if(!this.flvplayback_internal::_isRTMP)
         {
            throw new Error("Cannot call reconnect on an http connection");
         }
         this.flvplayback_internal::_nc.client = new ReconnectClient(this);
         this.flvplayback_internal::_nc.addEventListener(NetStatusEvent.NET_STATUS,this.flvplayback_internal::reconnectOnStatus);
         this.flvplayback_internal::_nc.connect(this.flvplayback_internal::_ncUri,false);
      }
      
      flvplayback_internal function onReconnected() : void
      {
         this.flvplayback_internal::_ncConnected = true;
         this.flvplayback_internal::_owner.ncReconnected();
      }
      
      public function close() : void
      {
         if(this.flvplayback_internal::_nc)
         {
            this.flvplayback_internal::_nc.close();
            this.flvplayback_internal::_ncConnected = false;
         }
      }
      
      public function helperDone(param1:Object, param2:Boolean) : void
      {
         var _loc3_:ParseResults = null;
         var _loc4_:* = null;
         var _loc7_:Number = NaN;
         if(!param2)
         {
            this.flvplayback_internal::_nc = null;
            this.flvplayback_internal::_ncConnected = false;
            this.flvplayback_internal::_owner.ncConnected();
            this.flvplayback_internal::_smilMgr = null;
            this.flvplayback_internal::_fpadMgr = null;
            return;
         }
         var _loc5_:Boolean = false;
         if(param1 == this.flvplayback_internal::_fpadMgr)
         {
            _loc4_ = this.flvplayback_internal::_fpadMgr.flvplayback_internal::rtmpURL;
            this.flvplayback_internal::_fpadMgr = null;
            _loc3_ = this.flvplayback_internal::parseURL(_loc4_);
            this.flvplayback_internal::_isRTMP = _loc3_.isRTMP;
            this.flvplayback_internal::_protocol = _loc3_.protocol;
            this.flvplayback_internal::_serverName = _loc3_.serverName;
            this.flvplayback_internal::_portNumber = _loc3_.portNumber;
            this.flvplayback_internal::_wrappedURL = _loc3_.wrappedURL;
            this.flvplayback_internal::_appName = _loc3_.appName;
            this.flvplayback_internal::_streamName = _loc3_.streamName;
            _loc7_ = this.flvplayback_internal::_fpadZone;
            this.flvplayback_internal::_fpadZone = NaN;
            this.flvplayback_internal::connectRTMP();
            this.flvplayback_internal::_fpadZone = _loc7_;
            return;
         }
         if(param1 != this.flvplayback_internal::_smilMgr)
         {
            return;
         }
         this.flvplayback_internal::_streamWidth = this.flvplayback_internal::_smilMgr.flvplayback_internal::width;
         this.flvplayback_internal::_streamHeight = this.flvplayback_internal::_smilMgr.flvplayback_internal::height;
         if((_loc4_ = String(this.flvplayback_internal::_smilMgr.flvplayback_internal::baseURLAttr[0])) != null && _loc4_ != "")
         {
            if(_loc4_.charAt(_loc4_.length - 1) != "/")
            {
               _loc4_ += "/";
            }
            _loc3_ = this.flvplayback_internal::parseURL(_loc4_);
            this.flvplayback_internal::_isRTMP = _loc3_.isRTMP;
            _loc5_ = true;
            this.flvplayback_internal::_streamName = _loc3_.streamName;
            if(this.flvplayback_internal::_isRTMP)
            {
               this.flvplayback_internal::_protocol = _loc3_.protocol;
               this.flvplayback_internal::_serverName = _loc3_.serverName;
               this.flvplayback_internal::_portNumber = _loc3_.portNumber;
               this.flvplayback_internal::_wrappedURL = _loc3_.wrappedURL;
               this.flvplayback_internal::_appName = _loc3_.appName;
               if(this.flvplayback_internal::_appName == null || this.flvplayback_internal::_appName == "")
               {
                  this.flvplayback_internal::_smilMgr = null;
                  throw new VideoError(VideoError.INVALID_XML,"Base RTMP URL must include application name: " + _loc4_);
               }
               if(this.flvplayback_internal::_smilMgr.flvplayback_internal::baseURLAttr.length > 1)
               {
                  _loc3_ = this.flvplayback_internal::parseURL(this.flvplayback_internal::_smilMgr.flvplayback_internal::baseURLAttr[1]);
                  if(_loc3_.serverName != null)
                  {
                     this.fallbackServerName = _loc3_.serverName;
                  }
               }
            }
         }
         this.flvplayback_internal::_streams = this.flvplayback_internal::_smilMgr.flvplayback_internal::videoTags;
         this.flvplayback_internal::_smilMgr = null;
         var _loc6_:uint = 0;
         while(_loc6_ < this.flvplayback_internal::_streams.length)
         {
            _loc4_ = String(this.flvplayback_internal::_streams[_loc6_].src);
            _loc3_ = this.flvplayback_internal::parseURL(_loc4_);
            if(!_loc5_)
            {
               this.flvplayback_internal::_isRTMP = _loc3_.isRTMP;
               _loc5_ = true;
               if(this.flvplayback_internal::_isRTMP)
               {
                  this.flvplayback_internal::_protocol = _loc3_.protocol;
                  if(this.flvplayback_internal::_streams.length > 1)
                  {
                     throw new VideoError(VideoError.INVALID_XML,"Cannot switch between multiple absolute RTMP URLs, must use meta tag base attribute.");
                  }
                  this.flvplayback_internal::_serverName = _loc3_.serverName;
                  this.flvplayback_internal::_portNumber = _loc3_.portNumber;
                  this.flvplayback_internal::_wrappedURL = _loc3_.wrappedURL;
                  this.flvplayback_internal::_appName = _loc3_.appName;
                  if(this.flvplayback_internal::_appName == null || this.flvplayback_internal::_appName == "")
                  {
                     throw new VideoError(VideoError.INVALID_XML,"Base RTMP URL must include application name: " + _loc4_);
                  }
               }
               else if(_loc3_.streamName.indexOf("/fms/fpad") >= 0 && this.flvplayback_internal::_streams.length > 1)
               {
                  throw new VideoError(VideoError.INVALID_XML,"Cannot switch between multiple absolute fpad URLs, must use meta tag base attribute.");
               }
            }
            else if(this.flvplayback_internal::_streamName != null && this.flvplayback_internal::_streamName != "" && !_loc3_.isRelative && this.flvplayback_internal::_streams.length > 1)
            {
               throw new VideoError(VideoError.INVALID_XML,"When using meta tag base attribute, cannot use absolute URLs for video or ref tag src attributes.");
            }
            this.flvplayback_internal::_streams[_loc6_].parseResults = _loc3_;
            _loc6_++;
         }
         this.flvplayback_internal::_autoSenseBW = this.flvplayback_internal::_streams.length > 1;
         if(!this.flvplayback_internal::_autoSenseBW)
         {
            if(this.flvplayback_internal::_streamName != null)
            {
               this.flvplayback_internal::_streamName += this.flvplayback_internal::_streams[0].parseResults.streamName;
            }
            else
            {
               this.flvplayback_internal::_streamName = this.flvplayback_internal::_streams[0].parseResults.streamName;
            }
            if(this.flvplayback_internal::_isRTMP && this.flvplayback_internal::_streamName.substr(-4).toLowerCase() == ".flv")
            {
               this.flvplayback_internal::_streamName = this.flvplayback_internal::_streamName.substr(0,this.flvplayback_internal::_streamName.length - 4);
            }
            this.flvplayback_internal::_streamLength = this.flvplayback_internal::_streams[0].dur;
         }
         if(this.flvplayback_internal::_isRTMP)
         {
            this.flvplayback_internal::connectRTMP();
         }
         else if(this.flvplayback_internal::_streamName != null && this.flvplayback_internal::_streamName.indexOf("/fms/fpad") >= 0)
         {
            this.flvplayback_internal::connectFPAD(this.flvplayback_internal::_streamName);
         }
         else
         {
            if(this.flvplayback_internal::_autoSenseBW)
            {
               this.flvplayback_internal::bitrateMatch();
            }
            this.flvplayback_internal::connectHTTP();
            this.flvplayback_internal::_owner.ncConnected();
         }
      }
      
      flvplayback_internal function bitrateMatch() : void
      {
         var _loc1_:Number = this.flvplayback_internal::_bitrate;
         if(isNaN(_loc1_))
         {
            _loc1_ = 0;
         }
         var _loc2_:uint = this.flvplayback_internal::_streams.length;
         var _loc3_:uint = 0;
         while(_loc3_ < this.flvplayback_internal::_streams.length)
         {
            if(isNaN(this.flvplayback_internal::_streams[_loc3_].bitrate) || _loc1_ >= this.flvplayback_internal::_streams[_loc3_].bitrate)
            {
               _loc2_ = _loc3_;
               break;
            }
            _loc3_++;
         }
         if(_loc2_ == this.flvplayback_internal::_streams.length)
         {
            throw new VideoError(VideoError.NO_BITRATE_MATCH);
         }
         if(this.flvplayback_internal::_streamName != null)
         {
            this.flvplayback_internal::_streamName += this.flvplayback_internal::_streams[_loc2_].src;
         }
         else
         {
            this.flvplayback_internal::_streamName = this.flvplayback_internal::_streams[_loc2_].src;
         }
         if(this.flvplayback_internal::_isRTMP && this.flvplayback_internal::_streamName.substr(-4).toLowerCase() == ".flv")
         {
            this.flvplayback_internal::_streamName = this.flvplayback_internal::_streamName.substr(0,this.flvplayback_internal::_streamName.length - 4);
         }
         this.flvplayback_internal::_streamLength = this.flvplayback_internal::_streams[_loc2_].dur;
      }
      
      flvplayback_internal function parseURL(param1:String) : ParseResults
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:ParseResults = null;
         var _loc2_:ParseResults = new ParseResults();
         var _loc3_:int = 0;
         var _loc4_:int;
         if((_loc4_ = param1.indexOf(":/",_loc3_)) >= 0)
         {
            _loc4_ += 2;
            _loc2_.protocol = param1.slice(_loc3_,_loc4_).toLowerCase();
            _loc2_.isRelative = false;
         }
         else
         {
            _loc2_.isRelative = true;
         }
         if(_loc2_.protocol != null && (_loc2_.protocol == "rtmp:/" || _loc2_.protocol == "rtmpt:/" || _loc2_.protocol == "rtmps:/" || _loc2_.protocol == "rtmpe:/" || _loc2_.protocol == "rtmpte:/"))
         {
            _loc2_.isRTMP = true;
            _loc3_ = _loc4_;
            if(param1.charAt(_loc3_) == "/")
            {
               _loc3_++;
               _loc5_ = param1.indexOf(":",_loc3_);
               if((_loc6_ = param1.indexOf("/",_loc3_)) < 0)
               {
                  if(_loc5_ < 0)
                  {
                     _loc2_.serverName = param1.slice(_loc3_);
                  }
                  else
                  {
                     _loc4_ = _loc5_;
                     _loc2_.portNumber = param1.slice(_loc3_,_loc4_);
                     _loc3_ = _loc4_ + 1;
                     _loc2_.serverName = param1.slice(_loc3_);
                  }
                  return _loc2_;
               }
               if(_loc5_ >= 0 && _loc5_ < _loc6_)
               {
                  _loc4_ = _loc5_;
                  _loc2_.serverName = param1.slice(_loc3_,_loc4_);
                  _loc3_ = _loc4_ + 1;
                  _loc4_ = _loc6_;
                  _loc2_.portNumber = param1.slice(_loc3_,_loc4_);
               }
               else
               {
                  _loc4_ = _loc6_;
                  _loc2_.serverName = param1.slice(_loc3_,_loc4_);
               }
               _loc3_ = _loc4_ + 1;
            }
            if(param1.charAt(_loc3_) == "?")
            {
               _loc7_ = param1.slice(_loc3_ + 1);
               if((_loc8_ = this.flvplayback_internal::parseURL(_loc7_)).protocol == null || !_loc8_.isRTMP)
               {
                  throw new VideoError(VideoError.INVALID_SOURCE,param1);
               }
               _loc2_.wrappedURL = "?";
               _loc2_.wrappedURL += _loc8_.protocol;
               if(_loc8_.serverName != null)
               {
                  _loc2_.wrappedURL += "/";
                  _loc2_.wrappedURL += _loc8_.serverName;
               }
               if(_loc8_.portNumber != null)
               {
                  _loc2_.wrappedURL += ":" + _loc8_.portNumber;
               }
               if(_loc8_.wrappedURL != null)
               {
                  _loc2_.wrappedURL += "/";
                  _loc2_.wrappedURL += _loc8_.wrappedURL;
               }
               _loc2_.appName = _loc8_.appName;
               _loc2_.streamName = _loc8_.streamName;
               return _loc2_;
            }
            if((_loc4_ = param1.indexOf("/",_loc3_)) < 0)
            {
               _loc2_.appName = param1.slice(_loc3_);
               return _loc2_;
            }
            _loc2_.appName = param1.slice(_loc3_,_loc4_);
            _loc3_ = _loc4_ + 1;
            if((_loc4_ = param1.indexOf("/",_loc3_)) < 0)
            {
               _loc2_.streamName = param1.slice(_loc3_);
               if(_loc2_.streamName.slice(-4).toLowerCase() == ".flv")
               {
                  _loc2_.streamName = _loc2_.streamName.slice(0,-4);
               }
               return _loc2_;
            }
            _loc2_.appName += "/";
            _loc2_.appName += param1.slice(_loc3_,_loc4_);
            _loc3_ = _loc4_ + 1;
            _loc2_.streamName = param1.slice(_loc3_);
            if(_loc2_.streamName.slice(-4).toLowerCase() == ".flv")
            {
               _loc2_.streamName = _loc2_.streamName.slice(0,-4);
            }
         }
         else
         {
            _loc2_.isRTMP = false;
            _loc2_.streamName = param1;
         }
         return _loc2_;
      }
      
      flvplayback_internal function canReuseOldConnection(param1:ParseResults) : Boolean
      {
         if(this.flvplayback_internal::_nc == null || !this.flvplayback_internal::_ncConnected)
         {
            return false;
         }
         if(!param1.isRTMP)
         {
            if(!this.flvplayback_internal::_isRTMP)
            {
               return true;
            }
            this.flvplayback_internal::_owner.close();
            this.flvplayback_internal::_nc = null;
            this.flvplayback_internal::_ncConnected = false;
            this.flvplayback_internal::initNCInfo();
            return false;
         }
         if(this.flvplayback_internal::_isRTMP)
         {
            if(param1.serverName == this.flvplayback_internal::_serverName && param1.appName == this.flvplayback_internal::_appName && param1.protocol == this.flvplayback_internal::_protocol && param1.portNumber == this.flvplayback_internal::_portNumber && param1.wrappedURL == this.flvplayback_internal::_wrappedURL)
            {
               return true;
            }
            this.flvplayback_internal::_owner.close();
            this.flvplayback_internal::_nc = null;
            this.flvplayback_internal::_ncConnected = false;
         }
         this.flvplayback_internal::initNCInfo();
         return false;
      }
      
      flvplayback_internal function connectHTTP() : Boolean
      {
         this.flvplayback_internal::_nc = new NetConnection();
         this.flvplayback_internal::_nc.connect(null);
         this.flvplayback_internal::_ncConnected = true;
         return true;
      }
      
      flvplayback_internal function connectRTMP() : Boolean
      {
         this.flvplayback_internal::_timeoutTimer.stop();
         this.flvplayback_internal::_timeoutTimer.start();
         this.flvplayback_internal::_tryNC = new Array();
         var _loc1_:int = this.flvplayback_internal::_protocol == "rtmp:/" || this.flvplayback_internal::_protocol == "rtmpe:/" ? 2 : 1;
         var _loc2_:uint = 0;
         while(_loc2_ < _loc1_)
         {
            this.flvplayback_internal::_tryNC[_loc2_] = new NetConnection();
            this.flvplayback_internal::_tryNC[_loc2_].objectEncoding = this.flvplayback_internal::_objectEncoding;
            this.flvplayback_internal::_tryNC[_loc2_].proxyType = this.flvplayback_internal::_proxyType;
            if(!isNaN(this.flvplayback_internal::_fpadZone))
            {
               this.flvplayback_internal::_tryNC[_loc2_].fpadZone = this.flvplayback_internal::_fpadZone;
            }
            this.flvplayback_internal::_tryNC[_loc2_].client = new ConnectClient(this,this.flvplayback_internal::_tryNC[_loc2_],_loc2_);
            this.flvplayback_internal::_tryNC[_loc2_].addEventListener(NetStatusEvent.NET_STATUS,this.flvplayback_internal::connectOnStatus);
            _loc2_++;
         }
         this.flvplayback_internal::nextConnect();
         return false;
      }
      
      flvplayback_internal function connectFPAD(param1:String) : Boolean
      {
         var _loc2_:Object = /^(.+)(\?|\&)(uri=)([^&]+)(\&.*)?$/.exec(param1);
         if(_loc2_ == null)
         {
            throw new VideoError(VideoError.INVALID_SOURCE,"fpad url must include uri parameter: " + param1);
         }
         var _loc3_:String = String(_loc2_[1] + _loc2_[2]);
         var _loc4_:String = String(_loc2_[4]);
         var _loc5_:String = _loc2_[5] == undefined ? "" : String(_loc2_[5]);
         var _loc6_:ParseResults;
         if(!(_loc6_ = this.flvplayback_internal::parseURL(_loc4_)).isRTMP)
         {
            throw new VideoError(VideoError.INVALID_SOURCE,"fpad url uri parameter must be rtmp url: " + param1);
         }
         this.flvplayback_internal::_fpadMgr = new fl.video.FPADManager(this);
         return this.flvplayback_internal::_fpadMgr.flvplayback_internal::connectXML(_loc3_,_loc4_,_loc5_,_loc6_);
      }
      
      flvplayback_internal function nextConnect(param1:TimerEvent = null) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         if(this.flvplayback_internal::_connTypeCounter == 0)
         {
            _loc2_ = this.flvplayback_internal::_protocol;
            _loc3_ = this.flvplayback_internal::_portNumber;
         }
         else
         {
            _loc3_ = null;
            if(this.flvplayback_internal::_protocol == "rtmp:/")
            {
               _loc2_ = "rtmpt:/";
            }
            else
            {
               if(this.flvplayback_internal::_protocol != "rtmpe:/")
               {
                  this.flvplayback_internal::_tryNC.pop();
                  return;
               }
               _loc2_ = "rtmpte:/";
            }
         }
         var _loc4_:String = _loc2_ + (this.flvplayback_internal::_serverName == null ? "" : "/" + this.flvplayback_internal::_serverName + (_loc3_ == null ? "" : ":" + _loc3_) + "/") + (this.flvplayback_internal::_wrappedURL == null ? "" : this.flvplayback_internal::_wrappedURL + "/") + this.flvplayback_internal::_appName;
         this.flvplayback_internal::_tryNC[this.flvplayback_internal::_connTypeCounter].client.pending = true;
         this.flvplayback_internal::_tryNC[this.flvplayback_internal::_connTypeCounter].connect(_loc4_,this.flvplayback_internal::_autoSenseBW);
         if(this.flvplayback_internal::_connTypeCounter < this.flvplayback_internal::_tryNC.length - 1)
         {
            ++this.flvplayback_internal::_connTypeCounter;
            this.flvplayback_internal::_tryNCTimer.reset();
            this.flvplayback_internal::_tryNCTimer.start();
         }
      }
      
      flvplayback_internal function cleanConns() : void
      {
         var _loc1_:uint = 0;
         this.flvplayback_internal::_tryNCTimer.reset();
         if(this.flvplayback_internal::_tryNC != null)
         {
            _loc1_ = 0;
            while(_loc1_ < this.flvplayback_internal::_tryNC.length)
            {
               if(this.flvplayback_internal::_tryNC[_loc1_] != null)
               {
                  this.flvplayback_internal::_tryNC[_loc1_].removeEventListener(NetStatusEvent.NET_STATUS,this.flvplayback_internal::connectOnStatus);
                  if(this.flvplayback_internal::_tryNC[_loc1_].client.pending)
                  {
                     this.flvplayback_internal::_tryNC[_loc1_].addEventListener(NetStatusEvent.NET_STATUS,this.flvplayback_internal::disconnectOnStatus);
                  }
                  else
                  {
                     this.flvplayback_internal::_tryNC[_loc1_].close();
                  }
               }
               this.flvplayback_internal::_tryNC[_loc1_] = null;
               _loc1_++;
            }
            this.flvplayback_internal::_tryNC = null;
         }
      }
      
      flvplayback_internal function tryFallBack() : void
      {
         if(this.flvplayback_internal::_serverName == this.fallbackServerName || this.fallbackServerName == null)
         {
            this.flvplayback_internal::_nc = null;
            this.flvplayback_internal::_ncConnected = false;
            this.flvplayback_internal::_owner.ncConnected();
         }
         else
         {
            this.flvplayback_internal::_connTypeCounter = 0;
            this.flvplayback_internal::cleanConns();
            this.flvplayback_internal::_serverName = this.fallbackServerName;
            this.flvplayback_internal::connectRTMP();
         }
      }
      
      flvplayback_internal function onConnected(param1:NetConnection, param2:Number) : void
      {
         var _loc3_:Array = null;
         var _loc4_:uint = 0;
         var _loc5_:String = null;
         this.flvplayback_internal::_timeoutTimer.stop();
         param1.removeEventListener(NetStatusEvent.NET_STATUS,this.flvplayback_internal::connectOnStatus);
         this.flvplayback_internal::_nc = param1;
         this.flvplayback_internal::_ncUri = this.flvplayback_internal::_nc.uri;
         this.flvplayback_internal::_ncConnected = true;
         if(this.flvplayback_internal::_autoSenseBW)
         {
            this.flvplayback_internal::_bitrate = param2 * 1024;
            if(this.flvplayback_internal::_streams != null)
            {
               this.flvplayback_internal::bitrateMatch();
            }
            else
            {
               _loc3_ = this.flvplayback_internal::_streamName.split(",");
               _loc4_ = 0;
               while(_loc4_ < _loc3_.length)
               {
                  _loc5_ = flvplayback_internal::stripFrontAndBackWhiteSpace(_loc3_[_loc4_]);
                  if(_loc4_ + 1 >= _loc3_.length)
                  {
                     this.flvplayback_internal::_streamName = _loc5_;
                     break;
                  }
                  if(param2 <= Number(_loc3_[_loc4_ + 1]))
                  {
                     this.flvplayback_internal::_streamName = _loc5_;
                     break;
                  }
                  _loc4_ += 2;
               }
               if(this.flvplayback_internal::_streamName.slice(-4).toLowerCase() == ".flv")
               {
                  this.flvplayback_internal::_streamName = this.flvplayback_internal::_streamName.slice(0,-4);
               }
            }
         }
         if(!this.flvplayback_internal::_owner.isLive && isNaN(this.flvplayback_internal::_streamLength))
         {
            this.flvplayback_internal::_nc.call("getStreamLength",new Responder(this.flvplayback_internal::getStreamLengthResult),this.flvplayback_internal::_streamName);
         }
         else
         {
            this.flvplayback_internal::_owner.ncConnected();
         }
      }
      
      flvplayback_internal function connectOnStatus(param1:NetStatusEvent) : void
      {
         var _loc2_:ParseResults = null;
         param1.target.client.pending = false;
         if(param1.info.code == "NetConnection.Connect.Success")
         {
            this.flvplayback_internal::_nc = this.flvplayback_internal::_tryNC[param1.target.client.connIndex];
            this.flvplayback_internal::cleanConns();
         }
         else if(param1.info.code == "NetConnection.Connect.Rejected" && param1.info.ex != null && param1.info.ex.code == 302)
         {
            this.flvplayback_internal::_connTypeCounter = 0;
            this.flvplayback_internal::cleanConns();
            _loc2_ = this.flvplayback_internal::parseURL(param1.info.ex.redirect);
            if(_loc2_.isRTMP)
            {
               this.flvplayback_internal::_protocol = _loc2_.protocol;
               this.flvplayback_internal::_serverName = _loc2_.serverName;
               this.flvplayback_internal::_wrappedURL = _loc2_.wrappedURL;
               this.flvplayback_internal::_portNumber = _loc2_.portNumber;
               this.flvplayback_internal::_appName = _loc2_.appName;
               if(_loc2_.streamName != null)
               {
                  this.flvplayback_internal::_appName += "/" + _loc2_.streamName;
               }
               this.flvplayback_internal::connectRTMP();
            }
            else
            {
               this.flvplayback_internal::tryFallBack();
            }
         }
         else if((param1.info.code == "NetConnection.Connect.Failed" || param1.info.code == "NetConnection.Connect.Rejected") && param1.target.client.connIndex == this.flvplayback_internal::_tryNC.length - 1)
         {
            if(!this.connectAgain())
            {
               this.flvplayback_internal::tryFallBack();
            }
         }
      }
      
      flvplayback_internal function reconnectOnStatus(param1:NetStatusEvent) : void
      {
         if(param1.info.code == "NetConnection.Connect.Failed" || param1.info.code == "NetConnection.Connect.Rejected")
         {
            this.flvplayback_internal::_nc = null;
            this.flvplayback_internal::_ncConnected = false;
            this.flvplayback_internal::_owner.ncReconnected();
         }
      }
      
      flvplayback_internal function disconnectOnStatus(param1:NetStatusEvent) : void
      {
         if(param1.info.code == "NetConnection.Connect.Success")
         {
            param1.target.removeEventListener(NetStatusEvent.NET_STATUS,this.flvplayback_internal::disconnectOnStatus);
            param1.target.close();
         }
      }
      
      flvplayback_internal function getStreamLengthResult(param1:Number) : void
      {
         if(param1 > 0)
         {
            this.flvplayback_internal::_streamLength = param1;
         }
         this.flvplayback_internal::_owner.ncConnected();
      }
      
      flvplayback_internal function _onFMSConnectTimeOut(param1:TimerEvent = null) : void
      {
         this.flvplayback_internal::cleanConns();
         this.flvplayback_internal::_nc = null;
         this.flvplayback_internal::_ncConnected = false;
         if(!this.connectAgain())
         {
            this.flvplayback_internal::_owner.ncConnected();
         }
      }
   }
}

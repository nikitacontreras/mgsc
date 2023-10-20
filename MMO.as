package
{
   import assets.Overlay;
   import com.adobe.serialization.json.JSON;
   import com.gameanalytics.constants.GAErrorSeverity;
   import com.qb9.flashlib.config.Settings;
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.flashlib.logs.*;
   import com.qb9.flashlib.net.LoadFile;
   import com.qb9.flashlib.net.LoadFileFormat;
   import com.qb9.flashlib.net.LoadFileParsers;
   import com.qb9.flashlib.tasks.Func;
   import com.qb9.flashlib.tasks.Parallel;
   import com.qb9.flashlib.tasks.Sequence;
   import com.qb9.flashlib.tasks.TaskEvent;
   import com.qb9.flashlib.utils.ArrayUtil;
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.flashlib.utils.ObjectUtil;
   import com.qb9.gaturro.GameData;
   import com.qb9.gaturro.audio.GaturroAudioPlayer;
   import com.qb9.gaturro.commons.preloading.task.setup.SetupPreloadingTask;
   import com.qb9.gaturro.globals.*;
   import com.qb9.gaturro.language.RegionEngine;
   import com.qb9.gaturro.logs.ErrorDisplayAppender;
   import com.qb9.gaturro.logs.ErrorHandlerAppender;
   import com.qb9.gaturro.net.GaturroNetResponses;
   import com.qb9.gaturro.net.SimulatedGaturroNetworkManager;
   import com.qb9.gaturro.net.load.GaturroLoadFile;
   import com.qb9.gaturro.net.metrics.Telemetry;
   import com.qb9.gaturro.net.metrics.TelemetryConfig;
   import com.qb9.gaturro.net.metrics.TrackActions;
   import com.qb9.gaturro.net.metrics.TrackAreas;
   import com.qb9.gaturro.net.metrics.TrackCategories;
   import com.qb9.gaturro.net.metrics.TrackErrors;
   import com.qb9.gaturro.net.requests.URLUtil;
   import com.qb9.gaturro.net.requests.antihack.BlackListDataRequest;
   import com.qb9.gaturro.net.security.files.FileControl;
   import com.qb9.gaturro.net.security.files.FileControlEvent;
   import com.qb9.gaturro.net.tracker.GaturroTracker;
   import com.qb9.gaturro.tutorial.TutorialManager;
   import com.qb9.gaturro.user.GaturroUser;
   import com.qb9.gaturro.util.ConfigSecurity;
   import com.qb9.gaturro.util.StageData;
   import com.qb9.gaturro.util.errors.AlreadyLogged;
   import com.qb9.gaturro.util.errors.ConnectionFailed;
   import com.qb9.gaturro.util.errors.ConnectionInactivity;
   import com.qb9.gaturro.util.errors.ConnectionLost;
   import com.qb9.gaturro.util.errors.ConnectionTimeout;
   import com.qb9.gaturro.util.errors.FileControlFailure;
   import com.qb9.gaturro.util.errors.IncompatibleBrowser;
   import com.qb9.gaturro.util.errors.InvalidCredentials;
   import com.qb9.gaturro.util.errors.PhpErrorLog;
   import com.qb9.gaturro.util.errors.ServerFull;
   import com.qb9.gaturro.util.errors.SessionExpiredError;
   import com.qb9.gaturro.util.errors.UnknownLoginError;
   import com.qb9.gaturro.util.errors.UserSuspended;
   import com.qb9.gaturro.util.errors.UserSuspendedLoginAttemp;
   import com.qb9.gaturro.view.gui.map.MapGuiModal;
   import com.qb9.gaturro.view.screens.DevLoginScreen;
   import com.qb9.gaturro.view.screens.ErrorScreen;
   import com.qb9.gaturro.view.screens.GaturroLoadingScreen;
   import com.qb9.gaturro.view.screens.LoginScreen;
   import com.qb9.gaturro.view.screens.ServersScreen;
   import com.qb9.gaturro.view.screens.events.LoginScreenEvent;
   import com.qb9.gaturro.view.screens.events.ServersScreenEvent;
   import com.qb9.gaturro.view.world.GaturroWorldView;
   import com.qb9.gaturro.world.core.GaturroWorld;
   import com.qb9.mambo.geom.Coord;
   import com.qb9.mambo.net.enums.MamboLoginErrors;
   import com.qb9.mambo.net.manager.DefaultNetworkManager;
   import com.qb9.mambo.net.manager.NetworkManager;
   import com.qb9.mambo.net.manager.NetworkManagerEvent;
   import com.qb9.mambo.net.manager.RequestTimeoutEvent;
   import com.qb9.mambo.net.requests.room.ChangeRoomActionRequest;
   import com.qb9.mambo.user.events.UserEvent;
   import com.qb9.mambo.view.world.WorldView;
   import com.qb9.mambo.world.core.RoomLink;
   import com.qb9.mambo.world.core.events.RoomEvent;
   import com.qb9.mines.mobject.Mobject;
   import config.AttributeControl;
   import config.ItemControl;
   import config.RegionConfig;
   import flash.display.DisplayObject;
   import flash.display.LoaderInfo;
   import flash.display.Sprite;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   import flash.external.ExternalInterface;
   import flash.net.SharedObject;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.system.Capabilities;
   import flash.system.Security;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.utils.setTimeout;
   
   public class MMO extends Sprite implements IDisposable
   {
      
      private static const Commodore:String = "MMO_Commodore";
      
      private static const LOGGERS:Array = ["mambo","gaturro_global"];
      
      private static const SOUNDS:Array = ["popup","popup2","flecha"];
      
      public static const BROWSER_NOT_ALLOWED:String = "BROWSER_NOT_ALLOWED";
      
      private static const LOGIN:uint = 4;
      
      private static const DIRECTORY:uint = 2;
      
      public static var pocketId:String = "";
      
      private static const PLAYING:uint = 6;
      
      private static const LOADING_WORLD_DATA:uint = 5;
      
      private static const LOCALE_URI:String = "cfgs/locale.json";
      
      private static const DIM:Object = {
         "width":800,
         "height":480
      };
      
      private static const LAST_MODIFIED_NEWS:String = "news/lastModified.txt";
      
      private static const Cooper:String = "MMO_Cooper";
      
      private static const GAMEPLAY_URI:String = "cfgs/gameplay.json";
      
      private static const SETTINGS_URI:String = "cfgs/settings.json";
      
      private static const CONNECTING:uint = 3;
      
      private static const LOADING_CONFIGURATION:uint = 1;
       
      
      private var loginFailed:Boolean = false;
      
      private var gameplay:Settings;
      
      private var accountId:String;
      
      private var minFps:Number = 9999;
      
      private var loading:GaturroLoadingScreen;
      
      private var overlay:Overlay;
      
      private var worldView:WorldView;
      
      private var developAccessToken:String;
      
      private var serverName:String;
      
      private var fpsValues:Array;
      
      private var tabs:uint = 0;
      
      private var prevtime:Number;
      
      private var externalLoaderInfo:LoaderInfo;
      
      private var noRestore:Boolean = false;
      
      private var state:uint;
      
      private var world:GaturroWorld;
      
      private var errorDisplay:ErrorDisplayAppender;
      
      private var passwd:String;
      
      private var directoryUnavailable:Boolean = false;
      
      private var fpsMaxValues:int = 100;
      
      private var fpsCounter:int = 0;
      
      private var maxFps:Number = 0;
      
      private var fpsText:TextField;
      
      private var fpsTextField:TextField;
      
      private var lastModifiedNews:LoadFile;
      
      private var userAgent:String;
      
      private var userName:String;
      
      public function MMO()
      {
         this.overlay = new Overlay();
         this.gameplay = new Settings();
         this.fpsValues = new Array();
         super();
         Security.allowDomain("*");
         Security.allowInsecureDomain("*");
         this.addEventListener(Event.ADDED_TO_STAGE,this.added);
      }
      
      private function added(param1:Event) : void
      {
         this.setup();
         Telemetry.getInstance().trackEvent(TrackCategories.MMO,TrackActions.PLUGING_VERSION + ":" + Capabilities.version);
         Telemetry.getInstance().trackEvent(TrackCategories.MMO,TrackActions.SCREEN_DIM + ":" + Capabilities.screenResolutionX + " " + Capabilities.screenResolutionY);
         Telemetry.getInstance().trackEvent(TrackCategories.MMO,TrackActions.OS + ":" + Capabilities.os);
         Telemetry.getInstance().trackEvent(TrackCategories.MMO,TrackActions.SCREEN_DPI + ":" + Capabilities.screenDPI);
         Telemetry.getInstance().trackEvent(TrackCategories.MMO,TrackActions.SCREEN_PXRATIO + ":" + Capabilities.pixelAspectRatio);
      }
      
      override public function addChild(param1:DisplayObject) : DisplayObject
      {
         super.addChild(param1);
         super.addChild(this.overlay);
         return param1;
      }
      
      private function loadLastModifiedNews() : void
      {
         var _loc1_:String = URLUtil.versionedPath(settings.resources.news + LAST_MODIFIED_NEWS);
         var _loc2_:String = URLUtil.getUrl(_loc1_);
         this.lastModifiedNews = new LoadFile(_loc2_);
         var _loc3_:Parallel = new Parallel();
         _loc3_.add(this.lastModifiedNews);
         new Sequence(_loc3_,new Func(this.loadLanguages)).start();
      }
      
      private function connected(param1:NetworkManagerEvent) : void
      {
         var _loc2_:ConnectionFailed = null;
         net.removeEventListener(NetworkManagerEvent.CONNECT,this.connected);
         if(param1.success)
         {
            Telemetry.getInstance().setCustomDimension(Telemetry.CUSTOM_DIMENSION_SERVER,this.serverName);
            Telemetry.getInstance().trackEvent(TrackCategories.MMO,TrackActions.CONNECTED + ":" + this.serverName);
            Telemetry.getInstance().trackScreen(TrackCategories.MMO,TrackActions.WORLD_STARTS);
            this.login();
         }
         else
         {
            _loc2_ = new ConnectionFailed();
            PhpErrorLog.registry(_loc2_);
            this.showErrorScreen(_loc2_.description);
            Telemetry.getInstance().trackError(GAErrorSeverity.CRITICAL,TrackErrors.CONNECTION_FAILED);
         }
      }
      
      private function restart() : void
      {
         DisplayUtil.empty(this);
         this.setLoading();
         this.connect();
      }
      
      private function get lanParameter() : String
      {
         return this.loaderInfo.parameters.lan;
      }
      
      private function whenWorldDataChanged(param1:Event) : void
      {
         this.disposeWorld();
         this.createWorld();
      }
      
      private function onRoomSelected(param1:RoomEvent) : void
      {
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         _loc2_.removeEventListener(RoomEvent.CHANGE_ROOM,this.onRoomSelected);
         this.removeChild(_loc2_);
         this.world.changeToRoom(param1.link);
      }
      
      private function continueSetup() : void
      {
         if(!settings.debug.on)
         {
            settings.debug = {};
         }
         stage.scaleMode = StageScaleMode.SHOW_ALL;
         stage.stageFocusRect = false;
         this.directoryUnavailable = !settings.connection.directory;
         this.loadSounds();
         this.connect();
      }
      
      private function loginWithScreen() : void
      {
         var finalPath:String;
         var configFile:LoadFile;
         var screen:LoginScreen = null;
         var usersConfig:Settings = null;
         usersConfig = new Settings();
         LoadFileParsers.registerParser(LoadFileFormat.JSON,com.adobe.serialization.json.JSON.decode);
         finalPath = URLUtil.getUrl("cfgs/devUsers.json");
         configFile = new LoadFile(finalPath,"json","",true);
         usersConfig.addFile(configFile);
         configFile.addEventListener(TaskEvent.COMPLETE,function():void
         {
            logger.debug(this,"usersLoadedComplete");
            if(usersConfig.users == null)
            {
               screen = new LoginScreen();
            }
            else
            {
               screen = new DevLoginScreen(usersConfig);
            }
            screen.addEventListener(LoginScreenEvent.LOGIN,loginFromScreen);
            addChild(screen);
            Telemetry.getInstance().trackScreen(TrackAreas.LOGIN);
            disposeLoading();
         });
         configFile.start();
      }
      
      private function disposeLoading() : void
      {
         if(!this.loading)
         {
            return;
         }
         this.loading.dispose();
         this.loading = null;
      }
      
      private function get cookieName() : String
      {
         return SharedObject.getLocal("gaturro").data.name;
      }
      
      private function showMap() : void
      {
         var _loc1_:MapGuiModal = new MapGuiModal(false);
         _loc1_.addEventListener(RoomEvent.CHANGE_ROOM,this.onRoomSelected);
         this.addChild(_loc1_);
      }
      
      private function whenPlayerIsSuspended(param1:NetworkManagerEvent) : void
      {
         tracker.event(TrackCategories.MODERATION,TrackActions.USER_WAS_SUSPENDED);
         this.noRestore = true;
         var _loc2_:Mobject = param1.mobject;
         var _loc3_:UserSuspended = new UserSuspended(_loc2_.getInteger("days"));
         PhpErrorLog.registry(_loc3_);
         this.showErrorScreen(_loc3_.description);
         Telemetry.getInstance().trackError(GAErrorSeverity.CRITICAL,TrackErrors.USER_SUSPENDED);
      }
      
      private function requestItemBlackList(param1:Event = null) : void
      {
         net.addEventListener(GaturroNetResponses.ITEM_BLACK_LIST,this.itemBlackListReceived);
         net.sendAction(new BlackListDataRequest(true));
      }
      
      private function checkDirectAccessToRoom() : void
      {
         logger.info("¿Que sitío seria ideal para ti?");
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:Object = null;
         var _loc4_:Coord = null;
         var _loc5_:Number = NaN;
         for(_loc1_ in settings.directAccessToRoom)
         {
            _loc2_ = String(this.loaderInfo.parameters[_loc1_]);
            if(_loc2_)
            {
               _loc3_ = settings.directAccessToRoom[_loc1_];
               _loc4_ = new Coord(_loc3_.coord[0],_loc3_.coord[1]);
               _loc5_ = Number(_loc3_.roomId);
               net.sendAction(new ChangeRoomActionRequest(new RoomLink(_loc4_,_loc5_)));
               return;
            }
         }
      }
      
      public function dispose() : void
      {
         if(!net)
         {
            return;
         }
         if(region)
         {
            region.stop();
         }
         this.disposeWorld();
         this.disposeLoading();
         DisplayUtil.empty(this);
         if(net)
         {
            net.dispose();
         }
         net = null;
         if(user)
         {
            user.dispose();
         }
         user = null;
      }
      
      private function get browser() : String
      {
         var _loc1_:String = String(this.loaderInfo.parameters.browser);
         return _loc1_ == null ? "" : _loc1_;
      }
      
      private function get geoIpParameter() : String
      {
         var _loc1_:String = String(this.loaderInfo.parameters.geo_ip);
         logger.debug("GeoIP value received: " + (_loc1_ == null ? "null (default: AR)" : _loc1_.toUpperCase()));
         return _loc1_ == null ? "AR" : _loc1_.toUpperCase();
      }
      
      private function initLogin(param1:String, param2:String) : void
      {
         clientData.startLogin();
         this.userName = param1;
         this.passwd = param2;
         net.login(param1,param2);
      }
      
      private function chooseServer(param1:ServersScreenEvent) : void
      {
         this.disposeServersScreen(param1);
         this.setLoading();
         var _loc2_:Object = settings.connection;
         _loc2_.address = param1.host;
         _loc2_.port = param1.port;
         _loc2_.serverName = param1.name;
         this.serverName = param1.name;
         this.initiateConnection();
      }
      
      private function disposeServersScreen(param1:Event) : void
      {
         var _loc2_:ServersScreen = param1.target as ServersScreen;
         _loc2_.removeEventListener(ServersScreenEvent.ERROR,this.skipServerElection);
         _loc2_.removeEventListener(ServersScreenEvent.READY,this.whenServersAreReady);
         _loc2_.removeEventListener(ServersScreenEvent.CHOSE,this.chooseServer);
         DisplayUtil.remove(_loc2_);
      }
      
      private function getUserAgent() : String
      {
         var browser:String = null;
         try
         {
            this.userAgent = ExternalInterface.call("window.navigator.userAgent.toString");
            browser = "[Unknown Browser]";
            if(this.userAgent.indexOf("Safari") != -1)
            {
               browser = "Safari";
            }
            if(this.userAgent.indexOf("Firefox") != -1)
            {
               browser = "Firefox";
            }
            if(this.userAgent.indexOf("Chrome") != -1)
            {
               browser = "Chrome";
            }
            if(this.userAgent.indexOf("MSIE") != -1)
            {
               browser = "Internet Explorer";
            }
            if(this.userAgent.indexOf("Opera") != -1)
            {
               browser = "Opera";
            }
            if(this.userAgent.indexOf("mundo-gaturro-desktop") != -1)
            {
               browser = "Mundo Gaturro Desktop";
            }
         }
         catch(e:Error)
         {
            return "[No ExternalInterface]";
         }
         return browser;
      }
      
      private function get loginUrl() : String
      {
         return this.loaderInfo.parameters.loginUrl;
      }
      
      private function initiateConnection() : void
      {
         this.state = CONNECTING;
         logger.info("Initiate Connection: ");
         Telemetry.getInstance().trackEvent(TrackCategories.MMO,TrackActions.CONNECTING);
         var _loc1_:Object = settings.connection;
         var _loc2_:uint = _loc1_.responseTimeout * 1000;
         var _loc3_:String = String(_loc1_.address);
         net = _loc3_ === ServersScreen.LOCAL ? new SimulatedGaturroNetworkManager(1) : new DefaultNetworkManager(_loc2_,_loc1_.requestsTimeouts);
         net.addEventListener(NetworkManagerEvent.CONNECTION_LOST,this.whenDisconnected);
         net.addEventListener(NetworkManagerEvent.TIMEOUT,this.whenTimeout);
         net.addEventListener(NetworkManagerEvent.LOGOUT,this.whenLogout);
         net.addEventListener(NetworkManagerEvent.CONNECT,this.connected);
         net.addEventListener(NetworkManagerEvent.PLAYER_SUSPENDED,this.whenPlayerIsSuspended);
         net.addEventListener(RequestTimeoutEvent.TIMEOUT,this.requestTimeout);
         net.connect(_loc3_,_loc1_.port);
         tracker.page(TrackActions.WORLD_STARTS);
      }
      
      override public function get loaderInfo() : LoaderInfo
      {
         return !!this.externalLoaderInfo ? this.externalLoaderInfo : super.loaderInfo;
      }
      
      private function whenLogout(param1:Event) : void
      {
         this.noRestore = true;
         var _loc2_:ConnectionInactivity = new ConnectionInactivity();
         PhpErrorLog.registry(_loc2_);
         this.showErrorScreen(_loc2_.description);
         Telemetry.getInstance().trackError(GAErrorSeverity.CRITICAL,TrackErrors.INACTIVITY);
      }
      
      public function showErrorScreen(param1:String, param2:Boolean = false) : void
      {
         var _loc3_:String = !!user ? String(user.username) : "";
         this.dispose();
         param1 = param1.split(">").pop();
         this.addChild(new ErrorScreen(param1));
         if(param2)
         {
            setTimeout(this.recoverFromError,4000);
         }
      }
      
      private function fixTextfield(param1:Event) : void
      {
         var _loc2_:TextField = param1.target as TextField;
         if(_loc2_)
         {
            _loc2_.mouseEnabled = _loc2_.tabEnabled = _loc2_.type === TextFieldType.INPUT;
            if(_loc2_.tabEnabled)
            {
               _loc2_.tabIndex = this.tabs++;
            }
         }
      }
      
      private function login() : void
      {
         var _loc2_:String = null;
         this.state = LOGIN;
         net.addEventListener(NetworkManagerEvent.LOGIN,this.logged);
         if(this.loginFailed)
         {
            return this.loginWithScreen();
         }
         if(this.loginId)
         {
            MMO.pocketId = this.loginId;
            return net.logWithID(this.loginId);
         }
         var _loc1_:String = this.cookieName;
         if(_loc1_)
         {
            _loc2_ = String(this.cookiePass || _loc1_);
            return this.initLogin(_loc1_,_loc2_);
         }
         this.loginWithScreen();
      }
      
      private function itemBlackListReceived(param1:NetworkManagerEvent) : void
      {
         net.removeEventListener(GaturroNetResponses.ITEM_BLACK_LIST,this.itemBlackListReceived);
         var _loc2_:Array = param1.mobject.getStringArray("blackList");
         ItemControl.init(_loc2_);
         net.addEventListener(GaturroNetResponses.ITEM_BLACK_LIST,this.attrsBlackListReceived);
         net.sendAction(new BlackListDataRequest(false));
      }
      
      private function get loginId() : String
      {
         return this.loaderInfo.parameters.loginId;
      }
      
      private function get mifi() : Boolean
      {
         return this.loaderInfo.parameters.mifi == "true";
      }
      
      private function recoverFromError() : void
      {
         switch(this.state)
         {
            case LOGIN:
               if(this.loginUrl)
               {
                  return this.redirect();
               }
               if(!this.loginFailed && !this.noRestore)
               {
                  this.restart();
               }
               this.loginFailed = true;
               break;
            case LOADING_CONFIGURATION:
            case DIRECTORY:
               if(this.loginUrl)
               {
                  this.redirect();
                  break;
               }
               break;
            case PLAYING:
            case CONNECTING:
            case LOADING_WORLD_DATA:
               if(this.directoryUnavailable || this.noRestore)
               {
                  if(this.loginUrl)
                  {
                     this.redirect();
                     break;
                  }
                  break;
               }
               this.restart();
               break;
         }
      }
      
      private function mergeSettings() : void
      {
         logger.info(this,"merged settings.");
         settings = Settings(ObjectUtil.copy(this.gameplay,settings));
         this.gameplay = null;
         ConfigSecurity.safeStringMembers(settings);
         var _loc1_:SetupPreloadingTask = new SetupPreloadingTask("cfgs/preloading.json");
         _loc1_.start();
         this.loadLastModifiedNews();
         if(settings.debug.on)
         {
            this.fpsText = new TextField();
            stage.addChild(this.fpsText);
            this.fpsText.text = "FPS:";
            this.fpsText.x = stageData.width - 883;
            this.fpsText.y = stageData.height - 483;
            this.fpsTextField = new TextField();
            stage.addChild(this.fpsTextField);
            this.fpsTextField.text = "0";
            this.fpsTextField.x = stageData.width - 850;
            this.fpsTextField.y = stageData.height - 483;
            this.prevtime = new Date().time;
            stage.addEventListener(Event.ENTER_FRAME,this._onEnterFrame);
         }
      }
      
      private function setupToken(param1:Mobject) : void
      {
         var _loc2_:String = param1.getString("key");
         GameData.securityRequestKey = _loc2_;
         this.developAccessToken = param1.getString("access_token");
         this.accountId = param1.getString("account_id");
         logger.debug("Amigos -> mi account Id: " + this.accountId + ", my token: " + this.developAccessToken);
      }
      
      private function setup() : void
      {
         logger.info("Optimizado para un mejor rendimiento?");
         this.removeEventListener(Event.ADDED_TO_STAGE,this.added);
         stageData = new StageData(stage,DIM.width,DIM.height);
         stage.addEventListener(Event.ADDED_TO_STAGE,this.fixTextfield,true);
         stage.quality = "medium";
         this.setLoading(false);
         this.state = LOADING_CONFIGURATION;
         this.setupLoggers();
         this.setupTelemetry();
         logger.info("MMO initiate setup: ");
         Telemetry.getInstance().trackScreen(TrackAreas.ENTERING);
         Telemetry.getInstance().trackEvent(TrackCategories.MMO,TrackActions.CONFIGURATION);
         this.setupSettings();
      }
      
      private function setLoading(param1:Boolean = true) : void
      {
         this.loading = this.loading || new GaturroLoadingScreen(param1);
         this.addChild(this.loading);
      }
      
      private function logged(param1:NetworkManagerEvent) : void
      {
         this.setLoading();
         net.removeEventListener(NetworkManagerEvent.LOGIN,this.logged);
         if(param1.success)
         {
            Telemetry.getInstance().setUserId(this.userName);
            Telemetry.getInstance().trackEvent(TrackCategories.SECURITY,TrackActions.LOGIN_SUCCESS);
            if(param1.mobject)
            {
               this.setupToken(param1.mobject);
            }
            this.requestItemBlackList();
         }
         else
         {
            Telemetry.getInstance().trackEvent(TrackCategories.SECURITY,TrackActions.LOGIN_FAIL);
            this.showLoginError(param1.errorCode);
         }
      }
      
      private function setupFileControl() : void
      {
         logger.info("Setting FileControl: ");
         securityFileControl = new FileControl();
         securityFileControl.addEventListener(FileControlEvent.CONTROL_FAILED,this.securityFileControlFailed);
      }
      
      private function securityFileControlFailed(param1:FileControlEvent) : void
      {
         logger.info("SECURITY ERROR: ",param1.dataObject);
         var _loc2_:FileControlFailure = param1.dataObject as FileControlFailure;
         logger.debug(_loc2_.data);
         Telemetry.getInstance().trackError(GAErrorSeverity.CRITICAL,TrackErrors.FILECONTROL_FAILED);
         if(!region)
         {
            return;
         }
         this.showErrorScreen(param1.dataObject.description,false);
      }
      
      private function _onEnterFrame(param1:Event) : void
      {
         var _loc2_:Number = new Date().time;
         ++this.fpsCounter;
         this.fpsCounter %= this.fpsMaxValues;
         this.fpsValues[this.fpsCounter] = Math.floor(1000 / (_loc2_ - this.prevtime));
         var _loc3_:Number = 0;
         var _loc4_:int = 0;
         while(_loc4_ < this.fpsMaxValues)
         {
            _loc3_ += this.fpsValues[_loc4_] || 24;
            _loc4_++;
         }
         _loc3_ /= this.fpsMaxValues;
         _loc3_ = Math.round(_loc3_);
         this.minFps = Math.min(this.minFps,_loc3_);
         this.maxFps = Math.max(this.maxFps,_loc3_);
         this.fpsText.text = "FPS:";
         this.fpsTextField.text = this.minFps + " " + _loc3_ + " " + this.maxFps;
         this.prevtime = _loc2_;
         if(this.fpsCounter == 0)
         {
            this.minFps = 9999;
            this.maxFps = 0;
         }
      }
      
      private function whenDisconnected(param1:Event) : void
      {
         var _loc2_:ConnectionLost = new ConnectionLost();
         PhpErrorLog.registry(_loc2_);
         this.showErrorScreen(_loc2_.description);
         Telemetry.getInstance().trackError(GAErrorSeverity.CRITICAL,TrackErrors.CONNECTION_LOST);
      }
      
      private function get cookiePass() : String
      {
         return SharedObject.getLocal("gaturro").data.pass;
      }
      
      private function loadLocales() : void
      {
         logger.info("Loading locales: ");
         var _loc1_:LoadFile = new GaturroLoadFile(GAMEPLAY_URI);
         this.gameplay.addFile(_loc1_);
         logger.info("GAMEPLAY FILE CARGADO");
         var _loc2_:LoadFile = new GaturroLoadFile(LOCALE_URI);
         locale.addFile(_loc2_);
         logger.info("LOCALE FILE CARGADO");
         var _loc3_:Parallel = new Parallel();
         _loc3_.add(_loc1_);
         _loc3_.add(_loc2_);
         new Sequence(_loc3_,new Func(this.mergeSettings)).start();
         logger.info("MERGEADO COMPLETO?");
      }
      
      private function setupLoggers() : void
      {
         var _loc2_:String = null;
         var _loc3_:IAppender = null;
         var _loc1_:Array = [new ErrorHandlerAppender(this)];
         if(BrowserConsoleAppender.available)
         {
            _loc1_.push(new BrowserConsoleAppender(true));
         }
         _loc1_.push(new FloggerAppender(),new ConsoleAppender());
         _loc1_.push(logs);
         this.errorDisplay = new ErrorDisplayAppender();
         this.errorDisplay.x = stageData.width - -70;
         this.errorDisplay.y = stageData.height - 100;
         this.addChild(this.errorDisplay);
         _loc1_.push(this.errorDisplay);
         for each(_loc2_ in LOGGERS)
         {
            for each(_loc3_ in _loc1_)
            {
               Logger.getLogger(_loc2_).addAppender(_loc3_);
            }
         }
      }
      
      private function disposeWorld(param1:Event = null) : void
      {
         if(!this.world)
         {
            return;
         }
         this.world.dispose();
         this.world = null;
         DisplayUtil.remove(this.worldView);
         this.worldView = null;
      }
      
      private function setupTelemetry() : void
      {
         tracker = new GaturroTracker();
         var _loc1_:TelemetryConfig = new TelemetryConfig();
         _loc1_.GoogleAnalytics_trackingId = "UA-3039420-9";
         _loc1_.GoogleAnalytics_host = "www.mundogaturro.com";
         _loc1_.GoogleAnalytics_prefix = "/client/";
         _loc1_.GameAnalytics_secretKey = "79b29e77006c26842d791308b892b7162acb1379";
         _loc1_.GameAnalytics_gameKey = "26cc3d02ee01b137d87b110c8161728a";
         _loc1_.AppVersion = GameData.VERSION;
         Telemetry.getInstance().init(_loc1_);
      }
      
      public function saveLoaderInfo(param1:LoaderInfo) : void
      {
         this.externalLoaderInfo = param1;
      }
      
      private function setupSettings() : void
      {
         logger.info("Loading Settings: ");
         LoadFileParsers.registerParser(LoadFileFormat.JSON,com.adobe.serialization.json.JSON.decode);
         var _loc1_:LoadFile = new LoadFile(this.urlBase + SETTINGS_URI);
         settings.addFile(_loc1_);
         Telemetry.getInstance().trackEvent(TrackCategories.MMO,TrackActions.CURRENT_URL + ":" + this.urlBase);
         var _loc2_:String = this.getUserAgent();
         var _loc3_:String = TrackActions.CLIENT + ":" + _loc2_;
         settings.userAgent = _loc2_;
         Telemetry.getInstance().trackEvent(TrackCategories.MMO,_loc3_);
         var _loc4_:Parallel;
         (_loc4_ = new Parallel()).add(_loc1_);
         new Sequence(_loc4_,new Func(this.loadLocales)).start();
      }
      
      private function attrsBlackListReceived(param1:NetworkManagerEvent) : void
      {
         net.removeEventListener(GaturroNetResponses.ITEM_BLACK_LIST,this.attrsBlackListReceived);
         var _loc2_:Array = param1.mobject.getStringArray("blackList");
         AttributeControl.init(_loc2_);
         this.loadUser();
      }
      
      private function whenServersAreReady(param1:Event) : void
      {
         this.disposeLoading();
      }
      
      private function whenTimeout(param1:Event) : void
      {
         var _loc2_:ConnectionTimeout = new ConnectionTimeout();
         PhpErrorLog.registry(_loc2_);
         this.showErrorScreen(_loc2_.description);
      }
      
      private function loadSounds() : void
      {
         var _loc1_:String = null;
         logger.info(this,"loadSounds()");
         audio = new GaturroAudioPlayer();
         for each(_loc1_ in SOUNDS)
         {
            audio.register(_loc1_).start();
         }
      }
      
      private function loadUser() : void
      {
         this.state = LOADING_WORLD_DATA;
         var _loc1_:String = this.lastModifiedNews.data as String;
         logger.debug("News were last modified at",_loc1_);
         var _loc2_:Number = Date.parse(_loc1_);
         if(isNaN(_loc2_))
         {
            logger.warning("Failed to parse the news last modified date correctly");
            _loc2_ = new Date().getTime();
         }
         user = new GaturroUser(net,_loc2_);
         user.hashSessionId = !!this.loginId ? this.loginId : this.developAccessToken;
         user.accountId = this.accountId;
         user.hasAPP = this.mifi;
         user.addEventListener(UserEvent.LOADED,this.createWorld);
      }
      
      private function requestTimeout(param1:RequestTimeoutEvent) : void
      {
         var _loc2_:String = param1.request;
         logger.debug("Request",_loc2_,"timedout.");
         if(ArrayUtil.contains(["MinesLogin","ChangeRoomActionRequest"],_loc2_))
         {
            this.dispose();
            this.showServers();
         }
         else if(_loc2_ == "RoomDataRequest")
         {
            this.showMap();
         }
      }
      
      private function showServers() : void
      {
         this.state = DIRECTORY;
         var _loc1_:ServersScreen = new ServersScreen();
         _loc1_.addEventListener(ServersScreenEvent.ERROR,this.skipServerElection);
         _loc1_.addEventListener(ServersScreenEvent.READY,this.whenServersAreReady);
         _loc1_.addEventListener(ServersScreenEvent.CHOSE,this.chooseServer);
         this.addChild(_loc1_);
         Telemetry.getInstance().trackScreen(TrackAreas.DIRECTORY);
         tracker.page(TrackActions.DIRECTORY);
      }
      
      private function loadLanguages() : void
      {
         var _loc1_:Parallel = null;
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:LoadFile = null;
         var _loc8_:Settings = null;
         logger.info(this,LAST_MODIFIED_NEWS,"loaded.");
         region = new RegionEngine(stage);
         region.start();
         if(!RegionConfig.data.enabled)
         {
            this.continueSetup();
            return;
         }
         if(this.lanParameter)
         {
            region.languageId = this.lanParameter;
         }
         region.country = this.geoIpParameter;
         if(region.country != "AR")
         {
            _loc1_ = new Parallel();
            for(_loc2_ in settings.languages)
            {
               _loc3_ = settings.languages[_loc2_];
               for each(_loc4_ in _loc3_)
               {
                  _loc5_ = URLUtil.getUrl(_loc4_);
                  _loc6_ = URLUtil.versionedPath(_loc5_);
                  _loc7_ = new LoadFile(_loc6_);
                  _loc1_.add(_loc7_);
                  (_loc8_ = new Settings(com.adobe.serialization.json.JSON.decode)).addFile(_loc7_);
                  region.addFileToLan(_loc2_,_loc8_);
               }
            }
            new Sequence(_loc1_,new Func(this.continueSetup)).start();
         }
         else
         {
            this.continueSetup();
         }
      }
      
      private function readyToPlay(param1:Event = null) : void
      {
         this.worldView.removeEventListener(GaturroWorldView.READY_GAME_EVENT,this.readyToPlay);
         clientData.readyToPlay();
         var _loc2_:int = int(clientData.totalLoadingTime);
         tracker.event(TrackCategories.MMO,TrackActions.LOGIN,null,_loc2_);
         Telemetry.getInstance().trackEvent(TrackCategories.MMO,TrackActions.READY_TO_PLAY);
      }
      
      private function skipServerElection(param1:Event) : void
      {
         this.disposeServersScreen(param1);
         this.directoryUnavailable = true;
         this.initiateConnection();
      }
      
      private function get urlBase() : String
      {
         var _loc1_:String = String(this.loaderInfo.parameters.urlconfig);
         return _loc1_ == null ? "" : _loc1_;
      }
      
      private function redirect() : void
      {
         this.dispose();
         navigateToURL(new URLRequest(this.loginUrl),"_self");
      }
      
      private function connect() : void
      {
         var _loc1_:String = null;
         logger.info(this,"connect()");
         if(this.browser != null && this.browser.length > 0)
         {
            _loc1_ = this.browser;
            _loc1_ = _loc1_.toUpperCase();
            if(_loc1_.indexOf("OPERA") >= 0)
            {
               this.showLoginError(MMO.BROWSER_NOT_ALLOWED);
               return;
            }
         }
         if(this.directoryUnavailable)
         {
            this.initiateConnection();
         }
         else
         {
            this.showServers();
         }
      }
      
      private function createWorld(param1:Event = null) : void
      {
         net.addEventListener(NetworkManagerEvent.WORLD_DATA_CHANGED,this.whenWorldDataChanged);
         logger.info("CAPABILITIES -->> ");
         logger.info("Capabilities.isDebugger: " + Capabilities.isDebugger);
         logger.info("Capabilities.language: " + Capabilities.language);
         logger.info("Capabilities.manufacturer: " + Capabilities.manufacturer);
         logger.info("Capabilities.os: " + Capabilities.os);
         logger.info("Capabilities.playerType: " + Capabilities.playerType);
         logger.info("Capabilities.screenResolutionX: " + Capabilities.screenResolutionX);
         logger.info("Capabilities.screenResolutionY: " + Capabilities.screenResolutionY);
         logger.info("Capabilities.serverString: " + Capabilities.serverString);
         logger.info("Capabilities.version: " + Capabilities.version);
         this.world = new GaturroWorld(user,net);
         this.worldView = new GaturroWorldView(this.world,this.loading);
         this.worldView.addEventListener(GaturroWorldView.READY_GAME_EVENT,this.readyToPlay);
         addChildAt(this.worldView,0);
         this.state = PLAYING;
         this.loading = null;
         this.setupTutorial();
         this.checkDirectAccessToRoom();
      }
      
      override public function removeChild(param1:DisplayObject) : DisplayObject
      {
         if(param1 !== this.overlay)
         {
            super.removeChild(param1);
         }
         return param1;
      }
      
      private function setupTutorial() : void
      {
         TutorialManager.setup();
      }
      
      private function showLoginError(param1:String) : void
      {
         var _loc2_:SessionExpiredError = null;
         var _loc3_:UserSuspendedLoginAttemp = null;
         var _loc4_:InvalidCredentials = null;
         var _loc5_:AlreadyLogged = null;
         var _loc6_:ServerFull = null;
         var _loc7_:IncompatibleBrowser = null;
         var _loc8_:UnknownLoginError = null;
         switch(param1)
         {
            case MamboLoginErrors.SESSION_EXPIRED:
               this.loginFailed = true;
               _loc2_ = new SessionExpiredError();
               PhpErrorLog.registry(_loc2_);
               this.showErrorScreen(_loc2_.description);
               Telemetry.getInstance().trackError(GAErrorSeverity.CRITICAL,TrackErrors.SESSION_EXPIRED);
               break;
            case MamboLoginErrors.USER_SUSPENDED:
               this.noRestore = true;
               _loc3_ = new UserSuspendedLoginAttemp();
               PhpErrorLog.registry(_loc3_);
               this.showErrorScreen(_loc3_.description);
               Telemetry.getInstance().trackError(GAErrorSeverity.CRITICAL,TrackErrors.USER_SUSPENDED);
               break;
            case MamboLoginErrors.INVALID_CREDENTIALS:
               _loc4_ = new InvalidCredentials();
               PhpErrorLog.registry(_loc4_);
               this.showErrorScreen(_loc4_.description,true);
               Telemetry.getInstance().trackError(GAErrorSeverity.CRITICAL,TrackErrors.INVALID_CREDENTIALS);
               break;
            case MamboLoginErrors.ALREADY_LOGGED:
               this.loginFailed = true;
               _loc5_ = new AlreadyLogged();
               PhpErrorLog.registry(_loc5_);
               this.showErrorScreen(_loc5_.description);
               Telemetry.getInstance().trackError(GAErrorSeverity.CRITICAL,TrackErrors.ALREADY_LOGGED);
               break;
            case MamboLoginErrors.SERVER_FULL:
               _loc6_ = new ServerFull();
               PhpErrorLog.registry(_loc6_);
               this.showErrorScreen(_loc6_.description);
               Telemetry.getInstance().trackError(GAErrorSeverity.CRITICAL,TrackErrors.SERVER_FULL);
               break;
            case MMO.BROWSER_NOT_ALLOWED:
               _loc7_ = new IncompatibleBrowser();
               PhpErrorLog.registry(_loc7_);
               this.showErrorScreen(_loc7_.description);
               Telemetry.getInstance().trackError(GAErrorSeverity.CRITICAL,TrackErrors.BROWSER_NOT_ALLOWED);
               break;
            default:
               _loc8_ = new UnknownLoginError();
               PhpErrorLog.registry(_loc8_);
               this.showErrorScreen(_loc8_.description);
               Telemetry.getInstance().trackError(GAErrorSeverity.CRITICAL,TrackErrors.UNKNOWN);
         }
      }
      
      private function loginFromScreen(param1:LoginScreenEvent) : void
      {
         var _loc2_:LoginScreen = param1.target as LoginScreen;
         _loc2_.removeEventListener(LoginScreenEvent.LOGIN,this.loginFromScreen);
         _loc2_.dispose();
         this.removeChild(_loc2_);
         this.initLogin(param1.user,param1.pass);
         this.setLoading();
      }
   }
}

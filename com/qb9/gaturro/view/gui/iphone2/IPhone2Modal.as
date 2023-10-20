package com.qb9.gaturro.view.gui.iphone2
{
   import assets.AlarmClockMainMC;
   import assets.AppStoreMainMC;
   import assets.Bola8MainMC;
   import assets.Iphone2ExtraContentMC;
   import assets.Iphone2MC;
   import assets.PianoMainMC;
   import assets.PodometroMainMC;
   import assets.SnakeGameMainMC;
   import com.qb9.flashlib.easing.SpeedBasedTween;
   import com.qb9.flashlib.tasks.*;
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.audio;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.globals.net;
   import com.qb9.gaturro.net.mail.GaturroMailer;
   import com.qb9.gaturro.net.requests.URLUtil;
   import com.qb9.gaturro.view.gui.base.BaseGuiModal;
   import com.qb9.gaturro.view.gui.iphone2.screens.*;
   import com.qb9.gaturro.view.gui.iphone2.screens.alarmclock.AlarmClockMainScreen;
   import com.qb9.gaturro.view.gui.iphone2.screens.bola8.Bola8MainScreen;
   import com.qb9.gaturro.view.gui.iphone2.screens.piano.PianoMainScreen;
   import com.qb9.gaturro.view.gui.iphone2.screens.podometro.PodometroMainScreen;
   import com.qb9.gaturro.view.gui.iphone2.screens.snakegame.SnakeGameMainScreen;
   import com.qb9.gaturro.view.gui.iphone2.screens.store.AppStoreMainScreen;
   import com.qb9.gaturro.view.gui.iphone2.transitions.*;
   import com.qb9.gaturro.view.gui.news.ReadNewsIphone2GuiModal;
   import com.qb9.gaturro.view.gui.socialnet.SocialNetIphone2GuiModal;
   import com.qb9.gaturro.view.world.GaturroRoomView;
   import com.qb9.gaturro.world.community.Buddy;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import com.qb9.mambo.net.mail.Mailer;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLRequest;
   
   public final class IPhone2Modal extends BaseGuiModal
   {
      
      private static const BASE:String = "content/";
      
      private static const MARGIN:uint = 20;
      
      private static const SPEED:uint = 500;
       
      
      private var container:Iphone2ExtraContentMC;
      
      private var task:ITask;
      
      private var whitelist:WhiteListNode;
      
      private var tasks:TaskContainer;
      
      private var room:GaturroRoom;
      
      private var roomView:GaturroRoomView;
      
      private var celButton:com.qb9.gaturro.view.gui.iphone2.GuiIPhone2Button;
      
      private var mailer:Mailer;
      
      private var skinName:String;
      
      private var screen:BaseIPhone2Screen;
      
      private var CANVAS_HEIGHT:Number;
      
      private var asset:Iphone2MC;
      
      public var skin:DisplayObject;
      
      private var CANVAS_WIDTH:Number;
      
      public function IPhone2Modal(param1:com.qb9.gaturro.view.gui.iphone2.GuiIPhone2Button, param2:TaskContainer, param3:Mailer, param4:GaturroRoom, param5:GaturroRoomView, param6:WhiteListNode, param7:Boolean)
      {
         this.container = new Iphone2ExtraContentMC();
         super();
         this.tasks = param2;
         this.mailer = param3;
         this.room = param4;
         this.roomView = param5;
         this.whitelist = param6;
         this.celButton = param1;
         this.init();
         if(param7)
         {
            this.addToPh(new IPhone2MenuScreen(this,GaturroMailer(param3),param2));
         }
         this.CANVAS_WIDTH = this.ph.width;
         this.CANVAS_HEIGHT = this.ph.height;
      }
      
      private function closeIphone(param1:MouseEvent) : void
      {
         close();
      }
      
      private function getAsset(param1:String, param2:*) : BaseIPhone2Screen
      {
         switch(param1)
         {
            case IPhone2Screens.MESSAGES:
               return new Iphone2MessagesMenu(this,GaturroMailer(this.mailer));
            case IPhone2Screens.NEWS:
               return new ReadNewsIphone2GuiModal(this,this.celButton);
            case IPhone2Screens.SOCIAL_NET:
               return new SocialNetIphone2GuiModal(this,this.room,this.roomView);
            case IPhone2Screens.CHOOSE_RECIPIENT:
               return new IPhone2ChooseRecipientScreen(this,param2);
            case IPhone2Screens.COMPOSE:
               return new IPhone2WhiteListComposeScreen(this,this.whitelist,this.tasks,param2);
            case IPhone2Screens.COMPOSE_TO_FRIEND:
               return new IPhone2WhiteListComposeScreen(this,this.whitelist,this.tasks,param2.internalMessage,param2.buddy);
            case IPhone2Screens.DELETE_MAIL:
               return new IPhone2DeleteMailScreen(this,param2);
            case IPhone2Screens.DELETING_MAIL:
               return new IPhone2DeletingMailScreen(this,this.mailer,param2);
            case IPhone2Screens.FRIENDS:
               return new IPhone2FriendsScreen(this,param2 == null ? Buddy.FRIEND : param2,true);
            case IPhone2Screens.INBOX:
               return new IPhone2InboxScreen(this,this.mailer,this.whitelist,false);
            case IPhone2Screens.INBOX_NOTIFICATIONS:
               return new IPhone2InboxScreen(this,this.mailer,this.whitelist,true);
            case IPhone2Screens.MENU:
               return new IPhone2MenuScreen(this,GaturroMailer(this.mailer),this.tasks);
            case IPhone2Screens.READ_MAIL:
               return new IPhone2ReadMailScreen(this,this.mailer,param2,this.whitelist);
            case IPhone2Screens.REMOVE_FRIEND:
               return new IPhone2RemoveFriendScreen(this,param2.buddy);
            case IPhone2Screens.REMOVING_FRIEND:
               return new IPhone2RemovingFriendScreen(this,param2.buddy);
            case IPhone2Screens.SEE_FRIEND:
               return new IPhone2FriendScreen(this,this.room,param2.buddy);
            case IPhone2Screens.SEE_FRIENDS:
               return new IPhone2FriendsScreen(this,Buddy.FRIEND,false);
            case IPhone2Screens.SENDING:
               return new IPhone2SendingScreen(this,this.mailer,net,param2);
            case IPhone2Screens.ERROR:
               return new IPhone2ErrorScreen(this,param2);
            case IPhone2Screens.PODOMETRO:
               return new PodometroMainScreen(this,new PodometroMainMC(),param2);
            case IPhone2Screens.BOLA8:
               return new Bola8MainScreen(this,new Bola8MainMC(),param2);
            case IPhone2Screens.ALARMCLOCK:
               return new AlarmClockMainScreen(this,new AlarmClockMainMC(),param2,this.celButton);
            case IPhone2Screens.PIANO:
               return new PianoMainScreen(this,new PianoMainMC(),param2);
            case IPhone2Screens.SNAKEGAME:
               return new SnakeGameMainScreen(this,new SnakeGameMainMC(),param2,this.tasks);
            case IPhone2Screens.STORE:
               return new AppStoreMainScreen(this,new AppStoreMainMC(),param2,this.tasks);
            default:
               logger.error("Unrecognized iphone screen:",param1);
               return null;
         }
      }
      
      private function disposeTask() : void
      {
         if(this.busy)
         {
            this.tasks.remove(this.task);
         }
         this.task = null;
      }
      
      private function slideScreen(param1:BaseIPhone2Screen, param2:uint) : void
      {
         if(param2 & IPhone2TransitionDirection.LEFT)
         {
            param1.x = this.CANVAS_WIDTH;
         }
         else if(param2 & IPhone2TransitionDirection.RIGHT)
         {
            param1.x = -this.CANVAS_WIDTH;
         }
         if(param2 & IPhone2TransitionDirection.UP)
         {
            param1.y = this.CANVAS_HEIGHT;
         }
         else if(param2 & IPhone2TransitionDirection.DOWN)
         {
            param1.y = -this.CANVAS_HEIGHT;
         }
         this.task = new Parallel(new SpeedBasedTween(param1,SPEED,{
            "x":0,
            "y":0
         },{"transition":"easeout"}),new Sequence(new SpeedBasedTween(this.screen,SPEED,{
            "x":-param1.x,
            "y":-param1.y
         },{"transition":"easeout"}),new Func(this.disposeScreen,this.screen),new Func(param1.ready)));
         this.tasks.add(this.task);
         this.addToPh(param1);
      }
      
      private function addEPlanningAdd(param1:MovieClip) : void
      {
         param1.mc.eph.gotoAndStop("default");
      }
      
      public function gotoAlarmClock() : void
      {
         this.screen.goto(IPhone2Screens.ALARMCLOCK);
      }
      
      private function eplaning() : void
      {
         var _loc1_:int = Math.random() * 10000;
         var _loc2_:String = "http://ads.e-planning.net/eb/3/902b/bc98e79fbcdee0e5?o=i&rnd=$RANDOM&p=8d27b8a106090a14" + _loc1_;
         var _loc3_:URLRequest = new URLRequest(_loc2_);
         var _loc4_:Loader;
         (_loc4_ = new Loader()).load(new URLRequest(_loc2_));
      }
      
      private function addSkin() : void
      {
         this.skinName = this.room.userAvatar.attributes.iphoneSkin;
         if(!this.skinName)
         {
            this.skinName = "iphoneSkin/yellow.swf";
         }
         var _loc1_:String = BASE + this.skinName;
         var _loc2_:Loader = new Loader();
         _loc2_.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleLoadingError);
         _loc2_.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.handleLoadingError);
         _loc2_.contentLoaderInfo.addEventListener(Event.INIT,this.skinLoaded);
         var _loc3_:String = URLUtil.versionedPath(URLUtil.getUrl(_loc1_));
         _loc2_.load(new URLRequest(_loc3_));
      }
      
      private function init() : void
      {
         this.container = new Iphone2ExtraContentMC();
         this.container.addEventListener(Event.COMPLETE,_close);
         addChild(this.container);
         this.asset = new Iphone2MC();
         this.container.ph.addChild(this.asset);
         this.addSkin();
         this.addEPlanningAdd(this.container);
         api.pauseBackgroundMusic();
         audio.addLazyPlay("iphone2_music");
      }
      
      private function closePopup(param1:Event = null) : void
      {
         this.container.gotoAndPlay(20);
      }
      
      override public function dispose() : void
      {
         api.resumeBackgroundMusic();
         api.stopSound("iphone2_music");
         if(this.asset.close)
         {
            this.asset.close.removeEventListener(MouseEvent.CLICK,close);
         }
         if(this.screen)
         {
            this.disposeScreen(this.screen);
         }
         this.disposeTask();
         this.screen = null;
         DisplayUtil.remove(this.asset);
         this.asset = null;
         this.tasks = null;
         this.room = null;
         this.mailer = null;
         this.whitelist = null;
         this.celButton = null;
         super.dispose();
      }
      
      private function skinLoaded(param1:Event) : void
      {
         LoaderInfo(param1.currentTarget).removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleLoadingError);
         LoaderInfo(param1.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR,this.handleLoadingError);
         LoaderInfo(param1.currentTarget).removeEventListener(Event.INIT,this.skinLoaded);
         var _loc2_:DisplayObject = DisplayObject(param1.currentTarget.content);
         this.container.mc.ph.addChild(_loc2_);
         this.container.mc.close.addEventListener(MouseEvent.CLICK,this.closeIphone);
      }
      
      private function get ph() : DisplayObjectContainer
      {
         return this.asset.ph;
      }
      
      public function transition(param1:IPhone2Transition) : void
      {
         var _loc2_:BaseIPhone2Screen = this.getAsset(param1.screen,param1.data);
         if(_loc2_)
         {
            this.slideScreen(_loc2_,param1.direction);
         }
      }
      
      public function goToNews() : void
      {
         this.screen.goto(IPhone2Screens.NEWS);
      }
      
      private function disposeScreen(param1:BaseIPhone2Screen) : void
      {
         if(!param1.isDisposed)
         {
            param1.dispose();
         }
         DisplayUtil.remove(param1);
      }
      
      private function handleLoadingError(param1:Event) : void
      {
         logger.warning("Iphone skin could not be loaded");
         LoaderInfo(param1.currentTarget).removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleLoadingError);
         LoaderInfo(param1.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR,this.handleLoadingError);
         LoaderInfo(param1.currentTarget).removeEventListener(Event.INIT,this.skinLoaded);
      }
      
      public function setScreen(param1:BaseIPhone2Screen) : void
      {
         if(this.screen)
         {
            this.disposeScreen(this.screen);
         }
         this.disposeTask();
         this.addToPh(param1);
      }
      
      private function addToPh(param1:BaseIPhone2Screen) : void
      {
         this.screen = param1;
         this.ph.addChild(param1);
      }
      
      private function get busy() : Boolean
      {
         return !!this.task && this.task.running;
      }
   }
}

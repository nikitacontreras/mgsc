package com.qb9.gaturro.view.minigames
{
   import com.qb9.flashlib.utils.StringUtil;
   import com.qb9.gaturro.GameData;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.world.minigames.Minigame;
   import com.qb9.mambo.view.MamboView;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.system.Security;
   
   public class MinigameView extends MamboView
   {
      
      public static const LOCAL_URL:String = "../../games/{0}/client/deploy/Game.swf";
       
      
      protected var swf:LoaderInfo;
      
      private var swfDisposed:Boolean = false;
      
      protected var minigame:Minigame;
      
      private var launched:Boolean = false;
      
      private const LAUCHING_BY_PROGRESS_DELAY:int = 1500;
      
      public function MinigameView(param1:Minigame)
      {
         super();
         this.minigame = param1;
         this.init();
      }
      
      private function loadFailed(param1:Event) : void
      {
         logger.warning("Loading failed for minigame",this.minigame.name,":",param1["text"]);
         this.minigame.finished();
      }
      
      private function gameFinished(param1:Event) : void
      {
         this.minigame.finished();
      }
      
      protected function init() : void
      {
         Security.allowDomain("*");
         Security.allowInsecureDomain("*");
         var _loc1_:Loader = new Loader();
         this.swf = _loc1_.contentLoaderInfo;
         this.swf.addEventListener(Event.INIT,this.gameAlmostLoaded);
         this.swf.addEventListener(Event.COMPLETE,this.gameLoaded);
         this.swf.addEventListener(ProgressEvent.PROGRESS,this.gameProgress);
         this.swf.addEventListener(IOErrorEvent.IO_ERROR,this.loadFailed);
         this.swf.addEventListener(IOErrorEvent.NETWORK_ERROR,this.loadFailed);
         this.swf.addEventListener(IOErrorEvent.DISK_ERROR,this.loadFailed);
         this.swf.addEventListener(IOErrorEvent.VERIFY_ERROR,this.loadFailed);
         this.swf.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.loadFailed);
         var _loc2_:String = this.url + "?" + GameData.VERSION.split(".").pop();
         logger.info("Loading the minigame",this.minigame.name," // Trying to load ",_loc2_);
         _loc1_.load(new URLRequest(_loc2_),new LoaderContext(false,new ApplicationDomain()));
      }
      
      private function cleanEvents() : void
      {
         this.swf.removeEventListener(Event.INIT,this.gameAlmostLoaded);
         this.swf.removeEventListener(Event.COMPLETE,this.gameLoaded);
         this.swf.removeEventListener(ProgressEvent.PROGRESS,this.gameProgress);
         this.swf.removeEventListener(IOErrorEvent.IO_ERROR,this.loadFailed);
         this.swf.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.loadFailed);
         this.swf.removeEventListener(IOErrorEvent.NETWORK_ERROR,this.loadFailed);
         this.swf.removeEventListener(IOErrorEvent.DISK_ERROR,this.loadFailed);
         this.swf.removeEventListener(IOErrorEvent.VERIFY_ERROR,this.loadFailed);
      }
      
      private function gameLoaded(param1:Event = null) : void
      {
         if(this.launched)
         {
            logger.debug("gameLoaded --> YA FUE LANZADO");
            return;
         }
         this.launched = true;
         logger.debug("The Minigame",this.minigame.name,"was loaded successfully");
         this.events.addEventListener(Event.INIT,this.gameStarted);
         this.events.addEventListener(Event.ADDED,this.addReward);
         this.events.addEventListener(Event.CLOSE,this.gameFinished);
         addChildAt(this.game,0);
         this.initializeGame(this.game);
      }
      
      override public function dispose() : void
      {
         if(disposed)
         {
            return;
         }
         this.cleanEvents();
         this.events.removeEventListener(Event.INIT,this.gameStarted);
         this.events.removeEventListener(Event.ADDED,this.addReward);
         this.events.removeEventListener(Event.CLOSE,this.gameFinished);
         if(this.minigame.active)
         {
            this.disposeGame();
         }
         this.swf = null;
         this.minigame = null;
         super.dispose();
      }
      
      private function get events() : EventDispatcher
      {
         return this.swf.sharedEvents;
      }
      
      protected function initializeGame(param1:Object) : void
      {
         if("initialize" in param1)
         {
            param1.initialize(this.minigame.userData,null,this.minigame.roomId);
         }
      }
      
      private function gameAlmostLoaded(param1:Event) : void
      {
         logger.debug("File",this.url,"was found and is being loaded");
      }
      
      private function getRewardFromEvent(param1:Event) : Object
      {
         return "reward" in param1 ? param1["reward"] : null;
      }
      
      private function gameStarted(param1:Event) : void
      {
         this.minigame.started();
      }
      
      private function addReward(param1:Event) : void
      {
         this.minigame.addReward(this.getRewardFromEvent(param1));
      }
      
      private function disposeGame() : void
      {
         if(this.swfDisposed)
         {
            return;
         }
         this.swfDisposed = true;
         try
         {
            Object(this.game).dispose();
         }
         catch(err:Error)
         {
            logger.warning("MinigameView > Error >",err.message);
         }
      }
      
      private function get game() : DisplayObjectContainer
      {
         return !!this.swf ? this.swf.content as DisplayObjectContainer : null;
      }
      
      private function get url() : String
      {
         var _loc1_:String = !!settings.debug.localMinigames ? LOCAL_URL : String(settings.connection.minigamesURL);
         return StringUtil.format(_loc1_,this.minigame.name);
      }
      
      private function gameProgress(param1:ProgressEvent) : void
      {
      }
   }
}

package com.qb9.gaturro.view.components.banner.gatubers
{
   import com.adobe.serialization.json.JSON;
   import com.qb9.flashlib.config.Settings;
   import com.qb9.flashlib.net.LoadFile;
   import com.qb9.flashlib.net.LoadFileFormat;
   import com.qb9.flashlib.net.LoadFileParsers;
   import com.qb9.flashlib.security.SafeNumber;
   import com.qb9.flashlib.tasks.TaskEvent;
   import com.qb9.flashlib.tasks.TaskRunner;
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.net.requests.URLUtil;
   import com.qb9.gaturro.service.events.EventData;
   import com.qb9.gaturro.view.gui.banner.properties.IHasRoomAPI;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   
   public class GatubersLiveBanner extends InstantiableGuiModal implements IHasRoomAPI
   {
       
      
      public var creating:MovieClip;
      
      public var totalPrice:SafeNumber;
      
      public var billMenu:MovieClip;
      
      public var publishMenu:MovieClip;
      
      public var publish:com.qb9.gaturro.view.components.banner.gatubers.Publish;
      
      public var readyClip:MovieClip;
      
      public var duration:com.qb9.gaturro.view.components.banner.gatubers.Duration;
      
      public var taskRunner:TaskRunner;
      
      private var currentState:com.qb9.gaturro.view.components.banner.gatubers.BannerState;
      
      public var api:GaturroRoomAPI;
      
      public var result:EventData;
      
      public var durationsMenu:MovieClip;
      
      public var createVideo:com.qb9.gaturro.view.components.banner.gatubers.GoLive;
      
      public var settings:Settings;
      
      public var information:TextField;
      
      private var asset:MovieClip;
      
      public var typeMenu:MovieClip;
      
      public var type:com.qb9.gaturro.view.components.banner.gatubers.BackgroundType;
      
      public var billing:com.qb9.gaturro.view.components.banner.gatubers.Billing;
      
      public var action:MovieClip;
      
      public function GatubersLiveBanner()
      {
         this.settings = new Settings();
         super("GatubersLiveBanner","GatubersLiveBanner");
      }
      
      public function switchState(param1:com.qb9.gaturro.view.components.banner.gatubers.BannerState) : void
      {
         if(this.currentState)
         {
            this.currentState.exit();
         }
         this.currentState = param1;
         this.currentState.enter();
      }
      
      override protected function ready() : void
      {
         this.taskRunner = new TaskRunner(this);
         this.taskRunner.start();
         this.result = new EventData();
         this.totalPrice = new SafeNumber(0);
         LoadFileParsers.registerParser(LoadFileFormat.JSON,com.adobe.serialization.json.JSON.decode);
         var _loc1_:String = URLUtil.getUrl("cfgs/banners/GatubersLiveBanner.json");
         var _loc2_:LoadFile = new LoadFile(_loc1_,"json");
         this.settings.addFile(_loc2_);
         _loc2_.addEventListener(TaskEvent.COMPLETE,this.onSettingsLoaded);
         this.taskRunner.add(_loc2_);
      }
      
      private function setupDisplay() : void
      {
         this.asset = view as MovieClip;
         this.readyClip = this.asset.ready;
         this.creating = this.asset.creating;
         this.information = this.asset.information;
         this.typeMenu = this.asset.typeMenu;
         this.billMenu = this.asset.bill;
         this.durationsMenu = this.asset.durations;
         this.action = this.asset.action;
         this.publishMenu = this.asset.publish;
      }
      
      override protected function onAssetReady() : void
      {
         this.setupDisplay();
         this.hideAll();
      }
      
      public function set roomAPI(param1:GaturroRoomAPI) : void
      {
         this.api = param1;
      }
      
      public function addExpense(param1:int) : void
      {
         this.totalPrice.value += param1;
         logger.debug(this,"currentPrice: ",this.totalPrice.value);
      }
      
      private function onSettingsLoaded(param1:Event = null) : void
      {
         this.configure();
         this.type = new com.qb9.gaturro.view.components.banner.gatubers.BackgroundType(this);
         this.duration = new com.qb9.gaturro.view.components.banner.gatubers.Duration(this);
         this.publish = new com.qb9.gaturro.view.components.banner.gatubers.Publish(this);
         this.billing = new com.qb9.gaturro.view.components.banner.gatubers.Billing(this);
         this.createVideo = new com.qb9.gaturro.view.components.banner.gatubers.GoLive(this);
         this.switchState(this.type);
      }
      
      private function configure(param1:Event = null) : void
      {
         logger.debug(this,"configure()");
         this.result.host = this.api.user.username;
      }
      
      public function hideAll() : void
      {
         this.readyClip.visible = false;
         this.creating.visible = false;
         this.information.visible = false;
         this.typeMenu.visible = false;
         this.billMenu.visible = false;
         this.durationsMenu.visible = false;
         this.action.visible = false;
         this.publishMenu.visible = false;
      }
   }
}

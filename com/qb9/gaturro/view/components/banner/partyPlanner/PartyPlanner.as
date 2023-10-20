package com.qb9.gaturro.view.components.banner.partyPlanner
{
   import com.adobe.serialization.json.JSON;
   import com.qb9.flashlib.config.Settings;
   import com.qb9.flashlib.net.LoadFile;
   import com.qb9.flashlib.net.LoadFileFormat;
   import com.qb9.flashlib.net.LoadFileParsers;
   import com.qb9.flashlib.tasks.TaskEvent;
   import com.qb9.flashlib.tasks.TaskRunner;
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.net.requests.URLUtil;
   import com.qb9.gaturro.service.events.EventData;
   import com.qb9.gaturro.view.gui.banner.properties.IHasRoomAPI;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class PartyPlanner extends InstantiableGuiModal implements IHasRoomAPI
   {
       
      
      private var _roomAPI:GaturroRoomAPI;
      
      public var billMenu:MovieClip;
      
      public var mateadaBackground:MovieClip;
      
      public var publish:com.qb9.gaturro.view.components.banner.partyPlanner.Publish;
      
      public var featuresPrice:Number;
      
      public var duration:com.qb9.gaturro.view.components.banner.partyPlanner.Duration;
      
      private var currentState:com.qb9.gaturro.view.components.banner.partyPlanner.BannerState;
      
      public var mateBackground:int = -1;
      
      public var publishMenu:MovieClip;
      
      public var prizesMenu:MovieClip;
      
      public var prizes:com.qb9.gaturro.view.components.banner.partyPlanner.Prizes;
      
      public var settings:Settings;
      
      public var taskRunner:TaskRunner;
      
      public var information:MovieClip;
      
      public var durationPrice:Number;
      
      public var typePrice:Number;
      
      public var result:EventData;
      
      public var action:MovieClip;
      
      public var prizesPrice:Number = 0;
      
      public var typeMenu:MovieClip;
      
      public var features:com.qb9.gaturro.view.components.banner.partyPlanner.Features;
      
      public var type:com.qb9.gaturro.view.components.banner.partyPlanner.PartyType;
      
      public var decorations:MovieClip;
      
      public var createParty:com.qb9.gaturro.view.components.banner.partyPlanner.CreateParty;
      
      public var featuresMenu:MovieClip;
      
      public var givingPrizes:int = -1;
      
      public var matesBck:com.qb9.gaturro.view.components.banner.partyPlanner.Mateada;
      
      public var durationsMenu:MovieClip;
      
      private var asset:MovieClip;
      
      public var billing:com.qb9.gaturro.view.components.banner.partyPlanner.Billing;
      
      public var mateBackgroundPrice:Number = 0;
      
      public function PartyPlanner()
      {
         this.settings = new Settings();
         this.result = new EventData();
         super("ConfigurablePartyPlannerBanner","ConfigurablePartyPlannerBannerAsset");
      }
      
      override public function close() : void
      {
         if(this.currentState != this.createParty)
         {
            this.earlyQuit();
         }
         super.close();
      }
      
      override protected function ready() : void
      {
         super.ready();
         this.taskRunner = new TaskRunner(this);
         this.taskRunner.start();
         this.asset = view as MovieClip;
         this.configure();
         LoadFileParsers.registerParser(LoadFileFormat.JSON,com.adobe.serialization.json.JSON.decode);
         var _loc1_:String = URLUtil.getUrl("cfgs/banners/PartyPlanner.json");
         var _loc2_:LoadFile = new LoadFile(_loc1_,"json");
         this.settings.addFile(_loc2_);
         _loc2_.addEventListener(TaskEvent.COMPLETE,this.onSettingsLoaded);
         this.taskRunner.add(_loc2_);
      }
      
      public function switchState(param1:com.qb9.gaturro.view.components.banner.partyPlanner.BannerState) : void
      {
         if(this.currentState)
         {
            this.currentState.exit();
         }
         this.currentState = param1;
         this.currentState.enter();
      }
      
      private function onSettingsLoaded(param1:Event = null) : void
      {
         this.type = new com.qb9.gaturro.view.components.banner.partyPlanner.PartyType(this);
         this.duration = new com.qb9.gaturro.view.components.banner.partyPlanner.Duration(this);
         this.features = new com.qb9.gaturro.view.components.banner.partyPlanner.Features(this);
         this.prizes = new com.qb9.gaturro.view.components.banner.partyPlanner.Prizes(this);
         this.matesBck = new com.qb9.gaturro.view.components.banner.partyPlanner.Mateada(this);
         this.publish = new com.qb9.gaturro.view.components.banner.partyPlanner.Publish(this);
         this.billing = new com.qb9.gaturro.view.components.banner.partyPlanner.Billing(this);
         this.createParty = new com.qb9.gaturro.view.components.banner.partyPlanner.CreateParty(this);
         this.switchState(this.type);
      }
      
      private function earlyQuit(param1:Event = null) : void
      {
         api.trackEvent("FIESTAS:PLANNER_BANNER","EARLY_EXIT");
      }
      
      public function total() : Number
      {
         return this.typePrice + this.durationPrice + this.featuresPrice + this.prizesPrice;
      }
      
      private function configure(param1:Event = null) : void
      {
         logger.info(this,"ready()");
         this.information = this.asset.information;
         this.typeMenu = this.asset.typeMenu;
         this.durationsMenu = this.asset.durations;
         this.featuresMenu = this.asset.features;
         this.billMenu = this.asset.bill;
         this.prizesMenu = this.asset.prizesMenu;
         this.mateadaBackground = this.asset.mateadaBackground;
         this.action = this.asset.action;
         this.decorations = this.asset.decorations;
         this.publishMenu = this.asset.publish;
         this.result.host = api.user.username;
         this.hideAll();
      }
      
      public function set roomAPI(param1:GaturroRoomAPI) : void
      {
         this._roomAPI = param1;
      }
      
      public function hideAll() : void
      {
         this.information.visible = false;
         this.typeMenu.visible = false;
         this.featuresMenu.visible = false;
         this.prizesMenu.visible = false;
         this.mateadaBackground.visible = false;
         this.billMenu.visible = false;
         this.durationsMenu.visible = false;
         this.action.visible = false;
         this.decorations.visible = false;
         this.publishMenu.visible = false;
      }
   }
}

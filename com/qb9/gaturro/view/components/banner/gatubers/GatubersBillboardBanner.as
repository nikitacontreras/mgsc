package com.qb9.gaturro.view.components.banner.gatubers
{
   import com.qb9.flashlib.utils.ArrayUtil;
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.event.ContextEvent;
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.net.metrics.Telemetry;
   import com.qb9.gaturro.service.events.EventData;
   import com.qb9.gaturro.service.events.EventsService;
   import com.qb9.gaturro.service.events.billboard.BillboardService;
   import com.qb9.gaturro.service.events.roomviews.EventsRoomsEnum;
   import com.qb9.gaturro.view.gui.banner.properties.IHasRoomAPI;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class GatubersBillboardBanner extends InstantiableGuiModal implements IHasRoomAPI
   {
       
      
      private var _roomAPI:GaturroRoomAPI;
      
      private var lastPage:int = 0;
      
      private var slotsNames:Array;
      
      private const ITEMS_PER_PAGE:int = 6;
      
      private const LAST_PAGE:int = 3;
      
      private var eventsService:EventsService;
      
      private const MAX_LINKS:int = 5;
      
      private var currentPage:int = 0;
      
      private var asset:MovieClip;
      
      private var slots:Array;
      
      private var billboardService:BillboardService;
      
      private var activeVideos:Array;
      
      public function GatubersBillboardBanner()
      {
         this.slotsNames = ["slot_0","slot_1","slot_2","slot_3","slot_4","slot_5"];
         this.slots = [];
         super("GatubersBillboardBanner","GatubersBillboardBannerAsset");
      }
      
      private function goDown(param1:MouseEvent) : void
      {
         this.currentPage = this.currentPage + 1 > this.lastPage ? this.lastPage : this.currentPage + 1;
         this.populatePage(this.currentPage);
      }
      
      public function set roomAPI(param1:GaturroRoomAPI) : void
      {
         this._roomAPI = param1;
      }
      
      private function randomLinks() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:int = 0;
         while(_loc2_ < this.MAX_LINKS)
         {
            if(this.activeVideos.length < 1)
            {
               return _loc1_;
            }
            _loc1_.push(ArrayUtil.popChoice(this.activeVideos));
            _loc2_++;
         }
         return _loc1_;
      }
      
      private function onServiceAdded(param1:ContextEvent = null) : void
      {
         var _loc2_:String = null;
         if(!param1 || param1.instanceType == EventsService)
         {
            Context.instance.removeEventListener(ContextEvent.ADDED,this.onServiceAdded);
            this.eventsService = Context.instance.getByType(EventsService) as EventsService;
            this.billboardService = this.eventsService.billboardService;
         }
         this.asset["noParties"].visible = false;
         for each(_loc2_ in this.slotsNames)
         {
            this.slots.push(this.asset[_loc2_] as MovieClip);
         }
         this.getEventsData();
         if(this.activeVideos.length == 0)
         {
            this.noVideos();
            Telemetry.getInstance().trackEvent("GATUBERS:TABLON","noStreams");
            return;
         }
         this.asset["scrollBtns"].up.addEventListener(MouseEvent.CLICK,this.goUp);
         this.asset["scrollBtns"].down.addEventListener(MouseEvent.CLICK,this.goDown);
         var _loc3_:int = int(this.activeVideos.length / this.ITEMS_PER_PAGE);
         this.lastPage = _loc3_ >= this.LAST_PAGE ? this.LAST_PAGE : _loc3_;
         this.populatePage(0);
         Telemetry.getInstance().trackEvent("GATUBERS:TABLON","open");
      }
      
      private function getEventsData() : void
      {
         this.activeVideos = this.billboardService.getActiveEvents();
      }
      
      override protected function ready() : void
      {
         super.ready();
         this.asset = view as MovieClip;
         if(Context.instance.getByType(EventsService))
         {
            this.onServiceAdded();
         }
         else
         {
            Context.instance.addEventListener(ContextEvent.ADDED,this.onServiceAdded);
         }
      }
      
      private function populatePage(param1:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:MovieClip = null;
         var _loc5_:EventData = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.slots.length)
         {
            _loc3_ = _loc2_ + param1 * this.ITEMS_PER_PAGE;
            (_loc4_ = this.asset[this.slotsNames[_loc2_]] as MovieClip).alpha = 0;
            if(this.activeVideos[_loc3_])
            {
               _loc5_ = this.activeVideos[_loc3_] as EventData;
               _loc4_.data = _loc5_;
               (_loc4_.partyHost as TextField).text = _loc5_.host;
               (_loc4_.icon as MovieClip).gotoAndStop(EventsRoomsEnum.getGatubersType(_loc5_.roomID));
               _loc4_.alpha = 1;
               _loc4_.addEventListener(MouseEvent.CLICK,this.onButtonClicked);
            }
            _loc2_++;
         }
         this.asset["page"].text = "" + (param1 + 1) + "/" + (this.lastPage + 1);
      }
      
      private function goUp(param1:MouseEvent) : void
      {
         this.currentPage = this.currentPage - 1 < 0 ? 0 : this.currentPage - 1;
         this.populatePage(this.currentPage);
      }
      
      private function noVideos() : void
      {
         var _loc2_:MovieClip = null;
         this.asset["noParties"].visible = true;
         this.asset["scrollBtns"].visible = false;
         this.asset["page"].text = "";
         var _loc1_:int = 0;
         while(_loc1_ < this.slots.length)
         {
            _loc2_ = this.asset[this.slotsNames[_loc1_]] as MovieClip;
            _loc2_.alpha = 0;
            _loc1_++;
         }
      }
      
      private function onButtonClicked(param1:MouseEvent = null) : void
      {
         this.eventsService.links = this.randomLinks();
         api.trackEvent("GATUBERS:TABLON","ir_a_canal");
         var _loc2_:EventData = (param1.currentTarget as MovieClip).data as EventData;
         logger.debug(this,_loc2_.remainingTime);
         if(_loc2_.remainingTime < 10000)
         {
            api.showModal("ESE VIDEO YA NO ESTÁ DISPONIBLE","information","¡LO SENTIMOS!");
         }
         else
         {
            api.inviteToParty(_loc2_.asJSONString());
         }
      }
   }
}

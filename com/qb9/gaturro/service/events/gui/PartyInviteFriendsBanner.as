package com.qb9.gaturro.service.events.gui
{
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.event.ContextEvent;
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.net.metrics.Telemetry;
   import com.qb9.gaturro.service.events.EventData;
   import com.qb9.gaturro.service.events.EventsAttributeEnum;
   import com.qb9.gaturro.service.events.EventsService;
   import com.qb9.gaturro.view.gui.banner.properties.IHasRoomAPI;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import com.qb9.gaturro.world.community.Buddy;
   import com.qb9.gaturro.world.community.CommunityManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   
   public class PartyInviteFriendsBanner extends InstantiableGuiModal implements IHasRoomAPI
   {
       
      
      protected var _roomAPI:GaturroRoomAPI;
      
      private var pages:int = 10;
      
      private var lastPage:int = 0;
      
      private var btnNames:Array;
      
      private var friends:Array;
      
      private const ITEMS_PER_PAGE:int = 8;
      
      private const LAST_PAGE:int = 10;
      
      private var currentPage:int = 0;
      
      private var asset:MovieClip;
      
      public function PartyInviteFriendsBanner(param1:String = "PartyInviteFriends", param2:String = "PartyInviteFriendsAsset")
      {
         this.btnNames = ["btn_1","btn_2","btn_3","btn_4","btn_5","btn_6","btn_7","btn_8"];
         this.friends = [];
         super(param1,param2);
      }
      
      protected function onInviteFriend(param1:MouseEvent) : void
      {
         logger.debug(this,"sending mail");
         var _loc2_:EventsService = Context.instance.getByType(EventsService) as EventsService;
         var _loc3_:String = !!_loc2_.eventData ? _loc2_.eventData.asJSONString() : null;
         if(_loc3_)
         {
            (param1.currentTarget as MovieClip).removeEventListener(MouseEvent.CLICK,this.onInviteFriend);
            (param1.currentTarget as MovieClip).removeEventListener(MouseEvent.MOUSE_OVER,this.onOver);
            (param1.currentTarget as MovieClip).removeEventListener(MouseEvent.MOUSE_OUT,this.onOut);
            (param1.currentTarget as MovieClip).gotoAndStop("click");
            this.sendMail((param1.currentTarget as MovieClip).data,_loc3_);
            Telemetry.getInstance().trackEvent("FIESTAS:INVITER","MAIL_INVITATION_SENT");
         }
      }
      
      public function set roomAPI(param1:GaturroRoomAPI) : void
      {
         this._roomAPI = param1;
      }
      
      private function onServiceAdded(param1:ContextEvent = null) : void
      {
         var e:ContextEvent = param1;
         if(!e || e.instanceType == EventsService)
         {
            Context.instance.removeEventListener(ContextEvent.ADDED,this.onServiceAdded);
         }
         this.asset["prev"].addEventListener(MouseEvent.CLICK,this.goUp);
         this.asset["next"].addEventListener(MouseEvent.CLICK,this.goDown);
         user.community.addEventListener(CommunityManager.BUDDIES_LOADED,function(param1:Event):void
         {
            param1.currentTarget.removeEventListener(param1.type,arguments.callee);
            findLastPage();
            setTimeout(populatePage,1000);
         });
         user.community.getBuddiesList();
         this.friends = user.community.buddies;
      }
      
      protected function onOver(param1:MouseEvent) : void
      {
         (param1.currentTarget as MovieClip).gotoAndStop("over");
      }
      
      private function populatePage(param1:int = 0) : void
      {
         var _loc3_:int = 0;
         var _loc4_:MovieClip = null;
         if(!this.friends || this.friends.length == 0)
         {
            this.asset.gotoAndStop("noFriends");
            return;
         }
         this.asset.gotoAndStop("friends");
         var _loc2_:int = 0;
         while(_loc2_ < this.btnNames.length)
         {
            _loc3_ = _loc2_ + param1 * this.ITEMS_PER_PAGE;
            (_loc4_ = this.asset[this.btnNames[_loc2_]] as MovieClip).alpha = 0;
            if(this.friends[_loc3_])
            {
               this.configBtn(_loc4_,this.friends[_loc3_]);
            }
            _loc2_++;
         }
         this.asset["page"].text = "" + (param1 + 1) + "/" + this.pages;
      }
      
      private function findLastPage() : void
      {
         var _loc1_:int = int(Math.ceil(this.friends.length / this.ITEMS_PER_PAGE));
         this.pages = _loc1_ > this.LAST_PAGE ? this.LAST_PAGE : _loc1_;
         this.lastPage = _loc1_ - 1 < 0 ? 0 : _loc1_ - 1;
         logger.debug(this,this.friends.length);
         logger.debug(this,this.pages);
         logger.debug(this,this.lastPage);
      }
      
      override protected function ready() : void
      {
         super.ready();
         this.asset = view as MovieClip;
         this.asset.gotoAndStop("loading");
         if(Context.instance.getByType(EventsService))
         {
            this.onServiceAdded();
         }
         else
         {
            Context.instance.addEventListener(ContextEvent.ADDED,this.onServiceAdded);
         }
      }
      
      private function sendMail(param1:String, param2:String) : void
      {
         var _loc3_:EventData = EventData.fromString(param2);
         if(_loc3_.type == EventsAttributeEnum.SERETUBERS)
         {
            api.roomView.gaturroMailer.sendMail(param1,api.user.username + " está transmitiendo en vivo ahora|" + param2,"SERETUBERS EN VIVO");
         }
         else if(_loc3_.type == EventsAttributeEnum.GATUBERS_LIVE)
         {
            api.roomView.gaturroMailer.sendMail(param1,api.user.username + " está transmitiendo en vivo ahora|" + param2,"GATUBERS EN VIVO");
         }
         else
         {
            api.roomView.gaturroMailer.sendMail(param1,api.user.username + " te invito a su fiesta|" + param2,"TE INVITARON A UNA FIESTA");
         }
      }
      
      override public function dispose() : void
      {
         this.currentPage = 0;
         super.dispose();
      }
      
      protected function onOut(param1:MouseEvent) : void
      {
         (param1.currentTarget as MovieClip).gotoAndStop("idle");
      }
      
      protected function goDown(param1:MouseEvent) : void
      {
         this.currentPage = this.currentPage + 1 > this.lastPage ? 0 : this.currentPage + 1;
         this.populatePage(this.currentPage);
         logger.debug(this,param1.currentTarget,this.currentPage);
      }
      
      protected function goUp(param1:MouseEvent) : void
      {
         this.currentPage = this.currentPage - 1 < 0 ? this.lastPage : this.currentPage - 1;
         this.populatePage(this.currentPage);
         logger.debug(this,param1.currentTarget,this.currentPage);
      }
      
      private function configBtn(param1:MovieClip, param2:Buddy) : void
      {
         logger.debug(this,param1);
         param1.alpha = 1;
         param1.buddie.text = param2.username;
         param1.data = param2.username;
         param1.addEventListener(MouseEvent.CLICK,this.onInviteFriend);
         param1.addEventListener(MouseEvent.MOUSE_OVER,this.onOver);
         param1.addEventListener(MouseEvent.MOUSE_OUT,this.onOut);
         param1.mouseEnabled = true;
         param1.gotoAndStop("idle");
      }
   }
}

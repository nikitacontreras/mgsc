package com.qb9.gaturro.service.events.gui
{
   import assets.ActionsButtonMC;
   import assets.SideButtons;
   import com.qb9.flashlib.tasks.TaskRunner;
   import com.qb9.flashlib.tasks.Timeout;
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.service.events.EventData;
   import com.qb9.gaturro.service.events.EventsAttributeEnum;
   import com.qb9.gaturro.service.events.EventsService;
   import com.qb9.gaturro.service.events.roomviews.EventsRoomView;
   import com.qb9.gaturro.view.world.GaturroRoomView;
   import com.qb9.gaturro.view.world.avatars.Gaturro;
   import com.qb9.mambo.world.avatars.Avatar;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.utils.getDefinitionByName;
   import icon.*;
   
   public class EventsGui extends SideButtons
   {
       
      
      private var btnInvite:Object;
      
      private var btnCandle:Object;
      
      private var btnGivePrize:Object;
      
      private var btnSeretubersGo:Object;
      
      private var tasks:TaskRunner;
      
      private var menuMateada:Object;
      
      private var menuGatubers:Object;
      
      private var btnBouquet:Object;
      
      private var btnWeddingCake:Object;
      
      private var menuCarnaval:Object;
      
      private var btnInviteMateada:Object;
      
      private var btnPhoto:Object;
      
      private var btnCarnavalGo:Object;
      
      private var btnGiveMate:Object;
      
      private var btnMateadaGo:Object;
      
      private var menuSeretubers:Object;
      
      private var btnPinata:Object;
      
      private var btnInviteGoLive:Object;
      
      private var btnSendMail:Object;
      
      private var btnInviteCarnaval:Object;
      
      private var btnGoParty:Object;
      
      private var btndefs:Array;
      
      private var partyService:EventsService;
      
      private var menus:Object;
      
      private var btnInviteSeretubers:Object;
      
      public function EventsGui(param1:EventsService)
      {
         this.btnInvite = {
            "func":"invite",
            "icon":"icon.invite",
            "mode":"toggle"
         };
         this.btnGoParty = {
            "func":"goParty",
            "icon":"icon.gotoParty",
            "mode":"button"
         };
         this.btnSendMail = {
            "func":"sendMail",
            "icon":"icon.mail",
            "mode":"button"
         };
         this.btnCandle = {
            "func":"cake",
            "icon":"icon.cake",
            "mode":"trigger"
         };
         this.btnPinata = {
            "func":"pinata",
            "icon":"icon.pinata",
            "mode":"trigger"
         };
         this.btnWeddingCake = {
            "func":"weddingCake",
            "icon":"icon.weddingCake",
            "mode":"trigger"
         };
         this.btnBouquet = {
            "func":"bouquet",
            "icon":"icon.bouquet",
            "mode":"trigger"
         };
         this.btnGivePrize = {
            "func":"givePrize",
            "icon":"icon.givePrize",
            "mode":"button"
         };
         this.btnPhoto = {
            "func":"photo",
            "icon":"icon.camera",
            "mode":"button"
         };
         this.btnInviteGoLive = {
            "func":"goParty",
            "icon":"icon.gotoGatuber",
            "mode":"button"
         };
         this.btnSeretubersGo = {
            "func":"goParty",
            "icon":"icon.goSeretuber",
            "mode":"button"
         };
         this.btnInviteSeretubers = {
            "func":"invite",
            "icon":"icon.InviteSeretuber",
            "mode":"toggle"
         };
         this.btnMateadaGo = {
            "func":"goParty",
            "icon":"icon.mateada",
            "mode":"button"
         };
         this.btnInviteMateada = {
            "func":"invite",
            "icon":"icon.inviteMateada",
            "mode":"toggle"
         };
         this.btnGiveMate = {
            "func":"giveMate",
            "icon":"icon.inviteMateada",
            "mode":"button"
         };
         this.btnCarnavalGo = {
            "func":"goParty",
            "icon":"icon.carnaval",
            "mode":"button"
         };
         this.btnInviteCarnaval = {
            "func":"invite",
            "icon":"icon.inviteCarnaval",
            "mode":"toggle"
         };
         this.menus = {
            "inviting":[{"btn":this.btnInvite},{"btn":this.btnGoParty},{"btn":this.btnSendMail}],
            "partyGuest":[{"btn":this.btnPhoto}],
            "birthday":[{"btn":this.btnPhoto},{
               "btn":this.btnCandle,
               "feature":0
            },{
               "btn":this.btnPinata,
               "feature":1
            }],
            "wedding":[{"btn":this.btnPhoto},{
               "btn":this.btnWeddingCake,
               "feature":0
            },{
               "btn":this.btnBouquet,
               "feature":1
            }],
            "elite":[{"btn":this.btnGivePrize}]
         };
         this.menuGatubers = {"inviting":[{"btn":this.btnInviteGoLive},{"btn":this.btnSendMail}]};
         this.menuSeretubers = {"inviting":[{"btn":this.btnInviteSeretubers},{"btn":this.btnSeretubersGo},{"btn":this.btnSendMail}]};
         this.menuMateada = {
            "inviting":[{"btn":this.btnInviteMateada},{"btn":this.btnMateadaGo}],
            "host":[{"btn":this.btnGiveMate},{"btn":this.btnSendMail}],
            "partyGuestInvited":[{"btn":this.btnMateadaGo}]
         };
         this.menuCarnaval = {
            "inviting":[{"btn":this.btnInviteCarnaval},{"btn":this.btnCarnavalGo},{"btn":this.btnSendMail}],
            "host":[],
            "partyGuestInvited":[]
         };
         this.btndefs = ["btn_0","btn_1","btn_2","btn_3"];
         super();
         logger.info(this,"PartyGui()");
         this.partyService = param1;
         this.tasks = new TaskRunner(this);
         this.tasks.start();
         this.menuSelector();
         this.reset();
      }
      
      private function givePrize(param1:MouseEvent) : void
      {
         api.instantiateBannerModal("PartyEliteWinnerSelectorBanner");
      }
      
      private function glow(param1:ActionsButtonMC) : void
      {
         param1.gotoAndStop("glow");
         var _loc2_:Timeout = new Timeout(param1.gotoAndStop,100,"on");
         this.tasks.add(_loc2_);
      }
      
      private function onPhoto(param1:MouseEvent) : void
      {
         api.showPhotoCamera(true);
         api.trackEvent("FIESTAS:BOTONERA:OWNER","triggerPhoto");
      }
      
      private function onPinata(param1:MouseEvent) : void
      {
         api.setAvatarAttribute("message","pinata");
         api.trackEvent("FIESTAS:BOTONERA:OWNER","triggerPinata");
      }
      
      private function showGuestInvitedMenu() : void
      {
         var _loc2_:int = 0;
         var _loc1_:Array = this.menus.partyGuestInvited;
         logger.debug(this,"showGuestInvitedMenu():");
         if(_loc1_)
         {
            _loc2_ = 0;
            while(_loc2_ < this.btndefs.length)
            {
               if(_loc1_[_loc2_])
               {
                  this.configureButton(this[this.btndefs[_loc2_]],_loc1_[_loc2_]);
               }
               _loc2_++;
            }
         }
      }
      
      private function btnClicked(param1:MouseEvent) : void
      {
         this.switchButtonState(param1.currentTarget as ActionsButtonMC);
         switch(param1.currentTarget.data.func)
         {
            case "invite":
               this.showBallon(param1);
               break;
            case "goParty":
               this.visitParty(param1);
               break;
            case "sendMail":
               this.inviteFriends(param1);
               break;
            case "cake":
               this.onCake(param1);
               break;
            case "pinata":
               this.onPinata(param1);
               break;
            case "photo":
               this.onPhoto(param1);
               break;
            case "weddingCake":
               this.onCake(param1);
               break;
            case "bouquet":
               this.onBouquet(param1);
               break;
            case "givePrize":
               this.givePrize(param1);
               break;
            case "givePrize":
               this.givePrize(param1);
               break;
            case "giveMate":
               this.giveMate(param1);
         }
      }
      
      private function showHostInviteMenu() : void
      {
         logger.info(this,"showHostMenu()");
         var _loc1_:Array = this.menus.inviting;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            this.configureButton(this[this.btndefs[_loc2_]],_loc1_[_loc2_]);
            _loc2_++;
         }
         var _loc3_:String = api.getAvatarAttribute("effect2") as String;
         if(Boolean(_loc3_) && _loc3_.indexOf("partyInvite") != -1)
         {
            this.switchButtonState(this["btn_0"]);
         }
      }
      
      private function onCake(param1:MouseEvent) : void
      {
         api.setAvatarAttribute("message","cake");
         api.trackEvent("FIESTAS:BOTONERA:OWNER","triggerTorta");
      }
      
      private function configureButton(param1:MovieClip, param2:Object) : void
      {
         if(param2.feature == null || this.partyService.eventData.feature(param2.feature))
         {
            param1.visible = true;
            this.addIconToBtn(param1,param2);
            param1.data = param2.btn;
         }
      }
      
      private function switchButtonState(param1:ActionsButtonMC) : void
      {
         switch(param1.data.mode)
         {
            case "toggle":
               this.toggle(param1);
               break;
            case "button":
               this.glow(param1);
               break;
            case "trigger":
               this.glow(param1);
               this.hide(param1);
         }
      }
      
      private function hide(param1:ActionsButtonMC) : void
      {
         var btn:ActionsButtonMC = param1;
         var to:Timeout = new Timeout(function():void
         {
            btn.visible = false;
         },200);
         this.tasks.add(to);
      }
      
      private function onBouquet(param1:MouseEvent) : void
      {
         var _loc5_:Avatar = null;
         var _loc6_:EventData = null;
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < api.avatars.length)
         {
            _loc5_ = api.avatars[_loc3_];
            if((_loc6_ = EventData.fromString(_loc5_.attributes.party as String)).host == api.user.username)
            {
               _loc2_.push(_loc5_);
            }
            _loc3_++;
         }
         var _loc4_:String = String(_loc2_[int(Math.random() * _loc2_.length)].username);
         api.setAvatarAttribute("message","ramo:" + _loc4_);
      }
      
      private function addIconToBtn(param1:MovieClip, param2:Object) : void
      {
         var _loc3_:Class = getDefinitionByName(param2.btn.icon) as Class;
         var _loc4_:Object = new _loc3_();
         while(param1.icon.numChildren > 0)
         {
            param1.icon.removeChildAt(0);
         }
         param1.icon.addChild(_loc4_);
      }
      
      public function configMenu(param1:GaturroRoomView) : void
      {
         logger.info(this,"configMenu()");
         this.reset();
         if(param1 is EventsRoomView)
         {
            if(this.partyService.imHost)
            {
               this.showPartyOwnerMenu(this.partyService.eventData.type);
            }
            else
            {
               this.showPartyGuestMenu(this.partyService.eventData.type);
            }
         }
         else if(this.partyService.imHost)
         {
            this.showHostInviteMenu();
         }
         else
         {
            this.showGuestInvitedMenu();
         }
      }
      
      private function inviteFriends(param1:MouseEvent) : void
      {
         api.instantiateBannerModal("PartyInviteFriendsBanner");
      }
      
      private function giveMate(param1:MouseEvent) : void
      {
         api.sendMessage("giveMate",{"id":api.user.username});
      }
      
      private function reset() : void
      {
         var _loc1_:String = null;
         for each(_loc1_ in this.btndefs)
         {
            this[_loc1_].buttonMode = true;
            this[_loc1_].gotoAndStop("on");
            this[_loc1_].visible = false;
            this[_loc1_].addEventListener(MouseEvent.CLICK,this.btnClicked);
         }
      }
      
      public function showPartyOwnerMenu(param1:String) : void
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         logger.info(this,"showPartyOwnerMenu: type ",param1);
         var _loc2_:int = 0;
         switch(param1)
         {
            case EventsAttributeEnum.BIRTHDAY_PARTY:
               _loc3_ = this.menus.birthday;
               _loc2_ = 0;
               while(_loc2_ < _loc3_.length)
               {
                  this.configureButton(this[this.btndefs[_loc2_]],_loc3_[_loc2_]);
                  _loc2_++;
               }
               break;
            case EventsAttributeEnum.WEDDING_PARTY:
               _loc4_ = this.menus.wedding;
               _loc2_ = 0;
               while(_loc2_ < _loc4_.length)
               {
                  this.configureButton(this[this.btndefs[_loc2_]],_loc4_[_loc2_]);
                  _loc2_++;
               }
               break;
            case EventsAttributeEnum.ELITE_PARTY:
               _loc5_ = this.menus.elite;
               _loc2_ = 0;
               while(_loc2_ < _loc5_.length)
               {
                  this.configureButton(this[this.btndefs[_loc2_]],_loc5_[_loc2_]);
                  _loc2_++;
               }
               break;
            case EventsAttributeEnum.MATEADA_PARTY:
               _loc6_ = this.menus.host;
               _loc2_ = 0;
               while(_loc2_ < _loc6_.length)
               {
                  this.configureButton(this[this.btndefs[_loc2_]],_loc6_[_loc2_]);
                  _loc2_++;
               }
               break;
            case EventsAttributeEnum.CARNAVAL_PARTY:
               _loc6_ = this.menus.host;
               _loc2_ = 0;
               while(_loc2_ < _loc6_.length)
               {
                  this.configureButton(this[this.btndefs[_loc2_]],_loc6_[_loc2_]);
                  _loc2_++;
               }
         }
      }
      
      private function toggle(param1:ActionsButtonMC) : void
      {
         if(param1.currentLabel == "glow")
         {
            param1.gotoAndStop("on");
            return;
         }
         if(param1.currentLabel == "on")
         {
            param1.gotoAndStop("glow");
            return;
         }
      }
      
      private function menuSelector() : void
      {
         switch(this.partyService.eventData.type)
         {
            case EventsAttributeEnum.GATUBERS_LIVE:
               this.menus = this.menuGatubers;
               break;
            case EventsAttributeEnum.SERETUBERS:
               this.menus = this.menuSeretubers;
               break;
            case EventsAttributeEnum.MATEADA_PARTY:
               this.menus = this.menuMateada;
               break;
            case EventsAttributeEnum.CARNAVAL_PARTY:
               this.menus = this.menuCarnaval;
         }
      }
      
      public function showPartyGuestMenu(param1:String) : void
      {
         var _loc3_:int = 0;
         logger.info(this,"showPartyGuestMenu: type ",param1);
         var _loc2_:Array = this.menus.partyGuest;
         if(_loc2_)
         {
            _loc3_ = 0;
            while(_loc3_ < this.btndefs.length)
            {
               if(_loc2_[_loc3_])
               {
                  this.configureButton(this[this.btndefs[_loc3_]],_loc2_[_loc3_]);
               }
               _loc3_++;
            }
         }
      }
      
      private function visitParty(param1:MouseEvent) : void
      {
         var _loc2_:EventsService = Context.instance.getByType(EventsService) as EventsService;
         api.trackEvent("FIESTAS:PARTY_GUI:CLICK_VISIT_MINE",api.user.username);
         var _loc3_:Timeout = new Timeout(_loc2_.gotoEvent,500);
         this.tasks.add(_loc3_);
      }
      
      private function showBallon(param1:MouseEvent) : void
      {
         logger.info(this,"showBillboard()");
         if((param1.currentTarget as MovieClip).currentLabel == "glow")
         {
            api.setAvatarAttribute(Gaturro.EFFECT2_KEY,"partyInvite");
            api.trackEvent("FIESTAS:PARTY_GUI:SHOW_INVITER",api.user.username);
         }
         else
         {
            api.setAvatarAttribute(Gaturro.EFFECT2_KEY,"");
            api.trackEvent("FIESTAS:PARTY_GUI:HIDE_INVITER",api.user.username);
         }
      }
   }
}

package com.qb9.gaturro.service.events.roomviews
{
   import com.adobe.serialization.json.JSON;
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.flashlib.utils.ArrayUtil;
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.event.ContextEvent;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.manager.counter.GaturroCounterManager;
   import com.qb9.gaturro.net.mail.GaturroMailer;
   import com.qb9.gaturro.net.metrics.Telemetry;
   import com.qb9.gaturro.service.events.EventData;
   import com.qb9.gaturro.service.events.EventsAttributeEnum;
   import com.qb9.gaturro.service.events.events.gatubers.GatubersLive;
   import com.qb9.gaturro.socialnet.messages.GaturroChatMessage;
   import com.qb9.gaturro.view.world.avatars.Gaturro;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.core.avatar.GaturroUserAvatar;
   import com.qb9.gaturro.world.reports.InfoReportQueue;
   import com.qb9.mambo.core.attributes.events.CustomAttributeEvent;
   import com.qb9.mambo.net.chat.ChatEvent;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import com.qb9.mambo.world.avatars.Avatar;
   import com.qb9.mambo.world.avatars.UserAvatar;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.Dictionary;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class GatubersRoomView extends EventsRoomView
   {
      
      public static const LIKE_GIVED_COUNTER_TYPE:String = "gatuberLikeGived";
      
      public static const SESSION_VIEW_PREFIX:String = "gatuberView";
      
      public static const VIEW_COUNTER_TYPE:String = "gatuberView";
      
      public static const LIKE_RECIVED_COUNTER_TYPE:String = "gatuberLikeRecived";
      
      public static const SESSION_LIKE_PREFIX:String = "gatuberLike";
       
      
      private var counterManager:GaturroCounterManager;
      
      private var btnLinkSet:Array;
      
      private var tubeGui:MovieClip;
      
      private var brillosBtn:SimpleButton;
      
      private var likeCountTF:TextField;
      
      private var progress:MovieClip;
      
      private var risasBtn:SimpleButton;
      
      private var initViewCount:int = 0;
      
      private var messageChangedHandlerMap:Dictionary;
      
      private var closeBtn:SimpleButton;
      
      private var likeBtn:MovieClip;
      
      private var papelitosBtn:SimpleButton;
      
      private var avatarSet:Array;
      
      private var viewCountTF:TextField;
      
      private var timeoutId:uint;
      
      private var vientosBtn:SimpleButton;
      
      private var initLikeCount:int = 0;
      
      private var _liveChatText:String;
      
      private var aplausosBtn:SimpleButton;
      
      private var nameHostTf:TextField;
      
      private var notifyCountIntervalId:uint;
      
      private var logo:MovieClip;
      
      private var videoData:MovieClip;
      
      private const MAX_LINKS:int = 5;
      
      private var suggestions:MovieClip;
      
      public function GatubersRoomView(param1:GaturroRoom, param2:TaskContainer, param3:InfoReportQueue, param4:GaturroMailer, param5:WhiteListNode)
      {
         super(param1,param3,param4,param5);
      }
      
      private function setupTextLike() : void
      {
         var _loc1_:int = 0;
         this.likeCountTF = this.tubeGui.getChildByName("likeCountTF") as TextField;
         if(eventsService.imHost)
         {
            _loc1_ = this.counterManager.getAmount(LIKE_RECIVED_COUNTER_TYPE);
            this.setLikeValue(_loc1_);
         }
      }
      
      private function triggerPapelitos() : void
      {
         this.tubeGui.papelitos.visible = true;
         setTimeout(this.hidePapelitos,6000);
         api.playSound("escenarioVip/asombro");
         api.setAvatarAttribute(Gaturro.ACTION_KEY,"vertical");
      }
      
      private function setupLikeBtn() : void
      {
         var _loc1_:String = null;
         var _loc2_:Object = null;
         this.likeBtn = this.tubeGui.getChildByName("likeBtn") as MovieClip;
         this.likeBtn.mouseChildren = false;
         if(!eventsService.imHost)
         {
            _loc1_ = SESSION_LIKE_PREFIX + eventsService.eventData.start;
            _loc2_ = api.getSession(_loc1_);
            if(!_loc2_)
            {
               this.likeBtn.addEventListener(MouseEvent.CLICK,this.onLikeClick);
               this.likeBtn.buttonMode = true;
               this.likeBtn.gotoAndStop("notLiked");
            }
            else
            {
               this.likeBtn.gotoAndStop("liked");
            }
         }
      }
      
      private function onBrillosClick(param1:MouseEvent) : void
      {
         this.encodeAndSetAttr("brillos",this.triggerBrillos);
      }
      
      private function removeLinkBtn() : void
      {
         var _loc1_:MovieClip = null;
         if(this.btnLinkSet)
         {
            for each(_loc1_ in this.btnLinkSet)
            {
               _loc1_.removeEventListener(MouseEvent.CLICK,this.gotoLink);
            }
         }
         this.btnLinkSet = null;
      }
      
      private function validateRoomId(param1:Number, param2:Array) : Boolean
      {
         var _loc3_:int = 0;
         while(_loc3_ < param2.length)
         {
            if(param2[_loc3_] == param1)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      private function onLikeClick(param1:MouseEvent) : void
      {
         if(!eventsService.imHost)
         {
            this.likeBtn.removeEventListener(MouseEvent.CLICK,this.onLikeClick);
            this.likeBtn.buttonMode = false;
            this.likeBtn.gotoAndStop("liked");
            this.giveLike();
         }
      }
      
      private function onRisasClick(param1:MouseEvent) : void
      {
         this.encodeAndSetAttr("risas",this.triggerRisas);
      }
      
      private function receiveLike() : void
      {
         this.counterManager.increase(LIKE_RECIVED_COUNTER_TYPE);
         var _loc1_:int = this.counterManager.getAmount(LIKE_RECIVED_COUNTER_TYPE);
         this.setLikeValue(_loc1_);
         this.broadcastCount(_loc1_);
      }
      
      private function exit() : void
      {
         api.changeRoomXY(51689089,6,7);
      }
      
      private function setupViewsTF() : void
      {
         this.viewCountTF = this.videoData.getChildByName("viewCountTF") as TextField;
         var _loc1_:int = eventsService.imHost ? this.counterManager.getAmount(VIEW_COUNTER_TYPE) : this.initViewCount;
         this.setViewCountValue(_loc1_);
      }
      
      private function triggerBrillos() : void
      {
         this.tubeGui.brillitos.visible = true;
         this.tubeGui.brillitos.gotoAndPlay(0);
         api.playSound("parqueDiversiones/escena_3");
         api.setAvatarAttribute(Gaturro.ACTION_KEY,"sit");
      }
      
      private function addMessage(param1:ChatEvent) : void
      {
         var _loc4_:GaturroUserAvatar = null;
         var _loc9_:int = 0;
         var _loc2_:GaturroChatMessage = param1.message as GaturroChatMessage;
         var _loc3_:Avatar = room.avatarByUsername(_loc2_.sender);
         _loc4_ = room.userAvatar as GaturroUserAvatar;
         var _loc5_:EventData = EventData.fromString(_loc3_.attributes[EventsAttributeEnum.EVENT_ATTR]);
         if(eventsService.eventData.host != _loc5_.host)
         {
            return;
         }
         if(eventsService.eventData.host == _loc3_.username)
         {
            return;
         }
         var _loc6_:* = _loc2_.sender + ": " + _loc2_.message + " \n";
         this._liveChatText += _loc6_;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         while(_loc7_ != -1)
         {
            _loc7_ = this._liveChatText.indexOf("\n",_loc7_ + 1);
            _loc8_++;
         }
         if(_loc8_ > 12)
         {
            _loc9_ = this._liveChatText.indexOf("\n") + 1;
            this._liveChatText = this._liveChatText.substr(_loc9_);
         }
         this.tubeGui.comments.commentsText.text = this._liveChatText;
         if(param1.type == ChatEvent.SENT)
         {
            api.trackEvent("GATUBERS:LIVE:COMMENT","");
         }
      }
      
      private function setViewCountValue(param1:int) : void
      {
         if(this.viewCountTF)
         {
            this.viewCountTF.text = !!param1 ? param1.toString() : "";
         }
      }
      
      private function onVientosClick(param1:MouseEvent) : void
      {
         this.encodeAndSetAttr("vientos",this.triggerVientos);
      }
      
      private function setupSuggestions() : void
      {
         var _loc3_:MovieClip = null;
         var _loc1_:Array = eventsService.links.concat();
         this.btnLinkSet = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < this.MAX_LINKS)
         {
            _loc3_ = this.suggestions["btn_" + _loc2_] as MovieClip;
            if(_loc1_.length > 0)
            {
               this.configureLinkButton(_loc3_,ArrayUtil.popChoice(_loc1_) as EventData);
            }
            else
            {
               _loc3_.visible = false;
            }
            _loc2_++;
         }
      }
      
      private function onClickLogo(param1:MouseEvent) : void
      {
         this.exit();
      }
      
      override public function dispose() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         chat.removeEventListener(ChatEvent.SENT,this.addMessage);
         chat.removeEventListener(ChatEvent.RECEIVED,this.addMessage);
         this.closeBtn.removeEventListener(MouseEvent.CLICK,this.onClickClose);
         this.logo.removeEventListener(MouseEvent.CLICK,this.onClickLogo);
         this.removeListenerActionBtn();
         this.removeLinkBtn();
         this.removeCustomAttrListener();
         Context.instance.removeEventListener(ContextEvent.ADDED,this.onAddedCounter);
         if(this.likeBtn)
         {
            this.likeBtn.removeEventListener(MouseEvent.CLICK,this.onLikeClick);
         }
         super.dispose();
      }
      
      private function notifyInitialLikeCount() : void
      {
         clearTimeout(this.notifyCountIntervalId);
         var _loc1_:int = this.counterManager.getAmount(LIKE_RECIVED_COUNTER_TYPE);
         var _loc2_:int = this.counterManager.getAmount(VIEW_COUNTER_TYPE);
         var _loc3_:Object = new Object();
         _loc3_.type = "initData";
         _loc3_.videoOwner = eventsService.eventData.host;
         _loc3_.likesCount = _loc1_;
         _loc3_.viewsCount = _loc2_;
         var _loc4_:String = com.adobe.serialization.json.JSON.encode(_loc3_);
         api.setAvatarAttribute("message",_loc4_);
      }
      
      override protected function kick() : void
      {
         api.showModal("SE HA TERMINADO EL STREAMING","information");
         this.timeoutId = setTimeout(this.doKick,1500);
      }
      
      private function giveLike() : void
      {
         api.trackEvent("GATUBERS:LIVE:LIKE","");
         this.counterManager.increase(LIKE_GIVED_COUNTER_TYPE);
         var _loc1_:Object = new Object();
         _loc1_.type = "like";
         _loc1_.videoOwner = eventsService.eventData.host;
         var _loc2_:String = com.adobe.serialization.json.JSON.encode(_loc1_);
         api.setAvatarAttribute("message",_loc2_);
         var _loc3_:String = SESSION_LIKE_PREFIX + eventsService.eventData.start;
         api.setSession(_loc3_,_loc3_);
      }
      
      private function configureLinkButton(param1:MovieClip, param2:EventData) : void
      {
         param1.title.text = param2.host.toUpperCase();
         param1.tn.gotoAndStop(EventsRoomsEnum.getGatubersType(param2.roomID));
         param1.data = param2;
         param1.addEventListener(MouseEvent.CLICK,this.gotoLink);
         param1.buttonMode = true;
         this.btnLinkSet.push(param1);
      }
      
      private function encodeAndSetAttr(param1:String, param2:Function) : void
      {
         var _loc3_:String = String(api.JSONEncode({
            "type":"hostAction",
            "action":param1
         }));
         api.setAvatarAttribute("message",_loc3_);
         param2();
      }
      
      private function onAddedCounter(param1:ContextEvent) : void
      {
         if(param1.instanceType == GaturroCounterManager)
         {
            Context.instance.removeEventListener(ContextEvent.ADDED,this.onAddedCounter);
            this.counterManager = Context.instance.getByType(GaturroCounterManager) as GaturroCounterManager;
         }
      }
      
      private function setupMesssageChangedHandlerMap() : void
      {
         this.messageChangedHandlerMap = new Dictionary();
         this.messageChangedHandlerMap["like"] = this.processLikeMessage;
         this.messageChangedHandlerMap["view"] = this.processViewMessage;
         this.messageChangedHandlerMap["viewCount"] = this.processViewCountMessage;
         this.messageChangedHandlerMap["likeCount"] = this.processLikeCountMessage;
         this.messageChangedHandlerMap["hostAction"] = this.processHostActionsMessage;
         this.messageChangedHandlerMap["initData"] = this.processInitDataMessage;
      }
      
      private function setupActionButton(param1:SimpleButton, param2:Function) : SimpleButton
      {
         param1.addEventListener(MouseEvent.CLICK,param2);
         return param1;
      }
      
      private function setupHostNameTF() : void
      {
         this.nameHostTf = this.videoData.getChildByName("nameHostTf") as TextField;
         this.nameHostTf.text = eventsService.eventData.host;
      }
      
      private function triggerVientos() : void
      {
         this.tubeGui.pedo.visible = true;
         api.playSound("parqueDiversiones/boing4");
         this.tubeGui.pedo.gotoAndPlay(0);
         setTimeout(api.playSound,1500,"escenarioVip/abucheo");
         api.setAvatarAttribute(Gaturro.ACTION_KEY,"laugh");
      }
      
      private function processInitDataMessage(param1:Object) : void
      {
         this.initViewCount = param1.viewsCount as int;
         this.initLikeCount = param1.likesCount as int;
         this.setViewCountValue(this.initViewCount);
         this.setLikeValue(this.initLikeCount);
      }
      
      private function onMessageChanged(param1:CustomAttributeEvent) : void
      {
         var _loc2_:Object = com.adobe.serialization.json.JSON.decode(String(param1.attribute.value));
         var _loc3_:Function = this.messageChangedHandlerMap[_loc2_.type];
         _loc3_(_loc2_);
      }
      
      private function doKick() : void
      {
         clearTimeout(this.timeoutId);
         api.changeRoomXY(51689089,10,10);
      }
      
      private function onPapelitosClick(param1:MouseEvent) : void
      {
         this.encodeAndSetAttr("papelitos",this.triggerPapelitos);
      }
      
      override protected function createAvatar(param1:Avatar) : DisplayObject
      {
         var _loc2_:DisplayObject = super.createAvatar(param1);
         var _loc3_:EventData = EventData.fromString(param1.attributes[EventsAttributeEnum.EVENT_ATTR]);
         if(_loc3_.host == eventsService.eventData.host && !(param1 is UserAvatar))
         {
            param1.addCustomAttributeListener("message",this.onMessageChanged);
            this.avatarSet.push(param1);
            if(eventsService.imHost)
            {
               this.notifyCountIntervalId = setTimeout(this.notifyInitialLikeCount,2000);
            }
            else
            {
               this.processView();
            }
         }
         if(api)
         {
            api.textMessageToGUI("EL USUARIO " + param1.username + " HA INGRESADO AL CANAL");
         }
         return _loc2_;
      }
      
      private function triggerRisas() : void
      {
         api.playSound("escenarioVip/risas");
         this.tubeGui.risas.visible = true;
         this.tubeGui.risas.gotoAndPlay(0);
         api.setAvatarAttribute(Gaturro.ACTION_KEY,"joke");
      }
      
      private function setupHostActions() : void
      {
         this.aplausosBtn = this.setupActionButton(this.tubeGui["hostActions"]["aplausos"],this.onAplausosClick);
         this.vientosBtn = this.setupActionButton(this.tubeGui["hostActions"]["vientos"],this.onVientosClick);
         this.papelitosBtn = this.setupActionButton(this.tubeGui["hostActions"]["papelitos"],this.onPapelitosClick);
         this.risasBtn = this.setupActionButton(this.tubeGui["hostActions"]["risas"],this.onRisasClick);
         this.brillosBtn = this.setupActionButton(this.tubeGui["hostActions"]["brillos"],this.onBrillosClick);
      }
      
      private function removeCustomAttrListener() : void
      {
         var _loc1_:Avatar = null;
         for each(_loc1_ in this.avatarSet)
         {
            _loc1_.removeCustomAttributeListener("message",this.onMessageChanged);
         }
         this.avatarSet = null;
      }
      
      private function setupChat() : void
      {
         this.chat.addEventListener(ChatEvent.SENT,this.addMessage);
         this.chat.addEventListener(ChatEvent.RECEIVED,this.addMessage);
      }
      
      override protected function setup() : void
      {
         super.setup();
         this.avatarSet = new Array();
         this.setupCounter();
         this.setupMesssageChangedHandlerMap();
         currentEvent = new GatubersLive(eventsService);
      }
      
      private function setupGui() : void
      {
         this.turnOffFXs();
         this.suggestions = this.tubeGui["suggestions"];
         this.tubeGui["comments"].commentsText.text = "";
         this._liveChatText = "";
         if(eventsService.imHost)
         {
            this.suggestions.visible = false;
            this.setupHostActions();
         }
         else
         {
            this.tubeGui["hostActions"].visible = false;
            this.setupSuggestions();
         }
         this.setupLogo();
         this.setupCloseBtn();
      }
      
      private function processLikeMessage(param1:Object) : void
      {
         if(eventsService.imHost && param1.videoOwner == api.user.username)
         {
            this.receiveLike();
         }
      }
      
      private function setupDisplay() : void
      {
         this.tubeGui = background["layer3"];
         addChild(this.tubeGui);
         this.setupVideoData();
         this.setupGui();
         this.setupLikeBtn();
         this.setupTextLike();
         this.setupProgress();
      }
      
      private function isHostStreaming() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:Avatar = null;
         if(Boolean(eventsService) && Boolean(eventsService.eventData))
         {
            _loc2_ = room.avatarByUsername(eventsService.eventData.host);
            if(_loc2_ == null)
            {
               return false;
            }
            _loc1_ = eventsService.eventData.host == _loc2_.username ? true : false;
         }
         return _loc1_;
      }
      
      override protected function addSceneObject(param1:RoomSceneObject) : void
      {
         var _loc2_:Avatar = null;
         var _loc3_:EventData = null;
         if(param1 is Avatar)
         {
            _loc2_ = param1 as Avatar;
            _loc3_ = EventData.fromString(_loc2_.attributes[EventsAttributeEnum.EVENT_ATTR]);
            if(eventsService.eventData.host != _loc3_.host)
            {
               return;
            }
         }
         super.addSceneObject(param1);
      }
      
      private function onClickClose(param1:MouseEvent) : void
      {
         this.exit();
      }
      
      private function onAplausosClick(param1:MouseEvent) : void
      {
         this.encodeAndSetAttr("aplausos",this.triggerAplausos);
      }
      
      override protected function finalInit() : void
      {
         logger.debug(this,room.attributes);
         logger.debug(this,room.id);
         logger.debug(this,room.name);
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         if(this.validateRoomId(room.id,EventsRoomsEnum.GATUBERS_1))
         {
            (background as MovieClip)["layer2"].gotoAndStop(1);
         }
         if(this.validateRoomId(room.id,EventsRoomsEnum.GATUBERS_2))
         {
            (background as MovieClip)["layer2"].gotoAndStop(2);
         }
         if(this.validateRoomId(room.id,EventsRoomsEnum.GATUBERS_3))
         {
            (background as MovieClip)["layer2"].gotoAndStop(3);
         }
         if(this.validateRoomId(room.id,EventsRoomsEnum.GATUBERS_4))
         {
            (background as MovieClip)["layer2"].gotoAndStop(4);
         }
         logger.debug(this,"addedEvent:");
         this.setupChat();
         this.setupDisplay();
         super.finalInit();
      }
      
      private function hidePapelitos() : void
      {
         this.tubeGui.papelitos.visible = false;
      }
      
      private function processView() : void
      {
         var _loc1_:String = SESSION_VIEW_PREFIX + eventsService.eventData.start;
         var _loc2_:Object = api.getSession(_loc1_);
         if(!_loc2_)
         {
            this.sendViewMessage();
            this.registerView();
         }
      }
      
      private function processViewMessage(param1:Object) : void
      {
         this.counterManager.increase(VIEW_COUNTER_TYPE);
         var _loc2_:int = this.counterManager.getAmount(VIEW_COUNTER_TYPE);
         this.setViewCountValue(_loc2_);
         this.sendViewCountMessage(_loc2_);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         if(!background)
         {
            return;
         }
         this.tubeGui.hostOffline.visible = !this.isHostStreaming();
         if(eventsService.eventData)
         {
            _loc2_ = eventsService.eventData.remainingTime / eventsService.eventData.duration;
            _loc3_ = 1 + 100 * (1 - _loc2_);
            this.progress.gotoAndStop(_loc3_);
         }
      }
      
      private function triggerAplausos() : void
      {
         this.tubeGui.aplausos.visible = true;
         api.playSound("escenarioVip/aplausos");
         this.tubeGui.aplausos.gotoAndPlay(0);
         api.setAvatarAttribute(Gaturro.ACTION_KEY,"celebrate");
      }
      
      private function setupCounter() : void
      {
         if(Context.instance.hasByType(GaturroCounterManager))
         {
            this.counterManager = Context.instance.getByType(GaturroCounterManager) as GaturroCounterManager;
         }
         else
         {
            Context.instance.addEventListener(ContextEvent.ADDED,this.onAddedCounter);
         }
      }
      
      private function setupVideoData() : void
      {
         this.videoData = this.tubeGui.getChildByName("videoData") as MovieClip;
         this.setupViewsTF();
         this.setupHostNameTF();
      }
      
      private function setupProgress() : void
      {
         this.progress = this.tubeGui["progress"] as MovieClip;
      }
      
      private function processViewCountMessage(param1:Object) : void
      {
         this.initViewCount = param1.count as int;
         this.setViewCountValue(this.initViewCount);
      }
      
      private function processLikeCountMessage(param1:Object) : void
      {
         this.setLikeValue(param1.count as int);
      }
      
      private function broadcastCount(param1:int) : void
      {
         var _loc2_:Object = new Object();
         _loc2_.type = "likeCount";
         _loc2_.videoOwner = eventsService.eventData.host;
         _loc2_.count = param1;
         var _loc3_:String = com.adobe.serialization.json.JSON.encode(_loc2_);
         api.setAvatarAttribute("message",_loc3_);
      }
      
      private function setupLogo() : void
      {
         this.logo = this.tubeGui["logo"] as MovieClip;
         this.logo.buttonMode = true;
         this.logo.addEventListener(MouseEvent.CLICK,this.onClickLogo);
      }
      
      private function removeListenerActionBtn() : void
      {
         if(this.aplausosBtn)
         {
            this.aplausosBtn.removeEventListener(MouseEvent.CLICK,this.onAplausosClick);
            this.vientosBtn.removeEventListener(MouseEvent.CLICK,this.onVientosClick);
            this.papelitosBtn.removeEventListener(MouseEvent.CLICK,this.onPapelitosClick);
            this.risasBtn.removeEventListener(MouseEvent.CLICK,this.onRisasClick);
            this.brillosBtn.removeEventListener(MouseEvent.CLICK,this.onBrillosClick);
         }
      }
      
      private function setLikeValue(param1:int = -1) : void
      {
         if(this.likeCountTF)
         {
            this.likeCountTF.text = param1 == -1 ? "1" : param1.toString();
         }
      }
      
      private function setupCloseBtn() : void
      {
         this.closeBtn = this.tubeGui["close"] as SimpleButton;
         this.closeBtn.addEventListener(MouseEvent.CLICK,this.onClickClose);
      }
      
      private function sendViewCountMessage(param1:int) : void
      {
         var _loc2_:Object = new Object();
         _loc2_.type = "viewCount";
         _loc2_.count = param1;
         var _loc3_:String = com.adobe.serialization.json.JSON.encode(_loc2_);
         api.setAvatarAttribute("message",_loc3_);
      }
      
      private function processHostActionsMessage(param1:Object) : void
      {
         switch(param1.action)
         {
            case "aplausos":
               this.triggerAplausos();
               break;
            case "vientos":
               this.triggerVientos();
               break;
            case "papelitos":
               this.triggerPapelitos();
               break;
            case "risas":
               this.triggerRisas();
               break;
            case "brillos":
               this.triggerBrillos();
         }
      }
      
      private function turnOffFXs() : void
      {
         this.tubeGui.papelitos.visible = false;
         this.tubeGui.risas.visible = false;
         this.tubeGui.pedo.visible = false;
         this.tubeGui.aplausos.visible = false;
         this.tubeGui.brillitos.visible = false;
      }
      
      private function registerView() : void
      {
         var _loc1_:String = SESSION_VIEW_PREFIX + eventsService.eventData.start;
         api.setSession(_loc1_,_loc1_);
      }
      
      private function sendViewMessage() : void
      {
         var _loc1_:Object = new Object();
         _loc1_.type = "view";
         _loc1_.videoOwner = eventsService.eventData.host;
         var _loc2_:String = com.adobe.serialization.json.JSON.encode(_loc1_);
         api.setAvatarAttribute("message",_loc2_);
      }
      
      private function gotoLink(param1:MouseEvent) : void
      {
         Telemetry.getInstance().trackEvent("GATUBERS:GOTO_LINK",param1.currentTarget.name);
         api.inviteToEvent((param1.currentTarget.data as EventData).asJSONString());
      }
   }
}

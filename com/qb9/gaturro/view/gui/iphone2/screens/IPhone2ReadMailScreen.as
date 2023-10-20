package com.qb9.gaturro.view.gui.iphone2.screens
{
   import assets.Iphone2ReadMC;
   import com.qb9.flashlib.lang.map;
   import com.qb9.flashlib.utils.StringUtil;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.globals.server;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.net.mail.GaturroMailMessage;
   import com.qb9.gaturro.net.metrics.Telemetry;
   import com.qb9.gaturro.service.events.EventData;
   import com.qb9.gaturro.service.events.EventsAttributeEnum;
   import com.qb9.gaturro.view.gui.iphone2.IPhone2Modal;
   import com.qb9.gaturro.whitelist.IPhoneWhiteListVariableReplacer;
   import com.qb9.gaturro.whitelist.WhiteListVariableReplacer;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import com.qb9.mambo.net.mail.MailMessage;
   import com.qb9.mambo.net.mail.Mailer;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public final class IPhone2ReadMailScreen extends BaseIPhone2Screen
   {
      
      private static const SCROLL_FACTOR:int = 1;
      
      private static const DAYS:Number = 1000 * 60 * 60 * 24;
      
      private static const MESSAGE_CROP_FOR_SCROLL:int = 24;
       
      
      private var mail:GaturroMailMessage;
      
      private var whitelist:WhiteListNode;
      
      private var mailer:Mailer;
      
      private var variables:WhiteListVariableReplacer;
      
      public function IPhone2ReadMailScreen(param1:IPhone2Modal, param2:Mailer, param3:MailMessage, param4:WhiteListNode)
      {
         super(param1,new Iphone2ReadMC(),{
            "username":this.gotoUser,
            "send":this.reply,
            "remove":this.deleteMessage,
            "up":this.scroll,
            "down":this.scroll
         });
         this.mailer = param2;
         this.mail = GaturroMailMessage(param3);
         this.whitelist = param4;
         this.variables = new IPhoneWhiteListVariableReplacer();
         this.init();
      }
      
      private function updatePagers() : void
      {
         setEnabled("arrows.up",this.messageField.scrollV > 1);
         setEnabled("arrows.down",this.atScrollEnd);
      }
      
      private function enableMessage() : void
      {
         this.messageField.mouseEnabled = true;
      }
      
      private function scroll(param1:DisplayObject) : void
      {
         var _loc2_:int = param1.name === "down" ? 1 : -1;
         this.messageField.scrollV += SCROLL_FACTOR * _loc2_;
         this.updatePagers();
      }
      
      private function init() : void
      {
         setText("date_txt",this.dateDesc);
         setText("message",MailUtil.fromMail(this.mail,this.whitelist,user.username));
         this.mailer.markAsRead(this.mail.id);
         setText("username",this.mail.isFromSystem ? IPhone2InboxScreen.MODERATOR_NAME : this.mail.sender);
         var _loc1_:Boolean = this.mail.isFromSystem || StringUtil.icompare(this.mail.sender,user.username);
         if(_loc1_)
         {
            setVisible("send",false);
            setEnabled("username",false);
            asset.arrows.y = asset.send.y;
         }
         else
         {
            setText("send.field","Responder");
         }
         setVisible("parties",false);
         setVisible("kings",false);
         setVisible("pool",false);
         setVisible("seretubers",false);
         setVisible("gatubers",false);
         var _loc2_:String = this.mail.data;
         if(_loc2_)
         {
            if(_loc2_.indexOf("reyes") != -1)
            {
               this.setReyesData(_loc2_);
               return;
            }
            if(_loc2_.indexOf("pool") != -1)
            {
               this.setPoolData(_loc2_);
               return;
            }
            this.setEventData(_loc2_);
         }
         var _loc3_:Boolean = this.atScrollEnd;
         if(!_loc3_)
         {
            setVisible("arrows",false);
         }
         else if(!_loc1_)
         {
            this.messageField.height -= MESSAGE_CROP_FOR_SCROLL;
         }
         this.updatePagers();
         this.messageField.addEventListener(MouseEvent.MOUSE_WHEEL,this.updatePagersFromEvent);
         delay(this.enableMessage);
      }
      
      private function onOver(param1:Event) : void
      {
         param1.currentTarget.gotoAndStop("over");
      }
      
      private function get time() : String
      {
         var _loc1_:int = this.date.hours;
         var _loc3_:Array = [12,this.date.minutes];
         _loc3_ = map(_loc3_,StringUtil.padLeft);
         return region.getText("a las").toUpperCase() + " " + _loc3_.join(":") + " " + (_loc1_ < 12 ? region.getText("AM") : region.getText("PM"));
      }
      
      private function gotoUser() : void
      {
         var _loc1_:Object = new Object();
         goto(IPhone2Screens.SEE_FRIEND,this.mail.sender);
      }
      
      private function days(param1:Date) : uint
      {
         return Math.floor(param1.time / DAYS);
      }
      
      private function get atScrollEnd() : Boolean
      {
         return this.messageField.scrollV < this.messageField.maxScrollV;
      }
      
      private function setReyesData(param1:String) : void
      {
         var params:String = param1;
         setVisible("kings",true);
         asset.kings.addEventListener(MouseEvent.CLICK,function():void
         {
            asset.kings.removeEventListener(MouseEvent.MOUSE_OVER,onOut);
            asset.kings.removeEventListener(MouseEvent.MOUSE_OUT,onOver);
            api.room.visit(mail.sender);
         });
         asset.kings.addEventListener(MouseEvent.MOUSE_OVER,this.onOut);
         asset.kings.addEventListener(MouseEvent.MOUSE_OUT,this.onOver);
      }
      
      private function updatePagersFromEvent(param1:Event) : void
      {
         delay(this.updatePagers);
      }
      
      private function get dateDesc() : String
      {
         var _loc1_:int = this.days(new Date(server.time)) - this.days(this.date);
         switch(_loc1_)
         {
            case 0:
               return region.getText("Hoy") + " " + this.time;
            case 1:
               return region.getText("Ayer") + " " + this.time;
            default:
               return region.getText("Hace") + " " + _loc1_ + " " + region.getText("días");
         }
      }
      
      private function setEventData(param1:String) : void
      {
         var _loc2_:EventData = EventData.fromString(param1);
         if(_loc2_.type == EventsAttributeEnum.SERETUBERS)
         {
            setVisible("seretubers",true);
            asset.seretubers.addEventListener(MouseEvent.CLICK,this.goToRoom);
            asset.seretubers.data = param1;
            asset.seretubers.buttonMode = true;
         }
         else if(_loc2_.type == EventsAttributeEnum.GATUBERS_LIVE)
         {
            setVisible("gatubers",true);
            asset.gatubers.addEventListener(MouseEvent.CLICK,this.goToRoom);
            asset.gatubers.data = param1;
            asset.gatubers.buttonMode = true;
         }
         else
         {
            setVisible("parties",true);
            asset.parties.action.field.text = region.getText("IR A LA FIESTA");
            asset.parties.action.addEventListener(MouseEvent.CLICK,this.goToRoom);
            asset.parties.action.data = param1;
            asset.seretubers.buttonMode = true;
         }
      }
      
      private function deleteMessage() : void
      {
         goto(IPhone2Screens.DELETE_MAIL,this.mail);
      }
      
      override public function dispose() : void
      {
         this.messageField.removeEventListener(MouseEvent.MOUSE_WHEEL,this.updatePagersFromEvent);
         this.mailer = null;
         this.mail = null;
         this.whitelist = null;
         this.variables = null;
         super.dispose();
      }
      
      private function setPoolData(param1:String) : void
      {
         var club:String = null;
         var data:Array = null;
         var params:String = param1;
         setVisible("pool",true);
         logger.debug(this,params);
         club = params.indexOf("69404") != -1 ? "RIVER" : "BOCA";
         api.trackEvent(club + "PILETA:TELEFONO","lee");
         data = params.split(":");
         asset.pool.addEventListener(MouseEvent.CLICK,function():void
         {
            asset.pool.removeEventListener(MouseEvent.MOUSE_OVER,onOver);
            asset.pool.removeEventListener(MouseEvent.MOUSE_OUT,onOut);
            api.trackEvent(club + "PILETA:TELEFONO","ingresa_invitado");
            api.gotoRoom(data[1],data[2]);
         });
         asset.pool.addEventListener(MouseEvent.MOUSE_OVER,this.onOut);
         asset.pool.addEventListener(MouseEvent.MOUSE_OUT,this.onOver);
      }
      
      private function reply() : void
      {
         goto(IPhone2Screens.COMPOSE,new InternalMessageData(this.mail.sender,null,this.forceWhiteList));
      }
      
      private function onOut(param1:Event) : void
      {
         param1.currentTarget.gotoAndStop("idle");
      }
      
      private function get date() : Date
      {
         return this.mail.date;
      }
      
      override protected function backButton() : void
      {
         if(this.mail.isNotificationMail)
         {
            back(IPhone2Screens.INBOX_NOTIFICATIONS);
         }
         else
         {
            back(IPhone2Screens.INBOX);
         }
      }
      
      private function get messageField() : TextField
      {
         return asset.message;
      }
      
      private function get forceWhiteList() : Boolean
      {
         return this.mail.messageKeys !== null;
      }
      
      private function goToRoom(param1:Event) : void
      {
         Telemetry.getInstance().trackEvent("FIESTAS:INVITER","CLICK_MAIL_INVITATION");
         asset.parties.action.removeEventListener(MouseEvent.CLICK,this.goToRoom);
         api.inviteToEvent(param1.currentTarget.data);
      }
   }
}

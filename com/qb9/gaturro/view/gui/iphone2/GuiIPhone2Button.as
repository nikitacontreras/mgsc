package com.qb9.gaturro.view.gui.iphone2
{
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.user.cellPhone.CellPhoneEvent;
   import com.qb9.gaturro.user.profile.GaturroProfile;
   import com.qb9.gaturro.view.gui.Gui;
   import com.qb9.gaturro.view.gui.base.BaseGuiModal;
   import com.qb9.gaturro.view.gui.base.BaseGuiModalOpener;
   import com.qb9.gaturro.view.gui.iphone2.screens.IPhone2ReadMailScreen;
   import com.qb9.gaturro.view.world.GaturroRoomView;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import com.qb9.mambo.net.mail.MailMessage;
   import com.qb9.mambo.net.mail.Mailer;
   import com.qb9.mambo.net.mail.MailerEvent;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   
   public final class GuiIPhone2Button extends BaseGuiModalOpener
   {
      
      public static const OPEN_IPHONE_EVENT:String = "OPEN_IPHONE_EVENT";
       
      
      private var whitelist:WhiteListNode;
      
      private var tasks:TaskContainer;
      
      private var room:GaturroRoom;
      
      private var gRoom:GaturroRoomView;
      
      private var mailer:Mailer;
      
      private var notification:Notification;
      
      private var autoStart:Boolean = true;
      
      public function GuiIPhone2Button(param1:Gui, param2:TaskContainer, param3:Mailer, param4:GaturroRoom, param5:GaturroRoomView, param6:WhiteListNode)
      {
         super(param1,param1.cel,18,15);
         this.tasks = param2;
         this.mailer = param3;
         this.room = param4;
         this.gRoom = param5;
         this.whitelist = param6;
         this.init();
      }
      
      private function showIphone(param1:Event = null) : void
      {
         this.action();
      }
      
      private function showNotification(param1:MailerEvent) : void
      {
         var _loc2_:MailMessage = param1.mail;
         if(!_loc2_)
         {
            return;
         }
         this.disposeNotification();
         this.notification = new Notification(_loc2_,this.tasks,this.whitelist);
         this.notification.addEventListener(Event.CLOSE,this.disposeNotification);
         this.notification.addEventListener(MouseEvent.CLICK,this.activateNotification);
         asset.addChild(this.notification);
      }
      
      private function init() : void
      {
         this.mailer.addEventListener(MailerEvent.CHANGED,this.updateCounter);
         this.mailer.addEventListener(MailerEvent.ADDED,this.showNotification);
         api.user.cellPhone.addEventListener(CellPhoneEvent.TRIGGER_ALARM,this.showIphoneAlarmClock);
         this.updateCounter();
         this.updateNewsIcon();
         this.gRoom.addEventListener(OPEN_IPHONE_EVENT,this.showIphone);
      }
      
      override protected function createModal() : BaseGuiModal
      {
         user.community.resetFriends();
         api.freeze();
         return new IPhone2Modal(this,this.tasks,this.mailer,this.room,this.gRoom,this.whitelist,this.autoStart);
      }
      
      public function updateNewsIcon(param1:Event = null) : void
      {
         logger.info("¿Debe lanzarlo en cada inicio de sesión?");
         mc.icon.visible = !this.profile.hasReadNews;
         if(!this.profile.hasReadNews)
         {
            if(user.attributes.sessionCount > 5)
            {
               this.showIphoneNews();
            }
         }
      }
      
      private function showIphoneAlarmClock(param1:CellPhoneEvent) : void
      {
         api.user.cellPhone.removeEventListener(CellPhoneEvent.TRIGGER_ALARM,this.showIphoneAlarmClock);
         if(gui == null)
         {
            return;
         }
         this.action();
         (this.modal as IPhone2Modal).gotoAlarmClock();
      }
      
      private function get iphone() : IPhone2Modal
      {
         return modal as IPhone2Modal;
      }
      
      private function get profile() : GaturroProfile
      {
         return user.profile as GaturroProfile;
      }
      
      private function disposeNotification(param1:Event = null) : void
      {
         if(!this.notification)
         {
            return;
         }
         this.notification.removeEventListener(MouseEvent.CLICK,this.activateNotification);
         this.notification.removeEventListener(Event.CLOSE,this.disposeNotification);
         this.notification.dispose();
         DisplayUtil.remove(this.notification);
         this.notification = null;
      }
      
      override public function dispose() : void
      {
         this.gRoom.removeEventListener(OPEN_IPHONE_EVENT,this.showIphone);
         this.mailer.removeEventListener(MailerEvent.ADDED,this.showNotification);
         this.mailer.removeEventListener(MailerEvent.CHANGED,this.updateCounter);
         this.mailer = null;
         this.tasks = null;
         this.room = null;
         this.gRoom = null;
         super.dispose();
      }
      
      private function updateCounter(param1:Event = null) : void
      {
         var _loc2_:uint = uint(this.mailer.unreadMails);
         mc.counter.text.text = _loc2_ > 99 ? "99" : _loc2_.toString();
         mc.counter.visible = _loc2_ > 0 ? true : false;
      }
      
      public function showIphoneNews(param1:Event = null) : void
      {
         this.action();
         (this.modal as IPhone2Modal).goToNews();
      }
      
      override protected function cleanModal(param1:Event = null) : void
      {
         if(modal)
         {
            modal.removeEventListener(Event.CLOSE,_action);
         }
         super.cleanModal(param1);
      }
      
      private function reopen(param1:Event) : void
      {
         asset.visible = true;
         modal.removeEventListener(Event.CLOSE,this.reopen);
         setTimeout(action,10);
      }
      
      private function activateNotification(param1:Event) : void
      {
         if(!modal)
         {
            this.autoStart = false;
            action();
            this.autoStart = true;
         }
         this.iphone.setScreen(new IPhone2ReadMailScreen(this.iphone,this.mailer,this.notification.mail,this.whitelist));
         this.disposeNotification();
      }
   }
}

import assets.IphoneAlertMC;
import com.qb9.flashlib.easing.Tween;
import com.qb9.flashlib.interfaces.IDisposable;
import com.qb9.flashlib.tasks.Func;
import com.qb9.flashlib.tasks.ITask;
import com.qb9.flashlib.tasks.Sequence;
import com.qb9.flashlib.tasks.TaskContainer;
import com.qb9.flashlib.tasks.Wait;
import com.qb9.flashlib.utils.StringUtil;
import com.qb9.gaturro.globals.region;
import com.qb9.gaturro.view.gui.iphone2.screens.IPhone2InboxScreen;
import com.qb9.gaturro.view.gui.iphone2.screens.MailUtil;
import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
import com.qb9.mambo.net.mail.MailMessage;
import flash.events.Event;

final class Notification extends IphoneAlertMC implements IDisposable
{
   
   private static const MAX_CHARS:uint = 80;
   
   private static const DURATION:uint = 10000;
   
   private static const FADE_DURATION:uint = 500;
    
   
   private var task:ITask;
   
   private var whitelist:WhiteListNode;
   
   private var tasks:TaskContainer;
   
   private var mail:MailMessage;
   
   public function Notification(param1:MailMessage, param2:TaskContainer, param3:WhiteListNode)
   {
      super();
      this.mail = param1;
      this.tasks = param2;
      this.whitelist = param3;
      this.init();
   }
   
   private function init() : void
   {
      buttonMode = true;
      var _loc1_:String = !!this.mail.isFromSystem ? IPhone2InboxScreen.MODERATOR_NAME : String(this.mail.sender);
      username.text = _loc1_.toUpperCase();
      var _loc2_:String = MailUtil.fromMail(this.mail,this.whitelist,_loc1_);
      message.text = region.getText(StringUtil.truncate(_loc2_,MAX_CHARS));
      alpha = 0;
      this.task = new Sequence(new Tween(this,FADE_DURATION,{"alpha":1}),new Wait(DURATION),new Tween(this,FADE_DURATION,{"alpha":0}),new Func(this.finish));
      this.tasks.add(this.task);
   }
   
   private function finish() : void
   {
      dispatchEvent(new Event(Event.CLOSE));
   }
   
   public function dispose() : void
   {
      if(this.task.running)
      {
         this.tasks.remove(this.task);
      }
      this.tasks = null;
      this.task = null;
      this.mail = null;
      this.whitelist = null;
   }
}

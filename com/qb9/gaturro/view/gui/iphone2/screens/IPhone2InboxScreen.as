package com.qb9.gaturro.view.gui.iphone2.screens
{
   import assets.Iphone2ReadAllButton;
   import com.qb9.flashlib.utils.StringUtil;
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.net.mail.GaturroMailMessage;
   import com.qb9.gaturro.view.gui.iphone2.IPhone2Modal;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import com.qb9.mambo.net.mail.MailMessage;
   import com.qb9.mambo.net.mail.Mailer;
   import com.qb9.mambo.net.mail.MailerEvent;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.events.MouseEvent;
   
   public final class IPhone2InboxScreen extends InternalListScreen
   {
      
      private static const VISIBLE_ITEMS:uint = 6;
      
      public static const MODERATOR_NAME:String = "Mundo Gaturro";
      
      private static const MAX_MESSAGE_CHARS:uint = 30;
      
      private static const COLUMNS:uint = 1;
       
      
      private var mailer:Mailer;
      
      private var whitelist:WhiteListNode;
      
      private var notificationsMode:Boolean = false;
      
      public function IPhone2InboxScreen(param1:IPhone2Modal, param2:Mailer, param3:WhiteListNode, param4:Boolean = false)
      {
         this.mailer = param2;
         this.whitelist = param3;
         this.notificationsMode = param4;
         super(param1,this.notificationsMode ? "Avisos" : "Mensajes",VISIBLE_ITEMS,COLUMNS);
         this.init();
      }
      
      override protected function get items() : Array
      {
         var _loc2_:GaturroMailMessage = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this.mailer.mails)
         {
            if(this.inboxContition(_loc2_))
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_;
      }
      
      private function removeSelectedItems(param1:MouseEvent) : void
      {
         var _loc2_:Array = this.seletedMails;
         if(_loc2_.length == 0)
         {
            goto(IPhone2Screens.ERROR,new InternalErrorData(region.getText("Debes elegir al menos un mensaje"),IPhone2Screens.INBOX));
         }
         else
         {
            goto(IPhone2Screens.DELETE_MAIL,_loc2_);
         }
      }
      
      private function removeAllItems(param1:MouseEvent) : void
      {
         if(this.items.length == 0)
         {
            goto(IPhone2Screens.ERROR,new InternalErrorData(region.getText("No hay mensajes para borrar"),IPhone2Screens.INBOX));
         }
         else
         {
            goto(IPhone2Screens.DELETE_MAIL,this.items);
         }
      }
      
      private function inboxContition(param1:GaturroMailMessage) : Boolean
      {
         var _loc3_:String = null;
         var _loc4_:Boolean = false;
         var _loc2_:Boolean = false;
         for each(_loc3_ in settings.iphone.notificationTexts)
         {
            if(param1.message == _loc3_)
            {
               _loc2_ = true;
            }
         }
         _loc4_ = param1.isNotificationMail;
         if(this.notificationsMode && _loc4_)
         {
            return true;
         }
         if(!this.notificationsMode && !_loc4_)
         {
            return true;
         }
         return false;
      }
      
      private function wheelMove(param1:MouseEvent) : void
      {
         var _loc2_:Number = param1.delta;
         if(_loc2_ > 0 && asset.arrows.up.alpha == 1)
         {
            up();
            this.removeRollOver();
         }
         else if(_loc2_ < 0 && asset.arrows.down.alpha == 1)
         {
            down();
            this.removeRollOver();
         }
      }
      
      protected function clockOnMailSelection(param1:MouseEvent) : void
      {
         param1.stopPropagation();
         var _loc2_:DisplayObjectContainer = DisplayObjectContainer(param1.target).parent;
         var _loc3_:GaturroMailMessage = GaturroMailMessage(originals[_loc2_]);
         _loc3_.isSelected = !_loc3_.isSelected;
         this.refreshSelection();
      }
      
      private function init() : void
      {
         this.mailer.addEventListener(MailerEvent.CHANGED,regenerate);
         regenerate();
         this.refreshSelection();
         setVisible("remove",true);
         setVisible("removeAll",true);
         setVisible("removeAll",true);
         asset.remove.addEventListener(MouseEvent.CLICK,this.removeSelectedItems);
         asset.removeAll.addEventListener(MouseEvent.CLICK,this.removeAllItems);
         asset.addEventListener(MouseEvent.MOUSE_WHEEL,this.wheelMove);
      }
      
      private function refreshSelection() : void
      {
         var _loc1_:Iphone2ReadAllButton = null;
         var _loc2_:GaturroMailMessage = null;
         var _loc3_:String = null;
         for each(_loc1_ in views)
         {
            _loc2_ = GaturroMailMessage(originals[_loc1_]);
            _loc3_ = _loc2_.isSelected ? "selected" : "unselected";
            _loc1_.selectionIcon.gotoAndStop(_loc3_);
         }
      }
      
      private function get seletedMails() : Array
      {
         var _loc2_:Iphone2ReadAllButton = null;
         var _loc3_:GaturroMailMessage = null;
         var _loc1_:Array = [];
         for each(_loc2_ in views)
         {
            _loc3_ = GaturroMailMessage(originals[_loc2_]);
            if(_loc3_.isSelected)
            {
               _loc1_.push(_loc3_);
            }
         }
         return _loc1_;
      }
      
      private function removeRollOver() : void
      {
         var _loc1_:Iphone2ReadAllButton = null;
         for each(_loc1_ in views)
         {
            _loc1_.mailButton.gotoAndStop("_up");
         }
      }
      
      override protected function backButton() : void
      {
         back(IPhone2Screens.MESSAGES);
      }
      
      override protected function selected(param1:Object) : void
      {
         goto(IPhone2Screens.READ_MAIL,param1 as MailMessage);
      }
      
      override protected function map(param1:Object) : DisplayObject
      {
         var _loc2_:MailMessage = param1 as MailMessage;
         var _loc3_:Iphone2ReadAllButton = new Iphone2ReadAllButton();
         _loc3_.gotoAndStop(_loc2_.isRead ? 2 : 1);
         var _loc4_:String = _loc2_.isFromSystem ? MODERATOR_NAME : _loc2_.sender;
         _loc3_.username.text = _loc4_.toUpperCase();
         var _loc5_:String = MailUtil.fromMail(_loc2_,this.whitelist,_loc4_);
         _loc3_.message.text = StringUtil.truncate(region.getText(_loc5_),MAX_MESSAGE_CHARS);
         _loc3_.selectionIcon.addEventListener(MouseEvent.CLICK,this.clockOnMailSelection);
         _loc3_.selectionIcon.mouseEnabled = true;
         _loc3_.selectionIcon.buttonMode = true;
         return _loc3_;
      }
      
      override public function dispose() : void
      {
         var _loc1_:Iphone2ReadAllButton = null;
         for each(_loc1_ in views)
         {
            _loc1_.selectionIcon.removeEventListener(MouseEvent.CLICK,this.clockOnMailSelection);
         }
         asset.remove.removeEventListener(MouseEvent.CLICK,this.removeSelectedItems);
         asset.removeAll.removeEventListener(MouseEvent.CLICK,this.removeAllItems);
         asset.removeEventListener(MouseEvent.MOUSE_WHEEL,this.wheelMove);
         this.mailer.removeEventListener(MailerEvent.CHANGED,regenerate);
         this.mailer = null;
         this.whitelist = null;
         super.dispose();
      }
   }
}

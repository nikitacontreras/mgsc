package com.qb9.gaturro.view.gui.iphone2.screens
{
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.view.gui.iphone2.IPhone2Modal;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class InternalComposeScreen extends InternalTitledScreen
   {
      
      protected static const DEFAULT_RECEIVER_TEXT:String = region.getText("PARA");
       
      
      private var wasWhiteList:Boolean;
      
      public function InternalComposeScreen(param1:IPhone2Modal, param2:MovieClip, param3:InternalMessageData, param4:Object = null)
      {
         (param4 ||= {}).send = this.sendMessage;
         param4.choose = this.chooseRecipient;
         super(param1,"Nuevo Mensaje",param2,param4);
         if(param3)
         {
            delay(this.copy,param3);
         }
         this.init();
      }
      
      private function init() : void
      {
         defaultText("username",DEFAULT_RECEIVER_TEXT);
         setText("send.field","ENVIAR");
         setEnabled("choose",user.community.buddies.length > 0);
      }
      
      private function sendMessage() : void
      {
         if(Boolean(this.receiver) && Boolean(this.message))
         {
            goto(IPhone2Screens.SENDING,this.getData());
         }
      }
      
      private function chooseRecipient() : void
      {
         goto(IPhone2Screens.CHOOSE_RECIPIENT,this.getData());
      }
      
      protected function copy(param1:InternalMessageData) : void
      {
         this.userField.text = param1.user || "";
         this.wasWhiteList = param1.forceWhiteList;
      }
      
      protected function get receiver() : String
      {
         var _loc1_:String = this.userField.text.toUpperCase();
         return _loc1_ === DEFAULT_RECEIVER_TEXT ? "" : _loc1_;
      }
      
      protected function get message() : Object
      {
         return null;
      }
      
      private function getData() : InternalMessageData
      {
         return new InternalMessageData(this.receiver,this.message,this.wasWhiteList);
      }
      
      override protected function backButton() : void
      {
         back(IPhone2Screens.MESSAGES);
      }
      
      protected function get userField() : TextField
      {
         return asset.username;
      }
   }
}

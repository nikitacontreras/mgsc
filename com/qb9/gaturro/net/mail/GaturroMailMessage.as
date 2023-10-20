package com.qb9.gaturro.net.mail
{
   import com.qb9.gaturro.globals.settings;
   import com.qb9.mambo.net.mail.MailMessage;
   
   public class GaturroMailMessage extends MailMessage
   {
       
      
      protected var _isSelected:Boolean;
      
      public function GaturroMailMessage()
      {
         super();
      }
      
      public function get actionData() : Array
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         var _loc3_:Array = null;
         if(Boolean(_message) && _message.indexOf("|") > 1)
         {
            _loc1_ = _message.indexOf("|") + 1;
            _loc2_ = _message.substr(_loc1_);
            return _loc2_.split(",");
         }
         return null;
      }
      
      public function get data() : String
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         if(Boolean(_message) && _message.indexOf("|") > 1)
         {
            _loc1_ = _message.indexOf("|") + 1;
            return _message.substr(_loc1_);
         }
         return null;
      }
      
      public function get isSelected() : Boolean
      {
         return this._isSelected;
      }
      
      override public function get message() : String
      {
         if(Boolean(_message) && _message.indexOf("|") > 1)
         {
            return _message.substr(0,_message.indexOf("|"));
         }
         return _message;
      }
      
      public function set isSelected(param1:Boolean) : void
      {
         this._isSelected = param1;
      }
      
      public function get isNotificationMail() : Boolean
      {
         var _loc2_:String = null;
         if(!this.serverMessage)
         {
            return true;
         }
         for each(_loc2_ in settings.iphone.notificationTexts)
         {
            if(this.message == _loc2_)
            {
               return true;
            }
         }
         return false;
      }
   }
}

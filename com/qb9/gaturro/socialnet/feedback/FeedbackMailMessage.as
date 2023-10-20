package com.qb9.gaturro.socialnet.feedback
{
   import com.qb9.gaturro.net.mail.GaturroMailMessage;
   
   public class FeedbackMailMessage extends GaturroMailMessage
   {
      
      public static var current_id:int = -1;
       
      
      public function FeedbackMailMessage(param1:String, param2:String, param3:String)
      {
         super();
         _id = current_id--;
         _sender = param1;
         _subject = param2;
         _isRead = false;
         _message = param3;
         _messageKeys = null;
         _date = new Date();
      }
   }
}

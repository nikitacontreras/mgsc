package com.qb9.gaturro.net.mail
{
   import com.qb9.gaturro.socialnet.feedback.FeedbackMailMessage;
   import com.qb9.mambo.net.mail.MailMessage;
   import com.qb9.mambo.net.mail.Mailer;
   import com.qb9.mambo.net.mail.MailerEvent;
   import com.qb9.mambo.net.manager.NetworkManager;
   import com.qb9.mines.mobject.Mobject;
   
   public class GaturroMailer extends Mailer
   {
       
      
      public function GaturroMailer(param1:NetworkManager)
      {
         super(param1);
      }
      
      public function sendFakeMessage(param1:String, param2:String, param3:String) : void
      {
         var _loc4_:FeedbackMailMessage = new FeedbackMailMessage(param1,param2,param3);
         this.addToList(_loc4_);
         this.dispatch(MailerEvent.ADDED,_loc4_);
      }
      
      public function mailQuantity(param1:Boolean) : int
      {
         var _loc3_:GaturroMailMessage = null;
         var _loc2_:int = 0;
         for each(_loc3_ in _mails)
         {
            if(_loc3_.isNotificationMail == param1)
            {
               _loc2_++;
            }
         }
         return _loc2_;
      }
      
      override protected function buildMail(param1:Mobject) : MailMessage
      {
         var _loc2_:MailMessage = new GaturroMailMessage();
         _loc2_.buildFromMobject(param1);
         return _loc2_;
      }
   }
}

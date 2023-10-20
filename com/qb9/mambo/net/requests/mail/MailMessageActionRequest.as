package com.qb9.mambo.net.requests.mail
{
   import com.qb9.mambo.net.requests.base.BaseMamboRequest;
   import com.qb9.mines.mobject.Mobject;
   
   public final class MailMessageActionRequest extends BaseMamboRequest
   {
       
      
      private var message:Object;
      
      private var subject:String;
      
      private var receiver:String;
      
      public function MailMessageActionRequest(param1:String, param2:Object, param3:String = null)
      {
         super();
         this.receiver = param1;
         this.message = param2;
         this.subject = param3;
      }
      
      override protected function build(param1:Mobject) : void
      {
         param1.setString("toUsername",this.receiver);
         if(this.message is String)
         {
            param1.setString("message",this.message as String);
         }
         else
         {
            param1.setIntegerArray("messageKeys",this.message as Array);
         }
         if(this.subject)
         {
            param1.setString("subject",this.subject);
         }
      }
   }
}

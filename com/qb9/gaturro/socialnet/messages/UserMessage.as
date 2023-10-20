package com.qb9.gaturro.socialnet.messages
{
   import com.qb9.gaturro.globals.server;
   import com.qb9.gaturro.globals.user;
   
   public class UserMessage extends SocialNetMessage
   {
       
      
      private var message:String;
      
      public function UserMessage(param1:String, param2:String)
      {
         super(param1);
         this.message = param2;
      }
      
      override public function get feedbackErrorText() : String
      {
         return "feedbackErrorMailText";
      }
      
      override public function get feedbackSuccessText() : String
      {
         return "feedbackSuccessMailText";
      }
      
      override public function setParams(param1:Array) : void
      {
         var _loc2_:Object = getStringKeyValue(user.username);
         param1.push(_loc2_);
         var _loc3_:Object = getStringKeyValue(this.message);
         param1.push(_loc3_);
         var _loc4_:Object = getStringKeyValue(server.serverName);
         param1.push(_loc4_);
         super.setParams(param1);
      }
   }
}

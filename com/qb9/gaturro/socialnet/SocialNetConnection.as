package com.qb9.gaturro.socialnet
{
   import com.qb9.gaturro.socialnet.messages.SocialNetMessage;
   import com.qb9.gaturro.util.xmprpc.ConnectionXMLRCP;
   
   public class SocialNetConnection extends ConnectionXMLRCP
   {
       
      
      private var _message:SocialNetMessage;
      
      public function SocialNetConnection()
      {
         super();
      }
      
      public function set message(param1:SocialNetMessage) : void
      {
         this._message = param1;
      }
      
      public function get message() : SocialNetMessage
      {
         return this._message;
      }
   }
}

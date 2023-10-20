package com.qb9.mambo.net.chat
{
   import com.qb9.mambo.net.manager.NetworkManager;
   import com.qb9.mambo.user.User;
   
   public final class GlobalChat extends BaseChat
   {
       
      
      public function GlobalChat(param1:NetworkManager, param2:User)
      {
         super("global",param1,param2);
      }
      
      public function send(param1:String) : void
      {
         sendMobject(buildMessageMobject(param1));
      }
      
      public function sendKey(param1:int) : void
      {
         sendMobject(buildMessageKeyMobject(param1));
      }
   }
}

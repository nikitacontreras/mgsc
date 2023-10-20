package com.qb9.gaturro.socialnet
{
   import com.qb9.gaturro.socialnet.messages.GaturroChatMessage;
   import com.qb9.mambo.net.chat.ChatMessage;
   import com.qb9.mambo.net.chat.RoomChat;
   import com.qb9.mambo.net.manager.NetworkManager;
   import com.qb9.mambo.user.User;
   import com.qb9.mambo.world.core.Room;
   import com.qb9.mines.mobject.Mobject;
   
   public class GaturroRoomChat extends RoomChat
   {
       
      
      public function GaturroRoomChat(param1:NetworkManager, param2:User, param3:Room)
      {
         super(param1,param2,param3);
      }
      
      override public function getMessage(param1:Mobject) : ChatMessage
      {
         var _loc2_:GaturroChatMessage = new GaturroChatMessage();
         _loc2_.buildFromMobject(param1);
         return _loc2_;
      }
   }
}

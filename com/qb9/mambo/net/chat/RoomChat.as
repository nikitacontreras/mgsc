package com.qb9.mambo.net.chat
{
   import com.qb9.mambo.net.manager.NetworkManager;
   import com.qb9.mambo.user.User;
   import com.qb9.mambo.world.core.Room;
   import com.qb9.mines.mobject.Mobject;
   
   public class RoomChat extends BaseChat
   {
       
      
      private var roomId:int;
      
      public function RoomChat(param1:NetworkManager, param2:User, param3:Room)
      {
         super("room",param1,param2);
         this.roomId = param3.id;
      }
      
      public function send(param1:String) : void
      {
         this.sendRoomMobject(buildMessageMobject(param1));
      }
      
      private function sendRoomMobject(param1:Mobject) : void
      {
         param1.setInteger("toRoomId",this.roomId);
         sendMobject(param1);
      }
      
      public function sendKey(param1:int) : void
      {
         this.sendRoomMobject(buildMessageKeyMobject(param1));
      }
   }
}

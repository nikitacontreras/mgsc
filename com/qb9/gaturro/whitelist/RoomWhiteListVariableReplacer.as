package com.qb9.gaturro.whitelist
{
   import com.qb9.mambo.world.avatars.Avatar;
   import com.qb9.mambo.world.core.Room;
   
   public final class RoomWhiteListVariableReplacer extends BaseWhiteListVariableReplacer implements WhiteListVariableReplacer
   {
       
      
      private var room:Room;
      
      public function RoomWhiteListVariableReplacer(param1:Room)
      {
         super({
            "username":this.userName,
            "usercoord":this.userCoord,
            "roomid":this.roomId,
            "roomname":this.roomName,
            "ca":this.customAttribute
         });
         this.room = param1;
      }
      
      public function replaceForUser(param1:String) : String
      {
         return replaceFor(this.room.userAvatar,param1);
      }
      
      private function roomId() : String
      {
         return this.room.id.toString();
      }
      
      private function roomName() : String
      {
         return this.room.name;
      }
      
      private function userCoord() : String
      {
         return this.avatar.coord.toString();
      }
      
      private function customAttribute(param1:String) : String
      {
         return this.avatar.attributes[param1];
      }
      
      private function get avatar() : Avatar
      {
         return source as Avatar;
      }
      
      private function userName() : String
      {
         return this.avatar.username.toLowerCase();
      }
      
      override public function dispose() : void
      {
         this.room = null;
         super.dispose();
      }
   }
}

package com.qb9.gaturro.socialnet.messages
{
   import com.qb9.mambo.net.chat.ChatMessage;
   import com.qb9.mines.mobject.Mobject;
   
   public class GaturroChatMessage extends ChatMessage
   {
       
      
      public var badwords:Boolean;
      
      public function GaturroChatMessage()
      {
         super();
      }
      
      override public function buildFromMobject(param1:Mobject) : void
      {
         super.buildFromMobject(param1);
         this.badwords = param1.getBoolean("badwords");
      }
   }
}

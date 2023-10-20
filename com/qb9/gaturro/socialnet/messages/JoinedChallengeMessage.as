package com.qb9.gaturro.socialnet.messages
{
   import com.qb9.gaturro.globals.user;
   
   public class JoinedChallengeMessage extends SocialNetMessage
   {
       
      
      private var iconName:String;
      
      private var challengeName:String;
      
      private var teamName:String;
      
      public function JoinedChallengeMessage(param1:String, param2:String, param3:String, param4:String)
      {
         super(param1);
         this.iconName = param2;
         this.challengeName = param3;
         this.teamName = param4;
      }
      
      override public function get mustSendMail() : Boolean
      {
         return false;
      }
      
      override public function setParams(param1:Array) : void
      {
         var _loc2_:Object = getStringKeyValue(user.username);
         param1.push(_loc2_);
         var _loc3_:Object = getStringKeyValue(this.iconName);
         param1.push(_loc3_);
         var _loc4_:Object = getStringKeyValue(this.challengeName);
         param1.push(_loc4_);
         var _loc5_:Object = getStringKeyValue(this.teamName);
         param1.push(_loc5_);
         super.setParams(param1);
      }
   }
}

package com.qb9.gaturro.socialnet.messages
{
   import com.qb9.gaturro.globals.user;
   
   public class ScoreMessage extends SocialNetMessage
   {
       
      
      private var message:Object;
      
      public function ScoreMessage(param1:String, param2:Object)
      {
         super(param1);
         this.message = param2;
      }
      
      override public function get feedbackErrorText() : String
      {
         return "feedbackErrorMailScore";
      }
      
      override public function get feedbackSuccessText() : String
      {
         return "feedbackSuccessMailScore";
      }
      
      override public function setParams(param1:Array) : void
      {
         var _loc2_:Object = getStringKeyValue(user.username);
         param1.push(_loc2_);
         var _loc3_:Object = getStringKeyValue(this.message.game_id);
         param1.push(_loc3_);
         var _loc4_:Object = getStringKeyValue(this.message.game_name);
         param1.push(_loc4_);
         var _loc5_:Object = getStringKeyValue(this.message.score);
         param1.push(_loc5_);
         super.setParams(param1);
      }
   }
}

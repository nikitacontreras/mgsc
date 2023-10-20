package com.qb9.gaturro.socialnet.messages
{
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.util.xmprpc.XMLRPCDataTypes;
   
   public class SocialNetMessage
   {
       
      
      protected var methodName:String;
      
      public function SocialNetMessage(param1:String)
      {
         super();
         this.methodName = param1;
      }
      
      public function get feedbackErrorText() : String
      {
         return "";
      }
      
      public function get method() : String
      {
         return this.methodName;
      }
      
      public function setParams(param1:Array) : void
      {
         var _loc2_:Object = this.getStringKeyValue(user.hashSessionId.toString());
         param1.push(_loc2_);
      }
      
      protected function getStringKeyValue(param1:String) : Object
      {
         return {
            "value":param1,
            "type":XMLRPCDataTypes.STRING
         };
      }
      
      public function get feedbackSuccessText() : String
      {
         return "";
      }
      
      public function get mustSendMail() : Boolean
      {
         return true;
      }
   }
}

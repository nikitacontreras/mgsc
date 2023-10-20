package com.qb9.gaturro.view.gui.iphone2.screens
{
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.whitelist.IPhoneWhiteListVariableReplacer;
   import com.qb9.gaturro.whitelist.WhiteListVariableReplacer;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import com.qb9.mambo.net.mail.MailMessage;
   
   public class MailUtil
   {
      
      private static var variables:WhiteListVariableReplacer;
      
      private static const IDS_JOIN:String = "\n";
       
      
      public function MailUtil()
      {
         super();
      }
      
      public static function fromMail(param1:MailMessage, param2:WhiteListNode, param3:Object = null) : String
      {
         return !!param1.messageKeys ? fromKeys(param1.messageKeys,param2,param3) : param1.message.toUpperCase();
      }
      
      public static function fromKey(param1:int, param2:WhiteListNode, param3:Object = null) : String
      {
         var _loc4_:WhiteListNode = param2.getByKey(param1);
         variables = variables || new IPhoneWhiteListVariableReplacer();
         return !!_loc4_ ? variables.replaceFor(param3,_loc4_.text).toUpperCase() : "";
      }
      
      public static function fromKeys(param1:Array, param2:WhiteListNode, param3:Object = null) : String
      {
         var _loc6_:String = null;
         var _loc4_:int = int(param1.length);
         var _loc5_:Array = new Array(_loc4_);
         var _loc7_:int = 0;
         while(_loc7_ < _loc4_)
         {
            _loc6_ = fromKey(param1[_loc7_],param2,param3);
            _loc5_[_loc7_] = region.getText(_loc6_);
            _loc7_++;
         }
         return _loc5_.join(IDS_JOIN);
      }
   }
}

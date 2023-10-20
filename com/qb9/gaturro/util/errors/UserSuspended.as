package com.qb9.gaturro.util.errors
{
   import com.qb9.flashlib.utils.StringUtil;
   import com.qb9.gaturro.globals.region;
   
   public class UserSuspended extends ErrorOccurred
   {
       
      
      private var daysSuspended:int;
      
      public function UserSuspended(param1:int)
      {
         super();
         this.daysSuspended = param1;
      }
      
      override public function get data() : String
      {
         return super.data + "|" + "days:" + this.daysSuspended.toString();
      }
      
      override public function get codeError() : int
      {
         return 2000;
      }
      
      override public function get description() : String
      {
         return StringUtil.format(region.key("user_has_been_suspended"),this.daysSuspended);
      }
   }
}

package config
{
   public class AdminControl
   {
      
      private static const VALID_ADMINS:Array = ["MROVERE","FROMANO","MALBEC2","GATURRO","MCHISPA","QB9MOD"];
       
      
      public function AdminControl()
      {
         super();
      }
      
      public static function isAdminUser(param1:String) : Boolean
      {
         var _loc2_:int = 0;
         while(_loc2_ < VALID_ADMINS.length)
         {
            if(param1 == VALID_ADMINS[_loc2_])
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public static function validAdminEvent(param1:String) : Boolean
      {
         var _loc2_:int = 0;
         while(_loc2_ < VALID_ADMINS.length)
         {
            if(param1 == VALID_ADMINS[_loc2_] + ":modEvent")
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
   }
}

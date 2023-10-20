package config
{
   public class PassportControl
   {
      
      private static const VIP_PACKS:Array = ["invisibles/halloween2018"];
       
      
      public function PassportControl()
      {
         super();
      }
      
      public static function isVipPack(param1:String) : Boolean
      {
         if(!param1)
         {
            return false;
         }
         if(param1.indexOf(".") == -1)
         {
            return false;
         }
         var _loc2_:String = String(param1.split(".")[0]);
         if(!_loc2_)
         {
            return false;
         }
         var _loc3_:int = 0;
         while(_loc3_ < VIP_PACKS.length)
         {
            if(VIP_PACKS[_loc3_] == _loc2_)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
   }
}

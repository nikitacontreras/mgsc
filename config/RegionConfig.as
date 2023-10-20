package config
{
   public class RegionConfig
   {
      
      private static var dataObj:Object = {"enabled":false};
       
      
      public function RegionConfig()
      {
         super();
      }
      
      public static function get data() : Object
      {
         return dataObj;
      }
   }
}

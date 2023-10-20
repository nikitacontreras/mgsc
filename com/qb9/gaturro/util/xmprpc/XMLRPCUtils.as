package com.qb9.gaturro.util.xmprpc
{
   public class XMLRPCUtils
   {
      
      public static var SIMPLE_TYPES:Array = [XMLRPCDataTypes.BASE64,XMLRPCDataTypes.INT,XMLRPCDataTypes.i4,XMLRPCDataTypes.STRING,XMLRPCDataTypes.CDATA,XMLRPCDataTypes.DOUBLE,XMLRPCDataTypes.DATETIME,XMLRPCDataTypes.BOOLEAN];
       
      
      public function XMLRPCUtils()
      {
         super();
      }
      
      public static function isSimpleType(param1:String) : Boolean
      {
         var _loc2_:Number = NaN;
         _loc2_ = 0;
         while(_loc2_ < SIMPLE_TYPES.length)
         {
            if(param1 == SIMPLE_TYPES[_loc2_])
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
   }
}

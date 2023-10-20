package com.qb9.flashlib.config
{
   import com.qb9.flashlib.utils.StringUtil;
   
   public final class Evaluator
   {
      
      private static const DECIMAL:RegExp = /^-?\d+(\.\d+)?$/;
      
      private static const NEW_LINE:String = "\n";
      
      private static const HEXADECIMAL:RegExp = /^0x[0-9a-f]+$/i;
      
      private static const ESCAPED_NEW_LINE:RegExp = /\\n/g;
       
      
      public function Evaluator()
      {
         super();
      }
      
      public static function parse(param1:String) : Object
      {
         param1 = StringUtil.trim(param1);
         switch(param1)
         {
            case "true":
               return true;
            case "false":
               return false;
            case "undefined":
            case "null":
               return null;
            default:
               if(DECIMAL.test(param1))
               {
                  return parseFloat(param1);
               }
               if(HEXADECIMAL.test(param1))
               {
                  return parseInt(param1,16);
               }
               return param1.replace(ESCAPED_NEW_LINE,NEW_LINE);
         }
      }
   }
}

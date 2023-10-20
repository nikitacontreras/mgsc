package com.qb9.flashlib.net
{
   public class LoadFileFormat
   {
      
      public static const BINARY:String = "binary";
      
      public static const PLAIN_TEXT:String = "plainText";
      
      public static const VARIABLES:String = "variables";
      
      public static const JSON:String = "json";
      
      private static const END:RegExp = /[#?].*$/;
      
      public static const INFER:String = "infer";
      
      public static const SOUND:String = "sound";
      
      public static const SWF:String = "swf";
      
      public static const XML:String = "xml";
      
      public static const IMAGE:String = "image";
       
      
      public function LoadFileFormat()
      {
         super();
      }
      
      public static function infer(param1:String) : String
      {
         var _loc2_:String = param1.replace(END,"").split(".").pop();
         switch(_loc2_)
         {
            case "swf":
               return SWF;
            case "jpg":
            case "jpeg":
            case "png":
            case "pneg":
            case "gif":
            case "bmp":
               return IMAGE;
            case "mp3":
            case "wav":
               return SOUND;
            case "xml":
               return XML;
            case "json":
               return JSON;
            default:
               return PLAIN_TEXT;
         }
      }
   }
}

package com.qb9.flashlib.net
{
   public class LoadFileParsers
   {
      
      protected static const parsers:Object = {};
       
      
      public function LoadFileParsers()
      {
         super();
      }
      
      public static function registerParser(param1:String, param2:Function) : void
      {
         parsers[param1] = param2;
      }
      
      public static function parse(param1:String, param2:*) : *
      {
         return !!parsers[param1] ? parsers[param1](param2) : param2;
      }
   }
}

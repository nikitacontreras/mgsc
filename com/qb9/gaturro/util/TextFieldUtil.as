package com.qb9.gaturro.util
{
   import flash.events.Event;
   import flash.text.StyleSheet;
   import flash.text.TextField;
   
   public final class TextFieldUtil
   {
       
      
      public function TextFieldUtil()
      {
         super();
      }
      
      private static function enableMouse(param1:Event) : void
      {
         var _loc2_:TextField = param1.currentTarget as TextField;
         _loc2_.mouseEnabled = true;
         _loc2_.removeEventListener(Event.ADDED_TO_STAGE,enableMouse);
      }
      
      public static function countWords(param1:String) : int
      {
         return param1.match(/[^\s]+/g).length;
      }
      
      public static function htmlUpperCase(param1:String) : String
      {
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc2_:Array = [];
         var _loc3_:RegExp = /href=(["'])(.+?)\1/g;
         while(_loc4_ = _loc3_.exec(param1))
         {
            if(_loc4_[2])
            {
               _loc2_.push(_loc4_[2]);
            }
         }
         param1 = param1.toUpperCase();
         for each(_loc5_ in _loc2_)
         {
            param1 = param1.replace(_loc5_.toUpperCase(),_loc5_);
         }
         return param1;
      }
      
      public static function linkContainer(param1:TextField) : void
      {
         if(param1.root)
         {
            param1.mouseEnabled = true;
         }
         else
         {
            param1.addEventListener(Event.ADDED_TO_STAGE,enableMouse);
         }
         var _loc2_:StyleSheet = new StyleSheet();
         _loc2_.setStyle("a:link",{
            "textDecoration":"underline",
            "color":"#CC0000"
         });
         _loc2_.setStyle("a:hover",{"color":"#FFF100"});
         param1.styleSheet = _loc2_;
      }
   }
}

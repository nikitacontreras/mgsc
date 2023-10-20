package com.qb9.flashlib.security
{
   public class SafeString
   {
       
      
      private const SEP:String = "-";
      
      private var charsValues:Array;
      
      public function SafeString(param1:String)
      {
         super();
         this.value = param1;
      }
      
      public function get value() : String
      {
         var _loc1_:String = "";
         var _loc2_:int = 0;
         while(_loc2_ < this.charsValues.length)
         {
            _loc1_ += String(this.charsValues[_loc2_]);
            _loc2_ += 2;
         }
         return _loc1_;
      }
      
      public function set value(param1:String) : void
      {
         this.charsValues = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            this.charsValues.push(param1.substr(_loc2_,1));
            this.charsValues.push(this.SEP);
            _loc2_++;
         }
      }
      
      public function toString() : String
      {
         return this.value;
      }
   }
}

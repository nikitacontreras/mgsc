package com.qb9.flashlib.security
{
   import flash.utils.ByteArray;
   
   public final class SafeNumber
   {
       
      
      private const bytes:ByteArray = new ByteArray();
      
      public function SafeNumber(param1:Number = NaN)
      {
         super();
         this.value = param1;
      }
      
      public function get value() : Number
      {
         if(this.bytes.length === 0)
         {
            return NaN;
         }
         this.reset();
         return this.bytes.readFloat();
      }
      
      public function set value(param1:Number) : void
      {
         this.reset();
         if(isNaN(param1))
         {
            this.bytes.length = 0;
         }
         else
         {
            this.bytes.writeFloat(param1);
         }
      }
      
      public function valueOf() : Object
      {
         return this.value;
      }
      
      public function toString() : String
      {
         return this.value.toString();
      }
      
      private function reset() : void
      {
         this.bytes.position = 0;
      }
   }
}

package com.qb9.flashlib.input.reader
{
   public final class StringReaderError extends Error
   {
      
      public static const ID:int = -1234;
       
      
      public function StringReaderError(param1:String)
      {
         super(param1,ID);
      }
   }
}

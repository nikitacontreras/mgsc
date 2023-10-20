package com.qb9.gaturro.util.errors
{
   public class ErrorOccurred
   {
       
      
      public function ErrorOccurred()
      {
         super();
      }
      
      public function get data() : String
      {
         return "code:" + this.codeError.toString();
      }
      
      public function get codeError() : int
      {
         return 0;
      }
      
      public function get description() : String
      {
         return "";
      }
   }
}

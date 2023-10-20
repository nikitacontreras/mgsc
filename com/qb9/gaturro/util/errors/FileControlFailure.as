package com.qb9.gaturro.util.errors
{
   import com.qb9.gaturro.globals.region;
   
   public class FileControlFailure extends ErrorOccurred
   {
       
      
      private var details:String;
      
      private var relativeURL:String;
      
      private var fileHash:String;
      
      private var savedHash:String;
      
      public function FileControlFailure(param1:String, param2:String, param3:String = "", param4:String = "")
      {
         super();
         this.relativeURL = param1;
         this.details = param2;
         this.savedHash = param3;
         this.fileHash = param4;
      }
      
      override public function get data() : String
      {
         return super.data + "|" + "url:" + this.relativeURL + "|" + "details:" + this.details + "|" + "savedHash:" + this.savedHash + "|" + "fileHash:" + this.fileHash;
      }
      
      override public function get codeError() : int
      {
         return 3000;
      }
      
      override public function get description() : String
      {
         return region.key("ERROR INESPERADO");
      }
   }
}

package com.qb9.flashlib.net
{
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   
   internal class QURLLoader extends URLLoader implements ILoader
   {
       
      
      public function QURLLoader(param1:URLRequest = null)
      {
         super(param1);
      }
      
      public function getBytesLoaded() : uint
      {
         return bytesLoaded;
      }
      
      public function setDataFormat(param1:String) : void
      {
         dataFormat = param1;
      }
      
      public function getData() : *
      {
         return LoadFileParsers.parse(dataFormat,data);
      }
      
      public function loadURL(param1:URLRequest) : void
      {
         load(param1);
      }
      
      public function getBytesTotal() : uint
      {
         return bytesTotal;
      }
      
      public function getDataFormat() : String
      {
         return dataFormat;
      }
   }
}

package com.qb9.flashlib.net
{
   import flash.media.Sound;
   import flash.media.SoundLoaderContext;
   import flash.net.URLRequest;
   
   internal class QSound extends Sound implements ILoader
   {
       
      
      protected var _dataFormat:String;
      
      public function QSound(param1:URLRequest = null, param2:SoundLoaderContext = null)
      {
         super(param1,param2);
      }
      
      public function getData() : *
      {
         return this;
      }
      
      public function setDataFormat(param1:String) : void
      {
         this._dataFormat = param1;
      }
      
      public function getBytesTotal() : uint
      {
         return bytesTotal;
      }
      
      public function loadURL(param1:URLRequest) : void
      {
         load(param1);
      }
      
      public function getDataFormat() : String
      {
         return this._dataFormat;
      }
      
      public function getBytesLoaded() : uint
      {
         return bytesLoaded;
      }
   }
}

package com.qb9.gaturro.net.library
{
   import com.qb9.gaturro.net.requests.URLUtil;
   import com.qb9.mambo.net.library.Library;
   import com.wispagency.display.LoaderInfo;
   import flash.events.Event;
   import flash.utils.ByteArray;
   
   public class GaturroLibrary extends Library
   {
       
      
      private var relativeName:String;
      
      public function GaturroLibrary(param1:String = ".", param2:Boolean = false, param3:String = null)
      {
         super(param1,param2,param3);
      }
      
      override protected function whenLibraryIsLoaded(param1:Event) : void
      {
         var _loc2_:LoaderInfo = LoaderInfo(param1.target);
         var _loc3_:ByteArray = ByteArray(_loc2_.urlLoader.data);
         var _loc4_:String = URLUtil.getUrl(this.relativeName);
         var _loc5_:String = URLUtil.versionedPath(_loc4_);
         var _loc6_:String = URLUtil.versionedFileName(_loc5_);
         super.whenLibraryIsLoaded(param1);
      }
      
      override protected function makeURL(param1:String, param2:String) : String
      {
         var _loc3_:String = super.makeURL(param1,param2);
         this.relativeName = _loc3_;
         var _loc4_:String = URLUtil.getUrl(_loc3_);
         return URLUtil.versionedPath(_loc4_);
      }
   }
}

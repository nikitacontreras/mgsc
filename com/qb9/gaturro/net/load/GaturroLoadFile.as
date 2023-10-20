package com.qb9.gaturro.net.load
{
   import com.qb9.flashlib.net.LoadFile;
   import com.qb9.gaturro.globals.securityFileControl;
   import com.qb9.gaturro.net.requests.URLUtil;
   import flash.events.Event;
   
   public class GaturroLoadFile extends LoadFile
   {
       
      
      private var relativeURL:String;
      
      private var versionedPath:String;
      
      private var versionedFileName:String;
      
      public function GaturroLoadFile(param1:String, param2:String = "infer", param3:String = null, param4:Boolean = false)
      {
         this.relativeURL = URLUtil.getUrl(param1);
         this.versionedPath = URLUtil.versionedPath(this.relativeURL);
         this.versionedFileName = URLUtil.versionedFileName(this.versionedPath);
         super(this.versionedPath,param2,param3,param4);
      }
      
      override protected function onComplete(param1:Event) : void
      {
         trace(securityFileControl);
         if(!securityFileControl)
         {
            super.onComplete(param1);
            return;
         }
      }
   }
}

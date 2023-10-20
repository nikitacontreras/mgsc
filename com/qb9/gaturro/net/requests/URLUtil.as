package com.qb9.gaturro.net.requests
{
   import com.qb9.gaturro.GameData;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.globals.settings;
   import flash.external.ExternalInterface;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.utils.Dictionary;
   
   public final class URLUtil
   {
      
      private static var versionPerFile:Dictionary;
      
      private static var needCacheVersion:Object = {
         "swf":true,
         "npc":true,
         "mp3":false,
         "json":true,
         "txt":true,
         "jpg":false
      };
      
      private static var suffix:String;
       
      
      public function URLUtil()
      {
         super();
      }
      
      private static function createFileCatalog() : void
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc1_:int = 0;
         versionPerFile = new Dictionary(true);
         for each(_loc2_ in GameData.RESOURSES_VERSION)
         {
            _loc1_++;
            _loc3_ = String(_loc2_[1]).replace(";","/") + "/" + _loc2_[2];
            _loc4_ = String(_loc2_[0]);
            _loc3_ = String(URLUtil.getUrl(_loc3_));
            versionPerFile[_loc3_] = _loc4_;
         }
      }
      
      public static function addSeparator(param1:String) : String
      {
         return param1 + (param1.indexOf("?") === -1 ? "?" : "&");
      }
      
      public static function openURL(param1:String) : void
      {
         var _loc2_:URLRequest = null;
         if(isDesktop())
         {
            if(ExternalInterface.available)
            {
               ExternalInterface.call("openURL",param1);
            }
            else
            {
               logger.error("Is desktop without external interface");
            }
         }
         else
         {
            _loc2_ = new URLRequest(param1);
            navigateToURL(_loc2_,"_blank");
         }
      }
      
      public static function concatVersion(param1:String, param2:String) : String
      {
         var _loc3_:int = param1.lastIndexOf(".");
         var _loc4_:String = param1.substr(0,_loc3_);
         var _loc5_:String = param1.substr(_loc3_ + 1);
         return _loc4_ + "." + param2 + "." + _loc5_;
      }
      
      private static function needsSuffix(param1:String) : Boolean
      {
         var _loc2_:int = param1.lastIndexOf(".");
         if(_loc2_ == -1 || _loc2_ >= param1.length)
         {
            return false;
         }
         var _loc3_:String = param1.substr(_loc2_ + 1);
         return needCacheVersion[_loc3_];
      }
      
      public static function noCache(param1:String) : String
      {
         return addSeparator(param1) + new Date().getTime();
      }
      
      public static function isDesktop() : Boolean
      {
         var _loc1_:String = "";
         if(ExternalInterface.available)
         {
            _loc1_ = ExternalInterface.call("window.navigator.userAgent.toString");
         }
         return _loc1_.indexOf("mundo-gaturro-desktop") != -1;
      }
      
      public static function getUrl(param1:String) : String
      {
         var _loc6_:String = null;
         var _loc2_:int = param1.indexOf("/");
         var _loc3_:String = param1.slice(0,_loc2_);
         var _loc4_:int = param1.indexOf(".",_loc2_);
         var _loc5_:String = param1.slice(_loc2_ + 1,_loc4_);
         return DirectoryFactory.getUrl(_loc3_) + param1;
      }
      
      public static function versionedPath(param1:String) : String
      {
         var _loc2_:String = null;
         if(!settings.resources.useVersionByFile || !needsSuffix(param1))
         {
            return param1;
         }
         if(settings.resources)
         {
            if(!versionPerFile)
            {
               createFileCatalog();
            }
            _loc2_ = String(versionPerFile[param1]);
            if(_loc2_)
            {
               return concatVersion(param1,_loc2_);
            }
         }
         return param1;
      }
      
      public static function versionedFileName(param1:String) : String
      {
         var _loc2_:Array = param1.split("/");
         return _loc2_[_loc2_.length - 2] + "/" + _loc2_[_loc2_.length - 1];
      }
   }
}

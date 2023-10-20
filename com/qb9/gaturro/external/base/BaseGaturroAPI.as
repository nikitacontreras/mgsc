package com.qb9.gaturro.external.base
{
   import com.qb9.flashlib.utils.ClassUtil;
   import com.qb9.flashlib.utils.StringUtil;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.globals.server;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.user.GaturroUser;
   
   public class BaseGaturroAPI
   {
       
      
      public function BaseGaturroAPI()
      {
         super();
      }
      
      public function getSession(param1:String) : Object
      {
         return this.user.getSession(param1);
      }
      
      private function log(param1:String, param2:Array) : void
      {
         param2.unshift(ClassUtil.getName(this),">");
         logger[param1].apply(logger,param2);
      }
      
      public function error(... rest) : void
      {
         this.log("error",rest);
      }
      
      public function getProfileAttribute(param1:String) : Object
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc2_:int = param1.indexOf(StringUtil.JPathSeparator);
         if(_loc2_ > 0)
         {
            _loc3_ = param1.substring(0,_loc2_);
            _loc4_ = String(this.user.profile.attributes[_loc3_]);
            return StringUtil.getJsonVar(param1,_loc4_);
         }
         return this.user.profile.attributes[param1];
      }
      
      public function get user() : GaturroUser
      {
         return user;
      }
      
      public function info(... rest) : void
      {
         this.log("info",rest);
      }
      
      public function get serverTime() : Number
      {
         return server.time;
      }
      
      public function debug(... rest) : void
      {
         this.log("debug",rest);
      }
      
      public function setSession(param1:String, param2:Object) : void
      {
         this.user.setSession(param1,param2);
      }
      
      public function setProfileAttribute(param1:String, param2:Object) : void
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc3_:int = param1.indexOf(StringUtil.JPathSeparator);
         if(_loc3_ > 0)
         {
            _loc4_ = param1.substring(0,_loc3_);
            _loc5_ = String(this.user.profile.attributes[_loc4_]);
            this.user.profile.attributes[_loc4_] = StringUtil.setJsonVar(param1,_loc5_,param2);
         }
         else
         {
            this.user.profile.attributes[param1] = param2;
         }
      }
      
      public function getUserAttribute(param1:String) : Object
      {
         return this.user.attributes[param1];
      }
      
      public function warning(... rest) : void
      {
         this.log("warning",rest);
      }
   }
}

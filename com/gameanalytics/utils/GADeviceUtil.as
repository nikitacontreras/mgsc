package com.gameanalytics.utils
{
   import com.gameanalytics.constants.GASharedObjectConstants;
   import flash.net.SharedObject;
   import flash.system.Capabilities;
   
   public class GADeviceUtil implements IGADeviceUtil
   {
       
      
      private var deviceId:String;
      
      public function GADeviceUtil()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         var _loc1_:SharedObject = SharedObject.getLocal(GASharedObjectConstants.SHARED_OBJECT_ID);
         if(_loc1_ && _loc1_.data && _loc1_.data[GASharedObjectConstants.DEVICE_ID] != undefined)
         {
            this.deviceId = _loc1_.data[GASharedObjectConstants.DEVICE_ID];
         }
         else
         {
            this.deviceId = GAUniqueIdUtil.createUnuqueId();
            if(_loc1_)
            {
               _loc1_.data[GASharedObjectConstants.DEVICE_ID] = this.deviceId;
               _loc1_.flush();
            }
         }
      }
      
      public function isMobileDevice() : Boolean
      {
         return false;
      }
      
      public function createInitialUserObject(param1:String, param2:String, param3:String, param4:String) : Object
      {
         return {
            "user_id":param1,
            "session_id":param2,
            "build":param3,
            "platform":Capabilities.os,
            "os_major":Capabilities.os,
            "sdk_version":param4
         };
      }
      
      public function getDeviceId() : String
      {
         return this.deviceId;
      }
   }
}

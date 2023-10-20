package com.qb9.gaturro.user.settings
{
   import flash.events.Event;
   
   public class UserSettingsEvent extends Event
   {
      
      public static const SETTING_CHANGED:String = "settingChanged";
       
      
      public var data:Object;
      
      public function UserSettingsEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}

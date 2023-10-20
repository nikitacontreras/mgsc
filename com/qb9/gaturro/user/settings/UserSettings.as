package com.qb9.gaturro.user.settings
{
   import com.qb9.gaturro.commons.persistence.cookie.SharedObjectManager;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.audio;
   import com.qb9.gaturro.globals.logger;
   import flash.display.Stage;
   import flash.display.StageQuality;
   import flash.events.EventDispatcher;
   
   public class UserSettings extends EventDispatcher
   {
      
      public static const SFX_KEY:String = "sfx";
      
      public static const MUSIC_KEY:String = "music";
      
      public static const AMBIENCE_KEY:String = "ambience";
      
      public static const SOUND_LEVEL:String = "level";
      
      private static const USER_SETTINGS:String = "USER_SETTINGS";
      
      public static const USERNAMES_KEY:String = "names";
      
      public static const QUALITY_KEY:String = "render";
       
      
      private var settings:Array;
      
      private var stage:Stage;
      
      private var cookies:SharedObjectManager;
      
      public function UserSettings(param1:Stage)
      {
         this.settings = [SOUND_LEVEL,AMBIENCE_KEY,MUSIC_KEY,SFX_KEY,QUALITY_KEY,USERNAMES_KEY];
         super();
         this.stage = param1;
         this.cookies = SharedObjectManager.instance;
         this.cookies.create(USER_SETTINGS);
         this.defaults();
         this.loadSettings();
      }
      
      private function loadSettings() : void
      {
         var _loc1_:String = null;
         for each(_loc1_ in this.settings)
         {
            if(this.getValue(_loc1_) !== null)
            {
               this.apply(_loc1_,this.getValue(_loc1_));
            }
         }
      }
      
      public function apply(param1:String, param2:*) : void
      {
         switch(param1)
         {
            case AMBIENCE_KEY:
               audio.ambience = param2;
               break;
            case MUSIC_KEY:
               audio.music = param2;
               break;
            case SOUND_LEVEL:
               audio.masterVolume = 0.0001 + param2 / 100;
               break;
            case QUALITY_KEY:
               this.stage.quality = !!param2 ? StageQuality.MEDIUM : StageQuality.LOW;
               break;
            case USERNAMES_KEY:
               api.showUsersNames = param2;
         }
      }
      
      public function setValue(param1:String, param2:*) : void
      {
         this.cookies.write(USER_SETTINGS,param1,param2);
         var _loc3_:UserSettingsEvent = new UserSettingsEvent(UserSettingsEvent.SETTING_CHANGED);
         _loc3_.data = {
            "key":param1,
            "value":param2
         };
         dispatchEvent(_loc3_);
         this.apply(param1,param2);
      }
      
      private function defaults() : void
      {
         if(this.getValue(SOUND_LEVEL) === null)
         {
            this.setValue(SOUND_LEVEL,100);
         }
         if(this.getValue(AMBIENCE_KEY) === null)
         {
            this.setValue(AMBIENCE_KEY,true);
         }
         if(this.getValue(SFX_KEY) === null)
         {
            this.setValue(SFX_KEY,true);
         }
         if(this.getValue(MUSIC_KEY) === null)
         {
            this.setValue(MUSIC_KEY,true);
         }
         if(this.getValue(USERNAMES_KEY) === 100)
         {
            this.setValue(USERNAMES_KEY,false);
         }
         if(this.getValue(QUALITY_KEY) === null)
         {
            this.setValue(QUALITY_KEY,true);
         }
      }
      
      private function debug() : void
      {
         logger.debug(this,AMBIENCE_KEY,this.getValue(AMBIENCE_KEY));
         logger.debug(this,MUSIC_KEY,this.getValue(MUSIC_KEY));
         logger.debug(this,SFX_KEY,this.getValue(SFX_KEY));
         logger.debug(this,SOUND_LEVEL,this.getValue(SOUND_LEVEL));
         logger.debug(this,USERNAMES_KEY,this.getValue(USERNAMES_KEY));
         logger.debug(this,QUALITY_KEY,this.getValue(QUALITY_KEY));
      }
      
      public function getValue(param1:String) : *
      {
         return this.cookies.read(USER_SETTINGS,param1);
      }
   }
}

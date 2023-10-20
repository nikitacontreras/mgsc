package com.qb9.gaturro.view.screens
{
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.globals.net;
   import com.qb9.gaturro.user.settings.UserSettings;
   import com.qb9.gaturro.user.settings.UserSettingsEvent;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import com.qb9.gaturro.view.gui.report.ReportModal;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public final class UserSettingsBanner extends InstantiableGuiModal
   {
      
      public static const CLOSE:String = "close";
      
      public static const TOGGLE_AUDIO:String = "toggleAudio";
       
      
      private var help:MovieClip;
      
      private var level:MovieClip;
      
      private var userSetting:UserSettings;
      
      private var buttons:Array;
      
      private var startsWithSound:Boolean;
      
      private var steps:int = 25;
      
      private var login:Boolean = true;
      
      private var levelBtns:Array;
      
      public function UserSettingsBanner()
      {
         this.buttons = [UserSettings.AMBIENCE_KEY,UserSettings.MUSIC_KEY,UserSettings.SFX_KEY,UserSettings.QUALITY_KEY,UserSettings.USERNAMES_KEY];
         this.levelBtns = [];
         super("UserSettingsBanner","UserSettingsBannerAsset");
         this.userSetting = Context.instance.getByType(UserSettings) as UserSettings;
         this.userSetting.addEventListener(UserSettingsEvent.SETTING_CHANGED,this.onSettingChanged);
      }
      
      private function onSettingChanged(param1:UserSettingsEvent) : void
      {
         logger.debug(this,param1.data.key,param1.data.value);
      }
      
      private function setupView() : void
      {
         var _loc1_:String = null;
         var _loc4_:MovieClip = null;
         for each(_loc1_ in this.buttons)
         {
            this.setupButton(_loc1_);
         }
         this.level = view.getChildByName("level") as MovieClip;
         this.level.mouseChildren = true;
         this.level.addEventListener(MouseEvent.CLICK,this.onLevelClick);
         var _loc2_:int = 0;
         while(_loc2_ < this.level.numChildren)
         {
            (_loc4_ = this.level.getChildAt(_loc2_) as MovieClip).gotoAndStop("off");
            this.levelBtns.push(_loc4_);
            _loc2_++;
         }
         var _loc3_:int = this.userSetting.getValue(UserSettings.SOUND_LEVEL) / this.steps;
         (this.levelBtns[_loc3_] as MovieClip).gotoAndStop("on");
         (view.getChildByName("help") as MovieClip).addEventListener(MouseEvent.CLICK,this.onHelpClick);
         (view.getChildByName("help") as MovieClip).buttonMode = true;
         (view.getChildByName("help") as MovieClip).mouseEnabled = true;
         (view.getChildByName("help") as MovieClip).mouseChildren = false;
         (view.getChildByName("abuse") as MovieClip).addEventListener(MouseEvent.CLICK,this.onAbuseClick);
         (view.getChildByName("abuse") as MovieClip).buttonMode = true;
         (view.getChildByName("abuse") as MovieClip).mouseChildren = false;
      }
      
      private function toggle(param1:MovieClip) : Boolean
      {
         var _loc2_:String = param1.currentLabel;
         param1.play();
         return _loc2_ != "on" ? true : false;
      }
      
      private function setupButton(param1:String) : MovieClip
      {
         var _loc2_:MovieClip = null;
         _loc2_ = view.getChildByName(param1) as MovieClip;
         _loc2_.data = param1;
         _loc2_.gotoAndStop(!!this.userSetting.getValue(param1) ? "on" : "off");
         _loc2_.addEventListener(MouseEvent.CLICK,this.handleButton);
         _loc2_.mouseChildren = false;
         _loc2_.buttonMode = true;
         return _loc2_;
      }
      
      override protected function onAssetReady() : void
      {
         this.setupView();
      }
      
      override public function dispose() : void
      {
         var _loc1_:String = null;
         if(this.help)
         {
            this.help.removeEventListener(MouseEvent.CLICK,this.onHelpClick);
         }
         for each(_loc1_ in this.buttons)
         {
            this.disposeButton(_loc1_);
         }
         this.level.removeEventListener(MouseEvent.CLICK,this.onLevelClick);
         (view.getChildByName("help") as MovieClip).removeEventListener(MouseEvent.CLICK,this.onHelpClick);
         super.dispose();
      }
      
      private function onAbuseClick(param1:Event = null) : void
      {
         logger.debug(this,"onAbuseClick");
         addChild(new ReportModal(net,api.room.userHistory));
         this.dispose();
      }
      
      private function onLevelClick(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:Number = NaN;
         for each(_loc2_ in this.levelBtns)
         {
            _loc2_.gotoAndStop("off");
         }
         _loc2_ = param1.target as MovieClip;
         _loc2_.gotoAndStop("on");
         _loc3_ = _loc2_.name.split("_")[1] * this.steps;
         this.userSetting.setValue(UserSettings.SOUND_LEVEL,_loc3_);
      }
      
      private function onHelpClick(param1:Event = null) : void
      {
         if(api.room.isFarmRoom)
         {
            api.showBannerModal("tutorialGranjaBLOG");
         }
         else
         {
            api.showBannerModal("tutorial",null);
         }
      }
      
      private function disposeButton(param1:String) : void
      {
         var _loc2_:MovieClip = view.getChildByName(param1) as MovieClip;
         _loc2_.removeEventListener(MouseEvent.CLICK,this.handleButton);
      }
      
      private function handleButton(param1:Event) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         var _loc3_:Boolean = this.toggle(_loc2_);
         this.userSetting.setValue(_loc2_.data,_loc3_);
      }
   }
}

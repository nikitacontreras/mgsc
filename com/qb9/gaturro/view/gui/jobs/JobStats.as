package com.qb9.gaturro.view.gui.jobs
{
   import asset.JobStatsAsset;
   import com.qb9.flashlib.easing.Tween;
   import com.qb9.flashlib.tasks.Func;
   import com.qb9.flashlib.tasks.Sequence;
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.view.gui.Gui;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.setTimeout;
   
   public class JobStats
   {
      
      public static const GRANJA:String = "GRANJERO";
       
      
      private var maxLevel:int;
      
      private var config:Object;
      
      private var xpAtNextLevel:int;
      
      private var xpAtPreviousLevel:int;
      
      private var gui:Gui;
      
      private var tasks:TaskContainer;
      
      public var currentLevel:int;
      
      private var percentage:Number;
      
      private var _asset:JobStatsAsset;
      
      private var xp:int;
      
      private var xpCap:int;
      
      private var category:String;
      
      public function JobStats(param1:String, param2:Gui, param3:Object, param4:TaskContainer)
      {
         super();
         this._asset = new JobStatsAsset();
         this.gui = param2;
         this.category = param1;
         this.config = param3;
         this.tasks = param4;
         this.init();
      }
      
      public function increaseXP(param1:int) : void
      {
         this.xp += param1;
         if(this.xp > this.xpCap)
         {
            this.xp = this.xpCap;
            api.showBannerModal("granjaMaxLevel");
         }
         api.setProfileAttribute(this.category,this.xp);
         if(this.xp == this.xpCap)
         {
            return;
         }
         this.checkLevelUp();
         while(this.xp > this.xpAtNextLevel)
         {
            this.checkLevelUp();
         }
      }
      
      private function acquiredAtlevel(param1:int) : Object
      {
         var _loc3_:Object = null;
         var _loc4_:Boolean = false;
         var _loc5_:Object = null;
         var _loc6_:String = null;
         var _loc2_:Array = [];
         for each(_loc3_ in settings.granjaHome.crops)
         {
            if(_loc3_.unlockAt == param1.toString())
            {
               _loc2_.push(_loc3_);
            }
         }
         _loc4_ = false;
         for each(_loc5_ in settings.granjaHome.parcelaCoord)
         {
            if(_loc5_.unlockAt == this.currentLevel.toString())
            {
               _loc4_ = true;
            }
         }
         _loc6_ = String(settings.granjaHome.levelUpBonus[param1.toString()]);
         return {
            "crops":_loc2_,
            "parcelaUnlock":_loc4_,
            "premio":_loc6_
         };
      }
      
      private function init() : void
      {
         var _loc1_:int = 0;
         this.xp = int(api.getProfileAttribute(this.category)) || 0;
         this.xpAtNextLevel = 0;
         this.currentLevel = 1;
         this.maxLevel = this.config.maxLevel;
         this.xpCap = this.config[this.maxLevel.toString()] - 1;
         var _loc2_:int = int.MAX_VALUE;
         var _loc3_:int = 1;
         while(_loc3_ <= this.maxLevel)
         {
            _loc1_ = this.config[_loc3_.toString()] as int;
            if(this.xp < _loc1_ && _loc1_ - this.xp < _loc2_)
            {
               this.xpAtPreviousLevel = this.config[(_loc3_ - 1).toString()] as int;
               this.xpAtNextLevel = _loc1_;
               _loc2_ = _loc1_ - this.xp;
               this.currentLevel = _loc3_ - 1;
            }
            _loc3_++;
         }
         if(this.xp > this.xpCap)
         {
            this.currentLevel = this.maxLevel;
            this.xp = this.xpCap;
            api.setProfileAttribute(this.category,this.xp);
            this.xpAtPreviousLevel = this.config[(this.currentLevel - 1).toString()] as int;
            this.xpAtNextLevel = this.config[this.currentLevel.toString()] as int;
         }
         this._asset.titleName.text = api.getText(this.category.toUpperCase() + " NIVEL");
         this._asset.level.text = this.currentLevel.toString();
         this.percentage = (this.xp - this.xpAtPreviousLevel) / (this.xpAtNextLevel - this.xpAtPreviousLevel);
         this._asset.progressBar.width = this._asset.totalLength.width * this.percentage;
         var _loc4_:int = api.getProfileAttribute("coins") as int;
         this._asset.jobCoins.userCoins.text = _loc4_.toString();
         this._asset.jobCoins.g.gotoAndStop("black");
         this.gui.addChild(this._asset);
      }
      
      private function activate(param1:MouseEvent) : void
      {
         this.increaseXP(this.xpAtNextLevel - this.xp);
      }
      
      private function checkLevelUp() : void
      {
         var _loc2_:Sequence = null;
         var _loc3_:int = 0;
         var _loc1_:Array = [];
         if(this.xp >= this.xpAtNextLevel)
         {
            ++this.currentLevel;
            this.xpAtPreviousLevel = this.xpAtNextLevel;
            this.xpAtNextLevel = this.config[(this.currentLevel + 1).toString()] as int;
            this.percentage = (this.xp - this.xpAtPreviousLevel) / (this.xpAtNextLevel - this.xpAtPreviousLevel);
            _loc3_ = this._asset.totalLength.width * this.percentage;
            _loc1_.push(new Tween(this._asset.progressBar,500,{"width":this._asset.totalLength.width},{"transition":"easeIn"}));
            _loc1_.push(new Tween(this._asset.progressBar,1,{"width":0},{"transition":"easeIn"}));
            _loc1_.push(new Tween(this._asset.level,1,{"text":this.currentLevel.toString()}));
            if(this.gui.hasModal)
            {
               _loc1_.push(new Func(this.gui.modal.addEventListener,Event.REMOVED_FROM_STAGE,this.levelUpAfterClosing));
            }
            else
            {
               _loc1_.push(new Func(api.showGranjaLevelUpModal,this.currentLevel,this.acquiredAtlevel(this.currentLevel)));
            }
         }
         else
         {
            this.percentage = (this.xp - this.xpAtPreviousLevel) / (this.xpAtNextLevel - this.xpAtPreviousLevel);
            _loc3_ = this._asset.totalLength.width * this.percentage;
         }
         _loc1_.push(new Tween(this._asset.progressBar,500,{"width":_loc3_},{"transition":"easeIn"}));
         _loc2_ = new Sequence(_loc1_);
         this.tasks.add(_loc2_);
      }
      
      private function levelUpAfterClosing(param1:Event) : void
      {
         api.showGranjaLevelUpModal(this.currentLevel,this.acquiredAtlevel(this.currentLevel));
      }
      
      public function get coinsAsset() : MovieClip
      {
         return this._asset.jobCoins;
      }
      
      private function animateCoins(param1:int, param2:int, param3:Boolean) : void
      {
         var _loc4_:TextField = this._asset.jobCoins.userCoins;
         if(param3)
         {
            param1++;
         }
         else
         {
            param1--;
         }
         _loc4_.text = param1.toString();
         if(param1 == param2)
         {
            return;
         }
         setTimeout(this.animateCoins,25,param1,param2,param3);
      }
      
      public function updateCoins(param1:int) : void
      {
         var _loc2_:int = int(this._asset.jobCoins.userCoins.text);
         var _loc3_:Boolean = _loc2_ > param1 ? false : true;
         setTimeout(this.animateCoins,25,_loc2_,param1,_loc3_);
      }
   }
}

package com.qb9.gaturro.level
{
   import com.adobe.serialization.json.JSON;
   import com.qb9.flashlib.config.Settings;
   import com.qb9.flashlib.net.LoadFile;
   import com.qb9.flashlib.net.LoadFileFormat;
   import com.qb9.flashlib.net.LoadFileParsers;
   import com.qb9.flashlib.tasks.TaskEvent;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.net.requests.URLUtil;
   import com.qb9.gaturro.view.world.avatars.Gaturro;
   import com.qb9.mambo.world.avatars.UserAvatar;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.setTimeout;
   
   public class LevelManager extends EventDispatcher
   {
      
      public static const LEVEL_REQ_TO_BE_SUPER_HEROE:int = 20;
       
      
      private var levelDef:Settings;
      
      public var _levelExplorer:int;
      
      public var _levelCompetitive:int;
      
      public var _levelSocial:int;
      
      public function LevelManager(param1:IEventDispatcher = null)
      {
         super(param1);
         this.initconfig();
      }
      
      public function getProgress(param1:Object) : int
      {
         var _loc6_:Object = null;
         var _loc2_:int = param1 as int;
         var _loc3_:Object = this.levelDef.definition.levels;
         var _loc4_:int = 1;
         var _loc5_:int = 1;
         for each(_loc6_ in _loc3_)
         {
            if(_loc2_ >= _loc6_.exp)
            {
               _loc4_ = int(_loc6_.exp);
            }
            else if(_loc2_ < _loc6_.exp)
            {
               _loc5_ = int(_loc6_.exp);
               break;
            }
         }
         return (_loc2_ - _loc4_) * 100 / (_loc5_ - _loc4_);
      }
      
      private function levelUp(param1:Object = null) : void
      {
         var prize:Object = param1;
         if(prize != null)
         {
            setTimeout(function():void
            {
               api.showModal("¡¡SUBISTE DE NIVEL!! ESTE ES TU PREMIO",prize as String);
               api.giveUser(prize as String,1);
            },4000);
         }
         this.refreshStats();
      }
      
      private function checkReset() : void
      {
         var _loc1_:Object = api.getProfileAttribute("resetLevels");
         if(_loc1_ == null || _loc1_ == false)
         {
            api.setProfileAttribute("resetLevels",true);
            this.resetLevels();
         }
      }
      
      private function setupLevels(param1:Event = null) : void
      {
         if(this.avatar.attributes.competitiveSkills == null)
         {
            this.avatar.attributes.competitiveSkills = 0;
         }
         if(this.avatar.attributes.explorerSkills == null)
         {
            this.avatar.attributes.explorerSkills = 0;
         }
         if(this.avatar.attributes.socialSkills == null)
         {
            this.avatar.attributes.socialSkills = 0;
         }
         this.checkReset();
         this._levelCompetitive = this.getLevelOfSkill(this.avatar.attributes.competitiveSkills);
         this._levelExplorer = this.getLevelOfSkill(this.avatar.attributes.explorerSkills);
         this._levelSocial = this.getLevelOfSkill(this.avatar.attributes.socialSkills);
      }
      
      public function addSocialExp(param1:int) : void
      {
         var levelBefExp:int;
         var partialResult:int = 0;
         var currentObjLevel:Object = null;
         var userCoins:int = 0;
         var exp:int = param1;
         if(!this.avatar.isCitizen)
         {
            return;
         }
         partialResult = this.avatar.attributes.socialSkills + exp;
         levelBefExp = this._levelSocial;
         this.avatar.attributes.socialSkills = partialResult;
         if(levelBefExp < this.getLevelOfSkill(partialResult))
         {
            this._levelExplorer = this.getLevelOfSkill(this.avatar.attributes.socialSkills);
            currentObjLevel = this.levelDef.definition.levels[this.getLevelOfSkill(partialResult) - 1];
            if(currentObjLevel.gold)
            {
               userCoins = api.getProfileAttribute("coins") as int;
               userCoins += currentObjLevel.gold;
               api.setProfileAttribute("system_coins",userCoins);
            }
            this.levelUp(currentObjLevel.social);
            setTimeout(function():void
            {
               api.userAvatar.attributes[Gaturro.ACTION_KEY] = "showObjectUp.magia.soc_lvlUp";
               api.playSound("levelup");
            },2000);
         }
         else
         {
            setTimeout(function():void
            {
               api.userAvatar.attributes[Gaturro.ACTION_KEY] = "showObjectUp.magia.soc_on";
               api.playSound("snake_jugar");
            },2000);
         }
         api.trackEvent("FEATURES:LEVEL_UP:ADDEXP:" + this.avatar.username + ":SOCIAL",exp.toString());
      }
      
      public function addCompetitiveExp(param1:int) : void
      {
         var levelBefExp:int;
         var partialResult:int = 0;
         var currentObjLevel:Object = null;
         var userCoins:int = 0;
         var exp:int = param1;
         if(!this.avatar.isCitizen)
         {
            return;
         }
         partialResult = this.avatar.attributes.competitiveSkills + exp;
         levelBefExp = this._levelCompetitive;
         this.avatar.attributes.competitiveSkills = partialResult;
         if(levelBefExp < this.getLevelOfSkill(partialResult))
         {
            this._levelCompetitive = this.getLevelOfSkill(this.avatar.attributes.competitiveSkills);
            currentObjLevel = this.levelDef.definition.levels[this.getLevelOfSkill(partialResult) - 1];
            if(currentObjLevel.gold)
            {
               userCoins = api.getProfileAttribute("coins") as int;
               userCoins += currentObjLevel.gold;
               api.setProfileAttribute("system_coins",userCoins);
            }
            this.levelUp(currentObjLevel.competitive);
            setTimeout(function():void
            {
               api.userAvatar.attributes[Gaturro.ACTION_KEY] = "showObjectUp.magia.comp_lvlUp";
               api.playSound("levelup");
            },2000);
         }
         else
         {
            setTimeout(function():void
            {
               api.userAvatar.attributes[Gaturro.ACTION_KEY] = "showObjectUp.magia.comp_on";
               api.playSound("snake_jugar");
            },2000);
         }
         api.trackEvent("FEATURES:LEVEL_UP:ADDEXP:" + this.avatar.username + ":COMPETITIVE",exp.toString());
      }
      
      private function get avatar() : UserAvatar
      {
         return api.userAvatar;
      }
      
      public function getLevelOfSkill(param1:Object) : int
      {
         var _loc4_:Object = null;
         var _loc2_:Object = this.levelDef.definition.levels;
         var _loc3_:int = 1;
         for each(_loc4_ in _loc2_)
         {
            if(param1 as int >= (_loc4_.exp as int))
            {
               _loc3_ = int(_loc4_.level);
            }
            else if(param1 as int < (_loc4_.exp as int))
            {
               return _loc3_;
            }
         }
         return _loc3_;
      }
      
      public function refreshStats() : void
      {
         this._levelCompetitive = this.getLevelOfSkill(this.avatar.attributes.competitiveSkills);
         this._levelExplorer = this.getLevelOfSkill(this.avatar.attributes.explorerSkills);
         this._levelSocial = this.getLevelOfSkill(this.avatar.attributes.socialSkills);
      }
      
      public function addExplorerExp(param1:int) : void
      {
         var levelBefExp:int;
         var partialResult:int = 0;
         var currentObjLevel:Object = null;
         var userCoins:int = 0;
         var exp:int = param1;
         if(!this.avatar.isCitizen)
         {
            return;
         }
         if(this.avatar == null)
         {
            return;
         }
         partialResult = this.avatar.attributes.explorerSkills + exp;
         levelBefExp = this._levelExplorer;
         this.avatar.attributes.explorerSkills = partialResult;
         if(levelBefExp < this.getLevelOfSkill(partialResult))
         {
            this._levelExplorer = this.getLevelOfSkill(this.avatar.attributes.explorerSkills);
            currentObjLevel = this.levelDef.definition.levels[this.getLevelOfSkill(partialResult) - 1];
            if(currentObjLevel.gold)
            {
               userCoins = api.getProfileAttribute("coins") as int;
               userCoins += currentObjLevel.gold;
               api.setProfileAttribute("system_coins",userCoins);
            }
            this.levelUp(currentObjLevel.explorer);
            setTimeout(function():void
            {
               api.userAvatar.attributes[Gaturro.ACTION_KEY] = "showObjectUp.magia.explo_lvlUp";
               api.playSound("levelup");
            },2000);
         }
         else
         {
            setTimeout(function():void
            {
               api.userAvatar.attributes[Gaturro.ACTION_KEY] = "showObjectUp.magia.explorer_on";
               api.playSound("snake_jugar");
            },2000);
         }
         api.trackEvent("FEATURES:LEVEL_UP:ADDEXP:" + this.avatar.username + ":EXPLORER",exp.toString());
      }
      
      public function resetLevels() : void
      {
         this.avatar.attributes.competitiveSkills = 0;
         this.avatar.attributes.explorerSkills = 0;
         this.avatar.attributes.socialSkills = 0;
      }
      
      private function initconfig() : void
      {
         this.levelDef = new Settings();
         LoadFileParsers.registerParser(LoadFileFormat.JSON,com.adobe.serialization.json.JSON.decode);
         var _loc1_:String = URLUtil.getUrl("cfgs/profileStats.json");
         var _loc2_:LoadFile = new LoadFile(_loc1_,"json");
         this.levelDef.addFile(_loc2_);
         _loc2_.addEventListener(TaskEvent.COMPLETE,this.setupLevels);
         _loc2_.start();
      }
   }
}

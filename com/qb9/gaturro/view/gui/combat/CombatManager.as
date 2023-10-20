package com.qb9.gaturro.view.gui.combat
{
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.flashlib.tasks.TaskRunner;
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.event.ContextEvent;
   import com.qb9.gaturro.commons.object.ObjectUtil;
   import com.qb9.gaturro.external.roomObjects.GaturroSceneObjectAPI;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.manager.counter.GaturroCounterManager;
   import com.qb9.gaturro.user.inventory.ClothInventorySceneObject;
   import com.qb9.gaturro.user.inventory.GaturroInventorySceneObject;
   import com.qb9.gaturro.user.inventory.WearableInventorySceneObject;
   import com.qb9.gaturro.view.gui.Gui;
   import com.qb9.gaturro.view.gui.actions.GatoonFightButtons;
   import com.qb9.gaturro.view.gui.util.GuiUtil;
   import com.qb9.gaturro.view.world.avatars.Gaturro;
   import com.qb9.gaturro.view.world.chat.ChatViewEvent;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.mambo.world.avatars.UserAvatar;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.utils.Dictionary;
   import flash.utils.clearTimeout;
   import flash.utils.getQualifiedClassName;
   import flash.utils.setTimeout;
   
   public class CombatManager implements IDisposable
   {
      
      private static const GATOONS_MONSTER1_KEY:String = "gatoonsMonster1";
      
      private static const GATOONS_MONSTER2_KEY:String = "gatoonsMonster2";
      
      private static const GATOONS_MONSTER_KEY:String = "gatoonsMonster";
       
      
      private var clothesByPower:Object;
      
      private var hitCounterAsset:MovieClip;
      
      private var transformInterval:int;
      
      private var tasks:TaskRunner;
      
      private var currentClothes:Object;
      
      private var counterManager:GaturroCounterManager;
      
      private var won:Boolean = false;
      
      private var objectAttackPattern:Array;
      
      private var GATOONS_CLOTHES_PACK:String = "gatoonsClothes.";
      
      private var actionAssetByPower:Object;
      
      private var setAttributeInterval:uint;
      
      private var gui:Gui;
      
      private var waitingEvents:Boolean;
      
      private var hitAnimationMC:MovieClip;
      
      private var fightingCamugata:Boolean;
      
      private var previousClothes:Object;
      
      private var actionByPower:Object;
      
      private var avatar:UserAvatar;
      
      private var objectAPI:GaturroSceneObjectAPI;
      
      private var resetClothesInterval:uint;
      
      private var fightButton:GatoonFightButtons;
      
      private var fightingGrandCosmus:Boolean;
      
      private var objectAttackCount:int;
      
      private var room:GaturroRoom;
      
      private var gatoonClothesOwned:Array;
      
      private var pwerConfigByName:Dictionary;
      
      public function CombatManager(param1:Gui, param2:GaturroRoom, param3:UserAvatar, param4:TaskRunner)
      {
         super();
         this.gui = param1;
         this.room = param2;
         this.avatar = param3;
         this.tasks = param4;
         this.waitingEvents = true;
         this.pwerConfigByName = new Dictionary();
         this.evalCounter();
      }
      
      private function onFinishedChat(param1:ChatViewEvent) : void
      {
         trace("PRENDE WAITING EVENTS: onFinishedChat()");
         this.waitingEvents = true;
      }
      
      public function stop() : void
      {
         if(this.fightButton)
         {
            this.fightButton.visible = false;
         }
         if(this.won)
         {
            this.resetClothesInterval = setTimeout(this.resetClothes,4000);
         }
         else
         {
            this.won = false;
            this.resetClothes();
         }
         this.hitCounterAsset.visible = false;
      }
      
      private function missEnemy() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:int = 0;
         this.objectAPI.object.dispatchEvent(new CombatEvent(CombatEvent.NPC_WRONG_ATTACK,this.objectAPI));
         if(this.objectAttackCount > 0 && this.fightingCamugata)
         {
            _loc1_ = this.hitCounterAsset["hit" + (this.objectAttackCount - 1).toString()];
            _loc2_ = 0;
            while(_loc2_ < _loc1_.numChildren - 1)
            {
               trace(getQualifiedClassName(_loc1_.getChildAt(_loc2_)));
               _loc2_++;
            }
            if(getQualifiedClassName(_loc1_.getChildAt(_loc2_)).indexOf("Emblem") != -1)
            {
               _loc1_.removeChildAt(_loc2_);
            }
            --this.objectAttackCount;
         }
      }
      
      private function retrievePowersFromInventory() : Array
      {
         var _loc3_:Object = null;
         var _loc4_:ClothInventorySceneObject = null;
         if(!this.gatoonClothesOwned)
         {
            this.gatoonClothesOwned = this.findAllGatoonsClothes();
         }
         var _loc1_:Array = [];
         var _loc2_:int = 0;
         while(_loc2_ < settings.gatoons.powerConfig.length)
         {
            _loc3_ = settings.gatoons.powerConfig[_loc2_];
            if(_loc4_ = this.findOneRandomCloth(_loc3_,this.gatoonClothesOwned))
            {
               _loc1_.push(_loc3_.power);
               this.actionByPower[_loc3_.power.toUpperCase()] = _loc3_.action;
               this.actionAssetByPower[_loc3_.power.toUpperCase()] = _loc3_.asset;
               this.pwerConfigByName[_loc3_.power.toUpperCase()] = _loc3_;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      private function setAvatarAttribute(param1:Object) : void
      {
         clearTimeout(this.setAttributeInterval);
         api.setAvatarAttribute(Gaturro.ACTION_KEY,param1);
      }
      
      private function enemyReaction(param1:String) : void
      {
         var _loc2_:Object = this.pwerConfigByName[param1];
         api.libraries.fetch(_loc2_.enemyAnimation,this.onEnemyHitFetch,param1);
      }
      
      private function findAllGatoonsClothes() : Array
      {
         var _loc3_:GaturroInventorySceneObject = null;
         var _loc4_:ClothInventorySceneObject = null;
         var _loc1_:Array = [];
         var _loc2_:int = 0;
         while(_loc2_ < this.objectAPI.user.visualizer.items.length)
         {
            _loc3_ = this.objectAPI.user.visualizer.items[_loc2_];
            if(_loc3_.name.indexOf(this.GATOONS_CLOTHES_PACK) != -1 && _loc3_ is WearableInventorySceneObject)
            {
               _loc4_ = _loc3_ as ClothInventorySceneObject;
               _loc1_.push(_loc3_);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      private function triggerAction(param1:String) : void
      {
         var _loc2_:String = this.fightingGrandCosmus || this.fightingCamugata ? "2" : "";
         api.setAvatarAttribute(Gaturro.ACTION_KEY,this.actionByPower[param1] + "." + this.actionAssetByPower[param1] + _loc2_);
         setTimeout(this.enemyReaction,600,param1);
         api.playSound("gatoons/gatoon_combat_" + param1.toLowerCase());
      }
      
      public function dispose() : void
      {
         if(Boolean(this.objectAPI) && Boolean(this.objectAPI.view))
         {
            this.objectAPI.view.removeEventListener(ChatViewEvent.FINISHED,this.onFinishedChat);
         }
         if(this.fightButton)
         {
            this.fightButton.removeEventListener(CombatGUIEvent.GUI_PRESSED,this.onAction);
            this.fightButton.removeEventListener(CombatGUIEvent.GUI_READY,this.onCombatGuiReady);
            this.fightButton.dispose();
            this.fightButton = null;
         }
         clearTimeout(this.setAttributeInterval);
         clearTimeout(this.resetClothesInterval);
         this.objectAPI = null;
         this.gui = null;
         this.avatar = null;
         this.room = null;
      }
      
      private function hitEnemy(param1:String) : void
      {
         ++this.objectAttackCount;
         api.libraries.fetch(this.emblemByType(param1),this.onAddIconToHit);
         if(this.objectAttackCount >= this.objectAttackPattern.length)
         {
            this.won = true;
            setTimeout(this.objectAPI.object.dispatchEvent,500,new CombatEvent(CombatEvent.NPC_DEFEATED,this.objectAPI));
         }
         else
         {
            if(this.fightingCamugata)
            {
               switch(this.objectAttackCount)
               {
                  case 0:
                     this.objectAPI.object.attributes.textID = 1;
                     break;
                  case 1:
                     this.objectAPI.object.attributes.textID = 2;
                     break;
                  case 2:
                     this.objectAPI.object.attributes.textID = 3;
                     break;
                  default:
                     this.objectAPI.object.attributes.textID = 4;
               }
            }
            this.objectAPI.object.dispatchEvent(new CombatEvent(CombatEvent.NPC_CORRECT_ATTACK,this.objectAPI));
         }
      }
      
      private function finishAction() : void
      {
         this.objectAPI.view.removeChild(this.hitAnimationMC);
         this.hitAnimationMC = null;
         trace("APAGA WAITING EVENTS finishActions()");
      }
      
      private function resetConfigData() : void
      {
         this.clothesByPower = {
            "FIRE":"",
            "LASER":"",
            "ICE":"",
            "BUBBLE":"",
            "PLASMA":""
         };
         this.actionByPower = {
            "FIRE":"",
            "LASER":"",
            "ICE":"",
            "BUBBLE":"",
            "PLASMA":""
         };
         this.actionAssetByPower = {
            "FIRE":"",
            "LASER":"",
            "ICE":"",
            "BUBBLE":"",
            "PLASMA":""
         };
      }
      
      private function evalCounter() : void
      {
         if(Context.instance.hasByType(GaturroCounterManager))
         {
            this.counterManager = Context.instance.getByType(GaturroCounterManager) as GaturroCounterManager;
         }
         else
         {
            Context.instance.addEventListener(ContextEvent.ADDED,this.onAdded);
         }
      }
      
      private function clothInArray(param1:String, param2:Array) : Boolean
      {
         var _loc3_:int = 0;
         while(_loc3_ < param2.length)
         {
            if(param1.indexOf(param2[_loc3_]) > -1)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      private function findObjectAttackPattern(param1:String) : Array
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         while(_loc3_ < settings.gatoons.monsterConfig.length)
         {
            _loc2_ = settings.gatoons.monsterConfig[_loc3_];
            if(_loc2_.name == param1)
            {
               this.objectAPI.object.attributes.reward = _loc2_.reward;
               return _loc2_.pattern;
            }
            _loc3_++;
         }
         return [CombatGUIEvent.TYPE_FIRE,CombatGUIEvent.TYPE_FIRE,CombatGUIEvent.TYPE_FIRE];
      }
      
      private function wearingAvatar(param1:Object) : void
      {
         this.avatar.attributes.mergeObject(ObjectUtil.clone(param1));
      }
      
      private function reset() : void
      {
         if(!this.counterManager)
         {
            return;
         }
         this.counterManager.reset(GATOONS_MONSTER1_KEY);
         this.counterManager.reset(GATOONS_MONSTER2_KEY);
      }
      
      private function checkElement(param1:String) : Boolean
      {
         return param1 == this.objectAttackPattern[this.objectAttackCount];
      }
      
      private function randomIndex(param1:int) : int
      {
         return int(Math.random() * param1);
      }
      
      private function onAdded(param1:ContextEvent) : void
      {
         if(param1.instanceType == GaturroCounterManager)
         {
            this.counterManager = Context.instance.getByType(GaturroCounterManager) as GaturroCounterManager;
            Context.instance.removeEventListener(ContextEvent.ADDED,this.onAdded);
         }
      }
      
      private function onFetchHitCounter(param1:DisplayObject) : void
      {
         this.hitCounterAsset = param1 as MovieClip;
         this.objectAPI.view.addChild(this.hitCounterAsset);
         var _loc2_:int = 0;
         while(_loc2_ < 10)
         {
            this.hitCounterAsset["hit" + _loc2_].visible = false;
            _loc2_++;
         }
         var _loc3_:int = 0;
         while(_loc3_ < this.objectAttackPattern.length)
         {
            this.hitCounterAsset["hit" + _loc3_].visible = true;
            _loc3_++;
         }
      }
      
      public function start(param1:GaturroSceneObjectAPI) : void
      {
         this.resetConfigData();
         if(!this.fightButton)
         {
            this.fightButton = new GatoonFightButtons(this.gui,this.room,this.avatar,this.tasks);
            this.fightButton.addEventListener(CombatGUIEvent.GUI_PRESSED,this.onAction);
            this.fightButton.addEventListener(CombatGUIEvent.GUI_READY,this.onCombatGuiReady);
         }
         else
         {
            this.fightButton.visible = true;
            this.fightButton.setAvailablePowers(this.retrievePowersFromInventory());
         }
         this.previousClothes = ObjectUtil.clone(this.avatar.attributes);
         this.objectAPI = param1;
         this.fightingGrandCosmus = param1.object.name == "gatoons.monstruo7_so";
         this.fightingCamugata = param1.object.name.indexOf("gatoonsNPC.camugata") != -1;
         if(this.fightingCamugata)
         {
            param1.object.attributes.textID = 1;
         }
         this.objectAttackPattern = this.findObjectAttackPattern(param1.object.name);
         this.waitingEvents = true;
         param1.view.addEventListener(ChatViewEvent.FINISHED,this.onFinishedChat);
         if(!this.hitCounterAsset)
         {
            api.libraries.fetch(this.GATOONS_CLOTHES_PACK + "hitCounter",this.onFetchHitCounter);
         }
         else
         {
            this.hitCounterAsset.visible = true;
         }
      }
      
      private function emblemByType(param1:String) : String
      {
         switch(param1)
         {
            case CombatGUIEvent.TYPE_FIRE:
               return this.GATOONS_CLOTHES_PACK + "fireEmblem";
            case CombatGUIEvent.TYPE_LASER:
               return this.GATOONS_CLOTHES_PACK + "laserEmblem";
            case CombatGUIEvent.TYPE_ICE:
               return this.GATOONS_CLOTHES_PACK + "iceEmblem";
            case CombatGUIEvent.TYPE_BUBBLE:
               return this.GATOONS_CLOTHES_PACK + "bubbleEmblem";
            case CombatGUIEvent.TYPE_PLASMA:
               return this.GATOONS_CLOTHES_PACK + "plasmaEmblem";
            default:
               return null;
         }
      }
      
      private function transformAvatar(param1:String) : void
      {
         var _loc2_:Object = this.pwerConfigByName[param1];
         api.setAvatarAttribute(Gaturro.ACTION_KEY,_loc2_.transformAnimation);
         if(this.fightingGrandCosmus || this.fightingCamugata)
         {
            setTimeout(this.triggerAction,200,param1);
         }
         else
         {
            setTimeout(this.changeClothes,600,param1);
         }
      }
      
      private function findOneRandomCloth(param1:Object, param2:Array) : ClothInventorySceneObject
      {
         var _loc5_:ClothInventorySceneObject = null;
         if(!param2)
         {
            return null;
         }
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < param2.length)
         {
            _loc5_ = param2[_loc4_];
            if(this.clothInArray(_loc5_.name,param1.costumes))
            {
               _loc3_.push(_loc5_);
            }
            _loc4_++;
         }
         if(_loc3_.length > 0)
         {
            return _loc3_[this.randomIndex(_loc3_.length)];
         }
         return null;
      }
      
      private function onAction(param1:CombatGUIEvent) : void
      {
         if(!this.waitingEvents)
         {
            return;
         }
         this.fightButton.shakeButton(param1.element.toLowerCase());
         this.transformAvatar(param1.element);
         this.waitingEvents = false;
      }
      
      private function onEnemyHitFetch(param1:DisplayObject, param2:String) : void
      {
         this.hitAnimationMC = param1 as MovieClip;
         this.objectAPI.view.addChild(this.hitAnimationMC);
         this.hitAnimationMC.gotoAndPlay(0);
         var _loc3_:Boolean = this.checkElement(param2);
         if(_loc3_)
         {
            this.hitEnemy(param2);
         }
         else
         {
            this.missEnemy();
         }
         setTimeout(this.finishAction,2000);
      }
      
      private function resetClothes() : void
      {
         var _loc1_:String = null;
         clearTimeout(this.resetClothesInterval);
         if(this.currentClothes)
         {
            for(_loc1_ in this.currentClothes)
            {
               if(this.currentClothes[_loc1_])
               {
                  this.avatar.attributes[_loc1_] = "";
               }
            }
         }
         this.wearingAvatar(this.previousClothes);
      }
      
      private function onCombatGuiReady(param1:CombatGUIEvent) : void
      {
         this.fightButton.setAvailablePowers(this.retrievePowersFromInventory());
      }
      
      private function onAddIconToHit(param1:DisplayObject) : void
      {
         var _loc2_:MovieClip = this.hitCounterAsset["hit" + (this.objectAttackCount - 1).toString()];
         GuiUtil.fit(param1,_loc2_.width,_loc2_.height);
         _loc2_.addChild(param1);
      }
      
      private function changeClothes(param1:String) : void
      {
         var _loc2_:Object = this.pwerConfigByName[param1];
         var _loc3_:ClothInventorySceneObject = this.findOneRandomCloth(_loc2_,this.gatoonClothesOwned);
         this.currentClothes = _loc3_.providedAttributes;
         this.wearingAvatar(this.currentClothes);
         setTimeout(this.triggerAction,200,param1);
      }
   }
}

package com.qb9.gaturro.world.npc.interpreter.condition
{
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.gaturro.commons.constraint.ConstraintManager;
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.constraint.StartDateConstraint;
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.cards;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.manager.counter.GaturroCounterManager;
   import com.qb9.gaturro.manager.passport.BetterWithPassportManager;
   import com.qb9.gaturro.manager.provider.ProviderManager;
   import com.qb9.gaturro.manager.team.TeamManager;
   import com.qb9.gaturro.service.events.EventsService;
   import com.qb9.gaturro.service.passport.BubbleFlannysService;
   import com.qb9.gaturro.view.world.ProyectoGatuberRoomView;
   import com.qb9.gaturro.world.core.elements.OwnedNpcRoomSceneObject;
   import com.qb9.gaturro.world.npc.interpreter.NpcInterpreterError;
   import com.qb9.gaturro.world.npc.struct.NpcContext;
   import com.qb9.gaturro.world.npc.struct.NpcStatement;
   import com.qb9.mambo.world.avatars.Avatar;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.utils.getQualifiedClassName;
   
   public final class NpcConditionEvaluator implements IDisposable
   {
       
      
      private var teamManager:TeamManager;
      
      private var context:NpcContext;
      
      private var conditions:Object;
      
      public function NpcConditionEvaluator(param1:NpcContext)
      {
         this.conditions = {
            "inventory.has":this.hasItems,
            "client.isDesktop":this.isDesktop,
            "self.state":this.display,
            "user.isCitizen":this.isVip,
            "user.isCitizenType":this.isVipType,
            "user.isPinCitizenBoca":this.isVipBoca3Dias,
            "user.isPinCitizenRiver":this.isVipRiver3Dias,
            "user.wears":this.userWears,
            "cards.enabled":this.cardsEnabled,
            "cards.haveCards":this.cardsHave,
            "constraint.isAccomplished":this.constraintIsAccomplished,
            "modulo":this.modulo,
            "eqCharAt":this.eqCharAt,
            "defined":this.variableExists,
            "exists":this.stateExists,
            "eq":this.equals,
            "gt":this.greaterThan,
            "lt":this.lowerThan,
            "egt":this.greaterEqualThan,
            "elt":this.lowerEqualThan,
            "null":this.isNull,
            "log":this.log,
            "not":this.not,
            "user.hasPet":this.userHasPet,
            "user.hasPenguin":this.userHasPenguin,
            "user.effect":this.checkUserEffect,
            "user.effect2":this.checkUserEffect2,
            "global.isNight":this.isNight,
            "room.isOwner":this.isOwner,
            "room.isRoof":this.isRoof,
            "room.isAttic":this.isAttic,
            "room.isHome":this.isHome,
            "bgroundIsName":this.bgroundIsName,
            "funnys.canCatchFunnys":this.canICatchFunnys,
            "funnys.cannotCatchFunnys":this.cannotCatchFunnys,
            "funnys.isReady":this.isFlanyReady,
            "date.startDate":this.startDate,
            "team.isSuscribed":this.suscribedToFeature,
            "team.isTeam":this.suscribedToTeam,
            "team.isEndDate":this.endDateReached,
            "war.hasGift":this.warHasGift,
            "war.canIRobTrolls":this.canIRobTrolls,
            "war.canIRobPapas":this.canIRobPapas,
            "dropGift.isReadyOwner":this.dropGiftReadyOwner,
            "dropGift.isReadyVisitor":this.dropGiftReadyVisitor,
            "dropGift.isDressed":this.dropGiftIsDressed,
            "betterWithPassaport.exist":this.existBetterWithPassportFeature,
            "betterWithPassaport.blocked":this.blockedBetterWithPassport,
            "feature.dressed":this.checkDressedForFeature,
            "party.hasActive":this.partyHasActive,
            "party.imHost":this.partyImHost,
            "take.coins":this.takeCoins,
            "provider.hasMore":this.providerHasMore,
            "counter.reached":this.counterReached,
            "counter.equal":this.counterEqual,
            "counter.max":this.counterMax,
            "levelManager.socialRequire":this.evaluateLevelSocial,
            "levelManager.compRequire":this.evaluateLevelCompetitive,
            "counter.max":this.counterMax,
            "seretubers.winner":this.isSeretuberWinner,
            "gatubers.isOficial":this.isGatuberOficial
         };
         super();
         this.context = param1;
      }
      
      private function providerHasMore(param1:String) : Boolean
      {
         var _loc2_:ProviderManager = Context.instance.getByType(ProviderManager) as ProviderManager;
         return _loc2_.hasMore(param1);
      }
      
      private function run(param1:String, param2:Array) : Boolean
      {
         if(param1 in this.conditions)
         {
            return this.conditions[param1].apply(this,param2);
         }
         throw new NpcInterpreterError("No condition named \"" + param1 + "\" was found");
      }
      
      private function dropGiftIsDressed() : Boolean
      {
         var _loc1_:String = this.roomAPI.getAvatarAttribute("cloth") as String;
         if(_loc1_.indexOf("reyes2017/wears") > -1)
         {
            return true;
         }
         if(_loc1_.indexOf("reyes2018/wears") > -1)
         {
            return true;
         }
         return false;
      }
      
      private function isNight() : Boolean
      {
         return this.roomAPI.timezone.isNight;
      }
      
      private function isDesktop() : Boolean
      {
         return this.roomAPI.isDesktop;
      }
      
      private function isVip() : Boolean
      {
         return this.roomAPI.isCitizen;
      }
      
      private function blockedBetterWithPassport(param1:String) : Boolean
      {
         if(this.roomAPI.user.isCitizen)
         {
            return false;
         }
         var _loc2_:BetterWithPassportManager = Context.instance.getByType(BetterWithPassportManager) as BetterWithPassportManager;
         var _loc3_:Boolean = _loc2_.isAvailable(param1);
         return !_loc3_;
      }
      
      private function suscribedToTeam(param1:String, param2:String = null) : Boolean
      {
         if(!this.teamManager)
         {
            this.teamManager = Context.instance.getByType(TeamManager) as TeamManager;
         }
         if(param2)
         {
            return this.teamManager.getSuscriptionName(param1) == param2;
         }
         return this.teamManager.getSuscriptionName(param1) as Boolean;
      }
      
      private function counterEqual(param1:String, param2:int) : Boolean
      {
         var _loc3_:GaturroCounterManager = Context.instance.getByType(GaturroCounterManager) as GaturroCounterManager;
         return _loc3_.equal(param1,param2);
      }
      
      public function evaluate(param1:NpcStatement) : Boolean
      {
         return this.run(param1.reserved,param1.getArguments(this.context));
      }
      
      private function canICatchFunnys() : Boolean
      {
         return this.bubbleFlanysService.canIGetFunny();
      }
      
      private function greaterEqualThan(param1:Object, param2:Object) : Boolean
      {
         return param1 >= param2;
      }
      
      private function isRoof() : Boolean
      {
         return this.roomAPI.room.isRoofRoom;
      }
      
      public function dispose() : void
      {
         this.context = null;
      }
      
      private function evaluateLevelCompetitive(param1:int) : Boolean
      {
         var _loc2_:int = this.roomAPI.levelManager.getLevelOfSkill(this.roomAPI.getAvatarAttribute("competitiveSkills"));
         if(_loc2_ >= param1)
         {
            return true;
         }
         return false;
      }
      
      private function bgroundIsName(param1:String) : Boolean
      {
         var _loc2_:MovieClip = null;
         var _loc4_:MovieClip = null;
         var _loc5_:DisplayObject = null;
         var _loc3_:int = 0;
         while(_loc3_ < this.roomAPI.roomView.numChildren)
         {
            if((_loc5_ = this.roomAPI.roomView.getChildAt(_loc3_)).name == "layer2")
            {
               _loc2_ = _loc5_ as MovieClip;
            }
            _loc3_++;
         }
         if(Boolean(_loc2_) && _loc2_.privateWall_container.numChildren > 0)
         {
            _loc4_ = _loc2_.privateWall_container.getChildAt(0);
            if(getQualifiedClassName(_loc4_) == param1 + "_on")
            {
               return true;
            }
         }
         return false;
      }
      
      private function existBetterWithPassportFeature(param1:String) : Boolean
      {
         var _loc2_:BetterWithPassportManager = Context.instance.getByType(BetterWithPassportManager) as BetterWithPassportManager;
         return _loc2_.hasFeature(param1);
      }
      
      private function isFlanyReady() : Boolean
      {
         return this.bubbleFlanysService.ableToSendReq();
      }
      
      private function isOwner() : Boolean
      {
         return this.roomAPI.room.ownedByUser;
      }
      
      private function dropGiftReadyVisitor() : Boolean
      {
         var _loc1_:String = this.context.api.getAttribute("materials") as String;
         var _loc2_:Object = this.roomAPI.JSONDecode(_loc1_) || {};
         if(_loc2_ && _loc2_.pasto && Boolean(_loc2_.agua) && !_loc2_.ready)
         {
            return true;
         }
         return false;
      }
      
      private function isSeretuberWinner() : Boolean
      {
         var _loc1_:Array = ["LAUTYDL","BYVALENGATUBER","ZORZ","PIOLAVAGOTEVES","DIGUANGTPLAY","YULIAAXD","MUNIECATOR","DAISYCASH010M","MIAAMESYTT","TAPION164","ALANCHURRO","ANABELL3290","LABELLAGATA11111","MROVERE2"];
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            if(this.roomAPI.user.username == _loc1_[_loc2_])
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      private function isHome() : Boolean
      {
         return this.roomAPI.room.hasOwner;
      }
      
      private function isVipRiver3Dias() : Boolean
      {
         return this.roomAPI.isVipRiver3Dias();
      }
      
      private function counterReached(param1:String, param2:int) : Boolean
      {
         var _loc3_:GaturroCounterManager = Context.instance.getByType(GaturroCounterManager) as GaturroCounterManager;
         return _loc3_.reached(param1,param2);
      }
      
      private function startDate(param1:String) : Boolean
      {
         var _loc2_:StartDateConstraint = new StartDateConstraint(true);
         _loc2_.setData({"date":param1});
         return _loc2_.accomplish();
      }
      
      private function cardQuantity() : int
      {
         if(this.roomAPI.cardsManager.isLoaded)
         {
            return this.roomAPI.cardsManager.cards.length;
         }
         return -1;
      }
      
      private function equals(param1:Object, param2:Object) : Boolean
      {
         return param1 === param2;
      }
      
      private function constraintIsAccomplished(param1:String) : Boolean
      {
         var _loc2_:ConstraintManager = Context.instance.getByType(ConstraintManager) as ConstraintManager;
         return _loc2_.accomplishById(param1);
      }
      
      private function display(param1:String) : Boolean
      {
         return this.context.api.getState() === param1;
      }
      
      private function log(... rest) : Boolean
      {
         this.context.info(rest.join(" "));
         return true;
      }
      
      private function hasItems(param1:uint, param2:String) : Boolean
      {
         return this.context.api.userHasItems(param2,param1);
      }
      
      private function evaluateLevelSocial(param1:int) : Boolean
      {
         var _loc2_:int = this.roomAPI.levelManager.getLevelOfSkill(this.roomAPI.getAvatarAttribute("socialSkills"));
         if(_loc2_ >= param1)
         {
            return true;
         }
         return false;
      }
      
      private function counterMax(param1:String) : Boolean
      {
         var _loc2_:GaturroCounterManager = Context.instance.getByType(GaturroCounterManager) as GaturroCounterManager;
         return _loc2_.reachedMax(param1);
      }
      
      private function userWears(param1:String, param2:String) : Boolean
      {
         return this.roomAPI.getAvatarAttribute(param1) === param2 + "_on";
      }
      
      private function greaterThan(param1:Object, param2:Object) : Boolean
      {
         return param1 > param2;
      }
      
      private function stateExists(param1:String) : Boolean
      {
         return this.context.behavior.hasState(param1);
      }
      
      private function canIRobTrolls() : Boolean
      {
         return this.roomAPI.canIRobTrolls;
      }
      
      private function userHasPet() : Boolean
      {
         var _loc1_:Avatar = this.roomAPI.userAvatar;
         var _loc2_:OwnedNpcRoomSceneObject = this.roomAPI.room.getOwnedNpcFor(_loc1_);
         if(!_loc2_)
         {
            return false;
         }
         if(_loc2_.name.substr(0,3) == "pet")
         {
            return true;
         }
         return false;
      }
      
      private function isNull(param1:Object) : Boolean
      {
         return !param1;
      }
      
      private function not(param1:String, ... rest) : Boolean
      {
         return !this.run(param1,rest);
      }
      
      private function checkUserEffect2(param1:String) : Boolean
      {
         var _loc2_:String = this.roomAPI.getAvatarAttribute("effect2") as String;
         return _loc2_ == param1;
      }
      
      private function get roomAPI() : GaturroRoomAPI
      {
         return this.context.roomAPI;
      }
      
      private function isGatuberOficial() : Boolean
      {
         var _loc1_:int = 0;
         while(_loc1_ < ProyectoGatuberRoomView.gatubersOficiales.length)
         {
            if(api.user.username.toUpperCase() == ProyectoGatuberRoomView.gatubersOficiales[_loc1_].toUpperCase())
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      private function lowerThan(param1:Object, param2:Object) : Boolean
      {
         return param1 < param2;
      }
      
      private function userHasPenguin() : Boolean
      {
         var _loc1_:Avatar = this.roomAPI.userAvatar;
         var _loc2_:OwnedNpcRoomSceneObject = this.roomAPI.room.getOwnedNpcFor(_loc1_);
         if(!_loc2_)
         {
            return false;
         }
         if(_loc2_.name == "pet.penguin")
         {
            return true;
         }
         return false;
      }
      
      private function warHasGift() : Boolean
      {
         var _loc1_:Object = this.roomAPI.getAvatarAttribute("gripFore");
         if(_loc1_ == "navidad2018/guerra.gift_on")
         {
            return true;
         }
         return false;
      }
      
      private function suscribedToFeature(param1:String) : Boolean
      {
         if(!this.teamManager)
         {
            this.teamManager = Context.instance.getByType(TeamManager) as TeamManager;
         }
         var _loc2_:String = this.teamManager.getSuscriptionName(param1);
         if(!_loc2_ || _loc2_ == "" || _loc2_ == " " || _loc2_ == "  ")
         {
            return false;
         }
         return true;
      }
      
      private function checkUserEffect(param1:String, param2:String = "", param3:String = "") : Boolean
      {
         param3 = this.roomAPI.getAvatarAttribute("effect" + param3) as String;
         if(param2 == "like")
         {
            return param3.indexOf(param1) != -1;
         }
         return param3 == param1;
      }
      
      private function cardsEnabled() : Boolean
      {
         return cards.isLoaded;
      }
      
      private function takeCoins(param1:int) : Boolean
      {
         var _loc2_:int = int(this.roomAPI.user.profile.attributes["coins"]);
         if(_loc2_ >= param1)
         {
            this.roomAPI.setProfileAttribute("system_coins",_loc2_ - param1);
            return true;
         }
         return false;
      }
      
      private function endDateReached(param1:String) : Boolean
      {
         if(!this.teamManager)
         {
            this.teamManager = Context.instance.getByType(TeamManager) as TeamManager;
         }
         return !this.teamManager.isEnabled(param1);
      }
      
      private function cardsHave() : Boolean
      {
         return cards.cards.length > 0;
      }
      
      private function isVipBoca3Dias() : Boolean
      {
         return this.roomAPI.isVipBoca3Dias();
      }
      
      private function isVipType(param1:String) : Boolean
      {
         return this.roomAPI.hasPassportType(param1);
      }
      
      private function cannotCatchFunnys() : Boolean
      {
         return this.bubbleFlanysService.cannotGetFunny();
      }
      
      private function dropGiftReadyOwner() : Boolean
      {
         var _loc1_:String = this.context.api.getAttribute("materials") as String;
         var _loc2_:Object = this.roomAPI.JSONDecode(_loc1_) || {};
         if(_loc2_ && _loc2_.ready && Boolean(_loc2_.gifter))
         {
            return true;
         }
         return false;
      }
      
      private function isAttic() : Boolean
      {
         return this.roomAPI.room.isAtticRoom;
      }
      
      private function partyImHost() : Boolean
      {
         var _loc1_:EventsService = Context.instance.getByType(EventsService) as EventsService;
         return Boolean(_loc1_) && _loc1_.imHost;
      }
      
      private function lowerEqualThan(param1:Object, param2:Object) : Boolean
      {
         return param1 <= param2;
      }
      
      private function eqCharAt(param1:int, param2:String, param3:String) : Boolean
      {
         var _loc4_:String;
         if((_loc4_ = param2.charAt(param1 - 1)) == param3)
         {
            return true;
         }
         return false;
      }
      
      private function modulo(param1:int, param2:int) : Boolean
      {
         return param1 % param2 == 0;
      }
      
      private function variableExists(param1:String) : Boolean
      {
         return this.context.hasVariable(param1);
      }
      
      private function partyHasActive() : Boolean
      {
         var _loc1_:EventsService = Context.instance.getByType(EventsService) as EventsService;
         return Boolean(_loc1_) && _loc1_.eventRunning;
      }
      
      private function checkDressedForFeature(param1:String, param2:Boolean = false) : Boolean
      {
         var _loc6_:String = null;
         if(param1 == "escenarioVip")
         {
            param1 = this.roomAPI.getSession("escenarioVip") as String;
         }
         var _loc3_:Array = settings.dressedForFeature[param1];
         if(!_loc3_)
         {
            return false;
         }
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_.length)
         {
            if((Boolean(_loc6_ = this.roomAPI.getAvatarAttribute(_loc3_[_loc5_].key) as String)) && _loc6_.indexOf(_loc3_[_loc5_].itemName) != -1)
            {
               if(!param2)
               {
                  return true;
               }
               _loc4_++;
            }
            _loc5_++;
         }
         if(!param2)
         {
            return false;
         }
         return _loc4_ == _loc3_.length;
      }
      
      private function get bubbleFlanysService() : BubbleFlannysService
      {
         var _loc1_:BubbleFlannysService = null;
         if(Context.instance.hasByType(BubbleFlannysService))
         {
            _loc1_ = Context.instance.getByType(BubbleFlannysService) as BubbleFlannysService;
         }
         else
         {
            _loc1_ = new BubbleFlannysService();
            _loc1_.init();
            Context.instance.addByType(_loc1_,BubbleFlannysService);
         }
         return _loc1_;
      }
      
      private function canIRobPapas() : Boolean
      {
         return this.roomAPI.canIRobPapapas;
      }
   }
}

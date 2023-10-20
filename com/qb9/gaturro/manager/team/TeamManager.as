package com.qb9.gaturro.manager.team
{
   import com.qb9.gaturro.commons.event.EventManager;
   import com.qb9.gaturro.commons.iterator.IIterator;
   import com.qb9.gaturro.commons.model.config.IConfig;
   import com.qb9.gaturro.commons.model.config.IConfigHolder;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.view.world.avatars.Gaturro;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.utils.setTimeout;
   
   public class TeamManager implements IConfigHolder
   {
      
      public static const METHOD_ADD_MERITS:String = "add_merit_points";
      
      private static const TEAM_PREFIX:String = "team_";
      
      public static const METHOD_GET_MERITS:String = "get_merit_points";
       
      
      private var _config:com.qb9.gaturro.manager.team.TeamConfig;
      
      private var eventManager:EventManager;
      
      public function TeamManager()
      {
         super();
         this.eventManager = new EventManager();
      }
      
      private function getTeamAddPointsURLVariables(param1:String, param2:int) : URLVariables
      {
         var _loc3_:URLVariables = new URLVariables();
         _loc3_.h = this.getHash();
         _loc3_.t = param1;
         _loc3_.p = param2;
         return _loc3_;
      }
      
      public function suscribeToTeam(param1:String, param2:String) : Boolean
      {
         var _loc3_:String = null;
         if(this._config.existFeature(param2))
         {
            _loc3_ = this.generateKey(param2);
            if(!user.profile.attributes[_loc3_] || user.profile.attributes[_loc3_] == " ")
            {
               user.profile.attributes[_loc3_] = param1;
               return true;
            }
         }
         return false;
      }
      
      private function buildRequestLoading(param1:String, param2:URLVariables) : URLLoader
      {
         var _loc3_:URLRequest = new URLRequest(param1);
         _loc3_.method = URLRequestMethod.POST;
         _loc3_.data = param2;
         var _loc4_:URLLoader;
         (_loc4_ = new URLLoader()).load(_loc3_);
         return _loc4_;
      }
      
      public function askForTeamList(param1:String, param2:Function) : void
      {
         if(!this._config.existFeature(param1))
         {
            logger.debug("This feature is not registred");
            throw new Error("This feature is not registred");
         }
         var _loc3_:String = this._config.getListURL();
         var _loc4_:URLVariables = this.getTeamListURLVariables(param1);
         var _loc5_:URLLoader = this.buildRequestLoading(_loc3_,_loc4_);
         var _loc6_:OldAskForTeamListDelegate;
         (_loc6_ = this.buildDelegate(param2,OldAskForTeamListDelegate,_loc5_) as OldAskForTeamListDelegate).feature = param1;
      }
      
      public function getTeamList(param1:String) : IIterator
      {
         return this._config.getTeamDefinitionList(param1);
      }
      
      private function buildDelegate(param1:Function, param2:Class, param3:URLLoader) : AbstractTeamDelegate
      {
         var _loc4_:AbstractTeamDelegate = new param2(param1,this.eventManager,param3,this._config);
         this.eventManager.addEventListener(param3,Event.COMPLETE,_loc4_.handDelegate);
         this.eventManager.addEventListener(param3,ErrorEvent.ERROR,_loc4_.handleError);
         this.eventManager.addEventListener(param3,IOErrorEvent.IO_ERROR,_loc4_.handleError);
         this.eventManager.addEventListener(param3,IOErrorEvent.NETWORK_ERROR,_loc4_.handleError);
         return _loc4_;
      }
      
      public function askForMyTeamPoints(param1:String, param2:Function) : void
      {
         var _loc3_:String = this.getSuscriptionName(param1);
         if(!_loc3_)
         {
            logger.debug("It can\'t ask for points if hasn\'t suscription");
            throw new Error("It can\'t ask for points if hasn\'t suscription");
         }
         var _loc4_:String = this._config.getGetURL();
         var _loc5_:URLVariables = this.getTeamPointsURLVariables(_loc3_);
         var _loc6_:URLLoader = this.buildRequestLoading(_loc4_,_loc5_);
         var _loc7_:OldAskForMyTeamPointsDelegate;
         (_loc7_ = this.buildDelegate(param2,OldAskForMyTeamPointsDelegate,_loc6_) as OldAskForMyTeamPointsDelegate).teamName = _loc3_;
      }
      
      public function addPoints(param1:String, param2:int, param3:Function = null) : void
      {
         var _loc7_:OldAddPointsDelegate = null;
         var _loc4_:String = this._config.getAddURL();
         var _loc5_:URLVariables = this.getTeamAddPointsURLVariables(param1,param2);
         var _loc6_:URLLoader = this.buildRequestLoading(_loc4_,_loc5_);
         if(param3 != null)
         {
            (_loc7_ = this.buildDelegate(param3,OldAddPointsDelegate,_loc6_) as OldAddPointsDelegate).teamName = param1;
            logger.info("**************************** TESTING WINNER 4/4 : " + param3);
         }
         this.checkIfHalloween2018(param1,param2);
      }
      
      private function generateKey(param1:String) : String
      {
         return TEAM_PREFIX + param1;
      }
      
      public function changeSuscription(param1:String, param2:String) : Boolean
      {
         var _loc3_:String = null;
         if(this._config.existFeature(param2))
         {
            _loc3_ = this.generateKey(param2);
            if(user.profile.attributes[_loc3_])
            {
               user.profile.attributes[_loc3_] = param1;
               return true;
            }
         }
         return false;
      }
      
      public function askForAllTeamList(param1:Function) : void
      {
         var _loc2_:String = this._config.getListAllURL();
         var _loc3_:URLVariables = this.getTeamAllListURLVariables();
         var _loc4_:URLLoader = this.buildRequestLoading(_loc2_,_loc3_);
         var _loc5_:OldAskForTeamListDelegate = this.buildDelegate(param1,OldAskForTeamListDelegate,_loc4_) as OldAskForTeamListDelegate;
      }
      
      private function checkIfHalloween2018(param1:String, param2:int) : void
      {
         var teamName:String = param1;
         var p:int = param2;
         if(teamName == "entrenamiento")
         {
            setTimeout(function():void
            {
               api.setAvatarAttribute(Gaturro.EFFECT_KEY,"lookLeft");
            },100);
            setTimeout(function():void
            {
               api.setAvatarAttribute("action","showObjectUp.halloween2018/props.moneda" + p.toString() + "_on");
            },300);
            setTimeout(function():void
            {
               api.setAvatarAttribute(Gaturro.EFFECT_KEY," ");
            },1000);
         }
      }
      
      public function isSuscribed(param1:String) : Boolean
      {
         var _loc2_:String = this.generateKey(param1);
         var _loc3_:String = String(user.profile.attributes[_loc2_]);
         return Boolean(_loc3_);
      }
      
      public function getSuscriptionName(param1:String) : String
      {
         var _loc2_:String = this.generateKey(param1);
         return String(user.profile.attributes[_loc2_]);
      }
      
      private function getHash() : String
      {
         return String(user.hashSessionId);
      }
      
      public function askForCertainTeamPoints(param1:String, param2:Function) : void
      {
         var _loc3_:TeamDefinition = this._config.getTeamDefinition(param1);
         if(!_loc3_)
         {
            logger.debug("The team: [" + param1 + "] is not configured.");
            throw new Error("The team: [" + param1 + "] is not configured.");
         }
         var _loc4_:String = this._config.getGetURL();
         var _loc5_:URLVariables = this.getTeamPointsURLVariables(param1);
         var _loc6_:URLLoader = this.buildRequestLoading(_loc4_,_loc5_);
         var _loc7_:OldAskForMyTeamPointsDelegate;
         (_loc7_ = this.buildDelegate(param2,OldAskForMyTeamPointsDelegate,_loc6_) as OldAskForMyTeamPointsDelegate).teamName = param1;
      }
      
      private function getTeamAllListURLVariables() : URLVariables
      {
         var _loc1_:URLVariables = new URLVariables();
         _loc1_.h = this.getHash();
         return _loc1_;
      }
      
      public function isEnabled(param1:String) : Boolean
      {
         var _loc3_:TeamFeatureDefinition = null;
         var _loc2_:* = false;
         if(this._config.existFeature(param1))
         {
            _loc3_ = this._config.getTeamFeature(param1);
            _loc2_ = _loc3_.expiration.time > api.serverTime;
         }
         return _loc2_;
      }
      
      private function getTeamListURLVariables(param1:String) : URLVariables
      {
         var _loc2_:URLVariables = new URLVariables();
         _loc2_.h = this.getHash();
         _loc2_.g = param1;
         return _loc2_;
      }
      
      public function getExpirationDate(param1:String) : Date
      {
         var _loc2_:Date = null;
         var _loc3_:TeamFeatureDefinition = this._config.getTeamFeature(param1);
         return new Date(_loc3_.expiration.time);
      }
      
      public function getSuscriptionDefinnition(param1:String) : TeamDefinition
      {
         var _loc3_:TeamDefinition = null;
         var _loc2_:String = this.getSuscriptionName(param1);
         if(_loc2_)
         {
            _loc3_ = this._config.getTeamDefinition(_loc2_);
         }
         return _loc3_;
      }
      
      public function set config(param1:IConfig) : void
      {
         this._config = param1 as com.qb9.gaturro.manager.team.TeamConfig;
      }
      
      private function getTeamPointsURLVariables(param1:String) : URLVariables
      {
         var _loc2_:URLVariables = new URLVariables();
         _loc2_.h = this.getHash();
         _loc2_.t = param1;
         return _loc2_;
      }
   }
}

import com.adobe.serialization.json.JSON;
import com.qb9.gaturro.commons.event.EventManager;
import com.qb9.gaturro.globals.api;
import com.qb9.gaturro.manager.team.*;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.net.URLLoader;

class OldAskForMyTeamPointsDelegate extends AbstractTeamDelegate
{
    
   
   private var _teamName:String;
   
   public function OldAskForMyTeamPointsDelegate(param1:Function, param2:EventManager, param3:EventDispatcher, param4:TeamConfig)
   {
      super(param1,param2,param3,param4);
   }
   
   public function set teamName(param1:String) : void
   {
      this._teamName = param1;
   }
   
   override public function handDelegate(param1:Event) : void
   {
      var _loc5_:Team = null;
      var _loc2_:URLLoader = param1.target as URLLoader;
      var _loc3_:String = _loc2_.data;
      var _loc4_:Object;
      if((_loc4_ = com.adobe.serialization.json.JSON.decode(_loc3_)).error)
      {
         api.log.debug("OldTeamAskForPoints > handDelegate > item = [" + _loc4_.error.message + "]");
      }
      else
      {
         api.log.debug("OldTeamAskForPoints > handDelegate > item = [" + _loc4_.data.team + " // " + _loc4_.data.points + "]");
         if(this._teamName == _loc4_.data.team)
         {
            _loc5_ = getTeam(_loc4_.data.team,parseInt(_loc4_.data.points));
            delegate.apply(this,[_loc5_]);
            super.handDelegate(param1);
         }
      }
   }
}

import com.adobe.serialization.json.JSON;
import com.qb9.gaturro.commons.event.EventManager;
import com.qb9.gaturro.manager.team.*;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.net.URLLoader;

class OldAddPointsDelegate extends AbstractTeamDelegate
{
    
   
   private var _teamName:String;
   
   public function OldAddPointsDelegate(param1:Function, param2:EventManager, param3:EventDispatcher, param4:TeamConfig)
   {
      super(param1,param2,param3,param4);
   }
   
   public function set teamName(param1:String) : void
   {
      this._teamName = param1;
   }
   
   override public function handDelegate(param1:Event) : void
   {
      var _loc5_:Team = null;
      var _loc2_:URLLoader = param1.target as URLLoader;
      var _loc3_:String = _loc2_.data;
      var _loc4_:Object;
      if((_loc4_ = com.adobe.serialization.json.JSON.decode(_loc3_)).error)
      {
         _loc5_ = null;
      }
      else
      {
         _loc5_ = getTeam(_loc4_.data.team,parseInt(_loc4_.data.points));
      }
      delegate.apply(this,[_loc5_]);
      super.handDelegate(param1);
   }
}

import com.qb9.gaturro.commons.event.EventManager;
import com.qb9.gaturro.globals.api;
import com.qb9.gaturro.globals.logger;
import com.qb9.gaturro.manager.team.Team;
import com.qb9.gaturro.manager.team.TeamConfig;
import com.qb9.gaturro.manager.team.TeamDefinition;
import flash.events.Event;
import flash.events.EventDispatcher;

class AbstractTeamDelegate
{
    
   
   protected var config:TeamConfig;
   
   protected var delegate:Function;
   
   private var eventTarget:EventDispatcher;
   
   private var eventManager:EventManager;
   
   public function AbstractTeamDelegate(param1:Function, param2:EventManager, param3:EventDispatcher, param4:TeamConfig)
   {
      super();
      this.config = param4;
      this.eventTarget = param3;
      this.eventManager = param2;
      this.delegate = param1;
   }
   
   public function handleError(param1:Event) : void
   {
      api.log.debug("TeamDelegate > handleError > e = [" + param1 + "]");
      this.removeListener();
   }
   
   public function handDelegate(param1:Event) : void
   {
      this.removeListener();
   }
   
   protected function getTeam(param1:String, param2:int) : Team
   {
      var _loc3_:TeamDefinition = this.config.getTeamDefinition(param1);
      if(!_loc3_)
      {
         logger.debug("There is no Team with the name: [" + param1 + "]");
         throw new Error("There is no Team with the name: [" + param1 + "]");
      }
      return new Team(_loc3_,param2);
   }
   
   private function removeListener() : void
   {
      this.eventManager.removeAllFromTarget(this.eventTarget);
      this.delegate = null;
      this.eventManager = null;
   }
}

import com.adobe.serialization.json.JSON;
import com.qb9.gaturro.commons.event.EventManager;
import com.qb9.gaturro.manager.team.*;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.net.URLLoader;

class TeamListDelegate extends AbstractTeamDelegate
{
    
   
   private var _feature:String;
   
   public function TeamListDelegate(param1:Function, param2:EventManager, param3:EventDispatcher, param4:TeamConfig)
   {
      super(param1,param2,param3,param4);
   }
   
   public function set feature(param1:String) : void
   {
      this._feature = param1;
   }
   
   override public function handDelegate(param1:Event) : void
   {
      var _loc7_:Team = null;
      var _loc8_:Object = null;
      var _loc2_:URLLoader = param1.target as URLLoader;
      var _loc3_:String = _loc2_.data;
      var _loc4_:Object;
      var _loc5_:Array = (_loc4_ = com.adobe.serialization.json.JSON.decode(_loc3_)).list;
      var _loc6_:Array = new Array();
      for each(_loc8_ in _loc5_)
      {
         _loc7_ = getTeam(_loc4_.name,parseInt(_loc4_.points));
         _loc6_.push(_loc7_);
      }
      delegate.apply(this,_loc6_);
      super.handDelegate(param1);
   }
}

import com.adobe.serialization.json.JSON;
import com.qb9.gaturro.commons.event.EventManager;
import com.qb9.gaturro.manager.team.*;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.net.URLLoader;

class OldAskForTeamListDelegate extends AbstractTeamDelegate
{
    
   
   private var _feature:String;
   
   public function OldAskForTeamListDelegate(param1:Function, param2:EventManager, param3:EventDispatcher, param4:TeamConfig)
   {
      super(param1,param2,param3,param4);
   }
   
   public function set feature(param1:String) : void
   {
      this._feature = param1;
   }
   
   override public function handDelegate(param1:Event) : void
   {
      var _loc7_:Team = null;
      var _loc8_:Boolean = false;
      var _loc9_:Object = null;
      var _loc2_:URLLoader = param1.target as URLLoader;
      var _loc3_:String = _loc2_.data;
      var _loc4_:Object;
      var _loc5_:Array = (_loc4_ = com.adobe.serialization.json.JSON.decode(_loc3_)).data;
      var _loc6_:Array = new Array();
      for each(_loc9_ in _loc5_)
      {
         if(this.config.getTeamDefinition(_loc9_.team))
         {
            if(_loc8_ = Boolean(this.config.belongsToFeature(this._feature,_loc9_.team)))
            {
               _loc7_ = getTeam(_loc9_.team,parseInt(_loc9_.points));
               _loc6_.push(_loc7_);
            }
         }
      }
      delegate.apply(this,[_loc6_]);
      super.handDelegate(param1);
   }
}

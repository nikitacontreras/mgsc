package com.qb9.gaturro.user.cellPhone.apps
{
   import com.qb9.gaturro.user.cellPhone.ICellPhoneApp;
   import flash.events.EventDispatcher;
   
   public class CellPhoneAppDefinition extends EventDispatcher
   {
      
      private static var definitions:Array;
      
      public static const APP_8:Class = AppPiano;
      
      public static const APP_9:Class = AppSnakeGame;
      
      public static const APP_10:Class = AppStore;
      
      public static const APP_1:Class = AppNovedades;
      
      public static const APP_2:Class = AppMensajes;
      
      public static const APP_3:Class = AppAmigos;
      
      public static const APP_5:Class = AppPodometro;
      
      public static const APP_6:Class = AppBola8;
      
      public static const APP_7:Class = AppAlarmClock;
      
      public static const APP_4:Class = AppPicapon;
       
      
      public function CellPhoneAppDefinition()
      {
         super();
      }
      
      private static function getDefinitions() : Array
      {
         var _loc1_:uint = 0;
         var _loc2_:Array = null;
         var _loc3_:Class = null;
         if(definitions == null)
         {
            _loc1_ = 1;
            _loc2_ = new Array();
            while(definitions == null)
            {
               _loc3_ = CellPhoneAppDefinition["APP_" + String(_loc1_)];
               if(_loc3_ == null)
               {
                  definitions = _loc2_;
                  break;
               }
               _loc2_.push(new AppDefinition(_loc3_,_loc1_));
               _loc1_++;
            }
         }
         return definitions;
      }
      
      private static function getAppDefinitionByAppKey(param1:String) : AppDefinition
      {
         var _loc2_:AppDefinition = null;
         var _loc3_:AppDefinition = null;
         for each(_loc3_ in getDefinitions())
         {
            if(_loc3_.appKey == param1)
            {
               _loc2_ = _loc3_;
               break;
            }
         }
         return _loc2_;
      }
      
      private static function getAppDefinitionById(param1:uint) : AppDefinition
      {
         var _loc2_:AppDefinition = null;
         var _loc3_:AppDefinition = null;
         for each(_loc3_ in getDefinitions())
         {
            if(_loc3_.id == param1)
            {
               _loc2_ = _loc3_;
               break;
            }
         }
         return _loc2_;
      }
      
      public static function generateAppbyAppKey(param1:String) : ICellPhoneApp
      {
         var _loc2_:AppDefinition = getAppDefinitionByAppKey(param1);
         if(_loc2_ == null)
         {
            return null;
         }
         var _loc3_:ICellPhoneApp = new _loc2_.classDefinition();
         _loc3_.id = _loc2_.id;
         _loc3_.appkey = _loc2_.appKey;
         return _loc3_;
      }
      
      public static function generateAppbyId(param1:uint) : ICellPhoneApp
      {
         var _loc2_:AppDefinition = getAppDefinitionById(param1);
         var _loc3_:ICellPhoneApp = new _loc2_.classDefinition();
         _loc3_.id = _loc2_.id;
         _loc3_.appkey = _loc2_.appKey;
         return _loc3_;
      }
   }
}

import flash.utils.getQualifiedClassName;

class AppDefinition
{
    
   
   private var _id:uint;
   
   private var _aliasName:String;
   
   private var _classDefinition:Class;
   
   private var _fullyQualifiedName:String;
   
   private var _appKey:String;
   
   public function AppDefinition(param1:Class, param2:uint)
   {
      super();
      this._classDefinition = param1;
      this._id = param2;
      this._fullyQualifiedName = getQualifiedClassName(param1);
      this._aliasName = this._fullyQualifiedName.substr(this._fullyQualifiedName.indexOf("::App") + "::App".length);
      this._appKey = this._aliasName.replace(this._aliasName.substr(0,1),this._aliasName.substr(0,1).toLowerCase());
   }
   
   public function set id(param1:uint) : void
   {
      this._id = param1;
   }
   
   public function set appKey(param1:String) : void
   {
      this._appKey = param1;
   }
   
   public function get classDefinition() : Class
   {
      return this._classDefinition;
   }
   
   public function set classDefinition(param1:Class) : void
   {
      this._classDefinition = param1;
   }
   
   public function get id() : uint
   {
      return this._id;
   }
   
   public function get appKey() : String
   {
      return this._appKey;
   }
}

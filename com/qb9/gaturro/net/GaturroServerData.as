package com.qb9.gaturro.net
{
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.manager.notificator.Notification;
   import com.qb9.gaturro.commons.manager.notificator.NotificationManager;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.notifier.GaturroNotificationType;
   import com.qb9.mambo.net.server.ServerData;
   import com.qb9.mines.mobject.Mobject;
   import flash.utils.getTimer;
   
   public final class GaturroServerData extends ServerData
   {
       
      
      private var _localTime:Number;
      
      private var _resellPriceRatio:Number;
      
      private var _maxPremiumItems:int;
      
      private var _minigameData:Object;
      
      public function GaturroServerData()
      {
         super();
      }
      
      public function set time(param1:Number) : void
      {
         this._localTime = param1;
         var _loc2_:NotificationManager = Context.instance.getByType(NotificationManager) as NotificationManager;
         _loc2_.brodcast(new com.qb9.gaturro.commons.manager.notificator.Notification(GaturroNotificationType.SETTED_SERVER_TIME,this._localTime));
      }
      
      public function get serverTimeReady() : Boolean
      {
         return !isNaN(this._localTime);
      }
      
      override public function get time() : Number
      {
         return this._localTime + getTimer();
      }
      
      public function get resellPriceRatio() : Number
      {
         return this._resellPriceRatio;
      }
      
      public function get maxPremiumItems() : int
      {
         return this._maxPremiumItems;
      }
      
      private function parseGameData(param1:Array) : Object
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:Object = null;
         var _loc10_:String = null;
         var _loc9_:Object = {};
         for each(_loc10_ in param1)
         {
            _loc2_ = _loc10_.split("|");
            _loc3_ = _loc2_[1].split(";");
            _loc8_ = {};
            _loc7_ = 0;
            while(_loc7_ < _loc3_.length)
            {
               if(!_loc3_[_loc7_])
               {
                  break;
               }
               if((_loc4_ = _loc3_[_loc7_].split("=")).length != 2)
               {
                  break;
               }
               _loc8_[_loc4_[0]] = _loc4_[1];
               _loc7_++;
            }
            _loc9_[_loc2_[0]] = _loc8_;
         }
         return _loc9_;
      }
      
      override public function buildFromMobject(param1:Mobject) : void
      {
         var _loc3_:Array = null;
         super.buildFromMobject(param1);
         var _loc2_:Object = param1.getMobject("gamedata");
         if(_loc2_ != null)
         {
            _loc3_ = _loc2_.getStringArray("props");
            this._minigameData = this.parseGameData(_loc3_);
         }
         param1 = param1.getMobject("extraData");
         this._resellPriceRatio = settings.price.resellPriceRatio;
         if(!this.resellPriceRatio)
         {
            this._resellPriceRatio = 0.5;
         }
         this._maxPremiumItems = param1.getInteger("maxPremiumItems");
         this.time = super.time;
      }
      
      public function get serverName() : String
      {
         return settings.connection.serverName;
      }
      
      public function get timeStamp() : Number
      {
         return this._localTime;
      }
      
      public function get minigameData() : Object
      {
         return this._minigameData;
      }
   }
}

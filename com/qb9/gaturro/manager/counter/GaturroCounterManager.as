package com.qb9.gaturro.manager.counter
{
   import com.adobe.serialization.json.JSON;
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.event.ContextEvent;
   import com.qb9.gaturro.commons.iterator.IIterator;
   import com.qb9.gaturro.commons.manager.counter.AbstractCounterManager;
   import com.qb9.gaturro.commons.manager.notificator.Notification;
   import com.qb9.gaturro.commons.manager.notificator.NotificationManager;
   import com.qb9.gaturro.commons.model.config.IConfig;
   import com.qb9.gaturro.commons.model.config.IConfigHolder;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.notifier.GaturroNotificationType;
   import com.qb9.gaturro.user.GaturroUser;
   import flash.utils.Dictionary;
   
   public class GaturroCounterManager extends AbstractCounterManager implements IConfigHolder
   {
       
      
      private var notificationManager:NotificationManager;
      
      private var user:GaturroUser;
      
      private var _config:IConfig;
      
      private var mapByType:Dictionary;
      
      private var mapByName:Dictionary;
      
      public function GaturroCounterManager()
      {
         super();
         this.setup();
      }
      
      private function setupNotificationManager() : void
      {
         this.notificationManager = Context.instance.getByType(NotificationManager) as NotificationManager;
         this.notificationManager.observe(GaturroNotificationType.COUNTER_INCREASE,this.processIncrease);
         this.notificationManager.observe(GaturroNotificationType.COUNTER_DECREASE,this.processDecrease);
      }
      
      private function getCounter(param1:String) : Counter
      {
         if(!this.mapByName[param1])
         {
            logger.debug("Doesn\'t exist a counter with the name = " + param1);
            throw new Error("Doesn\'t exist a counter with the name = " + param1);
         }
         return this.mapByName[param1];
      }
      
      private function save(param1:Counter) : void
      {
         this.user.profile.attributes[param1.id] = com.adobe.serialization.json.JSON.encode(param1.toObject());
      }
      
      private function trySetupNotification() : void
      {
         if(Context.instance.hasByType(NotificationManager))
         {
            this.setupNotificationManager();
         }
         else
         {
            Context.instance.addEventListener(ContextEvent.ADDED,this.onManagerAdded);
         }
      }
      
      override public function getAmount(param1:String) : int
      {
         var _loc2_:Counter = this.getCounter(param1);
         return _loc2_.amount;
      }
      
      public function reset(param1:String) : void
      {
         var _loc2_:Counter = this.getCounter(param1);
         _loc2_.reset();
         this.save(_loc2_);
      }
      
      override public function increase(param1:String, param2:int = 1) : void
      {
         var _loc3_:Array = null;
         var _loc4_:Counter = null;
         if(this.isTypeTraked(param1))
         {
            _loc3_ = this.getCounterList(param1);
            for each(_loc4_ in _loc3_)
            {
               _loc4_.increase(param2);
               this.save(_loc4_);
            }
            this.notificationManager.brodcast(new com.qb9.gaturro.commons.manager.notificator.Notification(GaturroNotificationType.COUNTER_CHANGED,param1));
         }
      }
      
      private function onManagerAdded(param1:ContextEvent) : void
      {
         if(param1.instanceType == NotificationManager)
         {
            this.setupNotificationManager();
            Context.instance.removeEventListener(ContextEvent.ADDED,this.onManagerAdded);
         }
      }
      
      private function getCounterList(param1:String) : Array
      {
         if(!this.mapByType[param1])
         {
            logger.debug("Doesn\'t exist a counter list with the type = " + param1);
            throw new Error("Doesn\'t exist a counter list with the type = " + param1);
         }
         return this.mapByType[param1];
      }
      
      private function parseConfig() : void
      {
         var _loc2_:Counter = null;
         var _loc3_:Object = null;
         var _loc1_:IIterator = this._config.getIterator();
         while(_loc1_.next())
         {
            _loc3_ = _loc1_.current() as Object;
            _loc2_ = this.createCounterByDef(_loc3_);
            if(!this.isPersisted(_loc2_.id))
            {
               this.save(_loc2_);
            }
            this.store(_loc2_);
         }
      }
      
      private function processIncrease(param1:com.qb9.gaturro.commons.manager.notificator.Notification) : void
      {
         this.increase(param1.data.key,param1.data.amount);
      }
      
      override public function reached(param1:String, param2:int) : Boolean
      {
         var _loc3_:int = this.getAmount(param1);
         return _loc3_ >= param2;
      }
      
      public function set config(param1:IConfig) : void
      {
         this._config = param1;
         if(Context.instance.hasByType(GaturroUser))
         {
            this.user = Context.instance.getByType(GaturroUser) as GaturroUser;
            this.parseConfig();
         }
         else
         {
            Context.instance.addEventListener(ContextEvent.ADDED,this.onUserAdded);
         }
      }
      
      private function onUserAdded(param1:ContextEvent) : void
      {
         if(param1.instanceType == GaturroUser)
         {
            this.user = Context.instance.getByType(GaturroUser) as GaturroUser;
            Context.instance.removeEventListener(ContextEvent.ADDED,this.onUserAdded);
            this.parseConfig();
         }
      }
      
      override public function decrease(param1:String, param2:int = 1) : void
      {
         var _loc3_:Array = null;
         var _loc4_:Counter = null;
         if(this.isTypeTraked(param1))
         {
            _loc3_ = this.getCounterList(param1);
            for each(_loc4_ in _loc3_)
            {
               _loc4_.decrease(param2);
               this.save(_loc4_);
            }
            this.notificationManager.brodcast(new com.qb9.gaturro.commons.manager.notificator.Notification(GaturroNotificationType.COUNTER_CHANGED,param1));
         }
      }
      
      private function isCounterTraked(param1:String) : Boolean
      {
         return this.mapByName[param1];
      }
      
      override public function start(param1:String, param2:String) : void
      {
         var _loc3_:Counter = null;
         if(!this.isCounterTraked(param2))
         {
            _loc3_ = this.createCounter(param1,param1,param2);
            if(!this.isPersisted(param1))
            {
               this.save(_loc3_);
            }
            this.store(_loc3_);
         }
      }
      
      private function processDecrease(param1:com.qb9.gaturro.commons.manager.notificator.Notification) : void
      {
         this.decrease(param1.data.key,param1.data.amount);
      }
      
      private function createCounter(param1:String, param2:String, param3:String) : Counter
      {
         var _loc7_:Object = null;
         var _loc4_:String = String(this.user.profile.attributes[param1]);
         var _loc5_:int = 0;
         if(_loc4_)
         {
            if((_loc7_ = com.adobe.serialization.json.JSON.decode(_loc4_)).name == param2)
            {
               _loc5_ = int(_loc7_.amount);
            }
         }
         return new Counter(param1,param2,param3,_loc5_);
      }
      
      private function store(param1:Counter) : void
      {
         this.mapByName[param1.name] = param1;
         if(!this.mapByType[param1.type])
         {
            this.mapByType[param1.type] = new Array();
         }
         var _loc2_:Array = this.mapByType[param1.type];
         _loc2_.push(param1);
      }
      
      private function isPersisted(param1:String) : Boolean
      {
         return Boolean(this.user.profile.attributes[param1]);
      }
      
      private function isTypeTraked(param1:String) : Boolean
      {
         return this.mapByType[param1];
      }
      
      private function createCounterByDef(param1:Object) : Counter
      {
         var _loc5_:Object = null;
         var _loc2_:String = String(this.user.profile.attributes[param1.storeID]);
         var _loc3_:int = 0;
         if(_loc2_)
         {
            if((_loc5_ = com.adobe.serialization.json.JSON.decode(_loc2_)).hasOwnProperty("name"))
            {
               if(_loc5_.name == param1.name)
               {
                  _loc3_ = int(_loc5_.amount);
               }
            }
         }
         var _loc4_:Counter = new Counter(param1.storeID,param1.name,param1.type,_loc3_,param1.max);
         if(Boolean(_loc5_) && !_loc5_.hasOwnProperty("name"))
         {
            this.save(_loc4_);
         }
         return _loc4_;
      }
      
      override public function reachedMax(param1:String) : Boolean
      {
         var _loc2_:Counter = this.getCounter(param1);
         return _loc2_.isReached;
      }
      
      override public function equal(param1:String, param2:int) : Boolean
      {
         var _loc3_:int = this.getAmount(param1);
         return _loc3_ == param2;
      }
      
      override public function exist(param1:String) : Boolean
      {
         return this.isPersisted(param1);
      }
      
      private function setup() : void
      {
         this.mapByType = new Dictionary();
         this.mapByName = new Dictionary();
         this.trySetupNotification();
      }
   }
}

class Counter
{
    
   
   private var _id:String;
   
   private var _max:int;
   
   private var _name:String;
   
   private var _amount:int;
   
   private var _type:String;
   
   public function Counter(param1:String, param2:String, param3:String, param4:int = 0, param5:int = 0)
   {
      super();
      this._max = param5;
      this._id = param1;
      this._type = param3;
      this._amount = param4;
      this._name = param2;
   }
   
   public function increase(param1:int = 1) : void
   {
      if(this._max <= 0 || this._max > 0 && this._amount + param1 <= this._max)
      {
         this._amount += param1;
      }
   }
   
   public function get max() : int
   {
      return this._max;
   }
   
   public function get isReached() : Boolean
   {
      return this._max > 0 ? this._amount >= this._max : false;
   }
   
   public function get type() : String
   {
      return this._type;
   }
   
   public function get name() : String
   {
      return this._name;
   }
   
   public function reset() : void
   {
      this._amount = 0;
   }
   
   public function get amount() : int
   {
      return this._amount;
   }
   
   public function toObject() : Object
   {
      return {
         "id":this._id,
         "type":this._type,
         "amount":this._amount,
         "name":this._name
      };
   }
   
   public function get id() : String
   {
      return this._id;
   }
   
   public function decrease(param1:int = 1) : void
   {
      this._amount -= param1;
   }
}

package com.qb9.gaturro.commons.manager.notificator
{
   import flash.utils.Dictionary;
   
   public class NotificationManager
   {
       
      
      private var observationList:Dictionary;
      
      public function NotificationManager()
      {
         super();
         this.setup();
      }
      
      public function unobserve(param1:String, param2:Function) : void
      {
         if(this.observationList[param1])
         {
            if(this.observationList[param1][param2])
            {
               delete this.observationList[param1][param2];
            }
         }
      }
      
      public function brodcast(param1:com.qb9.gaturro.commons.manager.notificator.Notification) : void
      {
         var _loc3_:Observer = null;
         var _loc2_:Dictionary = this.observationList[param1.type];
         if(_loc2_)
         {
            for each(_loc3_ in _loc2_)
            {
               _loc3_.delegate.apply(this,[param1]);
            }
         }
      }
      
      public function observe(param1:String, param2:Function) : void
      {
         var _loc3_:Observer = new Observer(param1,param2);
         if(!this.observationList[param1])
         {
            this.observationList[param1] = new Dictionary();
         }
         this.observationList[param1][param2] = _loc3_;
      }
      
      private function setup() : void
      {
         this.observationList = new Dictionary();
      }
      
      public function isObserving(param1:String, param2:Function) : Boolean
      {
         if(this.observationList[param1])
         {
            if(this.observationList[param1][param2])
            {
               return this.observationList[param1][param2];
            }
         }
         return false;
      }
   }
}

class Observer
{
    
   
   private var _delegate:Function;
   
   private var _type:String;
   
   public function Observer(param1:String, param2:Function)
   {
      super();
      this._delegate = param2;
      this._type = param1;
   }
   
   public function get delegate() : Function
   {
      return this._delegate;
   }
   
   public function get type() : String
   {
      return this._type;
   }
}

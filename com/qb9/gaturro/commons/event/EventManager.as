package com.qb9.gaturro.commons.event
{
   import com.qb9.gaturro.commons.dispose.ICheckableDisposable;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   
   public class EventManager implements ICheckableDisposable
   {
       
      
      private var _disposed:Boolean;
      
      private var map:Dictionary;
      
      public function EventManager()
      {
         super();
         this.map = new Dictionary();
      }
      
      private function addToMap(param1:EventDispatcher, param2:String, param3:Function) : void
      {
         var _loc4_:EventRelation = new EventRelation(param1,param2,param3);
         var _loc5_:Array;
         if(!(_loc5_ = this.map[param1]))
         {
            _loc5_ = new Array();
            this.map[param1] = _loc5_;
         }
         _loc5_.push(_loc4_);
      }
      
      public function get disposed() : Boolean
      {
         return this._disposed;
      }
      
      public function dispose() : void
      {
         this.removeAll();
         this._disposed = true;
      }
      
      public function removeEventListener(param1:EventDispatcher, param2:String, param3:Function) : void
      {
         param1.removeEventListener(param2,param3);
         this.removeFromMap(param1,param2,param3);
      }
      
      public function addEventListener(param1:EventDispatcher, param2:String, param3:Function) : void
      {
         param1.addEventListener(param2,param3);
         this.addToMap(param1,param2,param3);
      }
      
      private function removeFromMap(param1:EventDispatcher, param2:String, param3:Function) : void
      {
         var _loc5_:EventRelation = null;
         var _loc4_:Array;
         if(!(_loc4_ = this.map[param1]))
         {
            throw new Error("Attempted to remove event relation that not exist for EventDispatcher = [ " + param1 + " ]");
         }
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_.length)
         {
            if((_loc5_ = _loc4_[_loc6_]).eventType === param2 && _loc5_.handler === param3)
            {
               _loc4_.splice(_loc6_,1);
               break;
            }
            _loc6_++;
         }
      }
      
      public function removeAllFromTarget(param1:EventDispatcher) : void
      {
         var _loc3_:EventRelation = null;
         var _loc2_:Array = this.map[param1];
         if(!_loc2_)
         {
            throw new Error("Attempted to remove event relation that not exist for EventDispatcher = [ " + param1 + " ]");
         }
         delete this.map[param1];
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc3_ = _loc2_[_loc4_];
            _loc3_.taget.removeEventListener(_loc3_.eventType,_loc3_.handler);
            _loc2_.splice(_loc4_,1);
            _loc4_++;
         }
      }
      
      public function removeAll() : void
      {
         var _loc1_:Array = null;
         var _loc2_:EventRelation = null;
         for each(_loc1_ in this.map)
         {
            for each(_loc2_ in _loc1_)
            {
               _loc2_.taget.removeEventListener(_loc2_.eventType,_loc2_.handler);
            }
            _loc1_.length = 0;
         }
         this.map = new Dictionary();
      }
   }
}

import flash.events.EventDispatcher;

class EventRelation
{
    
   
   private var _taget:EventDispatcher;
   
   private var _eventType:String;
   
   private var _handler:Function;
   
   public function EventRelation(param1:EventDispatcher, param2:String, param3:Function)
   {
      super();
      this._handler = param3;
      this._eventType = param2;
      this._taget = param1;
   }
   
   public function get handler() : Function
   {
      return this._handler;
   }
   
   public function get taget() : EventDispatcher
   {
      return this._taget;
   }
   
   public function get eventType() : String
   {
      return this._eventType;
   }
}

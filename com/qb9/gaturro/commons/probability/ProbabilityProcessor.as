package com.qb9.gaturro.commons.probability
{
   import com.qb9.gaturro.commons.dispose.ICheckableDisposable;
   
   public class ProbabilityProcessor implements ICheckableDisposable
   {
       
      
      private var cache:Array;
      
      private var accumulated:int = 0;
      
      private var rangeList:Array;
      
      private var _disposed:Boolean;
      
      public function ProbabilityProcessor()
      {
         super();
         this.rangeList = new Array();
         this.cache = new Array();
      }
      
      public function get disposed() : Boolean
      {
         return this._disposed;
      }
      
      public function dispose() : void
      {
         this._disposed = true;
      }
      
      public function reset() : void
      {
         var _loc1_:ProbabilityRange = null;
         for each(_loc1_ in this.rangeList)
         {
            _loc1_.reset();
            this.cache.push(_loc1_);
         }
         this.rangeList.length = 0;
      }
      
      private function getRange(param1:uint, param2:int, param3:*) : ProbabilityRange
      {
         var _loc4_:ProbabilityRange = null;
         if(this.cache.length)
         {
            (_loc4_ = this.cache.shift()).setValues(param1,param2,param3);
         }
         else
         {
            _loc4_ = new ProbabilityRange(param1,param2,param3);
         }
         return _loc4_;
      }
      
      public function raffle() : *
      {
         var _loc1_:* = undefined;
         var _loc3_:ProbabilityRange = null;
         var _loc2_:int = Math.random() * 100;
         for each(_loc3_ in this.rangeList)
         {
            if(_loc2_ <= _loc3_.maxRange)
            {
               _loc1_ = _loc3_.element;
               break;
            }
         }
         return _loc1_;
      }
      
      public function addPercentile(param1:int, param2:* = null) : void
      {
         if(param1 < 1 || param1 > 99)
         {
            throw new RangeError("The percentile excedes the bounds. It should be between 1 and 99");
         }
         if(this.accumulated + param1 > 100)
         {
            throw new Error("The accumulated percent excedes the limit. Remains " + (100 - this.accumulated));
         }
         this.accumulated += param1;
         if(!param2)
         {
            param2 = this.rangeList.length;
         }
         var _loc3_:ProbabilityRange = this.getRange(this.rangeList.length,this.accumulated,param2);
         this.rangeList.push(_loc3_);
      }
   }
}

class ProbabilityRange
{
    
   
   private var _maxRange:int;
   
   private var _index:int;
   
   private var _element;
   
   public function ProbabilityRange(param1:int, param2:int, param3:*)
   {
      super();
      this.setValues(param1,param2,param3);
   }
   
   public function setValues(param1:int, param2:int, param3:*) : void
   {
      this._index = param1;
      this._element = param3;
      this._maxRange = param2;
   }
   
   public function reset() : void
   {
      this._index = 0;
      this._maxRange = 0;
      this._element = null;
   }
   
   public function get index() : int
   {
      return this._index;
   }
   
   public function get maxRange() : int
   {
      return this._maxRange;
   }
   
   public function get element() : *
   {
      return this._element;
   }
}

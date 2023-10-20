package com.qb9.flashlib.utils
{
   public class ArrayUtil
   {
       
      
      public function ArrayUtil()
      {
         super();
      }
      
      public static function shuffle(param1:Array) : Array
      {
         var _loc2_:Array = [];
         param1 = param1.slice();
         while(param1.length > 0)
         {
            _loc2_.push(popChoice(param1));
         }
         return _loc2_;
      }
      
      public static function choice(param1:Array) : Object
      {
         return param1[chooseIndex(param1)];
      }
      
      public static function replace(param1:Array, param2:Object, param3:Object) : void
      {
         if(contains(param1,param2))
         {
            param1[param1.indexOf(param2)] = param3;
         }
      }
      
      public static function flatten(param1:Array) : Array
      {
         var _loc3_:* = undefined;
         var _loc2_:Array = [];
         for each(_loc3_ in param1)
         {
            if(_loc3_ is Array)
            {
               append(_loc2_,flatten(_loc3_));
            }
            else
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public static function sum(param1:Array) : Number
      {
         var _loc3_:Number = NaN;
         var _loc2_:Number = 0;
         for each(_loc3_ in param1)
         {
            _loc2_ += _loc3_;
         }
         return _loc2_;
      }
      
      public static function removeDuplicates(param1:Array) : Array
      {
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         var _loc4_:int = int(param1.length);
         while(_loc3_ < _loc4_)
         {
            addUnique(_loc2_,param1[_loc3_]);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function choiceWithProbability(param1:Array, param2:Array) : Object
      {
         var _loc3_:Number = sum(param2) * Math.random();
         var _loc4_:int = 0;
         while(_loc4_ < param2.length)
         {
            _loc3_ -= param2[_loc4_];
            if(_loc3_ < 0)
            {
               return param1[_loc4_];
            }
            _loc4_++;
         }
         return null;
      }
      
      public static function popChoice(param1:Array) : Object
      {
         return param1.splice(chooseIndex(param1),1)[0];
      }
      
      public static function equal(param1:Array, param2:Array) : Boolean
      {
         var _loc3_:int = int(param1.length);
         if(param2.length !== _loc3_)
         {
            return false;
         }
         while(_loc3_--)
         {
            if(param1[_loc3_] !== param2[_loc3_])
            {
               return false;
            }
         }
         return true;
      }
      
      public static function removeElement(param1:Array, param2:Object) : Object
      {
         var _loc3_:int = param1.indexOf(param2);
         if(_loc3_ != -1)
         {
            return param1.splice(_loc3_,1)[0];
         }
         return null;
      }
      
      public static function addUnique(param1:Array, param2:*) : void
      {
         if(!contains(param1,param2))
         {
            param1.push(param2);
         }
      }
      
      public static function append(param1:Array, param2:Object) : void
      {
         var _loc3_:Array = param2 is Array ? param2 as Array : ObjectUtil.values(param2);
         param1.push.apply(param1,_loc3_);
      }
      
      public static function chooseIndex(param1:Array) : int
      {
         return Math.random() * param1.length;
      }
      
      public static function contains(param1:Array, param2:Object) : Boolean
      {
         return param1.indexOf(param2) !== -1;
      }
   }
}

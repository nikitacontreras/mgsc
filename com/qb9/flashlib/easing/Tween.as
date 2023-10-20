package com.qb9.flashlib.easing
{
   import com.qb9.flashlib.tasks.*;
   
   public class Tween extends Ease
   {
       
      
      protected var dest:Object;
      
      protected var src:Object;
      
      protected var obj:Object;
      
      protected var options:Object;
      
      public function Tween(param1:Object, param2:int, param3:Object, param4:Object = null)
      {
         this.options = param4 || {};
         super(this.updateFunction,param2,0,1,this.options.transition);
         this.dest = param3;
         this.obj = param1;
         this.src = this.options.from || {};
         this.dest = param3;
      }
      
      protected function updateFunction(param1:Number) : void
      {
         var _loc2_:String = null;
         for(_loc2_ in this.dest)
         {
            this.obj[_loc2_] = this.tweenedAttribute(_loc2_,param1);
         }
         if(this.options.updateFunction != null)
         {
            this.options.updateFunction(this.obj,param1);
         }
      }
      
      override public function start() : void
      {
         var _loc1_:String = null;
         for(_loc1_ in this.dest)
         {
            if(this.src[_loc1_] == null)
            {
               this.src[_loc1_] = Number(this.obj[_loc1_]);
            }
            if(this.options.relative)
            {
               this.dest[_loc1_] += this.src[_loc1_];
            }
         }
         super.start();
      }
      
      protected function tweenedAttribute(param1:String, param2:Number) : Number
      {
         var _loc3_:Number = Number(this.src[param1]);
         var _loc4_:Number = Number(this.dest[param1]) - _loc3_;
         return _loc3_ + param2 * _loc4_;
      }
      
      override public function clone() : ITask
      {
         return new Tween(this.obj,duration,this.dest,this.options);
      }
   }
}

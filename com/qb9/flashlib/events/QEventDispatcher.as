package com.qb9.flashlib.events
{
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.flashlib.utils.ArrayUtil;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   
   public class QEventDispatcher extends EventDispatcher implements IDisposable
   {
       
      
      protected var listeners:Object;
      
      public function QEventDispatcher(param1:IEventDispatcher = null)
      {
         super(param1);
         this.listeners = {};
      }
      
      override public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         super.removeEventListener(param1,param2,param3);
         var _loc4_:Array;
         if(!(_loc4_ = this.listeners[param1]))
         {
            return;
         }
         ArrayUtil.removeElement(_loc4_,param2);
         if(_loc4_.length == 0)
         {
            delete this.listeners[param1];
         }
      }
      
      override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = true) : void
      {
         super.addEventListener(param1,param2,param3,param4,param5);
         if(this.listeners[param1])
         {
            if(!ArrayUtil.contains(this.listeners[param1],param2))
            {
               this.listeners[param1].push(param2);
            }
         }
         else
         {
            this.listeners[param1] = [param2];
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:String = null;
         var _loc2_:Array = null;
         for(_loc1_ in this.listeners)
         {
            _loc2_ = this.listeners[_loc1_];
            while(Boolean(_loc2_) && _loc2_.length > 0)
            {
               this.removeEventListener(_loc1_,_loc2_[_loc2_.length - 1]);
            }
         }
      }
      
      public function dispatch(param1:String, param2:* = null) : Boolean
      {
         if(!this.hasEventListener(param1))
         {
            return true;
         }
         return this.dispatchEvent(new QEvent(param1,param2));
      }
   }
}

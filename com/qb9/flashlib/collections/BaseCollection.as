package com.qb9.flashlib.collections
{
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.flashlib.utils.ArrayUtil;
   
   public class BaseCollection implements IDisposable
   {
       
      
      protected var items:Array;
      
      protected var _size:uint;
      
      public function BaseCollection(param1:uint = 4294967295)
      {
         this.items = [];
         super();
         this._size = param1;
      }
      
      public function get size() : uint
      {
         return this._size;
      }
      
      protected function hasItem(param1:Object) : Boolean
      {
         return this.items.indexOf(param1) !== -1;
      }
      
      protected function addItemAt(param1:Object, param2:int) : void
      {
         this.items.splice(param2,0,param1);
      }
      
      public function get full() : Boolean
      {
         return this.items.length >= this.size;
      }
      
      public function get empty() : Boolean
      {
         return this.items.length === 0;
      }
      
      protected function removeItem(param1:Object) : Object
      {
         return ArrayUtil.removeElement(this.items,param1);
      }
      
      public function toArray() : Array
      {
         return this.items.concat();
      }
      
      public function dispose() : void
      {
         this.items = null;
      }
   }
}

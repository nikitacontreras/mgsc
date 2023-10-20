package com.qb9.gaturro.commons.iterator
{
   import com.qb9.gaturro.commons.iterator.iterable.IIterable;
   import com.qb9.gaturro.commons.iterator.iterable.IterableFactory;
   
   public class Iterator implements IIterator
   {
       
      
      private var _disposed:Boolean;
      
      private var _iterable:IIterable;
      
      private var _index:int = -1;
      
      public function Iterator(param1:IIterable = null)
      {
         super();
         this.iterable = param1;
      }
      
      public function getPrev() : *
      {
         return this.prev() ? this.current() : null;
      }
      
      public function next() : Boolean
      {
         var _loc1_:Boolean = this._iterable.exist(this._index + 1);
         if(_loc1_)
         {
            ++this._index;
         }
         return _loc1_;
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function get initialized() : Boolean
      {
         return this._index > -1;
      }
      
      public function sort(param1:Object, param2:Object = null) : void
      {
         this._iterable.sort(param1,param2);
      }
      
      public function set index(param1:int) : void
      {
         this._index = param1;
      }
      
      public function setupIterable(param1:Object) : void
      {
         this._iterable = IterableFactory.build(param1);
      }
      
      public function get disposed() : Boolean
      {
         return this._disposed;
      }
      
      public function toArray() : Array
      {
         return this._iterable.toArray();
      }
      
      public function dispose() : void
      {
         this._disposed = true;
         this._iterable.dispose();
         this._iterable = null;
         this._index = -1;
      }
      
      public function getNext() : *
      {
         return this.next() ? this.current() : null;
      }
      
      public function reset() : void
      {
         this._index = -1;
      }
      
      public function get iterable() : IIterable
      {
         return this._iterable;
      }
      
      public function prev() : Boolean
      {
         var _loc1_:Boolean = this._iterable.exist(this._index - 1);
         if(_loc1_)
         {
            --this._index;
         }
         return _loc1_;
      }
      
      public function get length() : int
      {
         return this._iterable.length;
      }
      
      public function current() : *
      {
         return this._index < 0 ? null : this._iterable.getValue(this._index);
      }
      
      public function set iterable(param1:IIterable) : void
      {
         this._iterable = param1;
      }
   }
}

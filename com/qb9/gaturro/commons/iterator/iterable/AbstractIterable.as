package com.qb9.gaturro.commons.iterator.iterable
{
   import flash.errors.IllegalOperationError;
   
   public class AbstractIterable implements IIterable, IIterableHolder
   {
       
      
      private var _disposed:Boolean;
      
      protected var list:Array;
      
      private var _source:Object;
      
      public function AbstractIterable(param1:Object = null, param2:AbstractIterable = null)
      {
         super();
         if(!param2 || !(param2 is AbstractIterable))
         {
            throw new IllegalOperationError("Forbiden use. This class should be used, only, through inhereted implementationss");
         }
         this.resuse(param1);
      }
      
      public function getValue(param1:int) : *
      {
         if(!this.exist(param1))
         {
            throw new IllegalOperationError("The index supplied doesn\'t exist in the list");
         }
         return this.list[param1];
      }
      
      protected function setupList(param1:Object) : void
      {
         var _loc2_:* = undefined;
         for each(_loc2_ in param1)
         {
            this.list.push(_loc2_);
         }
      }
      
      public function remove(param1:int, param2:int) : void
      {
         this.list.splice(param1,param2);
      }
      
      public function toString() : String
      {
         return "Iterable= [" + this.list + "]";
      }
      
      public function reset() : void
      {
         this.resuse(this._source);
      }
      
      public function concat(param1:IIterable) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            this.list.push(param1.getValue(_loc2_));
            _loc2_++;
         }
      }
      
      public function slice(param1:int, param2:int) : IIterable
      {
         return IterableFactory.build(this.list.slice(param1,param2));
      }
      
      public function dispose() : void
      {
         this._disposed = true;
         this.list = null;
      }
      
      public function get source() : Object
      {
         return this._source;
      }
      
      public function sort(param1:Object, param2:Object = null) : void
      {
         this.list.sortOn(param1,param2);
      }
      
      public function resuse(param1:Object) : void
      {
         this.list = new Array();
         this._source = param1;
         this.setupList(param1);
      }
      
      public function add(param1:*, param2:* = null) : void
      {
         this.list.push(param1);
      }
      
      public function get disposed() : Boolean
      {
         return this._disposed;
      }
      
      public function get length() : int
      {
         return this.list.length;
      }
      
      public function toArray() : Array
      {
         return this.list.slice();
      }
      
      public function exist(param1:int) : Boolean
      {
         return Boolean(this.list) && param1 < this.list.length && param1 >= 0;
      }
   }
}

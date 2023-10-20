package com.qb9.gaturro.commons.iterator.iterable
{
   import com.qb9.gaturro.commons.dispose.ICheckableDisposable;
   
   public interface IIterable extends ICheckableDisposable
   {
       
      
      function getValue(param1:int) : *;
      
      function remove(param1:int, param2:int) : void;
      
      function toArray() : Array;
      
      function get length() : int;
      
      function resuse(param1:Object) : void;
      
      function reset() : void;
      
      function slice(param1:int, param2:int) : IIterable;
      
      function concat(param1:IIterable) : void;
      
      function exist(param1:int) : Boolean;
      
      function get source() : Object;
      
      function sort(param1:Object, param2:Object = null) : void;
   }
}

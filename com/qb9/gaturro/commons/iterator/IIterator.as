package com.qb9.gaturro.commons.iterator
{
   import com.qb9.gaturro.commons.dispose.ICheckableDisposable;
   import com.qb9.gaturro.commons.iterator.iterable.IIterable;
   
   public interface IIterator extends ICheckableDisposable
   {
       
      
      function get iterable() : IIterable;
      
      function set index(param1:int) : void;
      
      function sort(param1:Object, param2:Object = null) : void;
      
      function get length() : int;
      
      function getPrev() : *;
      
      function set iterable(param1:IIterable) : void;
      
      function setupIterable(param1:Object) : void;
      
      function getNext() : *;
      
      function get index() : int;
      
      function next() : Boolean;
      
      function get initialized() : Boolean;
      
      function reset() : void;
      
      function current() : *;
      
      function prev() : Boolean;
      
      function toArray() : Array;
   }
}

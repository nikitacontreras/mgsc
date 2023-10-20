package com.qb9.gaturro.commons.constraint
{
   import com.qb9.gaturro.commons.dispose.ICheckableDisposable;
   
   public interface IConstraint extends ICheckableDisposable
   {
       
      
      function unobserve() : void;
      
      function observe(param1:Function) : void;
      
      function accomplish(param1:* = null) : Boolean;
      
      function setData(param1:*) : void;
      
      function set invert(param1:Boolean) : void;
   }
}

package com.qb9.gaturro.commons.dispose
{
   import com.qb9.flashlib.interfaces.IDisposable;
   
   public interface ICheckableDisposable extends IDisposable
   {
       
      
      function get disposed() : Boolean;
   }
}

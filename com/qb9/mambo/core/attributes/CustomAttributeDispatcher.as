package com.qb9.mambo.core.attributes
{
   import com.qb9.flashlib.interfaces.IDisposable;
   import flash.events.IEventDispatcher;
   
   public interface CustomAttributeDispatcher extends IEventDispatcher, IDisposable
   {
       
      
      function dispatchCustomAttributes(param1:Array) : void;
      
      function removeCustomAttributeListener(param1:String, param2:Function) : void;
      
      function addCustomAttributeListener(param1:String, param2:Function) : void;
   }
}

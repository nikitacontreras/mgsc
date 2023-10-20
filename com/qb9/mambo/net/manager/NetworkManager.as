package com.qb9.mambo.net.manager
{
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.mambo.net.requests.base.MamboRequest;
   import flash.events.IEventDispatcher;
   
   public interface NetworkManager extends IEventDispatcher, IDisposable
   {
       
      
      function logout() : void;
      
      function logWithID(param1:String) : void;
      
      function login(param1:String, param2:String) : void;
      
      function connect(param1:String, param2:uint) : void;
      
      function sendAction(param1:MamboRequest) : void;
   }
}

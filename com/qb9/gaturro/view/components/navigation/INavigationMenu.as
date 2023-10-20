package com.qb9.gaturro.view.components.navigation
{
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.gaturro.view.components.repeater.RepeaterPaginatedFacade;
   import flash.display.DisplayObjectContainer;
   
   public interface INavigationMenu extends IDisposable
   {
       
      
      function setup(param1:DisplayObjectContainer, param2:RepeaterPaginatedFacade) : void;
      
      function reset() : void;
   }
}

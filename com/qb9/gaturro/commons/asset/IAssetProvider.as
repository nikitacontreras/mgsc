package com.qb9.gaturro.commons.asset
{
   import flash.display.DisplayObject;
   import flash.system.ApplicationDomain;
   
   public interface IAssetProvider
   {
       
      
      function getDefinition(param1:String) : Class;
      
      function get applicationDomain() : ApplicationDomain;
      
      function hasDefinition(param1:String) : Boolean;
      
      function getInstanceByName(param1:String) : DisplayObject;
   }
}

package com.qb9.gaturro.commons.loader
{
   import flash.display.DisplayObject;
   import flash.system.ApplicationDomain;
   
   public class SWFLoaderWrapper
   {
       
      
      private var loader:com.qb9.gaturro.commons.loader.SWFLoader;
      
      public function SWFLoaderWrapper(param1:com.qb9.gaturro.commons.loader.SWFLoader)
      {
         super();
         this.loader = param1;
      }
      
      public function getInstanceByName(param1:String) : DisplayObject
      {
         return this.loader.getInstanceByName(param1);
      }
      
      public function getDefinition(param1:String) : Class
      {
         return this.loader.getDefinition(param1) as Class;
      }
      
      public function get applicationDomain() : ApplicationDomain
      {
         return this.loader.applicationDomain;
      }
      
      public function hasDefinition(param1:String) : Boolean
      {
         return this.loader.hasDefinition(param1);
      }
   }
}

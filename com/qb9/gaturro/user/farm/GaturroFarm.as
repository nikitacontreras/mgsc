package com.qb9.gaturro.user.farm
{
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   
   public class GaturroFarm extends EventDispatcher
   {
       
      
      private var _roomId:String;
      
      private var _farmLevel:uint;
      
      public function GaturroFarm(param1:IEventDispatcher = null)
      {
         super(param1);
      }
   }
}

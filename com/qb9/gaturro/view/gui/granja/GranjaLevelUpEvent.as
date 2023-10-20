package com.qb9.gaturro.view.gui.granja
{
   import flash.events.Event;
   
   public class GranjaLevelUpEvent extends Event
   {
      
      public static const OPEN:String = "openGranjaLevelUpModal";
       
      
      private var _level:int;
      
      private var _acquired:Object;
      
      public function GranjaLevelUpEvent(param1:String, param2:int, param3:Object)
      {
         super(param1);
         this._level = param2;
         this._acquired = param3;
      }
      
      public function get level() : int
      {
         return this._level;
      }
      
      override public function clone() : Event
      {
         return new GranjaLevelUpEvent(type,this._level,this._acquired);
      }
      
      public function get acquired() : Object
      {
         return this._acquired;
      }
   }
}

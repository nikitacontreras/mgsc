package com.qb9.gaturro.view.gui.granja
{
   import com.qb9.gaturro.external.roomObjects.GaturroSceneObjectAPI;
   import flash.events.Event;
   
   public class GranjaParcelaUnlockEvent extends Event
   {
      
      public static const OPEN:String = "openParcelaUnlock";
       
      
      private var _objectAPI:GaturroSceneObjectAPI;
      
      public function GranjaParcelaUnlockEvent(param1:String, param2:GaturroSceneObjectAPI)
      {
         super(param1);
         this._objectAPI = param2;
      }
      
      public function get objectAPI() : GaturroSceneObjectAPI
      {
         return this._objectAPI;
      }
      
      override public function clone() : Event
      {
         return new GranjaParcelaUnlockEvent(type,this._objectAPI);
      }
   }
}

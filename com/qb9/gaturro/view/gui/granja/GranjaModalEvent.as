package com.qb9.gaturro.view.gui.granja
{
   import com.qb9.gaturro.external.roomObjects.GaturroSceneObjectAPI;
   import flash.events.Event;
   
   public class GranjaModalEvent extends Event
   {
      
      public static const OPEN:String = "openGranjaModal";
       
      
      private var _oAPI:GaturroSceneObjectAPI;
      
      public function GranjaModalEvent(param1:String, param2:GaturroSceneObjectAPI)
      {
         super(param1);
         this._oAPI = param2;
      }
      
      public function get objectAPI() : GaturroSceneObjectAPI
      {
         return this._oAPI;
      }
      
      override public function clone() : Event
      {
         return new GranjaModalEvent(type,this._oAPI);
      }
   }
}

package com.qb9.gaturro.view.gui.fishing
{
   import com.qb9.gaturro.external.roomObjects.GaturroSceneObjectAPI;
   import flash.events.Event;
   
   public class FishingGuiModalEvent extends Event
   {
      
      public static const OPEN:String = "ggmeOpenFishing";
       
      
      private var _objectApi:GaturroSceneObjectAPI;
      
      public function FishingGuiModalEvent(param1:String, param2:GaturroSceneObjectAPI)
      {
         super(param1,false,false);
         this._objectApi = param2;
      }
      
      public function get objectApi() : GaturroSceneObjectAPI
      {
         return this._objectApi;
      }
      
      override public function clone() : Event
      {
         return new FishingGuiModalEvent(type,this._objectApi);
      }
   }
}

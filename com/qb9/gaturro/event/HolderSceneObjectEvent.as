package com.qb9.gaturro.event
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   
   public class HolderSceneObjectEvent extends Event
   {
      
      public static const ADDED:String = "childAdded";
      
      public static const REMOVE:String = "childRemove";
       
      
      private var _sceenObject:DisplayObject;
      
      public function HolderSceneObjectEvent(param1:String, param2:DisplayObject)
      {
         super(param1,bubbles,cancelable);
         this._sceenObject = param2;
      }
      
      public function get sceneObject() : DisplayObject
      {
         return this._sceenObject;
      }
      
      override public function toString() : String
      {
         return formatToString("HolderSceneObjectEvent","type","target");
      }
      
      override public function clone() : Event
      {
         return new HolderSceneObjectEvent(type,this.sceneObject);
      }
   }
}

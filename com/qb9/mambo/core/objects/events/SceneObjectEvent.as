package com.qb9.mambo.core.objects.events
{
   import com.qb9.mambo.core.objects.SceneObject;
   import flash.events.Event;
   
   public final class SceneObjectEvent extends Event
   {
      
      public static const ACTIVATED:String = "soeActivated";
       
      
      private var _object:SceneObject;
      
      public function SceneObjectEvent(param1:String, param2:SceneObject = null)
      {
         super(param1);
         this._object = param2;
      }
      
      override public function clone() : Event
      {
         return new SceneObjectEvent(type);
      }
      
      public function get object() : SceneObject
      {
         return this._object;
      }
   }
}

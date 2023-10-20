package com.qb9.mambo.user.inventory.events
{
   import com.qb9.mambo.user.inventory.InventorySceneObject;
   import flash.events.Event;
   
   public final class InventoryEvent extends Event
   {
      
      public static const ITEM_REMOVED:String = "ieItemRemoved";
      
      public static const ITEM_ADDED:String = "ieItemAdded";
       
      
      private var _object:InventorySceneObject;
      
      public function InventoryEvent(param1:String, param2:InventorySceneObject = null)
      {
         super(param1);
         this._object = param2;
      }
      
      override public function clone() : Event
      {
         return new InventoryEvent(type,this.object);
      }
      
      public function get object() : InventorySceneObject
      {
         return this._object;
      }
   }
}

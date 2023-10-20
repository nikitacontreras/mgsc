package com.qb9.gaturro.world.core.elements
{
   import com.qb9.flashlib.utils.ArrayUtil;
   import com.qb9.gaturro.world.core.elements.events.HolderRoomSceneObjectEvent;
   import com.qb9.mambo.core.attributes.CustomAttributes;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import com.qb9.mambo.world.tiling.TileGrid;
   
   public final class HolderRoomSceneObject extends RoomSceneObject
   {
       
      
      private var _children:Array;
      
      public function HolderRoomSceneObject(param1:CustomAttributes, param2:TileGrid)
      {
         this._children = [];
         super(param1,param2);
      }
      
      public function get action() : String
      {
         return attributes.useAction;
      }
      
      public function get children() : Array
      {
         return this._children.concat();
      }
      
      public function removeChild(param1:RoomSceneObject) : void
      {
         ArrayUtil.removeElement(this._children,param1);
         dispatchEvent(new HolderRoomSceneObjectEvent(HolderRoomSceneObjectEvent.LEAVING,this,param1));
      }
      
      private function get capacity() : uint
      {
         return uint(attributes.capacity) || 1;
      }
      
      public function addChild(param1:RoomSceneObject) : void
      {
         ArrayUtil.addUnique(this._children,param1);
         dispatchEvent(new HolderRoomSceneObjectEvent(HolderRoomSceneObjectEvent.ENTERING,this,param1));
      }
      
      override public function get blocks() : Boolean
      {
         return this.full;
      }
      
      public function get full() : Boolean
      {
         return this._children.length >= this.capacity;
      }
   }
}

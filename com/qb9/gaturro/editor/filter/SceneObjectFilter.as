package com.qb9.gaturro.editor.filter
{
   import com.qb9.flashlib.lang.filter;
   import com.qb9.gaturro.world.core.elements.BannerRoomSceneObject;
   import com.qb9.gaturro.world.core.elements.HolderRoomSceneObject;
   import com.qb9.gaturro.world.core.elements.HomeInteractiveRoomSceneObject;
   import com.qb9.gaturro.world.core.elements.HouseDecorationRoomSceneObject;
   import com.qb9.gaturro.world.core.elements.ImageRoomSceneObject;
   import com.qb9.gaturro.world.core.elements.MinigameRoomSceneObject;
   import com.qb9.gaturro.world.core.elements.MultiHolderRoomSceneObject;
   import com.qb9.gaturro.world.core.elements.NpcRoomSceneObject;
   import com.qb9.gaturro.world.core.elements.OwnedNpcRoomSceneObject;
   import com.qb9.gaturro.world.core.elements.QueueRoomSceneObject;
   import com.qb9.gaturro.world.core.elements.VendorRoomSceneObject;
   import com.qb9.mambo.world.avatars.Avatar;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import flash.utils.Dictionary;
   
   public class SceneObjectFilter
   {
       
      
      private var sceneObjectMap:Dictionary;
      
      public function SceneObjectFilter()
      {
         super();
         this.setup();
      }
      
      private function isImage(param1:RoomSceneObject) : Boolean
      {
         return param1 is ImageRoomSceneObject;
      }
      
      private function isDecoration(param1:RoomSceneObject) : Boolean
      {
         return param1 is HouseDecorationRoomSceneObject;
      }
      
      public function filterListArray(param1:Array, param2:String) : Array
      {
         var _loc3_:Function = this.sceneObjectMap[param2];
         return filter(param1,_loc3_).sortOn("id",Array.NUMERIC);
      }
      
      private function setup() : void
      {
         this.sceneObjectMap = new Dictionary();
         this.sceneObjectMap["ownerNPC"] = this.isOwnerNpc;
         this.sceneObjectMap["npc"] = this.isNpc;
         this.sceneObjectMap["minigame"] = this.isMinigame;
         this.sceneObjectMap["vendor"] = this.isVendor;
         this.sceneObjectMap["holder"] = this.isHolder;
         this.sceneObjectMap["multiholder"] = this.isMultiholder;
         this.sceneObjectMap["banner"] = this.isBanner;
         this.sceneObjectMap["image"] = this.isImage;
         this.sceneObjectMap["queue"] = this.isQueue;
         this.sceneObjectMap["decoration"] = this.isDecoration;
         this.sceneObjectMap["interactive"] = this.isInteractive;
         this.sceneObjectMap[""] = this.isNotAvatar;
      }
      
      private function isBanner(param1:RoomSceneObject) : Boolean
      {
         return param1 is BannerRoomSceneObject;
      }
      
      private function isQueue(param1:RoomSceneObject) : Boolean
      {
         return param1 is QueueRoomSceneObject;
      }
      
      private function isNotAvatar(param1:RoomSceneObject) : Boolean
      {
         return param1 is Avatar === false;
      }
      
      private function isVendor(param1:RoomSceneObject) : Boolean
      {
         return param1 is VendorRoomSceneObject;
      }
      
      private function isHolder(param1:RoomSceneObject) : Boolean
      {
         return param1 is HolderRoomSceneObject;
      }
      
      private function isNpc(param1:RoomSceneObject) : Boolean
      {
         return param1 is NpcRoomSceneObject;
      }
      
      private function isOwnerNpc(param1:RoomSceneObject) : Boolean
      {
         return param1 is OwnedNpcRoomSceneObject;
      }
      
      private function isMinigame(param1:RoomSceneObject) : Boolean
      {
         return param1 is MinigameRoomSceneObject;
      }
      
      private function isMultiholder(param1:RoomSceneObject) : Boolean
      {
         return param1 is MultiHolderRoomSceneObject;
      }
      
      public function filterList(param1:Array, param2:String) : String
      {
         var _loc3_:Function = this.sceneObjectMap[param2];
         return filter(param1,_loc3_).sortOn("id",Array.NUMERIC).join("\n");
      }
      
      private function isInteractive(param1:RoomSceneObject) : Boolean
      {
         return param1 is HomeInteractiveRoomSceneObject;
      }
   }
}

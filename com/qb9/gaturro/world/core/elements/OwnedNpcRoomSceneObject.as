package com.qb9.gaturro.world.core.elements
{
   import com.qb9.gaturro.world.collection.NpcScriptList;
   import com.qb9.mambo.core.attributes.CustomAttributes;
   import com.qb9.mambo.world.avatars.Avatar;
   import com.qb9.mambo.world.tiling.TileGrid;
   
   public class OwnedNpcRoomSceneObject extends NpcRoomSceneObject
   {
       
      
      private var _ownedNpcName:String;
      
      private var _avatar:Avatar;
      
      public function OwnedNpcRoomSceneObject(param1:Avatar, param2:CustomAttributes, param3:TileGrid, param4:NpcScriptList)
      {
         super(param2,param3,param4);
         this._avatar = param1;
         this._ownedNpcName = String(param2.name) || "";
      }
      
      public function get onwedNpcName() : String
      {
         return this._ownedNpcName;
      }
      
      public function get avatar() : Avatar
      {
         return this._avatar;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this._avatar = null;
      }
   }
}

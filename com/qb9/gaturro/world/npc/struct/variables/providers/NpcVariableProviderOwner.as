package com.qb9.gaturro.world.npc.struct.variables.providers
{
   import com.qb9.gaturro.world.core.avatar.pet.AvatarPet;
   import com.qb9.gaturro.world.core.elements.OwnedNpcRoomSceneObject;
   import com.qb9.gaturro.world.npc.struct.NpcContext;
   import com.qb9.mambo.world.core.RoomSceneObject;
   
   public final class NpcVariableProviderOwner extends BaseNpcAttributeProvider
   {
       
      
      public function NpcVariableProviderOwner()
      {
         super();
      }
      
      override protected function getObject(param1:NpcContext) : RoomSceneObject
      {
         var _loc2_:RoomSceneObject = param1.api.object;
         if(_loc2_ is AvatarPet)
         {
            return AvatarPet(_loc2_).avatar;
         }
         if(_loc2_ is OwnedNpcRoomSceneObject)
         {
            return OwnedNpcRoomSceneObject(_loc2_).avatar;
         }
         return null;
      }
   }
}

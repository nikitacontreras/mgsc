package com.qb9.gaturro.world.npc.struct.variables.providers
{
   import com.qb9.gaturro.world.npc.struct.NpcContext;
   import com.qb9.mambo.world.core.RoomSceneObject;
   
   public final class NpcVariableProviderUser extends BaseNpcAttributeProvider
   {
       
      
      public function NpcVariableProviderUser()
      {
         super();
      }
      
      override protected function getObject(param1:NpcContext) : RoomSceneObject
      {
         return param1.roomAPI.userAvatar;
      }
   }
}

package com.qb9.gaturro.world.npc.struct.variables.providers
{
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.npc.struct.NpcContext;
   import com.qb9.gaturro.world.npc.struct.NpcScript;
   import com.qb9.mambo.world.core.RoomSceneObject;
   
   public final class NpcVariableProviderLast extends BaseNpcAttributeProvider
   {
      
      public static const LAST_FIND:String = "_LAST_ID_";
       
      
      public function NpcVariableProviderLast()
      {
         super();
         functions.defined = this.defined;
      }
      
      public function defined(param1:NpcContext) : Boolean
      {
         return this.getObject(param1) !== null;
      }
      
      override protected function getObject(param1:NpcContext) : RoomSceneObject
      {
         var _loc2_:Number = param1.getVariable(NpcScript.LAST_FIND) as int;
         var _loc3_:GaturroRoom = param1.roomAPI.room;
         return _loc3_.sceneObjectById(Math.abs(_loc2_));
      }
   }
}

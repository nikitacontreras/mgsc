package com.qb9.gaturro.world.npc.struct.variables.providers
{
   import com.qb9.gaturro.world.npc.struct.NpcContext;
   
   public final class NpcVariableProviderRoom extends BaseNpcVariableProvider implements NpcVariableProvider
   {
       
      
      public function NpcVariableProviderRoom()
      {
         super({"getValue":this.getValue});
      }
      
      public function has(param1:String, param2:NpcContext) : Boolean
      {
         return param1 !== null;
      }
      
      public function getValue(param1:String, param2:NpcContext) : Object
      {
         var _loc3_:Object = null;
         if(param1 in param2.roomAPI.room)
         {
            _loc3_ = param2.roomAPI.room[param1];
         }
         if(param1 in param2.roomAPI.room.attributes)
         {
            _loc3_ = param2.roomAPI.room.attributes[param1];
         }
         return !_loc3_ ? param2.roomAPI.room.id : _loc3_;
      }
      
      public function dispose() : void
      {
      }
   }
}

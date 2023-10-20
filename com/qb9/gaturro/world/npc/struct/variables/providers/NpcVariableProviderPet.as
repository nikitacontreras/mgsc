package com.qb9.gaturro.world.npc.struct.variables.providers
{
   import com.qb9.flashlib.utils.StringUtil;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.world.core.avatar.ownednpc.OwnedNpcFactory;
   import com.qb9.gaturro.world.npc.struct.NpcContext;
   import com.qb9.mambo.core.attributes.CustomAttributeHolder;
   
   public final class NpcVariableProviderPet extends BaseNpcVariableProvider implements NpcVariableProvider
   {
       
      
      public function NpcVariableProviderPet()
      {
         super();
      }
      
      public function has(param1:String, param2:NpcContext) : Boolean
      {
         return this.getValue(param1,param2) !== null;
      }
      
      public function pad(param1:String, param2:NpcContext) : Object
      {
         var _loc3_:Object = this.def(param1,param2);
         if(_loc3_ !== null)
         {
            return StringUtil.padLeft(Number(_loc3_),2);
         }
         return _loc3_;
      }
      
      override protected function def(param1:String, param2:NpcContext) : Object
      {
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         var _loc5_:uint = 0;
         switch(param1)
         {
            case "type":
               _loc4_ = user.house.items;
               _loc5_ = 0;
               while(_loc5_ < _loc4_.length)
               {
                  _loc3_ = _loc4_[_loc5_];
                  if(OwnedNpcFactory.isOwnedNpcItem(_loc3_ as CustomAttributeHolder))
                  {
                     trace(_loc3_.name);
                  }
                  _loc5_++;
               }
               return "koala";
            default:
               return null;
         }
      }
      
      public function getValue(param1:String, param2:NpcContext) : Object
      {
         return evaluate(param1,param2);
      }
      
      public function dispose() : void
      {
      }
   }
}

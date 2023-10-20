package com.qb9.gaturro.world.npc.interpreter.action
{
   import com.qb9.mambo.world.core.RoomSceneObject;
   
   internal final class InternalFindHandler
   {
       
      
      public function InternalFindHandler()
      {
         super();
      }
      
      public static function find(param1:Array, param2:String, param3:uint = 0) : RoomSceneObject
      {
         var _loc5_:RoomSceneObject = null;
         var _loc4_:*;
         if(_loc4_ = param2.slice(-1) === "*")
         {
            param2 = param2.slice(0,-1);
         }
         for each(_loc5_ in param1)
         {
            if(_loc5_.name === param2 || _loc4_ && _loc5_.name.indexOf(param2) === 0)
            {
               if(param3-- === 0)
               {
                  return _loc5_;
               }
            }
         }
         return null;
      }
   }
}

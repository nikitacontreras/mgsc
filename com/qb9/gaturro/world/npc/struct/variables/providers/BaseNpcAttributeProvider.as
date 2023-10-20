package com.qb9.gaturro.world.npc.struct.variables.providers
{
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.view.world.avatars.Gaturro;
   import com.qb9.gaturro.world.core.avatar.pet.AvatarPet;
   import com.qb9.gaturro.world.npc.struct.NpcContext;
   import com.qb9.mambo.world.avatars.Avatar;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import com.qb9.mambo.world.elements.MovingRoomSceneObject;
   
   internal class BaseNpcAttributeProvider extends BaseNpcVariableProvider implements NpcVariableProvider
   {
       
      
      public function BaseNpcAttributeProvider(param1:Object = null)
      {
         super({
            "attr":this.attr,
            "costume":this.costume
         });
      }
      
      public function costume(param1:NpcContext) : String
      {
         return HelperCostume.costume(this.getObject(param1));
      }
      
      public function has(param1:String, param2:NpcContext) : Boolean
      {
         return param1 in functions || this.getValue(param1,param2) !== null;
      }
      
      public function getValue(param1:String, param2:NpcContext) : Object
      {
         return this.getObject(param2) && evaluate(param1,param2);
      }
      
      protected function getObject(param1:NpcContext) : RoomSceneObject
      {
         return null;
      }
      
      public function attr(param1:String, param2:NpcContext) : Object
      {
         var _loc3_:Object = this.getObject(param2).attributes[param1];
         return _loc3_ !== null ? _loc3_ : "";
      }
      
      override protected function def(param1:String, param2:NpcContext) : Object
      {
         var _loc4_:GaturroRoomAPI = null;
         var _loc5_:* = undefined;
         var _loc3_:RoomSceneObject = this.getObject(param2);
         switch(param1)
         {
            case "x":
               return _loc3_.coord.x;
            case "y":
               return _loc3_.coord.y;
            case "destX":
               return MovingRoomSceneObject(_loc3_).destination.x;
            case "destY":
               return MovingRoomSceneObject(_loc3_).destination.y;
            case "name":
               if(_loc3_ is Avatar)
               {
                  return Avatar(_loc3_).username;
               }
               if(_loc3_ is AvatarPet)
               {
                  return AvatarPet(_loc3_).petName;
               }
               return _loc3_.name;
               break;
            case "action":
               if(_loc3_ is Avatar)
               {
                  if(Boolean((_loc5_ = (_loc4_ = GaturroRoomAPI(param2.roomAPI)).getView(_loc3_)).clip) && _loc5_.clip is Gaturro)
                  {
                     return Gaturro(_loc5_.clip).action;
                  }
                  return "oca";
               }
               return _loc3_.attributes.action;
               break;
            case "emote":
               return _loc3_.attributes.emote;
            default:
               return null;
         }
      }
      
      public function dispose() : void
      {
      }
   }
}

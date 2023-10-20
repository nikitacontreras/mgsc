package com.qb9.gaturro.service.torneo
{
   import com.qb9.gaturro.globals.net;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.mambo.core.attributes.CustomAttribute;
   import com.qb9.mambo.core.objects.SceneObject;
   import com.qb9.mambo.net.requests.customAttributes.BaseUpdateCustomAttributesRequest;
   
   public class EliminatoriaRoomUtil
   {
       
      
      private var soContainer:String = "";
      
      private var attributeKeyPrefix:String = "rank_";
      
      private var containerDefinitions:Array;
      
      public function EliminatoriaRoomUtil()
      {
         this.containerDefinitions = ["torneo2017/props.partidoHolder_so"];
         super();
      }
      
      private function searchForContainer(param1:GaturroRoom) : void
      {
         var _loc2_:SceneObject = null;
         for each(_loc2_ in param1.sceneObjects)
         {
            if(this.containerDefinitions.indexOf(_loc2_.name) != -1)
            {
               this.soContainer = _loc2_.name;
               return;
            }
         }
      }
      
      public function dbread(param1:int, param2:GaturroRoom) : String
      {
         var _loc3_:SceneObject = null;
         var _loc4_:String = null;
         this.searchForContainer(param2);
         for each(_loc3_ in param2.sceneObjects)
         {
            if(_loc3_.name == this.soContainer)
            {
               return String(_loc3_.attributes[this.attributeKeyPrefix + param1]);
            }
         }
         return null;
      }
      
      public function dbclear(param1:int, param2:GaturroRoom) : void
      {
         var _loc3_:SceneObject = null;
         var _loc4_:CustomAttribute = null;
         this.searchForContainer(param2);
         for each(_loc3_ in param2.sceneObjects)
         {
            if(_loc3_.name == this.soContainer)
            {
               _loc4_ = new CustomAttribute(this.attributeKeyPrefix + param1.toString(),"");
               _loc3_.attributes.mergeAttributesArray([_loc4_]);
               net.sendAction(new BaseUpdateCustomAttributesRequest("sceneObjectId",_loc3_.id,_loc3_.attributes.toArray()));
            }
         }
      }
      
      public function dbwrite(param1:PlayOffMatchData, param2:int, param3:GaturroRoom) : void
      {
         var _loc4_:SceneObject = null;
         var _loc5_:CustomAttribute = null;
         this.searchForContainer(param3);
         for each(_loc4_ in param3.sceneObjects)
         {
            if(_loc4_.name == this.soContainer)
            {
               _loc5_ = new CustomAttribute(this.attributeKeyPrefix + param2.toString(),param1.asJSONString());
               _loc4_.attributes.mergeAttributesArray([_loc5_]);
               net.sendAction(new BaseUpdateCustomAttributesRequest("sceneObjectId",_loc4_.id,_loc4_.attributes.toArray()));
            }
         }
      }
   }
}

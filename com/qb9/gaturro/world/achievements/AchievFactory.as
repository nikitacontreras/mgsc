package com.qb9.gaturro.world.achievements
{
   import com.qb9.gaturro.world.achievements.types.Achievement;
   import com.qb9.gaturro.world.achievements.types.ActionQuantityAchiev;
   import com.qb9.gaturro.world.achievements.types.ClothingAchiev;
   import com.qb9.gaturro.world.achievements.types.CoinAccumulationAchiev;
   import com.qb9.gaturro.world.achievements.types.ConsecutiveAccessAchiev;
   import com.qb9.gaturro.world.achievements.types.ElementActionQuantityAchiev;
   import com.qb9.gaturro.world.achievements.types.GiveObjectAchiev;
   import com.qb9.gaturro.world.achievements.types.LocationAttrAchiev;
   import com.qb9.gaturro.world.achievements.types.LocationRoomAchiev;
   import com.qb9.gaturro.world.achievements.types.MeetingRoomAchiev;
   import com.qb9.gaturro.world.achievements.types.PermanenceRoomAchiev;
   import com.qb9.gaturro.world.achievements.types.ThrowableAchiev;
   import com.qb9.gaturro.world.achievements.types.VisitingRoomsAchiev;
   
   public class AchievFactory
   {
       
      
      public function AchievFactory()
      {
         super();
      }
      
      public function createAchiev(param1:Object, param2:Object, param3:Boolean) : Achievement
      {
         var _loc7_:Achievement = null;
         var _loc4_:String = String(param1.type);
         var _loc5_:String = String(param1.key);
         var _loc6_:String = param2[_loc5_] == null ? "" : String(param2[_loc5_]);
         switch(_loc4_)
         {
            case "give":
               _loc7_ = new GiveObjectAchiev(param1);
               break;
            case "coins":
               _loc7_ = new CoinAccumulationAchiev(param1);
               break;
            case "access":
               _loc7_ = new ConsecutiveAccessAchiev(param1);
               break;
            case "visiting":
               _loc7_ = new VisitingRoomsAchiev(param1);
               break;
            case "meeting":
               _loc7_ = new MeetingRoomAchiev(param1);
               break;
            case "permanence":
               _loc7_ = new PermanenceRoomAchiev(param1);
               break;
            case "location":
               _loc7_ = new LocationRoomAchiev(param1);
               break;
            case "actionRepeat":
               _loc7_ = new ActionQuantityAchiev(param1);
               break;
            case "actionElement":
               _loc7_ = new ElementActionQuantityAchiev(param1);
               break;
            case "clothing":
               _loc7_ = new ClothingAchiev(param1);
               break;
            case "throwable":
               _loc7_ = new ThrowableAchiev(param1);
               break;
            case "locationAttr":
               _loc7_ = new LocationAttrAchiev(param1);
         }
         if(_loc7_)
         {
            _loc7_.init(_loc6_,param3);
         }
         return _loc7_;
      }
   }
}

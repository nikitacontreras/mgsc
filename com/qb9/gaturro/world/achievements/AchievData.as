package com.qb9.gaturro.world.achievements
{
   import com.qb9.gaturro.world.achievements.types.Achievement;
   
   public class AchievData
   {
       
      
      private var user:String;
      
      private var list:Array;
      
      public function AchievData(param1:String)
      {
         this.list = new Array();
         super();
         this.user = param1;
      }
      
      public function achievByKey(param1:String) : Achievement
      {
         var _loc2_:Achievement = null;
         for each(_loc2_ in this.list)
         {
            if(_loc2_.keyId == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function get achievementList() : Array
      {
         return this.list;
      }
      
      public function get username() : String
      {
         return this.user;
      }
   }
}

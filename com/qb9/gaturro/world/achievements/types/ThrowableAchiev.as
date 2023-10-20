package com.qb9.gaturro.world.achievements.types
{
   public class ThrowableAchiev extends Achievement
   {
       
      
      public function ThrowableAchiev(param1:Object)
      {
         super(param1);
      }
      
      override public function init(param1:String, param2:Boolean) : void
      {
         super.init(param1,param2);
         if(param1 == Achievement.ACHIEVEMENT_SUCCESS)
         {
            achieved = true;
         }
      }
      
      public function achieveNow(param1:Boolean = true) : void
      {
         if(this.isAchieved() == false)
         {
            this.achieve();
         }
      }
   }
}

package com.qb9.gaturro.world.parties.target
{
   import com.qb9.mambo.world.avatars.Avatar;
   
   public class Attendance extends Target
   {
       
      
      private var totalUsers:int = 0;
      
      private var popularityObtained:int = 0;
      
      public function Attendance(param1:Object)
      {
         super(param1);
      }
      
      override public function get description() : String
      {
         return super.description + " (" + this.totalUsers.toString() + ")";
      }
      
      override public function get popularityValue() : int
      {
         return this.popularityObtained;
      }
      
      override public function check(param1:Object) : void
      {
         var _loc4_:Object = null;
         var _loc2_:int = int(param1.room.attributes.capacity);
         var _loc3_:int = 0;
         for each(_loc4_ in param1.room.sceneObjects)
         {
            if(_loc4_ is Avatar)
            {
               _loc3_++;
            }
         }
         _loc3_--;
         if(_loc3_ > _loc2_)
         {
            _loc3_ = _loc2_;
         }
         var _loc5_:int;
         if((_loc5_ = _loc3_ * super.popularityValue) > 0 && !targetDone)
         {
            confirm();
         }
         if(_loc5_ > this.popularityObtained)
         {
            this.totalUsers = _loc3_;
            this.popularityObtained = _loc5_;
         }
      }
   }
}

package com.qb9.gaturro.world.parties.target
{
   import com.qb9.gaturro.globals.region;
   import com.qb9.mambo.world.avatars.UserAvatar;
   
   public class Target
   {
       
      
      protected var targetDone:Boolean = false;
      
      protected var targetData:Object;
      
      public function Target(param1:Object)
      {
         super();
         this.targetData = param1;
      }
      
      protected function confirm() : void
      {
         this.targetDone = true;
      }
      
      public function get done() : Boolean
      {
         return this.targetDone;
      }
      
      public function get popularityValue() : int
      {
         return this.targetData.popularity;
      }
      
      public function get showCheck() : Boolean
      {
         return this.targetData.showCheck;
      }
      
      protected function checkAttr(param1:Object, param2:String, param3:String) : Boolean
      {
         var _loc5_:Object = null;
         var _loc6_:String = null;
         var _loc4_:UserAvatar = UserAvatar(param1.room.userAvatar);
         for(_loc5_ in _loc4_.attributes)
         {
            if(_loc5_ == param2)
            {
               _loc6_ = String(_loc4_.attributes[_loc5_]);
               if((_loc6_ = String(_loc6_.split(".")[0])) == param3)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public function get description() : String
      {
         return region.getText(this.targetData.description);
      }
      
      public function check(param1:Object) : void
      {
      }
   }
}

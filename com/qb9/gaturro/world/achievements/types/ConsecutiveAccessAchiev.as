package com.qb9.gaturro.world.achievements.types
{
   import com.qb9.gaturro.globals.server;
   import flash.utils.setTimeout;
   
   public class ConsecutiveAccessAchiev extends Achievement
   {
       
      
      protected var value:String;
      
      protected var quantityNeeds:int;
      
      protected const MILLISECONDS_IN_DAY:Number = 86400000;
      
      public function ConsecutiveAccessAchiev(param1:Object)
      {
         super(param1);
         this.quantityNeeds = param1.data.quantity;
      }
      
      override public function init(param1:String, param2:Boolean) : void
      {
         super.init(param1,param2);
         this.value = param1;
         setTimeout(this.check,1000);
      }
      
      private function check() : void
      {
         if(this.value == Achievement.ACHIEVEMENT_SUCCESS)
         {
            achieved = true;
            return;
         }
         if(!monitor)
         {
            return;
         }
         var _loc1_:Number = int(server.time / this.MILLISECONDS_IN_DAY);
         if(this.value == "")
         {
            save(_loc1_.toString() + ";1");
            return;
         }
         var _loc2_:Number = Number(this.value.split(";")[0]);
         var _loc3_:int = Number(this.value.split(";")[1]);
         if(_loc1_ <= _loc2_)
         {
            return;
         }
         if(_loc1_ == _loc2_ + 1)
         {
            _loc3_++;
            if(_loc3_ >= this.quantityNeeds)
            {
               setTimeout(achieve,3000);
            }
            else
            {
               save(_loc1_.toString() + ";" + _loc3_.toString());
            }
         }
         else
         {
            save(_loc1_.toString() + ";1");
         }
      }
   }
}

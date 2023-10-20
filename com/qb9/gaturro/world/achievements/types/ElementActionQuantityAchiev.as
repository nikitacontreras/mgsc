package com.qb9.gaturro.world.achievements.types
{
   import com.qb9.flashlib.utils.ArrayUtil;
   import flash.utils.setTimeout;
   
   public class ElementActionQuantityAchiev extends ActionQuantityAchiev
   {
       
      
      protected var elementList:Array;
      
      public function ElementActionQuantityAchiev(param1:Object)
      {
         this.elementList = new Array();
         super(param1);
      }
      
      override public function init(param1:String, param2:Boolean) : void
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         super.init(param1,param2);
         if(param1 == Achievement.ACHIEVEMENT_SUCCESS)
         {
            achieved = true;
         }
         else
         {
            if(param1 == "")
            {
               return;
            }
            _loc3_ = param1.split(";");
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               this.elementList.push(_loc3_[_loc4_]);
               _loc4_++;
            }
         }
      }
      
      override protected function computeAction(param1:String) : void
      {
         var _loc2_:Array = param1.split(".");
         if(_loc2_.length < 3)
         {
            return;
         }
         var _loc3_:String = String(_loc2_[1]) + "." + String(_loc2_[2]);
         if(ArrayUtil.contains(this.elementList,_loc3_))
         {
            return;
         }
         this.elementList.push(_loc3_);
         if(this.elementList.length >= quantityNeeds)
         {
            setTimeout(achieve,5000);
         }
         else
         {
            save(this.serialize(this.elementList));
         }
      }
      
      private function serialize(param1:Array) : String
      {
         var _loc3_:String = null;
         var _loc2_:String = "";
         for each(_loc3_ in param1)
         {
            _loc2_ += _loc3_ + ";";
         }
         return _loc2_.substr(0,_loc2_.length - 1);
      }
   }
}

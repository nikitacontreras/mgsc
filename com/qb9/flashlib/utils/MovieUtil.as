package com.qb9.flashlib.utils
{
   import flash.display.FrameLabel;
   import flash.display.MovieClip;
   
   public final class MovieUtil
   {
       
      
      public function MovieUtil()
      {
         super();
      }
      
      public static function hasLabel(param1:MovieClip, param2:String) : Boolean
      {
         return ArrayUtil.contains(getLabels(param1),param2);
      }
      
      public static function makeLabels(param1:Object) : Array
      {
         var _loc3_:String = null;
         var _loc2_:Array = [];
         for(_loc3_ in param1)
         {
            _loc2_.push(new FrameLabel(_loc3_,param1[_loc3_]));
         }
         return _loc2_;
      }
      
      public static function getLabels(param1:MovieClip) : Array
      {
         var _loc3_:FrameLabel = null;
         var _loc2_:Array = [];
         for each(_loc3_ in param1.currentLabels)
         {
            _loc2_.push(_loc3_.name);
         }
         return _loc2_;
      }
   }
}

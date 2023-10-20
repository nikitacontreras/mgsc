package com.qb9.gaturro.view.world.avatars
{
   import com.qb9.flashlib.utils.DisplayUtil;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   internal class InternalClipUtil
   {
       
      
      public function InternalClipUtil()
      {
         super();
      }
      
      public static function gatherPlaceholders(param1:Sprite) : Array
      {
         var _loc3_:DisplayObject = null;
         var _loc2_:Array = [];
         for each(_loc3_ in DisplayUtil.children(param1,true))
         {
            if(_loc3_.name && _loc3_ is MovieClip && MovieClip(_loc3_).numChildren === 0)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
   }
}

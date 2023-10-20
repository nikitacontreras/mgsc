package com.qb9.gaturro.view.gui.iphone2.transitions
{
   public final class IPhone2TransitionDirection
   {
      
      public static const LEFT:uint = 1;
      
      public static const DOWN:uint = 8;
      
      public static const UP:uint = 4;
      
      public static const RIGHT:uint = 2;
       
      
      public function IPhone2TransitionDirection()
      {
         super();
      }
      
      public static function opposite(param1:uint) : uint
      {
         var _loc2_:uint = 0;
         if(param1 & LEFT)
         {
            _loc2_ |= RIGHT;
         }
         if(param1 & RIGHT)
         {
            _loc2_ |= LEFT;
         }
         if(param1 & UP)
         {
            _loc2_ |= DOWN;
         }
         if(param1 & DOWN)
         {
            _loc2_ |= UP;
         }
         return _loc2_;
      }
   }
}

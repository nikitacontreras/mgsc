package com.qb9.flashlib.geom
{
   public final class Direction
   {
      
      public static const NORTH:int = 1;
      
      public static const DOWN:int = 32;
      
      public static const SOUTH:int = 2;
      
      public static const WEST:int = 4;
      
      public static const UP:int = 16;
      
      public static const EAST:int = 8;
       
      
      public function Direction()
      {
         super();
      }
      
      public static function calculate(param1:Object, param2:Object) : int
      {
         var _loc3_:* = 0;
         if(param1.x < param2.x)
         {
            _loc3_ |= EAST;
         }
         else if(param1.x > param2.x)
         {
            _loc3_ |= WEST;
         }
         if(param1.y < param2.y)
         {
            _loc3_ |= SOUTH;
         }
         else if(param1.y > param2.y)
         {
            _loc3_ |= NORTH;
         }
         if("z" in param1 && "z" in param2)
         {
            if(param1.z < param2.z)
            {
               _loc3_ |= UP;
            }
            else if(param1.z > param2.z)
            {
               _loc3_ |= DOWN;
            }
         }
         return _loc3_;
      }
   }
}

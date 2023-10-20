package com.qb9.mambo.world.path
{
   import com.qb9.mambo.geom.Coord;
   
   public interface PathFinder
   {
       
      
      function findPath(param1:Coord, param2:Coord, param3:PathFinderMap) : Array;
   }
}

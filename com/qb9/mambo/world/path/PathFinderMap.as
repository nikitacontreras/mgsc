package com.qb9.mambo.world.path
{
   import com.qb9.mambo.geom.Coord;
   
   public interface PathFinderMap
   {
       
      
      function isBlocked(param1:Coord) : Boolean;
      
      function getCost(param1:Coord, param2:Coord) : Number;
      
      function getEstimatedCost(param1:Coord, param2:Coord) : Number;
   }
}

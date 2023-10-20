package com.qb9.mambo.world.path
{
   import com.qb9.mambo.geom.Coord;
   
   public class PathCreator
   {
       
      
      private var map:com.qb9.mambo.world.path.PathFinderMap;
      
      private var finder:com.qb9.mambo.world.path.PathFinder;
      
      public function PathCreator(param1:com.qb9.mambo.world.path.PathFinder, param2:com.qb9.mambo.world.path.PathFinderMap)
      {
         super();
         this.finder = param1;
         this.map = param2;
      }
      
      public function getPath(param1:Coord, param2:Coord) : Path
      {
         var _loc3_:Array = this.finder.findPath(param1,param2,this.map);
         if(Boolean(_loc3_) && _loc3_.length > 1)
         {
            return new Path(_loc3_,param2);
         }
         return null;
      }
   }
}

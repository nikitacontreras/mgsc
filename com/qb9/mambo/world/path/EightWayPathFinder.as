package com.qb9.mambo.world.path
{
   import com.qb9.mambo.geom.Coord;
   
   public class EightWayPathFinder extends FourWayPathFinder
   {
       
      
      private var strict:Boolean;
      
      public function EightWayPathFinder(param1:Boolean = false, param2:int = 0)
      {
         super(param2);
         this.strict = param1;
      }
      
      override protected function getAdjacent(param1:Coord) : Array
      {
         var _loc4_:Coord = null;
         var _loc2_:Array = [Coord.create(param1.x + 1,param1.y + 1),Coord.create(param1.x + 1,param1.y - 1),Coord.create(param1.x - 1,param1.y + 1),Coord.create(param1.x - 1,param1.y - 1)];
         var _loc3_:Array = super.getAdjacent(param1);
         if(!this.strict)
         {
            return _loc3_.concat(_loc2_);
         }
         for each(_loc4_ in _loc2_)
         {
            if(this.sidesFree(param1,_loc4_))
            {
               _loc3_.push(_loc4_);
            }
         }
         return _loc3_;
      }
      
      private function sidesFree(param1:Coord, param2:Coord) : Boolean
      {
         return isFree(Coord.create(param1.x,param2.y)) && isFree(Coord.create(param2.x,param1.y));
      }
   }
}

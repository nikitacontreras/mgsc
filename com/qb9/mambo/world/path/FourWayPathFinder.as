package com.qb9.mambo.world.path
{
   import com.qb9.flashlib.collections.PriorityQueue;
   import com.qb9.mambo.geom.Coord;
   import flash.utils.Dictionary;
   
   public class FourWayPathFinder implements PathFinder
   {
       
      
      private var cache:Dictionary;
      
      protected var dest:Coord;
      
      private var limit:int;
      
      protected var map:com.qb9.mambo.world.path.PathFinderMap;
      
      public function FourWayPathFinder(param1:int = 0)
      {
         super();
         this.limit = param1;
      }
      
      private function totalCost(param1:Array) : Number
      {
         var _loc4_:Coord = null;
         var _loc2_:Number = 0;
         var _loc3_:Coord = param1[0];
         for each(_loc4_ in param1.slice(1))
         {
            _loc2_ += this.map.getCost(_loc3_,_loc4_);
            _loc3_ = _loc4_;
         }
         return _loc2_;
      }
      
      public function findPath(param1:Coord, param2:Coord, param3:com.qb9.mambo.world.path.PathFinderMap) : Array
      {
         var _loc9_:Array = null;
         var _loc10_:Coord = null;
         var _loc11_:Coord = null;
         var _loc12_:Array = null;
         this.map = param3;
         this.dest = param2;
         this.cache = new Dictionary(true);
         var _loc4_:Dictionary = new Dictionary(true);
         var _loc5_:int = 0;
         var _loc6_:PriorityQueue = new PriorityQueue();
         var _loc7_:Array = [param1];
         var _loc8_:Number = this.f(_loc7_);
         _loc6_.enqueue(_loc7_,1 / _loc8_);
         while(!_loc6_.empty)
         {
            if(++_loc5_ === this.limit)
            {
               break;
            }
            _loc9_ = _loc6_.dequeue() as Array;
            if(!((_loc10_ = this.last(_loc9_)) in _loc4_))
            {
               if(_loc10_.equals(param2))
               {
                  return _loc9_;
               }
               _loc4_[_loc10_] = true;
               _loc7_ = this.chooseClosest(_loc7_,_loc9_);
               for each(_loc11_ in this.successors(_loc10_))
               {
                  _loc12_ = _loc9_.concat(_loc11_);
                  _loc8_ = this.f(_loc12_);
                  _loc6_.enqueue(_loc12_,1 / _loc8_);
               }
            }
         }
         return _loc7_;
      }
      
      private function f(param1:Array) : Number
      {
         return this.totalCost(param1) + this.map.getEstimatedCost(this.last(param1),this.dest);
      }
      
      private function successors(param1:Coord) : Array
      {
         var _loc3_:Coord = null;
         var _loc2_:Array = [];
         for each(_loc3_ in this.getAdjacent(param1))
         {
            if(this.isFree(_loc3_))
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      protected function isFree(param1:Coord) : Boolean
      {
         if(param1 in this.cache === false)
         {
            this.cache[param1] = !this.map.isBlocked(param1);
         }
         return this.cache[param1];
      }
      
      private function chooseClosest(param1:Array, param2:Array) : Array
      {
         var _loc3_:Number = this.map.getEstimatedCost(this.last(param1),this.dest);
         var _loc4_:Number = this.map.getEstimatedCost(this.last(param2),this.dest);
         if(_loc3_ < _loc4_)
         {
            return param1;
         }
         if(_loc3_ > _loc4_)
         {
            return param2;
         }
         var _loc5_:Number = this.totalCost(param1);
         var _loc6_:Number = this.totalCost(param2);
         if(_loc5_ < _loc6_)
         {
            return param1;
         }
         if(_loc5_ > _loc6_)
         {
            return param2;
         }
         if(param1.length <= param2.length)
         {
            return param1;
         }
         return param2;
      }
      
      private function last(param1:Array) : Coord
      {
         return param1[param1.length - 1];
      }
      
      protected function getAdjacent(param1:Coord) : Array
      {
         var coord:Coord = param1;
         var _loc3_:*;
         with(_loc3_ = coord)
         {
            return [Coord.create(x + 1,y),Coord.create(x - 1,y),Coord.create(x,y + 1),Coord.create(x,y - 1)];
         }
      }
   }

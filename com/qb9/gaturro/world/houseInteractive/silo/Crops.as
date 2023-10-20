package com.qb9.gaturro.world.houseInteractive.silo
{
   public class Crops
   {
       
      
      private var crops:Array;
      
      public function Crops()
      {
         super();
         this.crops = [];
      }
      
      public function byPosition(param1:int) : Object
      {
         var _loc2_:Object = null;
         if(param1 < this.crops.length)
         {
            _loc2_ = this.crops[param1];
         }
         return _loc2_;
      }
      
      public function byName(param1:String) : Object
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         for each(_loc3_ in this.crops)
         {
            if(_loc3_.name == param1)
            {
               _loc2_ = _loc3_;
            }
         }
         return _loc2_;
      }
      
      public function hasCrop(param1:String) : Boolean
      {
         var _loc2_:Object = null;
         for each(_loc2_ in this.crops)
         {
            if(param1 == _loc2_.name)
            {
               return true;
            }
         }
         return false;
      }
      
      public function toString() : String
      {
         var _loc2_:Object = null;
         var _loc1_:String = "";
         for each(_loc2_ in this.crops)
         {
            _loc1_ += String(_loc2_.id) + ":" + String(_loc2_.qty) + ",";
         }
         return _loc1_.substring(0,_loc1_.length - 1);
      }
      
      public function get length() : int
      {
         return this.crops.length;
      }
      
      public function addCrop(param1:Object) : void
      {
         if(this.hasCrop(param1.name))
         {
            this.addQty(param1.name,1);
            return;
         }
         this.crops.push(param1);
      }
      
      public function removeQty(param1:String, param2:int) : void
      {
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc3_:int = 0;
         for each(_loc4_ in this.crops)
         {
            if(_loc4_.name == param1)
            {
               if((_loc5_ = int(_loc4_.qty)) - param2 <= 0)
               {
                  this.crops.splice(_loc3_,1);
               }
               else
               {
                  _loc4_.qty = _loc5_ - param2;
               }
            }
            _loc3_++;
         }
      }
      
      public function addQty(param1:String, param2:int) : void
      {
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         for each(_loc3_ in this.crops)
         {
            if(_loc3_.name == param1)
            {
               _loc4_ = int(_loc3_.qty);
               _loc3_.qty = _loc4_ + param2;
            }
         }
      }
      
      public function get amount() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this.crops.length)
         {
            _loc1_ += int(this.crops[_loc2_].qty);
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function byId(param1:int) : Object
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         for each(_loc3_ in this.crops)
         {
            if(_loc3_.id == param1)
            {
               _loc2_ = _loc3_;
            }
         }
         return _loc2_;
      }
   }
}

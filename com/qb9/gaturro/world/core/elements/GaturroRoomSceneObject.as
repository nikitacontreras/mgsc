package com.qb9.gaturro.world.core.elements
{
   import com.qb9.mambo.core.attributes.CustomAttributes;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import com.qb9.mambo.world.tiling.TileGrid;
   
   public class GaturroRoomSceneObject extends RoomSceneObject
   {
       
      
      private var _data:Object;
      
      private const ITEM_DATA_SEPARATOR:String = " @DATA@ ";
      
      public function GaturroRoomSceneObject(param1:CustomAttributes, param2:TileGrid)
      {
         super(param1,param2);
      }
      
      public function get dump() : Array
      {
         return dumpVars;
      }
      
      public function get hasData() : Boolean
      {
         return super.name.indexOf(this.ITEM_DATA_SEPARATOR) > -1;
      }
      
      override public function get isGrabbable() : Boolean
      {
         return super.isGrabbable || "stackBy" in attributes;
      }
      
      override public function get name() : String
      {
         var _loc1_:int = super.name.indexOf(this.ITEM_DATA_SEPARATOR);
         if(_loc1_ > -1)
         {
            return super.name.substr(0,_loc1_);
         }
         return super.name;
      }
      
      public function dataByKey(param1:String) : String
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         if(!this._data && this.hasData)
         {
            _loc2_ = super.name.indexOf(this.ITEM_DATA_SEPARATOR);
            _loc3_ = super.name.substr(_loc2_ + this.ITEM_DATA_SEPARATOR.length);
            if(_loc4_ = _loc3_.split(","))
            {
               this._data = {};
               _loc5_ = 0;
               while(_loc5_ < _loc4_.length)
               {
                  _loc6_ = _loc4_[_loc5_].split(":");
                  this._data[_loc6_[0]] = _loc6_[1];
                  _loc5_++;
               }
            }
         }
         if(Boolean(this._data) && param1 in this._data)
         {
            return this._data[param1];
         }
         return "";
      }
   }
}

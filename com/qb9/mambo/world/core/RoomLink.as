package com.qb9.mambo.world.core
{
   import com.qb9.mambo.geom.Coord;
   import com.qb9.mambo.net.mobject.MobjectBuildable;
   import com.qb9.mambo.net.mobject.Mobjectable;
   import com.qb9.mines.mobject.Mobject;
   
   public final class RoomLink implements MobjectBuildable, Mobjectable
   {
       
      
      private var _worldCoord:Coord;
      
      private var _roomId:int;
      
      private var _coord:Coord;
      
      private var _owner:String;
      
      public function RoomLink(param1:Coord = null, param2:Object = null)
      {
         super();
         this._coord = param1 || Coord.create();
         if(param2 is Coord)
         {
            this._worldCoord = param2 as Coord;
         }
         else if(param2 is int)
         {
            this._roomId = param2 as int;
         }
         else if(param2 is String)
         {
            this._owner = param2 as String;
         }
      }
      
      public function set roomId(param1:int) : void
      {
         this._roomId = param1;
      }
      
      public function toMobject() : Mobject
      {
         var _loc1_:Mobject = new Mobject();
         _loc1_.setIntegerArray("coord",this.coord.toArray());
         if(this.roomId)
         {
            _loc1_.setInteger("roomId",this.roomId);
         }
         if(this.worldCoord)
         {
            _loc1_.setIntegerArray("worldCoord",this.worldCoord.toArray());
         }
         if(this.owner)
         {
            _loc1_.setString("ownerUsername",this.owner);
         }
         return _loc1_;
      }
      
      public function get worldCoord() : Coord
      {
         return this._worldCoord;
      }
      
      public function buildFromMobject(param1:Mobject) : void
      {
         this._roomId = param1.getInteger("roomId");
         this._coord = Coord.fromArray(param1.getIntegerArray("coord"));
         var _loc2_:Array = param1.getIntegerArray("worldCoord");
         if(_loc2_)
         {
            this._worldCoord = Coord.fromArray(_loc2_);
         }
      }
      
      public function get owner() : String
      {
         return this._owner;
      }
      
      public function get coord() : Coord
      {
         return this._coord;
      }
      
      public function get roomId() : int
      {
         return this._roomId;
      }
   }
}

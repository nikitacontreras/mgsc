package com.qb9.mambo.world.tiling
{
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.flashlib.lang.any;
   import com.qb9.flashlib.logs.Logger;
   import com.qb9.flashlib.utils.ArrayUtil;
   import com.qb9.mambo.geom.Coord;
   import com.qb9.mambo.net.mobject.MobjectBuildable;
   import com.qb9.mambo.world.avatars.UserAvatar;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import com.qb9.mines.mobject.Mobject;
   
   public class Tile implements MobjectBuildable, IDisposable
   {
       
      
      protected var _blocked:Boolean;
      
      protected var _coord:Coord;
      
      protected var _id:Number;
      
      private var _children:Array;
      
      public function Tile()
      {
         super();
         this._children = [];
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function buildFromMobject(param1:Mobject) : void
      {
         this._id = param1.getInteger("id");
         this._coord = Coord.fromArray(param1.getIntegerArray("coord"));
         this._blocked = param1.getBoolean("blockingHint");
      }
      
      private function isBlocking(param1:RoomSceneObject) : Boolean
      {
         return param1.blocks;
      }
      
      public function removeChild(param1:RoomSceneObject) : void
      {
         var _loc2_:int = this._children.indexOf(param1);
         if(_loc2_ === -1)
         {
            return Logger.getLogger("mambo").warning("SceneObject does not belong to this tile",param1);
         }
         this._children.splice(_loc2_,1);
      }
      
      public function get blockedByChildren() : Boolean
      {
         return any(this._children,this.isBlocking);
      }
      
      public function addChild(param1:RoomSceneObject) : void
      {
         ArrayUtil.removeElement(this._children,param1);
         this._children.push(param1);
      }
      
      public function activate(param1:UserAvatar) : void
      {
         var _loc2_:RoomSceneObject = null;
         for each(_loc2_ in this._children)
         {
            if(_loc2_ !== param1)
            {
               _loc2_.activate(param1);
            }
         }
      }
      
      public function dispose() : void
      {
         this._children = null;
         this._coord = null;
      }
      
      public function get coord() : Coord
      {
         return this._coord;
      }
      
      mambo function set blocked(param1:Boolean) : void
      {
         this._blocked = param1;
      }
      
      public function get blocked() : Boolean
      {
         return this._blocked;
      }
      
      public function get children() : Array
      {
         return this._children.concat();
      }
   }
}

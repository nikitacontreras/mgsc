package com.qb9.mambo.view.world.tiling
{
   import com.qb9.mambo.world.tiling.Tile;
   import flash.events.IEventDispatcher;
   
   public interface TileView extends IEventDispatcher
   {
       
      
      function set mouseEnabled(param1:Boolean) : void;
      
      function get mouseEnabled() : Boolean;
      
      function get tile() : Tile;
   }
}

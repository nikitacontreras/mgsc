package com.qb9.gaturro.editor.gui.modes
{
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.mambo.view.world.tiling.TileView;
   
   public interface GuiMode extends IDisposable
   {
       
      
      function press(param1:TileView) : void;
      
      function setup() : void;
      
      function release(param1:TileView) : void;
   }
}

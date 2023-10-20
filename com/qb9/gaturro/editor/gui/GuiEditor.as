package com.qb9.gaturro.editor.gui
{
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.gaturro.editor.NetActionManager;
   import com.qb9.gaturro.editor.gui.modes.BlockGuiMode;
   import com.qb9.gaturro.editor.gui.modes.DestroyGuiMode;
   import com.qb9.gaturro.editor.gui.modes.GuiMode;
   import com.qb9.gaturro.editor.gui.modes.MoveGuiMode;
   import com.qb9.mambo.view.world.tiling.TileView;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public final class GuiEditor implements IDisposable
   {
       
      
      private var mode:GuiMode;
      
      private var currentName:String;
      
      private var room:Sprite;
      
      private var actions:NetActionManager;
      
      public function GuiEditor(param1:Sprite, param2:NetActionManager)
      {
         super();
         this.room = param1;
         this.actions = param2;
      }
      
      private function doAction(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         var asset:TileView = this.getObject(e);
         if(!asset)
         {
            return;
         }
         try
         {
            if(e.type === MouseEvent.MOUSE_DOWN)
            {
               this.mode.press(asset);
            }
            else
            {
               this.mode.release(asset);
            }
            e.stopImmediatePropagation();
         }
         catch(err:Error)
         {
         }
      }
      
      protected function unbind() : void
      {
         this.room.removeEventListener(MouseEvent.MOUSE_DOWN,this.doAction);
         this.room.removeEventListener(MouseEvent.MOUSE_UP,this.doAction);
      }
      
      protected function clean() : void
      {
         this.unbind();
         if(this.mode)
         {
            this.mode.dispose();
         }
         this.mode = null;
      }
      
      protected function bind() : void
      {
         this.room.addEventListener(MouseEvent.MOUSE_DOWN,this.doAction);
         this.room.addEventListener(MouseEvent.MOUSE_UP,this.doAction);
      }
      
      private function getObject(param1:MouseEvent) : TileView
      {
         var _loc3_:DisplayObject = null;
         var _loc2_:Array = this.room.stage.getObjectsUnderPoint(new Point(param1.stageX,param1.stageY));
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_ is TileView)
            {
               return _loc3_ as TileView;
            }
         }
         return null;
      }
      
      public function setAction(param1:String = "") : void
      {
         if(param1 === this.currentName)
         {
            param1 = "";
         }
         this.clean();
         this.currentName = param1;
         switch(param1)
         {
            case "block":
               this.mode = new BlockGuiMode(this.actions);
               break;
            case "move":
               this.mode = new MoveGuiMode(this.actions);
               break;
            case "destroy":
               this.mode = new DestroyGuiMode(this.actions);
               break;
            default:
               return;
         }
         this.bind();
      }
      
      public function dispose() : void
      {
         this.clean();
         this.room = null;
         this.actions = null;
      }
   }
}

package com.qb9.gaturro.view.world.cursor
{
   import assets.MouseMove;
   import com.qb9.flashlib.geom.Direction;
   import com.qb9.flashlib.tasks.Task;
   import com.qb9.gaturro.globals.region;
   import flash.display.Sprite;
   import flash.ui.Mouse;
   
   public final class Cursor extends Task
   {
      
      public static const WALK:String = "walk";
      
      public static const DRAG:String = "drag";
      
      private static const FRONT_ALPHA:Number = 0.3;
      
      public static const ARROW:String = "pointer";
      
      public static const HAND:String = "hand";
       
      
      private var cursor2:MouseMove;
      
      private var container:Sprite;
      
      private var cursor1:MouseMove;
      
      public function Cursor(param1:Sprite)
      {
         super();
         this.container = param1;
      }
      
      private function createPointer(param1:int) : MouseMove
      {
         var _loc2_:MouseMove = new MouseMove();
         _loc2_.mouseChildren = false;
         _loc2_.mouseEnabled = false;
         this.container.addChildAt(_loc2_,param1);
         return _loc2_;
      }
      
      public function set visible(param1:Boolean) : void
      {
         if(param1 === this.visible)
         {
            return;
         }
         this.cursor1.visible = param1;
         if(param1)
         {
            Mouse.hide();
         }
         else
         {
            Mouse.show();
         }
         this.evalState();
      }
      
      public function get active() : Boolean
      {
         return this.cursor1 != null;
      }
      
      private function getArrowFrame(param1:int) : int
      {
         if(param1 & Direction.NORTH)
         {
            return 3;
         }
         if(param1 & Direction.SOUTH)
         {
            return 4;
         }
         if(param1 & Direction.WEST)
         {
            return 1;
         }
         if(param1 & Direction.EAST)
         {
            return 2;
         }
         if(param1 & Direction.UP)
         {
            return 5;
         }
         if(param1 & Direction.DOWN)
         {
            return 6;
         }
         return 1;
      }
      
      public function toArrow(param1:int, param2:String) : void
      {
         if(this.cursor1)
         {
            this.cursor1.gotoAndStop("arrow" + this.getArrowFrame(param1));
            region.setText(this.cursor1.label.field,param2.toUpperCase());
            this.cursor1.label.visible = true;
         }
         if(this.cursor2)
         {
            this.cursor2.visible = false;
         }
      }
      
      public function click() : void
      {
         if(this.cursor1.pointer)
         {
            this.cursor1.pointer.play();
         }
         if(this.cursor2.pointer)
         {
            this.cursor2.pointer.play();
         }
      }
      
      override public function update(param1:uint) : void
      {
         this.cursor1.x = this.cursor2.x = this.container.mouseX;
         this.cursor1.y = this.cursor2.y = this.container.mouseY;
         super.update(param1);
      }
      
      public function get visible() : Boolean
      {
         return this.cursor1.visible;
      }
      
      private function evalState() : void
      {
         this.cursor2.visible = this.visible;
         this.cursor1.alpha = this.pointer === WALK ? FRONT_ALPHA : 1;
      }
      
      override public function dispose() : void
      {
         this.container = null;
         this.visible = false;
         this.cursor2 = null;
         this.cursor1 = null;
         super.dispose();
      }
      
      public function get y() : int
      {
         return this.cursor1.y;
      }
      
      public function set pointer(param1:String) : void
      {
         if(param1 === this.pointer)
         {
            return;
         }
         this.cursor1.gotoAndStop(param1);
         this.cursor2.gotoAndStop(param1);
         this.cursor2.visible = true;
         this.cursor1.label.visible = false;
         this.evalState();
      }
      
      public function addCursors(param1:int, param2:int) : void
      {
         this.cursor1 = this.createPointer(param1);
         this.cursor2 = this.createPointer(param2);
         this.visible = false;
      }
      
      public function get pointer() : String
      {
         return this.cursor1.currentLabel;
      }
      
      public function get x() : int
      {
         return this.cursor1.x;
      }
   }
}

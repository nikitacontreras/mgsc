package com.qb9.flashlib.prototyping.shapes
{
   import com.qb9.flashlib.geom.Anchor;
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.flashlib.interfaces.IMoveable;
   import flash.display.Graphics;
   import flash.display.Sprite;
   
   public class BasicShape extends Sprite implements IMoveable, IDisposable
   {
      
      public static var defaultAnchor:Anchor = Anchor.topLeft;
       
      
      protected var config:com.qb9.flashlib.prototyping.shapes.BasicShapeConfig;
      
      protected var g:Graphics;
      
      protected var anchor:Anchor;
      
      public function BasicShape(param1:Object = null, param2:Anchor = null)
      {
         super();
         if(param1 === null)
         {
            param1 = -1;
         }
         if(param1 is Number)
         {
            param1 = new com.qb9.flashlib.prototyping.shapes.BasicShapeConfig(int(param1));
         }
         this.config = param1 as com.qb9.flashlib.prototyping.shapes.BasicShapeConfig;
         this.anchor = param2 || defaultAnchor;
         this.g = graphics;
         this.paint(param1.color);
      }
      
      protected function draw() : void
      {
      }
      
      public function paint(param1:int) : void
      {
         this.g.clear();
         if(param1 !== -1)
         {
            this.g.beginFill(param1,this.config.alpha);
         }
         else
         {
            this.g.beginFill(0,0);
         }
         if(this.config.borderWidth)
         {
            this.g.lineStyle(this.config.borderWidth,this.config.borderColor,this.config.borderAlpha);
         }
         this.draw();
         this.g.endFill();
      }
      
      public function dispose() : void
      {
         this.g = null;
         this.config = null;
         this.anchor = null;
      }
   }
}

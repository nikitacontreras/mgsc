package com.qb9.flashlib.prototyping.shapes
{
   import com.qb9.flashlib.geom.Anchor;
   
   public class Ellipse extends BasicShape
   {
       
      
      protected var rx:Number;
      
      protected var ry:Number;
      
      public function Ellipse(param1:Number, param2:Number, param3:Object = -1, param4:Anchor = null)
      {
         this.rx = param1;
         this.ry = param2;
         super(param3,param4);
      }
      
      override protected function draw() : void
      {
         g.drawEllipse(-anchor.u * 2 * this.rx,-anchor.v * 2 * this.ry,this.rx * 2,this.ry * 2);
      }
   }
}

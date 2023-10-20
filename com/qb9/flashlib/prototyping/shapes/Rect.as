package com.qb9.flashlib.prototyping.shapes
{
   import com.qb9.flashlib.geom.Anchor;
   
   public class Rect extends BasicShape
   {
       
      
      protected var h:Number;
      
      protected var w:Number;
      
      public function Rect(param1:Number, param2:Number, param3:Object = -1, param4:Anchor = null)
      {
         this.w = param1;
         this.h = param2;
         super(param3,param4);
      }
      
      override protected function draw() : void
      {
         g.drawRect(-this.w * anchor.u,-this.h * anchor.v,this.w,this.h);
      }
   }
}

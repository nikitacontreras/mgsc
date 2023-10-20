package com.qb9.flashlib.prototyping.shapes
{
   import com.qb9.flashlib.geom.Anchor;
   
   public class IsoscelesTriangle extends BasicShape
   {
       
      
      protected var h:Number;
      
      protected var b:Number;
      
      public function IsoscelesTriangle(param1:Number, param2:Number = NaN, param3:Object = -1, param4:Anchor = null)
      {
         this.b = param1;
         this.h = isNaN(param2) ? param1 : param2;
         super(param3,param4);
      }
      
      override protected function draw() : void
      {
         var _loc1_:Number = -anchor.u * this.b;
         var _loc2_:Number = -anchor.v * this.h;
         g.moveTo(0 + _loc1_,this.h + _loc2_);
         g.lineTo(this.b / 2 + _loc1_,0 + _loc2_);
         g.lineTo(this.b + _loc1_,this.h + _loc2_);
         g.lineTo(0 + _loc1_,this.h + _loc2_);
      }
   }
}

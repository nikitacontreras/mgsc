package com.qb9.flashlib.prototyping.shapes
{
   import com.qb9.flashlib.geom.Anchor;
   import com.qb9.flashlib.math.QMath;
   
   public class Parallelogram extends BasicShape
   {
       
      
      private var a:int;
      
      private var b:Number;
      
      private var h:Number;
      
      public function Parallelogram(param1:Number, param2:Number, param3:int = 45, param4:Object = -1, param5:Anchor = null)
      {
         this.b = param1;
         this.h = param2;
         this.a = param3;
         super(param4,param5);
      }
      
      override protected function draw() : void
      {
         var _loc1_:Number = this.h * Math.tan(QMath.deg2rad(this.a));
         var _loc2_:Number = this.b + _loc1_;
         var _loc3_:Number = -_loc2_ * anchor.u;
         var _loc4_:Number = -this.h * anchor.v;
         g.moveTo(_loc1_ + _loc3_,0 + _loc4_);
         g.lineTo(_loc2_ + _loc3_,0 + _loc4_);
         g.lineTo(this.b + _loc3_,this.h + _loc4_);
         g.lineTo(0 + _loc3_,this.h + _loc4_);
         g.lineTo(_loc1_ + _loc3_,0 + _loc4_);
      }
   }
}

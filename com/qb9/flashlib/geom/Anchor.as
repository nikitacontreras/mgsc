package com.qb9.flashlib.geom
{
   public class Anchor
   {
      
      public static const bottomRight:com.qb9.flashlib.geom.Anchor = make(1,1);
      
      public static const centerLeft:com.qb9.flashlib.geom.Anchor = make(0,0.5);
      
      public static const topRight:com.qb9.flashlib.geom.Anchor = make(1,0);
      
      public static const bottomCenter:com.qb9.flashlib.geom.Anchor = make(0.5,1);
      
      public static const topCenter:com.qb9.flashlib.geom.Anchor = make(0.5,0);
      
      public static const bottomLeft:com.qb9.flashlib.geom.Anchor = make(0,1);
      
      public static const center:com.qb9.flashlib.geom.Anchor = make(0.5,0.5);
      
      public static const centerRight:com.qb9.flashlib.geom.Anchor = make(1,0.5);
      
      public static const topLeft:com.qb9.flashlib.geom.Anchor = make(0,0);
       
      
      protected var _u:Number;
      
      protected var _v:Number;
      
      public function Anchor(param1:Number, param2:Number)
      {
         super();
         this._u = param1;
         this._v = param2;
      }
      
      private static function make(param1:Number, param2:Number) : com.qb9.flashlib.geom.Anchor
      {
         return new com.qb9.flashlib.geom.Anchor(param1,param2);
      }
      
      public function get u() : Number
      {
         return this._u;
      }
      
      public function get v() : Number
      {
         return this._v;
      }
   }
}

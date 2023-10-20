package com.qb9.gaturro.view.gui.iphone2.screens.snakegame
{
   import flash.display.Shape;
   
   public class SnakeElement extends Shape
   {
       
      
      protected var _direction:String;
      
      protected var _catchValue:Number;
      
      public function SnakeElement(param1:uint, param2:Number, param3:Number, param4:Number)
      {
         super();
         graphics.lineStyle(0,param1,param2);
         graphics.beginFill(param1,param2);
         graphics.drawRect(0,0,param3,param4);
         graphics.endFill();
         this._catchValue = 0;
      }
      
      public function get catchValue() : Number
      {
         return this._catchValue;
      }
      
      public function set catchValue(param1:Number) : void
      {
         this._catchValue = param1;
      }
      
      public function set direction(param1:String) : void
      {
         this._direction = param1;
      }
      
      public function get direction() : String
      {
         return this._direction;
      }
   }
}

package com.qb9.gaturro.view.camera
{
   import com.qb9.flashlib.tasks.Task;
   import flash.display.Sprite;
   import flash.errors.IllegalOperationError;
   import flash.geom.Point;
   
   public class AbstractCamera extends Task implements ICamera
   {
       
      
      protected var layers:Array;
      
      protected var roomDisplay:Sprite;
      
      protected var bounds:int;
      
      public function AbstractCamera(param1:Sprite, param2:Array, param3:int)
      {
         super();
         this.bounds = param3;
         this.layers = param2;
         this.roomDisplay = param1;
      }
      
      override public function update(param1:uint) : void
      {
         this.doMove(param1);
      }
      
      public function init() : void
      {
         throw new IllegalOperationError("This is an abstract method and should be implemented by the concrete class");
      }
      
      public function move(param1:Point) : void
      {
         throw new IllegalOperationError("This is an abstract method and should be implemented by the concrete class");
      }
      
      protected function doMove(param1:uint) : void
      {
         throw new IllegalOperationError("This is an abstract method and should be implemented by the concrete class");
      }
   }
}

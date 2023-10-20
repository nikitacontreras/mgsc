package com.qb9.gaturro.util
{
   import flash.display.Stage;
   import flash.geom.Rectangle;
   
   public class StageData extends Rectangle
   {
       
      
      private var stage:Stage;
      
      public function StageData(param1:Stage, param2:uint = 0, param3:uint = 0)
      {
         super(0,0,param2 || param1.stageWidth,param3 || param1.stageHeight);
         this.stage = param1;
      }
      
      public function set quality(param1:String) : void
      {
         this.stage.quality = param1;
      }
      
      public function set frameRate(param1:Number) : void
      {
         this.stage.frameRate = param1;
      }
      
      public function get frameRate() : Number
      {
         return this.stage.frameRate;
      }
      
      public function get quality() : String
      {
         return this.stage.quality.toLowerCase();
      }
   }
}

package com.qb9.flashlib.display
{
   import com.qb9.flashlib.tasks.ITask;
   import com.qb9.flashlib.tasks.Task;
   import com.qb9.flashlib.utils.DisplayUtil;
   import flash.display.MovieClip;
   
   public class PlayMovieClip extends Task
   {
       
      
      protected var delay:uint;
      
      protected var accumulator:uint;
      
      protected var mc:MovieClip;
      
      protected var _fps:Number;
      
      public var autoDispose:Boolean;
      
      protected var currentFrame:uint;
      
      public var remainingLoops:int;
      
      public function PlayMovieClip(param1:MovieClip, param2:Number = 0, param3:uint = 0, param4:Boolean = false)
      {
         super();
         this.remainingLoops = param3;
         this.mc = param1;
         this.autoDispose = param4;
         this.fps = param2 || param1.stage.frameRate;
      }
      
      override public function update(param1:uint) : void
      {
         super.update(param1);
         this.accumulator += param1;
         if(this.accumulator < this.delay)
         {
            return;
         }
         var _loc2_:uint = this.accumulator / this.delay;
         this.accumulator -= this.delay * _loc2_;
         this.currentFrame += _loc2_;
         this.updateLoops(this.currentFrame / this.mc.totalFrames);
         this.currentFrame %= this.mc.totalFrames;
         this.updateMC();
      }
      
      public function set fps(param1:Number) : void
      {
         this._fps = param1;
         this.delay = 1000 / Math.abs(param1);
      }
      
      private function updateLoops(param1:uint) : void
      {
         if(this.remainingLoops <= 0)
         {
            return;
         }
         this.remainingLoops -= param1;
         if(this.remainingLoops > 0)
         {
            return;
         }
         this.taskComplete();
         this.currentFrame = this.mc.totalFrames - 1;
      }
      
      override protected function taskComplete() : void
      {
         if(this.autoDispose)
         {
            DisplayUtil.dispose(this.mc);
         }
         super.taskComplete();
      }
      
      protected function updateMC() : void
      {
         this.mc.gotoAndStop(this._fps > 0 ? this.currentFrame + 1 : this.mc.totalFrames - this.currentFrame);
      }
      
      public function get movieClip() : MovieClip
      {
         return this.mc;
      }
      
      override public function start() : void
      {
         this.currentFrame = 0;
         this.updateMC();
         super.start();
      }
      
      override public function clone() : ITask
      {
         return new PlayMovieClip(this.mc,this._fps,this.remainingLoops,this.autoDispose);
      }
      
      public function get fps() : Number
      {
         return this._fps;
      }
   }
}

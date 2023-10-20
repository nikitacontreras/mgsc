package com.qb9.gaturro.view.components.banner.dressingRoom
{
   import com.qb9.flashlib.tasks.TaskRunner;
   import com.qb9.gaturro.view.components.canvas.FrameCanvas;
   import com.qb9.gaturro.view.gui.base.modal.AbstractCanvasFrameBanner;
   import com.qb9.gaturro.view.world.avatars.AvatarDresser;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   
   public class LoadingCanvas extends FrameCanvas
   {
       
      
      private var down:SimpleButton;
      
      private var task:TaskRunner;
      
      private var bot:MovieClip;
      
      private var dresser:AvatarDresser;
      
      private var costumes:Array;
      
      private var up:SimpleButton;
      
      private var action:MovieClip;
      
      public function LoadingCanvas(param1:String, param2:String, param3:DisplayObjectContainer, param4:AbstractCanvasFrameBanner)
      {
         this.costumes = [];
         super(param1,param2,param3,param4);
      }
      
      override protected function setupShowView() : void
      {
      }
   }
}

package com.qb9.gaturro.view.components.banner.dressingRoom
{
   import com.qb9.flashlib.tasks.TaskRunner;
   import com.qb9.gaturro.view.components.canvas.FrameCanvas;
   import com.qb9.gaturro.view.gui.base.modal.AbstractCanvasFrameBanner;
   import com.qb9.gaturro.view.world.avatars.AvatarDresser;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   
   public class PhotoCanvas extends FrameCanvas
   {
       
      
      private var dresser:AvatarDresser;
      
      private var task:TaskRunner;
      
      private var action:MovieClip;
      
      private var bot:MovieClip;
      
      public function PhotoCanvas(param1:String, param2:String, param3:DisplayObjectContainer, param4:AbstractCanvasFrameBanner)
      {
         super(param1,param2,param3,param4);
      }
      
      override public function show(param1:Object = null) : void
      {
         this.bot = param1 as MovieClip;
         this.view.addChild(this.bot);
      }
      
      override protected function setupShowView() : void
      {
         this.action = view.getChildByName("action") as MovieClip;
         this.action.field.text = "APLICAR";
      }
   }
}

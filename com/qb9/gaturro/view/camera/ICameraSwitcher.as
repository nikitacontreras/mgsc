package com.qb9.gaturro.view.camera
{
   import com.qb9.flashlib.tasks.TaskRunner;
   import flash.display.Sprite;
   
   public interface ICameraSwitcher extends ICamera
   {
       
      
      function pause() : void;
      
      function isPaused() : Boolean;
      
      function switchCamera(param1:String, param2:Sprite, param3:Array, param4:int, ... rest) : void;
      
      function set tasksRunner(param1:TaskRunner) : void;
      
      function resume() : void;
      
      function get currentCamera() : AbstractCamera;
   }
}

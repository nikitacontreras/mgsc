package com.qb9.gaturro.view.world.chat
{
   import com.qb9.flashlib.tasks.ITask;
   import flash.display.DisplayObject;
   
   public interface IChatBallon extends ITask
   {
       
      
      function removeBalloon() : void;
      
      function get owner() : DisplayObject;
   }
}

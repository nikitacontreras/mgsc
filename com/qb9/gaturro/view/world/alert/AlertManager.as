package com.qb9.gaturro.view.world.alert
{
   import assets.LoseSignalMC;
   import assets.WinSignalMC;
   import com.qb9.flashlib.display.PlayMovieClip;
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.flashlib.tasks.ITask;
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.globals.stageData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public final class AlertManager extends Sprite implements IDisposable
   {
       
      
      private var task:ITask;
      
      private var tasks:TaskContainer;
      
      public function AlertManager(param1:TaskContainer)
      {
         super();
         this.tasks = param1;
         mouseChildren = false;
         mouseEnabled = false;
      }
      
      public function bad(param1:String) : void
      {
         this.say(new LoseSignalMC(),param1);
      }
      
      private function disposeTask() : void
      {
         if(this.busy)
         {
            this.tasks.remove(this.task);
         }
         DisplayUtil.empty(this);
         this.task = null;
      }
      
      private function get busy() : Boolean
      {
         return !!this.task && this.task.running;
      }
      
      private function say(param1:MovieClip, param2:String) : void
      {
         this.disposeTask();
         region.setText(param1.textField,param2);
         addChild(param1);
         this.task = new PlayMovieClip(param1,stageData.frameRate,1,true);
         this.tasks.add(this.task);
      }
      
      public function good(param1:String) : void
      {
         this.say(new WinSignalMC(),param1);
      }
      
      public function dispose() : void
      {
         this.disposeTask();
         this.tasks = null;
      }
   }
}

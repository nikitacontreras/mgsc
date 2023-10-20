package com.qb9.gaturro.view.world.movement.impl
{
   import com.qb9.flashlib.tasks.Loop;
   import com.qb9.flashlib.tasks.Sequence;
   import com.qb9.flashlib.tasks.Task;
   import com.qb9.flashlib.tasks.Wait;
   import com.qb9.gaturro.view.world.avatars.GaturroAvatarView;
   import com.qb9.gaturro.view.world.movement.AbstractMovement;
   import flash.display.DisplayObject;
   
   public class AvatarActionMovement extends AbstractMovement
   {
       
      
      public function AvatarActionMovement(param1:String, param2:DisplayObject)
      {
         super(param1,param2);
      }
      
      override protected function buildTask() : Task
      {
         var _loc1_:Wait = new Wait(options.interval);
         var _loc2_:AvatarActionTask = new AvatarActionTask(GaturroAvatarView(target).avatar,options.actions);
         var _loc3_:Sequence = new Sequence(_loc1_,_loc2_);
         return new Loop(_loc3_);
      }
   }
}

import com.qb9.flashlib.tasks.ITask;
import com.qb9.flashlib.tasks.Task;
import com.qb9.gaturro.view.world.avatars.Gaturro;
import com.qb9.mambo.world.avatars.Avatar;

class AvatarActionTask extends Task
{
    
   
   private var target:Avatar;
   
   private var action:String;
   
   public function AvatarActionTask(param1:Avatar, param2:String)
   {
      super();
      this.action = param2;
      this.target = param1;
   }
   
   override public function start() : void
   {
      if(this.target.attributes)
      {
         this.target.attributes[Gaturro.ACTION_KEY] = this.action;
      }
      super.start();
      taskComplete();
   }
   
   override public function clone() : ITask
   {
      return new AvatarActionTask(this.target,this.action);
   }
}

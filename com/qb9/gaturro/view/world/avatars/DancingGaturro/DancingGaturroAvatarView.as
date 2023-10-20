package com.qb9.gaturro.view.world.avatars.DancingGaturro
{
   import com.qb9.flashlib.math.Random;
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.gaturro.view.world.avatars.GaturroAvatarView;
   import com.qb9.gaturro.view.world.elements.behaviors.NamedView;
   import com.qb9.mambo.view.world.util.TwoWayLink;
   import com.qb9.mambo.world.avatars.Avatar;
   
   public class DancingGaturroAvatarView extends GaturroAvatarView implements NamedView
   {
       
      
      public function DancingGaturroAvatarView(param1:Avatar, param2:TaskContainer, param3:TwoWayLink, param4:TwoWayLink)
      {
         super(param1,param2,param3,param4);
      }
      
      override protected function stopMoving() : void
      {
         var _loc1_:int = Random.randint(2,5);
         clip.randomDance();
      }
   }
}

package com.qb9.gaturro.view.world.avatars.SwimmingTiledGaturro
{
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.gaturro.view.world.avatars.GaturroAvatarView;
   import com.qb9.gaturro.view.world.elements.behaviors.NamedView;
   import com.qb9.mambo.view.world.util.TwoWayLink;
   import com.qb9.mambo.world.avatars.Avatar;
   
   public class SwimmingGaturroAvatarView extends GaturroAvatarView implements NamedView
   {
       
      
      public var floor_water:Boolean = false;
      
      public function SwimmingGaturroAvatarView(param1:Avatar, param2:TaskContainer, param3:TwoWayLink, param4:TwoWayLink)
      {
         super(param1,param2,param3,param4);
      }
      
      override protected function stopMoving() : void
      {
         super.stopMoving();
         if(this.floor_water)
         {
            clip.floatar();
         }
         else
         {
            clip.stand();
         }
      }
      
      override protected function startMoving() : void
      {
         super.startMoving();
         if(notWalking)
         {
            return;
         }
         if(this.floor_water)
         {
            clip.swim();
         }
         else
         {
            clip.walk();
         }
      }
   }
}

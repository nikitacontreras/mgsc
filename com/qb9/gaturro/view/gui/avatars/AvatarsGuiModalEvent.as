package com.qb9.gaturro.view.gui.avatars
{
   import com.qb9.gaturro.view.world.avatars.GaturroAvatarView;
   import flash.events.Event;
   
   public final class AvatarsGuiModalEvent extends Event
   {
      
      public static const OPEN:String = "agmeOpenAvatars";
       
      
      public function AvatarsGuiModalEvent(param1:String)
      {
         super(param1,true);
      }
      
      public function get avatar() : GaturroAvatarView
      {
         return target as GaturroAvatarView;
      }
      
      override public function clone() : Event
      {
         return new AvatarsGuiModalEvent(type);
      }
   }
}

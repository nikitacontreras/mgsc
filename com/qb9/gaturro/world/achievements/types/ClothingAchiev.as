package com.qb9.gaturro.world.achievements.types
{
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.mambo.core.attributes.CustomAttributes;
   import com.qb9.mambo.core.attributes.events.CustomAttributesEvent;
   import flash.utils.setTimeout;
   
   public class ClothingAchiev extends Achievement
   {
       
      
      protected var clothData:Object;
      
      public function ClothingAchiev(param1:Object)
      {
         super(param1);
         this.clothData = param1.data;
      }
      
      override public function init(param1:String, param2:Boolean) : void
      {
         super.init(param1,param2);
         if(param1 == Achievement.ACHIEVEMENT_SUCCESS)
         {
            achieved = true;
         }
      }
      
      override public function changeRoom(param1:GaturroRoom) : void
      {
         this.deactivate();
         super.changeRoom(param1);
         this.activate();
      }
      
      override protected function activate() : void
      {
         if(!monitor)
         {
            return;
         }
         if(!room || !room.userAvatar)
         {
            return;
         }
         room.userAvatar.addEventListener(CustomAttributesEvent.CHANGED,this.checkAction);
      }
      
      override protected function deactivate() : void
      {
         if(!room || !room.userAvatar)
         {
            return;
         }
         room.userAvatar.removeEventListener(CustomAttributesEvent.CHANGED,this.checkAction);
      }
      
      protected function checkAction(param1:CustomAttributesEvent) : void
      {
         var _loc4_:String = null;
         if(!room)
         {
            return;
         }
         if(!room.userAvatar)
         {
            return;
         }
         var _loc2_:CustomAttributes = room.userAvatar.attributes;
         var _loc3_:Boolean = true;
         for(_loc4_ in this.clothData)
         {
            if(_loc2_[_loc4_] != this.clothData[_loc4_])
            {
               _loc3_ = false;
            }
         }
         if(_loc3_)
         {
            this.deactivate();
            setTimeout(achieve,3000);
         }
      }
   }
}

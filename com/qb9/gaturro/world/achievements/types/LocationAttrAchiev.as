package com.qb9.gaturro.world.achievements.types
{
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.net;
   import com.qb9.mambo.net.manager.NetworkManagerEvent;
   import flash.utils.setTimeout;
   
   public class LocationAttrAchiev extends Achievement
   {
       
      
      public function LocationAttrAchiev(param1:Object)
      {
         super(param1);
      }
      
      override public function init(param1:String, param2:Boolean) : void
      {
         super.init(param1,param2);
         if(param1 == Achievement.ACHIEVEMENT_SUCCESS)
         {
            achieved = true;
         }
         else
         {
            this.activate();
         }
      }
      
      override protected function activate() : void
      {
         if(!monitor)
         {
            return;
         }
         net.addEventListener(NetworkManagerEvent.UNIQUE_ACTION_SENT,this.roomVisited);
      }
      
      override protected function deactivate() : void
      {
         net.removeEventListener(NetworkManagerEvent.UNIQUE_ACTION_SENT,this.roomVisited);
      }
      
      private function ckeck() : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         if(!api)
         {
            return;
         }
         var _loc1_:Boolean = true;
         for(_loc2_ in dataObj)
         {
            _loc3_ = String(dataObj[_loc2_]);
            if(!(_loc2_ in api.room.attributes))
            {
               _loc1_ = false;
               break;
            }
            if(_loc2_ == "partyOwner")
            {
               if(_loc3_ == "{user}")
               {
                  if(String(api.room.attributes[_loc2_]) != api.userAvatar.username)
                  {
                     _loc1_ = false;
                     break;
                  }
               }
               else if(_loc3_ == "{no-user}")
               {
                  if(String(api.room.attributes[_loc2_]) == api.userAvatar.username)
                  {
                     _loc1_ = false;
                     break;
                  }
               }
            }
            else if(String(api.room.attributes[_loc2_]) != _loc3_)
            {
               _loc1_ = false;
               break;
            }
         }
         if(_loc1_)
         {
            setTimeout(achieve,500);
         }
      }
      
      override public function dispose() : void
      {
         this.deactivate();
         super.dispose();
      }
      
      private function roomVisited(param1:NetworkManagerEvent) : void
      {
         var _loc2_:String = param1.mobject.getString("request");
         if(_loc2_ != "ChangeRoomActionRequest")
         {
            return;
         }
         setTimeout(this.ckeck,4000);
      }
   }
}

package com.qb9.gaturro.world.achievements.types
{
   import com.qb9.flashlib.utils.ArrayUtil;
   import com.qb9.gaturro.globals.net;
   import com.qb9.mambo.net.manager.NetworkManagerEvent;
   import flash.utils.setTimeout;
   
   public class VisitingRoomsAchiev extends Achievement
   {
       
      
      protected var roomsVisited:Array;
      
      protected var roomsNeeds:Array;
      
      public function VisitingRoomsAchiev(param1:Object)
      {
         this.roomsNeeds = new Array();
         this.roomsVisited = new Array();
         super(param1);
         this.roomsNeeds = String(param1.data.rooms).split(";");
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
            if(param1 != "")
            {
               this.roomsVisited = param1.split(";");
            }
            this.activate();
         }
      }
      
      override public function dispose() : void
      {
         this.deactivate();
         super.dispose();
      }
      
      private function serialize(param1:Array) : String
      {
         var _loc3_:String = null;
         var _loc2_:String = "";
         for each(_loc3_ in param1)
         {
            _loc2_ += _loc3_ + ";";
         }
         return _loc2_.substr(0,_loc2_.length - 1);
      }
      
      private function isComplete() : Boolean
      {
         var _loc1_:String = null;
         for each(_loc1_ in this.roomsNeeds)
         {
            if(ArrayUtil.contains(this.roomsVisited,_loc1_) == false)
            {
               return false;
            }
         }
         return true;
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
      
      private function roomVisited(param1:NetworkManagerEvent) : void
      {
         var _loc4_:Boolean = false;
         var _loc2_:String = param1.mobject.getString("request");
         if(_loc2_ != "ChangeRoomActionRequest")
         {
            return;
         }
         var _loc3_:String = param1.mobject.getInteger("roomId").toString();
         if(ArrayUtil.contains(this.roomsNeeds,_loc3_) == false)
         {
            return;
         }
         if(ArrayUtil.contains(this.roomsVisited,_loc3_) == false)
         {
            this.roomsVisited.push(_loc3_);
            if(_loc4_ = this.isComplete())
            {
               setTimeout(achieve,4000);
            }
            else
            {
               save(this.serialize(this.roomsVisited));
            }
         }
      }
   }
}

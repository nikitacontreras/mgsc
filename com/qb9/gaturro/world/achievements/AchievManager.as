package com.qb9.gaturro.world.achievements
{
   import com.qb9.flashlib.events.QEvent;
   import com.qb9.gaturro.globals.*;
   import com.qb9.gaturro.socialnet.SocialNet;
   import com.qb9.gaturro.socialnet.messages.SocialNetMessage;
   import com.qb9.gaturro.world.achievements.service.AchievConnection;
   import com.qb9.gaturro.world.achievements.types.Achievement;
   import com.qb9.gaturro.world.achievements.types.ThrowableAchiev;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class AchievManager extends EventDispatcher
   {
       
      
      public const NEW_ACHIEVEMENT_REACHED:String = "NEW_ACHIEVEMENT_REACHED";
      
      private var friendAchievData:com.qb9.gaturro.world.achievements.AchievData;
      
      private var room:GaturroRoom;
      
      private var myAchievData:com.qb9.gaturro.world.achievements.AchievData;
      
      public function AchievManager()
      {
         super();
      }
      
      public function achieveNow(param1:String) : void
      {
         var _loc2_:Achievement = null;
         for each(_loc2_ in this.myAchievData.achievementList)
         {
            if(_loc2_ is ThrowableAchiev && _loc2_.keyId == param1)
            {
               ThrowableAchiev(_loc2_).achieveNow();
            }
         }
      }
      
      protected function saveData(param1:QEvent) : void
      {
         var _loc2_:String = String(param1.data.key);
         var _loc3_:String = String(param1.data.value);
         var _loc4_:Boolean = Boolean(param1.data.mustCelebrate);
         var _loc5_:Function = _loc3_ == Achievement.ACHIEVEMENT_SUCCESS ? (_loc4_ ? this.achievWithCelebrate : this.achievWithoutCelebrate) : this.saveDataCallback;
         var _loc6_:AchievConnection;
         (_loc6_ = new AchievConnection(_loc5_,_loc5_)).saveData(user.username,_loc2_,_loc3_);
         logger.debug("Achievement save data --> " + _loc2_ + " -> " + _loc3_);
      }
      
      public function getFriendAchiev(param1:String, param2:Number) : void
      {
         if(!settings.achievements || !settings.services.achievements.enabled)
         {
            return;
         }
         var _loc3_:AchievConnection = new AchievConnection(this.create,this.serviceError);
         _loc3_.getAllData(param1,param2);
         this.friendAchievData = null;
      }
      
      private function createAchievs(param1:com.qb9.gaturro.world.achievements.AchievData, param2:Object, param3:Boolean) : void
      {
         var _loc5_:Object = null;
         var _loc6_:Achievement = null;
         var _loc4_:AchievFactory = new AchievFactory();
         for each(_loc5_ in settings.achievements.list)
         {
            if(_loc6_ = _loc4_.createAchiev(_loc5_,param2,param3))
            {
               param1.achievementList.push(_loc6_);
               _loc6_.addEventListener(Achievement.ACHIEVE_SAVE_EVENT,this.saveData);
               this.checkInitialStatus(_loc6_);
            }
         }
         this.logAchievementStats(param1,param2);
      }
      
      public function init() : void
      {
         if(!settings.achievements || !settings.services.achievements.enabled)
         {
            return;
         }
         var _loc1_:AchievConnection = new AchievConnection(this.create,this.serviceError);
         _loc1_.getAllData(user.username,user.id);
      }
      
      private function achieve() : void
      {
         audio.addLazyPlay("win");
         if(this.room)
         {
            this.room.userAvatar.attributes.action = "celebrate";
         }
         this.dispatchEvent(new Event(this.NEW_ACHIEVEMENT_REACHED));
      }
      
      protected function achievWithoutCelebrate(param1:String, param2:Object) : void
      {
         this.confirmAchiev(param1,param2);
      }
      
      private function logAchievementStats(param1:com.qb9.gaturro.world.achievements.AchievData, param2:Object) : void
      {
         var _loc4_:String = null;
         var _loc3_:String = "";
         for(_loc4_ in param2)
         {
            _loc3_ += _loc4_ + ":" + param2[_loc4_] + ";";
         }
         logger.debug("Achievements stats received for " + param1.username + " --> " + _loc3_);
      }
      
      private function serviceError(param1:String, param2:Object) : void
      {
         if(user.username == param1)
         {
            this.myAchievData = new com.qb9.gaturro.world.achievements.AchievData(param1);
         }
         else
         {
            this.friendAchievData = new com.qb9.gaturro.world.achievements.AchievData(param1);
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:Achievement = null;
         if(this.myAchievData)
         {
            for each(_loc1_ in this.myAchievData.achievementList)
            {
               _loc1_.removeEventListener(Achievement.ACHIEVE_SAVE_EVENT,this.saveData);
               _loc1_.dispose();
            }
         }
         this.myAchievData = null;
         _loc1_ = null;
         this.room = null;
      }
      
      public function getList(param1:String) : Array
      {
         var _loc2_:Boolean = user.username == param1 ? false : true;
         if(_loc2_)
         {
            if(this.friendAchievData)
            {
               return this.friendAchievData.achievementList;
            }
         }
         else if(this.myAchievData)
         {
            return this.myAchievData.achievementList;
         }
         return null;
      }
      
      public function changeRoom(param1:GaturroRoom) : void
      {
         var _loc2_:Achievement = null;
         if(!this.myAchievData)
         {
            return;
         }
         this.room = param1;
         for each(_loc2_ in this.myAchievData.achievementList)
         {
            _loc2_.changeRoom(this.room);
         }
      }
      
      protected function saveDataCallback(param1:String, param2:Object) : void
      {
      }
      
      protected function achievWithCelebrate(param1:String, param2:Object) : void
      {
         var _loc3_:String = null;
         var _loc4_:Object = null;
         var _loc5_:String = null;
         var _loc6_:SocialNetMessage = null;
         this.confirmAchiev(param1,param2);
         this.achieve();
         if(socialNet.enabled)
         {
            _loc3_ = String(param2.key);
            for each(_loc4_ in settings.achievements.list)
            {
               if(_loc4_.key == _loc3_)
               {
                  _loc5_ = region.getText("HE CONSEGUIDO EL SIGUIENTE LOGRO:") + " " + region.getText(_loc4_.title).toUpperCase();
                  _loc6_ = SocialNet.getAchievMessage(_loc5_);
                  socialNet.sendMessage(_loc6_);
                  break;
               }
            }
         }
      }
      
      private function checkInitialStatus(param1:Achievement) : void
      {
         if(param1.keyId == "tutorialDone" && !param1.isAchieved())
         {
            if(user.attributes.sessionCount > 3)
            {
               ThrowableAchiev(param1).achieveNow(false);
            }
         }
      }
      
      protected function confirmAchiev(param1:String, param2:Object) : void
      {
         var _loc3_:Achievement = null;
         if(param2.success)
         {
            _loc3_ = this.myAchievData.achievByKey(param2.key);
            if(_loc3_)
            {
               _loc3_.confirmAchiev();
            }
         }
      }
      
      public function getLoaded(param1:String) : Boolean
      {
         var _loc2_:Boolean = user.username == param1 ? false : true;
         if(_loc2_)
         {
            if(this.friendAchievData)
            {
               return true;
            }
         }
         else if(this.myAchievData)
         {
            return true;
         }
         return false;
      }
      
      private function create(param1:String, param2:Object) : void
      {
         var _loc4_:com.qb9.gaturro.world.achievements.AchievData = null;
         var _loc3_:Boolean = user.username == param1 ? false : true;
         if(_loc3_)
         {
            this.friendAchievData = new com.qb9.gaturro.world.achievements.AchievData(param1);
            _loc4_ = this.friendAchievData;
         }
         else
         {
            this.myAchievData = new com.qb9.gaturro.world.achievements.AchievData(param1);
            _loc4_ = this.myAchievData;
         }
         this.createAchievs(_loc4_,param2,!_loc3_);
      }
   }
}

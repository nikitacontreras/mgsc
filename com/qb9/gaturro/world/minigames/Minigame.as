package com.qb9.gaturro.world.minigames
{
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.globals.tracker;
   import com.qb9.gaturro.net.metrics.Telemetry;
   import com.qb9.gaturro.net.metrics.TrackActions;
   import com.qb9.gaturro.net.metrics.TrackCategories;
   import com.qb9.gaturro.world.minigames.events.MinigameEvent;
   import com.qb9.gaturro.world.minigames.rewards.MinigameReward;
   import com.qb9.gaturro.world.minigames.rewards.inventory.InventoryMinigameReward;
   import com.qb9.gaturro.world.minigames.rewards.items.ItemMinigameReward;
   import com.qb9.gaturro.world.minigames.rewards.none.NullMinigameReward;
   import com.qb9.gaturro.world.minigames.rewards.points.PointsMinigameReward;
   import com.qb9.mambo.core.objects.MamboObject;
   import com.qb9.mambo.world.core.events.GeneralEvent;
   
   public class Minigame extends MamboObject
   {
       
      
      private var _rewards:Array;
      
      private var _name:String;
      
      private var _active:Boolean = false;
      
      private var _userData:com.qb9.gaturro.world.minigames.MinigameUserData;
      
      private var _roomId:int;
      
      public function Minigame(param1:String, param2:com.qb9.gaturro.world.minigames.MinigameUserData, param3:int)
      {
         this._rewards = [];
         super();
         this._name = param1;
         this._userData = param2;
         this._roomId = param3;
      }
      
      public function started() : void
      {
         info("Minigame",this.name,"Started");
         tracker.page(TrackActions.INTO_GAME,this.name);
         Telemetry.getInstance().trackScreen("minigame:" + this.name);
         this._active = true;
         this.dispatch(MinigameEvent.STARTED);
      }
      
      public function get rewards() : Array
      {
         return this._rewards.concat();
      }
      
      public function get active() : Boolean
      {
         return this._active;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      override public function dispose() : void
      {
         dispatchEvent(new GeneralEvent(GeneralEvent.DISPOSED));
         this._rewards = null;
         super.dispose();
      }
      
      public function addReward(param1:Object) : void
      {
         var _loc2_:MinigameReward = this.makeReward(param1);
         info("Adding reward for minigame",this.name,"message was:","\"" + _loc2_.message + "\"");
         this._rewards.push(_loc2_);
      }
      
      public function finished() : void
      {
         info("Minigame",this.name,"finished");
         this._active = false;
         this.dispatch(MinigameEvent.FINISHED);
      }
      
      public function get roomId() : int
      {
         return this._roomId;
      }
      
      private function makePointReward(param1:int, param2:Number) : PointsMinigameReward
      {
         if(param2 <= 0)
         {
            param2 = param1;
         }
         tracker.event(TrackCategories.GAMES,TrackActions.EARNS_POINTS,this.name,param1);
         return new PointsMinigameReward(this.name,param1,param2);
      }
      
      final override public function dispatch(param1:String, param2:* = null) : Boolean
      {
         return dispatchEvent(new MinigameEvent(param1,param2));
      }
      
      public function get userData() : com.qb9.gaturro.world.minigames.MinigameUserData
      {
         return this._userData;
      }
      
      private function makeReward(param1:Object) : MinigameReward
      {
         if(!param1)
         {
            return new NullMinigameReward();
         }
         if(param1 is String)
         {
            return this.makeRewardFromString(param1 as String);
         }
         if(Boolean(param1.reward) && param1.reward is String)
         {
            return this.makeRewardFromString(param1.reward as String);
         }
         if(param1 is Number)
         {
            return this.makePointReward(int(param1),int(param1));
         }
         if(param1 && param1 is Object && "reward" in param1 && param1.reward > 0)
         {
            return this.makePointReward(param1.reward,"sessionScore" in param1 ? Number(param1.sessionScore) : 0);
         }
         if(Boolean(param1.reward) && param1.reward is Number)
         {
            return this.makePointReward(int(param1.reward),int(param1));
         }
         return new NullMinigameReward();
      }
      
      private function makeRewardFromString(param1:String) : MinigameReward
      {
         var _loc2_:Array = param1.split("_");
         if(_loc2_.length == 1)
         {
            return new ItemMinigameReward(param1);
         }
         if(_loc2_[0] != "inventory" || _loc2_.length != 3)
         {
            logger.warning("Unknown inventory item reward string,",param1);
            return new NullMinigameReward();
         }
         return new InventoryMinigameReward(_loc2_[1],_loc2_[2]);
      }
   }
}

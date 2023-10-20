package com.qb9.gaturro.world.minigames.rewards
{
   import com.qb9.flashlib.events.QEventDispatcher;
   import com.qb9.flashlib.lang.foreach;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.globals.tracker;
   import com.qb9.gaturro.net.GaturroNetResponses;
   import com.qb9.gaturro.net.metrics.TrackActions;
   import com.qb9.gaturro.net.metrics.TrackCategories;
   import com.qb9.gaturro.net.requests.npc.ScoreActionRequest;
   import com.qb9.gaturro.world.minigames.rewards.inventory.InventoryMinigameReward;
   import com.qb9.gaturro.world.minigames.rewards.inventory.events.InventoryRewardEvent;
   import com.qb9.gaturro.world.minigames.rewards.items.ItemMinigameReward;
   import com.qb9.gaturro.world.minigames.rewards.items.events.ItemRewardEvent;
   import com.qb9.gaturro.world.minigames.rewards.none.NullMinigameReward;
   import com.qb9.gaturro.world.minigames.rewards.none.events.NullRewardEvent;
   import com.qb9.gaturro.world.minigames.rewards.points.GameMinigameReward;
   import com.qb9.gaturro.world.minigames.rewards.points.PointsMinigameReward;
   import com.qb9.gaturro.world.minigames.rewards.points.events.GameRewardEvent;
   import com.qb9.mambo.net.manager.NetworkManager;
   import com.qb9.mambo.net.manager.NetworkManagerEvent;
   
   public final class RewardManager extends QEventDispatcher
   {
      
      public static const LAST_REWARD:String = "lastReward";
       
      
      private var lastReward:PointsMinigameReward;
      
      private var queue:Array;
      
      private var net:NetworkManager;
      
      public function RewardManager(param1:NetworkManager)
      {
         this.queue = [];
         super();
         this.net = param1;
         this.init();
      }
      
      private function giveReward(param1:MinigameReward) : void
      {
         if(param1 is InventoryMinigameReward)
         {
            this.parseInventoryReward(param1 as InventoryMinigameReward);
         }
         if(param1 is ItemMinigameReward)
         {
            this.parseItemReward(param1 as ItemMinigameReward);
         }
         if(param1 is PointsMinigameReward)
         {
            this.parsePointsReward(param1 as PointsMinigameReward);
         }
         if(param1 is NullMinigameReward)
         {
            this.parseNullReward(param1 as NullMinigameReward);
         }
      }
      
      public function add(param1:MinigameReward) : void
      {
         var _loc2_:MinigameReward = null;
         for each(_loc2_ in this.queue)
         {
            if(_loc2_.canMergeWith(param1))
            {
               _loc2_.merge(param1);
               return;
            }
         }
         this.queue.push(param1);
      }
      
      private function feriaGameReward(param1:PointsMinigameReward) : void
      {
         var _loc2_:GameMinigameReward = new GameMinigameReward(param1.points / 3,param1.game,param1.sessionScore,false);
         dispatchEvent(new GameRewardEvent(GameRewardEvent.AWARDED,_loc2_));
      }
      
      private function info(... rest) : void
      {
         rest.unshift("RewardManager >");
         logger.info.apply(logger,rest);
      }
      
      private function navidadGameReward(param1:PointsMinigameReward) : void
      {
         var _loc2_:GameMinigameReward = new GameMinigameReward(param1.points,param1.game,param1.sessionScore,false);
         dispatchEvent(new GameRewardEvent(GameRewardEvent.AWARDED_NAVIDAD,_loc2_));
      }
      
      private function parseNullReward(param1:NullMinigameReward) : void
      {
         this.info("Got no reward");
         dispatchEvent(new NullRewardEvent(NullRewardEvent.AWARDED,param1));
      }
      
      private function parsePointsReward(param1:PointsMinigameReward) : void
      {
         this.info("Acquired",param1.points,"points from game",param1.game);
         this.info("Acquired",param1.sessionScore,"session score from game",param1.game);
         if(api.isTypeGame(param1.game,"feria"))
         {
            this.feriaGameReward(param1);
         }
         else if(api.isTypeGame(param1.game,"halloween2017"))
         {
            this.halloweenGameReward(param1);
         }
         else if(api.isTypeGame(param1.game,"navidad2017"))
         {
            this.navidadGameReward(param1);
         }
         else if(api.isTypeGame(param1.game,"reyes2018"))
         {
            this.reyesGameReward(param1);
         }
         else
         {
            this.net.sendAction(new ScoreActionRequest(param1.points,param1.sessionScore,param1.game));
         }
         this.lastReward = param1;
      }
      
      private function halloweenGameReward(param1:PointsMinigameReward) : void
      {
         var _loc2_:GameMinigameReward = new GameMinigameReward(param1.points,param1.game,param1.sessionScore,false);
         dispatchEvent(new GameRewardEvent(GameRewardEvent.AWARDED_HALLOWEEN,_loc2_));
      }
      
      private function init() : void
      {
         this.net.addEventListener(GaturroNetResponses.MINIGAME_SCORE,this.acquireCoins);
      }
      
      private function parseItemReward(param1:ItemMinigameReward) : void
      {
         this.info("Acquired a",param1.itemName);
         dispatchEvent(new ItemRewardEvent(ItemRewardEvent.AWARDED,param1));
      }
      
      override public function dispose() : void
      {
         this.net.removeEventListener(GaturroNetResponses.MINIGAME_SCORE,this.acquireCoins);
         this.net = null;
         this.queue = null;
         super.dispose();
      }
      
      public function parseRewards() : void
      {
         foreach(this.queue,this.giveReward);
         this.queue.length = 0;
      }
      
      private function acquireCoins(param1:NetworkManagerEvent) : void
      {
         this.info("Score Action Response Received");
         var _loc2_:uint = param1.mobject.getInteger("coins");
         var _loc3_:String = param1.mobject.getString("game");
         var _loc4_:Number = 0;
         var _loc5_:Boolean = false;
         if(this.lastReward)
         {
            _loc4_ = this.lastReward.sessionScore;
            if(param1.mobject.getBoolean("betterScore"))
            {
               _loc5_ = true;
            }
         }
         var _loc6_:GameMinigameReward = new GameMinigameReward(_loc2_,_loc3_,_loc4_,_loc5_);
         this.info("Acquired",_loc2_,"coins by playing",_loc3_);
         tracker.event(TrackCategories.GAMES,TrackActions.EARNS_COINS,_loc3_,_loc2_);
         dispatchEvent(new GameRewardEvent(GameRewardEvent.AWARDED,_loc6_));
      }
      
      private function reyesGameReward(param1:PointsMinigameReward) : void
      {
         var _loc2_:GameMinigameReward = new GameMinigameReward(param1.points,param1.game,param1.sessionScore,false);
         dispatchEvent(new GameRewardEvent(GameRewardEvent.AWARDED_REYES,_loc2_));
      }
      
      private function parseInventoryReward(param1:InventoryMinigameReward) : void
      {
         this.info("Acquired an inventory item:",param1.itemName);
         dispatchEvent(new InventoryRewardEvent(InventoryRewardEvent.AWARDED,param1));
      }
   }
}

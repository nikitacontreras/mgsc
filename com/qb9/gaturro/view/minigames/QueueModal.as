package com.qb9.gaturro.view.minigames
{
   import assets.QueueMC;
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.flashlib.utils.StringUtil;
   import com.qb9.gaturro.globals.libs;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.globals.net;
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.globals.tracker;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.net.metrics.TrackActions;
   import com.qb9.gaturro.net.metrics.TrackCategories;
   import com.qb9.mambo.queue.ServerLoginData;
   import com.qb9.mambo.queue.WaitingQueue;
   import com.qb9.mambo.queue.WaitingQueueEvent;
   import com.qb9.mambo.view.MamboView;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.clearInterval;
   import flash.utils.clearTimeout;
   import flash.utils.setInterval;
   import flash.utils.setTimeout;
   
   public final class QueueModal extends MamboView
   {
      
      private static const THUMBS_PACK:String = "queues";
      
      private static const MARGIN:uint = 2;
       
      
      private var timerId:int;
      
      private var singlePlayer:String;
      
      private var queue:WaitingQueue;
      
      private var timeout:int;
      
      private var asset:QueueMC;
      
      public function QueueModal(param1:String, param2:String, param3:Number)
      {
         super();
         this.singlePlayer = param2;
         this.queue = new WaitingQueue(net,user,param3,param1);
         this.init();
      }
      
      private function get seconds() : uint
      {
         return parseInt(this.asset.seconds.text,10);
      }
      
      private function get users() : Array
      {
         return DisplayUtil.children(this.ph);
      }
      
      private function startSinglePlayer(param1:Event) : void
      {
         dispatchEvent(new QueueModalEvent(QueueModalEvent.SINGLE_PLAYER,this.singlePlayer));
      }
      
      private function init() : void
      {
         this.asset = new QueueMC();
         addChild(this.asset);
         libs.fetch(THUMBS_PACK + "." + this.queue.name + "_so",this.addThumb);
         if(this.singlePlayer)
         {
            this.initSingle();
         }
         else
         {
            this.initQueue();
         }
      }
      
      private function unsubscribe() : void
      {
         if(!this.queue.subscribed)
         {
            return;
         }
         this.queue.unsubscribe();
         tracker.event(TrackCategories.GAMES,TrackActions.LEAVES_QUEUE,this.queue.name);
      }
      
      private function stepTimer() : void
      {
         --this.seconds;
         if(this.seconds === 0)
         {
            this.cleanTimer();
         }
      }
      
      private function initQueueEvents() : void
      {
         this.queue.addEventListener(WaitingQueueEvent.CREATED,this.resetTimer);
         this.queue.addEventListener(WaitingQueueEvent.ADDED,this.resetTimer);
         this.queue.addEventListener(WaitingQueueEvent.REMOVED,this.resetTimer);
         this.queue.addEventListener(WaitingQueueEvent.CREATED,this.redraw);
         this.queue.addEventListener(WaitingQueueEvent.CHANGED,this.redraw);
         this.queue.addEventListener(WaitingQueueEvent.CANCELLED,this.close);
         this.queue.addEventListener(WaitingQueueEvent.READY,this.startGame);
      }
      
      override public function dispose() : void
      {
         clearTimeout(this.timeout);
         if(this.queue)
         {
            this.unsubscribe();
            this.queue.dispose();
         }
         this.queue = null;
         this.asset.close.removeEventListener(MouseEvent.MOUSE_UP,this.tryToClose);
         this.asset.close.removeEventListener(MouseEvent.MOUSE_UP,this.close);
         this.asset = null;
         DisplayUtil.remove(this);
         this.cleanTimer();
         super.dispose();
      }
      
      private function tryToClose(param1:Event) : void
      {
         this.unsubscribe();
         param1.stopImmediatePropagation();
      }
      
      private function close(param1:Event = null) : void
      {
         dispatchEvent(new Event(Event.CLOSE));
      }
      
      private function initQueue(param1:Event = null) : void
      {
         this.asset.close.removeEventListener(MouseEvent.MOUSE_UP,this.close);
         this.asset.close.addEventListener(MouseEvent.MOUSE_UP,this.tryToClose);
         this.queue.subscribe();
         this.initQueueEvents();
         this.asset.gotoAndStop(1);
         tracker.event(TrackCategories.GAMES,TrackActions.JOIN_QUEUE,this.queue.name);
      }
      
      private function force() : void
      {
         this.queue.forceStart();
      }
      
      private function startGame(param1:WaitingQueueEvent) : void
      {
         var _loc2_:ServerLoginData = param1.login;
         tracker.event(TrackCategories.GAMES,TrackActions.STARTS_QUEUE,this.queue.name);
         dispatchEvent(new QueueModalEvent(QueueModalEvent.QUEUE_IS_READY,_loc2_));
      }
      
      private function addThumb(param1:DisplayObject) : void
      {
         if(param1)
         {
            if(this.asset)
            {
               this.asset.thumbPh.addChild(param1);
            }
         }
         else
         {
            logger.warning("QueueModal > Failed to load the thumb for queue",!!this.queue ? this.queue.name : "unknown");
         }
      }
      
      private function resetTimer(param1:Event = null) : void
      {
         this.cleanTimer();
         this.seconds = settings.queue.forceTimeout;
         if(this.queue.users.length >= this.queue.minPlayers)
         {
            this.timerId = setInterval(this.stepTimer,1000);
         }
      }
      
      private function redraw(param1:WaitingQueueEvent) : void
      {
         if(!this.ph.numChildren)
         {
            this.createList();
         }
         var _loc2_:Array = this.queue.users;
         var _loc3_:Array = this.users;
         var _loc4_:int = int(_loc3_.length);
         while(_loc4_--)
         {
            Item(_loc3_[_loc4_]).user = _loc2_[_loc4_] as String;
         }
      }
      
      private function get ph() : Sprite
      {
         return this.asset.ph;
      }
      
      private function createList() : void
      {
         var _loc2_:Item = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.queue.size)
         {
            _loc2_ = new Item(_loc1_);
            _loc2_.y = (_loc2_.height + MARGIN) * _loc1_;
            this.ph.addChild(_loc2_);
            _loc1_++;
         }
         this.timeout = setTimeout(this.force,settings.queue.forceTimeout * 1000);
      }
      
      private function cleanTimer() : void
      {
         clearInterval(this.timerId);
      }
      
      private function set seconds(param1:uint) : void
      {
         region.setText(this.asset.seconds,StringUtil.padLeft(param1));
      }
      
      private function initSingle() : void
      {
         region.setText(this.asset.singleplayer.field,"PRACTICAR");
         this.asset.singleplayer.addEventListener(MouseEvent.CLICK,this.startSinglePlayer);
         region.setText(this.asset.multiplayer.field,"JUGAR");
         this.asset.multiplayer.addEventListener(MouseEvent.CLICK,this.initQueue);
         this.asset.close.addEventListener(MouseEvent.MOUSE_UP,this.close);
         this.asset.gotoAndStop(2);
      }
   }
}

import assets.QueueUserLine;
import com.qb9.gaturro.globals.region;

final class Item extends QueueUserLine
{
    
   
   public function Item(param1:uint)
   {
      super();
      region.setText(num,(param1 + 1).toString());
   }
   
   public function get user() : String
   {
      return String(username.text) || null;
   }
   
   public function set user(param1:String) : void
   {
      waitingMC.visible = !param1;
      username.text = param1 || "";
   }
}

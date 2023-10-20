package com.qb9.gaturro.world.npc.struct.behavior
{
   import com.qb9.flashlib.events.QEventDispatcher;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.world.npc.struct.NpcScript;
   import com.qb9.gaturro.world.npc.struct.states.NpcState;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public final class NpcBehavior extends QEventDispatcher
   {
       
      
      private var script:NpcScript;
      
      private var locked:Boolean = false;
      
      private var timeoutId:int = 0;
      
      private var disposed:Boolean = false;
      
      private var currentState:String;
      
      private var events:Object;
      
      public function NpcBehavior(param1:NpcScript)
      {
         this.events = {};
         super();
         this.script = param1;
         this.currentState = param1.initialState;
      }
      
      private function cleanEvents() : void
      {
         this.events = {};
      }
      
      private function error(... rest) : void
      {
         logger.warning(["NpcBehavior",this.script.name,this.currentState,rest.join(" ")].join(" > "));
      }
      
      public function triggerEvent(param1:String) : void
      {
         if(this.hasEvent(param1))
         {
            this.goToState(this.events[param1]);
         }
      }
      
      public function goToState(param1:String) : void
      {
         if(!param1)
         {
            return this.error("Couldn´t change to empty state name");
         }
         if(!this.hasState(param1))
         {
            return this.error("No state found named",param1);
         }
         this.cleanEvents();
         this.cleanTimeout();
         this.currentState = param1;
         if(!this.locked)
         {
            dispatchEvent(new NpcBehaviorEvent(NpcBehaviorEvent.STATE_CHANGE));
         }
      }
      
      public function get state() : NpcState
      {
         return this.getState(this.currentState);
      }
      
      private function runTimeout(param1:String) : void
      {
         this.timeoutId = 0;
         if(!this.disposed)
         {
            this.goToState(param1);
         }
      }
      
      public function hasState(param1:String) : Boolean
      {
         return this.script.hasState(param1);
      }
      
      private function cleanTimeout() : void
      {
         clearTimeout(this.timeoutId);
         this.timeoutId = 0;
      }
      
      public function getState(param1:String) : NpcState
      {
         return this.script.getState(param1);
      }
      
      public function startTimeout(param1:String, param2:int) : void
      {
         this.cleanTimeout();
         this.timeoutId = setTimeout(this.runTimeout,param2,param1);
      }
      
      public function hasEvent(param1:String) : Boolean
      {
         return param1 in this.events;
      }
      
      override public function dispose() : void
      {
         this.cleanTimeout();
         this.cleanEvents();
         this.disposed = true;
         super.dispose();
      }
      
      public function lock() : void
      {
         this.locked = true;
      }
      
      public function get scriptName() : String
      {
         return this.script.name;
      }
      
      public function setEvent(param1:String, param2:String) : void
      {
         this.events[param1] = param2;
      }
   }
}

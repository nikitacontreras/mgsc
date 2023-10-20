package com.qb9.gaturro.world.npc.interpreter
{
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.flashlib.lang.every;
   import com.qb9.gaturro.world.npc.interpreter.action.NpcActionRunner;
   import com.qb9.gaturro.world.npc.interpreter.condition.NpcConditionEvaluator;
   import com.qb9.gaturro.world.npc.struct.NpcContext;
   import com.qb9.gaturro.world.npc.struct.NpcStatement;
   import com.qb9.gaturro.world.npc.struct.behavior.NpcBehavior;
   import com.qb9.gaturro.world.npc.struct.behavior.NpcBehaviorEvent;
   import com.qb9.gaturro.world.npc.struct.states.NpcState;
   import com.qb9.gaturro.world.npc.struct.states.action.NpcActionState;
   import com.qb9.gaturro.world.npc.struct.states.condition.NpcConditionState;
   import com.qb9.gaturro.world.npc.struct.states.dialog.NpcDialogState;
   
   public final class NpcInterpeter implements IDisposable
   {
      
      public static const ATTRIBUTE_EVENT_PREFFIX:String = "attr_";
       
      
      private var context:NpcContext;
      
      private var conditions:NpcConditionEvaluator;
      
      private var actions:NpcActionRunner;
      
      public function NpcInterpeter(param1:NpcContext)
      {
         super();
         this.context = param1;
         this.init();
      }
      
      public function hasEvent(param1:String) : Boolean
      {
         return this.behavior.hasEvent(param1);
      }
      
      private function runConditionState(param1:NpcConditionState) : void
      {
         this.behavior.goToState(every(param1.conditions,this.isFullfilled) ? param1.getTrueState(this.context) : param1.getFalseState(this.context));
      }
      
      public function start() : void
      {
         var _loc1_:String = this.userState;
         if(Boolean(_loc1_) && this.behavior.hasState(_loc1_))
         {
            this.behavior.goToState(_loc1_);
         }
         else
         {
            this.runState();
         }
      }
      
      private function runDialogState(param1:NpcDialogState) : void
      {
         var _loc2_:String = param1.getNextState(this.context);
         this.behavior.setEvent(NpcBehaviorEvent.FINISHED_CHAT,_loc2_);
         this.behavior.setEvent(NpcBehaviorEvent.CLICK,_loc2_);
         this.context.api.say(param1.getMessage(this.context));
      }
      
      private function get userState() : String
      {
         return this.context.roomAPI.getProfileAttribute(this.context.stateKey) as String;
      }
      
      public function triggerEvent(param1:String) : void
      {
         this.behavior.triggerEvent(param1);
      }
      
      private function skipDialogStates() : void
      {
         var _loc1_:NpcState = null;
         var _loc2_:String = null;
         while(true)
         {
            _loc1_ = this.behavior.state;
            if(!(_loc1_ is NpcDialogState))
            {
               break;
            }
            _loc2_ = NpcDialogState(_loc1_).getNextState(this.context);
            this.behavior.goToState(_loc2_);
         }
      }
      
      private function runState(param1:NpcBehaviorEvent = null) : void
      {
         var _loc2_:NpcState = this.behavior.state;
         if(_loc2_ is NpcActionState)
         {
            this.runActionState(_loc2_ as NpcActionState);
         }
         if(_loc2_ is NpcConditionState)
         {
            this.runConditionState(_loc2_ as NpcConditionState);
         }
         if(_loc2_ is NpcDialogState)
         {
            this.runDialogState(_loc2_ as NpcDialogState);
         }
      }
      
      public function dispose() : void
      {
         this.conditions.dispose();
         this.conditions = null;
         this.actions.dispose();
         this.actions = null;
         this.behavior.removeEventListener(NpcBehaviorEvent.STATE_CHANGE,this.runState);
         this.context.dispose();
         this.context = null;
      }
      
      private function get state() : NpcState
      {
         return this.behavior.state;
      }
      
      private function get behavior() : NpcBehavior
      {
         return this.context.behavior;
      }
      
      private function init() : void
      {
         this.conditions = new NpcConditionEvaluator(this.context);
         this.actions = new NpcActionRunner(this.context);
         this.behavior.addEventListener(NpcBehaviorEvent.STATE_CHANGE,this.runState);
      }
      
      private function isFullfilled(param1:NpcStatement) : Boolean
      {
         var condition:NpcStatement = param1;
         try
         {
            return this.conditions.evaluate(condition);
         }
         catch(err:Error)
         {
            context.error(err.message);
            return false;
         }
      }
      
      public function get stateName() : String
      {
         return this.behavior.state.name;
      }
      
      private function runActionState(param1:NpcActionState) : void
      {
         var _loc2_:NpcStatement = null;
         for each(_loc2_ in param1.actions)
         {
            if(this.behavior.state !== param1)
            {
               break;
            }
            this.actions.run(_loc2_);
         }
      }
   }
}

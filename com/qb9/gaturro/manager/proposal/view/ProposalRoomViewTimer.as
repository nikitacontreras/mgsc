package com.qb9.gaturro.manager.proposal.view
{
   import com.qb9.gaturro.commons.dispose.ICheckableDisposable;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class ProposalRoomViewTimer implements ICheckableDisposable
   {
      
      internal static const WAITTING_RESPONSE_MESSAGE:String = "WAITTING_RESPONSE_MESSAGE";
      
      internal static const WAITTING_RESPONSE_KICK:String = "WAITTING_RESPONSE_KICK";
      
      internal static const IDLE:String = "idle";
      
      internal static const WAITTING_COMPANION_KICK:String = "WAITTING_COMPANION_KICK";
      
      internal static const WAITTING_PROPOSAL_MESSAGE:String = "WAITTING_PROPOSAL_MESSAGE";
      
      internal static const WAITTING_PROPOSAL_KICK:String = "WAITTING_PROPOSAL_KICK";
      
      internal static const WAITTING_COMPANION_MESSAGE:String = "WAITTING_COMPANION_MESSAGE";
       
      
      private var _disposed:Boolean;
      
      private var timer:Timer;
      
      private var _currentHandler:Function;
      
      private var _state:String;
      
      public function ProposalRoomViewTimer()
      {
         super();
         this.timer = new Timer(0);
         this._state = IDLE;
      }
      
      public function startTimer(param1:int, param2:Function, param3:String) : void
      {
         if(this.timer.running)
         {
            this.stopTimer();
         }
         this._currentHandler = param2;
         this.timer.delay = param1;
         this.timer.addEventListener(TimerEvent.TIMER,param2);
         this._state = param3;
         this.timer.start();
      }
      
      public function dispose() : void
      {
         this.stopTimer();
         this.timer = null;
         this._disposed = true;
      }
      
      public function get disposed() : Boolean
      {
         return this._disposed;
      }
      
      public function get state() : String
      {
         return this._state;
      }
      
      public function stopTimer() : void
      {
         this._state = IDLE;
         this.timer.stop();
         if(this._currentHandler != null)
         {
            this.timer.removeEventListener(TimerEvent.TIMER,this._currentHandler);
            this._currentHandler = null;
         }
      }
      
      public function isIdle() : Boolean
      {
         return this._state == IDLE;
      }
   }
}

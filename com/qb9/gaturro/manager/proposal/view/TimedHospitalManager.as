package com.qb9.gaturro.manager.proposal.view
{
   import com.qb9.gaturro.event.HolderSceneObjectEvent;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.manager.proposal.constants.ProposalNPCAdviserMessagesEnum;
   import com.qb9.mambo.core.attributes.events.CustomAttributeEvent;
   import flash.events.TimerEvent;
   
   public class TimedHospitalManager extends HospitalManager
   {
      
      private static const TRACK_SCOPE:String = "guardia";
      
      private static const INACTIVITY_TOLERANCE:int = 15000;
      
      private static const SECOND_INACTIVITY_TOLERANCE:int = 5000;
       
      
      private var hospitalTimer:HospitalTimer;
      
      public function TimedHospitalManager()
      {
         super();
         this.hospitalTimer = new HospitalTimer();
      }
      
      override protected function onRemovedDoctor(param1:HolderSceneObjectEvent) : void
      {
         this.hospitalTimer.stopTimer();
         if(api.roomView.userView == patient)
         {
            this.hospitalTimer.startTimer(INACTIVITY_TOLERANCE,this.onDidntGetCompanionMessage,HospitalTimer.WAITTING_COMPANION_MESSAGE);
         }
         super.onRemovedDoctor(param1);
      }
      
      override public function response(param1:int) : void
      {
         if(this.hospitalTimer.state == HospitalTimer.WAITTING_RESPONSE_MESSAGE || this.hospitalTimer.state == HospitalTimer.WAITTING_RESPONSE_KICK)
         {
            this.hospitalTimer.stopTimer();
         }
         super.response(param1);
      }
      
      private function onDidntGetCompanionKick(param1:TimerEvent) : void
      {
         var _loc2_:String = !!patient ? "paciente_noContraparte" : "doctor_noContraparte";
         api.trackEvent("FEATURES:SALITA:INTERACCION","expulsion_" + _loc2_);
         this.hospitalTimer.stopTimer();
         this.kick();
      }
      
      override protected function onRemovedPatient(param1:HolderSceneObjectEvent) : void
      {
         this.hospitalTimer.stopTimer();
         if(api.roomView.userView == doctor)
         {
            this.hospitalTimer.startTimer(INACTIVITY_TOLERANCE,this.onDidntGetCompanionMessage,HospitalTimer.WAITTING_COMPANION_MESSAGE);
         }
         super.onRemovedPatient(param1);
      }
      
      override protected function onPatientAttributeChanged(param1:CustomAttributeEvent) : void
      {
         super.onPatientAttributeChanged(param1);
         if(api.roomView.userView == doctor)
         {
            this.hospitalTimer.startTimer(INACTIVITY_TOLERANCE,this.onDidntResponseMessage,HospitalTimer.WAITTING_RESPONSE_MESSAGE);
         }
      }
      
      override public function dispose() : void
      {
         this.hospitalTimer.dispose();
         this.hospitalTimer = null;
         super.dispose();
      }
      
      private function onDidntResponseMessage(param1:TimerEvent) : void
      {
         this.hospitalTimer.startTimer(SECOND_INACTIVITY_TOLERANCE,this.onDidntResponseKick,HospitalTimer.WAITTING_RESPONSE_KICK);
         nurse.say(ProposalNPCAdviserMessagesEnum.PROMPT);
      }
      
      override protected function onAdded(param1:HolderSceneObjectEvent) : void
      {
         super.onAdded(param1);
         if(api.roomView.userView == doctor || api.roomView.userView == patient)
         {
            if(Boolean(patient) && Boolean(doctor))
            {
               if(this.hospitalTimer.state == HospitalTimer.WAITTING_COMPANION_MESSAGE || this.hospitalTimer.state == HospitalTimer.WAITTING_COMPANION_KICK)
               {
                  this.hospitalTimer.stopTimer();
               }
               if(api.roomView.userView == patient)
               {
                  this.hospitalTimer.startTimer(INACTIVITY_TOLERANCE,this.onDidntStartPlayMessage,HospitalTimer.WAITTING_PROPOSAL_MESSAGE);
               }
            }
            else
            {
               this.hospitalTimer.startTimer(INACTIVITY_TOLERANCE,this.onDidntGetCompanionMessage,HospitalTimer.WAITTING_COMPANION_MESSAGE);
            }
         }
      }
      
      private function onDidntGetCompanionMessage(param1:TimerEvent) : void
      {
         this.hospitalTimer.startTimer(SECOND_INACTIVITY_TOLERANCE,this.onDidntGetCompanionKick,HospitalTimer.WAITTING_COMPANION_KICK);
         nurse.say(ProposalNPCAdviserMessagesEnum.PROMPT);
      }
      
      private function onDidntResponseKick(param1:TimerEvent) : void
      {
         api.trackEvent("FEATURES:SALITA:INTERACCION","consultorio_paciente_noAccion");
         this.hospitalTimer.stopTimer();
         this.kick();
      }
      
      override protected function restart() : void
      {
         this.kick();
      }
      
      override protected function setupTracking() : void
      {
         trackScope = TRACK_SCOPE;
      }
      
      override protected function kick() : void
      {
         api.moveToTileXY(api.userAvatar.coord.x,api.userAvatar.coord.y + 3);
      }
      
      private function onDidntStartPlayMessage(param1:TimerEvent) : void
      {
         this.hospitalTimer.startTimer(SECOND_INACTIVITY_TOLERANCE,this.onDidntStartPlayKick,HospitalTimer.WAITTING_PROPOSAL_KICK);
         nurse.say(ProposalNPCAdviserMessagesEnum.PROMPT);
      }
      
      override protected function evalResult() : void
      {
         if(api.roomView.userView == doctor || api.roomView.userView == patient)
         {
            super.evalResult();
         }
      }
      
      private function onDidntStartPlayKick(param1:TimerEvent) : void
      {
         api.trackEvent("FEATURES:SALITA:INTERACCION","consultorio_doctor_noAccion");
         this.hospitalTimer.stopTimer();
         this.kick();
      }
      
      override public function propose(param1:int) : void
      {
         if(this.hospitalTimer.state == HospitalTimer.WAITTING_PROPOSAL_MESSAGE || this.hospitalTimer.state == HospitalTimer.WAITTING_PROPOSAL_KICK)
         {
            this.hospitalTimer.stopTimer();
         }
         super.propose(param1);
      }
   }
}

import com.qb9.gaturro.commons.dispose.ICheckableDisposable;
import flash.events.TimerEvent;
import flash.utils.Timer;

class HospitalTimer implements ICheckableDisposable
{
   
   private static const WAITTING_RESPONSE_MESSAGE:String = "WAITTING_RESPONSE_MESSAGE";
   
   private static const WAITTING_RESPONSE_KICK:String = "WAITTING_RESPONSE_KICK";
   
   private static const IDLE:String = "idle";
   
   private static const WAITTING_COMPANION_KICK:String = "WAITTING_COMPANION_KICK";
   
   private static const WAITTING_PROPOSAL_MESSAGE:String = "WAITTING_PROPOSAL_MESSAGE";
   
   private static const WAITTING_PROPOSAL_KICK:String = "WAITTING_PROPOSAL_KICK";
   
   private static const WAITTING_COMPANION_MESSAGE:String = "WAITTING_COMPANION_MESSAGE";
    
   
   private var _disposed:Boolean;
   
   private var timer:Timer;
   
   private var _currentHandler:Function;
   
   private var _state:String;
   
   public function HospitalTimer()
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

package com.qb9.gaturro.manager.proposal.view
{
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.dispose.ICheckableDisposable;
   import com.qb9.gaturro.event.HolderSceneObjectEvent;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.manager.proposal.ProposalManager;
   import com.qb9.gaturro.manager.proposal.constants.ProposalNPCAdviserMessagesEnum;
   import com.qb9.gaturro.view.gui.contextual.ContextualMenuManager;
   import com.qb9.gaturro.view.world.avatars.GaturroAvatarView;
   import com.qb9.gaturro.view.world.elements.HolderRoomSceneObjectView;
   import com.qb9.mambo.core.attributes.events.CustomAttributeEvent;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class HospitalManager implements ICheckableDisposable
   {
      
      public static const HOSPITAL_HOLDER_DOCTOR:String = "hospitalHolderDoctor";
      
      public static const HOSPITAL_FEATURE_NURSE:String = "hospitalFeatureNurse";
      
      public static const HOSPITAL_FEATURE:String = "hospitalFeature";
      
      private static const TRACK_CATEGORY:String = "FEATURES:SALITA:INTERACCION";
      
      public static const HOSPITAL_HOLDER:String = "hospitalHolder";
      
      private static const DOCTOR:String = "doctor";
      
      private static const PATIENT_CLOTH:String = "salitaMedicaAssets.remeraPaciente";
      
      private static const DOCTOR_CLOTH:String = "salitaMedicaAssets.remeraMedico";
      
      private static const PATIENT:String = "patient";
      
      private static const TRACK_SCOPE:String = "consultorio";
      
      public static const HOSPITAL_HOLDER_PATIENT:String = "hospitalHolderPatient";
      
      public static const HOSPITAL_FEATURE_MACHINE:String = "hospitalFeatureMachine";
      
      private static const PROPOSAL_CODE:int = 1;
       
      
      private var _disposed:Boolean;
      
      protected var patient:GaturroAvatarView;
      
      private var doctorFailedAttemptsCount:int = 0;
      
      protected var patientHolder:HolderRoomSceneObjectView;
      
      protected var nurse:NpcHospitalNurse;
      
      protected var doctor:GaturroAvatarView;
      
      protected var doctorHolder:HolderRoomSceneObjectView;
      
      private var contextualMenuManager:ContextualMenuManager;
      
      protected var timer:Timer;
      
      protected var machine:NpcHospitalMachine;
      
      protected var trackScope:String;
      
      private var proposalManager:ProposalManager;
      
      private var patientFailedAttemptsCount:int = 0;
      
      public function HospitalManager()
      {
         super();
         this.proposalManager = new ProposalManager(PROPOSAL_CODE);
         this.timer = new Timer(400000,1);
         this.contextualMenuManager = Context.instance.getByType(ContextualMenuManager) as ContextualMenuManager;
         this.setupTracking();
      }
      
      protected function onRemovedDoctor(param1:HolderSceneObjectEvent) : void
      {
         trace("HospitalManager > onRemoved > doctor = [" + this.doctor + "]");
         if(this.doctor)
         {
            trace("HospitalManager > onRemoved > doctor.avatar = [" + this.doctor.avatar + "]");
            if(this.doctor.avatar)
            {
               this.doctor.avatar.removeCustomAttributeListener(ProposalManager.PROPOSAL_ATTR,this.onDoctorAttributeChanged);
               trace("HospitalManager > onRemoved > doctor.avatar.hasEventListener(ProposalManager.PROPOSAL_ATTR) = [" + this.doctor.avatar.hasEventListener(ProposalManager.PROPOSAL_ATTR) + "]");
            }
            this.proposalManager.resetResponse();
            if(api.roomView.userView == this.patient)
            {
               trace("HospitalManager > onRemoved > patient = [" + this.patient + "]");
               this.proposalManager.resetResponserAttr();
               this.removeContextualMennu(this.patient);
            }
            else if(api.roomView.userView == this.doctor)
            {
               trace("HospitalManager > onRemoved > doctor = [" + this.doctor + "]");
               this.removeContextualMennu(this.doctor);
               this.timer.stop();
            }
            this.doctor = null;
         }
         else
         {
            trace("there\'s no Docctor defined");
         }
      }
      
      protected function onRemoved(param1:HolderSceneObjectEvent) : void
      {
         this.machine.reset();
      }
      
      protected function restart() : void
      {
         if(api.roomView.userView == this.patient)
         {
            this.showPatientContextualMenu();
         }
      }
      
      protected function scopedTrack(param1:String) : void
      {
         api.trackEvent(TRACK_CATEGORY,this.trackScope + "_" + param1);
      }
      
      public function get disposed() : Boolean
      {
         return this._disposed;
      }
      
      public function dispose() : void
      {
         if(Boolean(this.patient) && Boolean(this.patient.avatar))
         {
            this.patient.avatar.removeCustomAttributeListener(ProposalManager.PROPOSAL_ATTR,this.onPatientAttributeChanged);
         }
         if(Boolean(this.doctor) && Boolean(this.doctor.avatar))
         {
            this.doctor.avatar.removeCustomAttributeListener(ProposalManager.PROPOSAL_ATTR,this.onDoctorAttributeChanged);
         }
         if(this.doctorHolder)
         {
            this.doctorHolder.removeEventListener(HolderSceneObjectEvent.ADDED,this.onAddedDoctor);
            this.doctorHolder.removeEventListener(HolderSceneObjectEvent.ADDED,this.onAdded);
            this.doctorHolder.removeEventListener(HolderSceneObjectEvent.REMOVE,this.onRemoved);
            this.doctorHolder = null;
         }
         if(this.patientHolder)
         {
            this.patientHolder.removeEventListener(HolderSceneObjectEvent.ADDED,this.onAddedPatient);
            this.patientHolder.removeEventListener(HolderSceneObjectEvent.ADDED,this.onAdded);
            this.patientHolder.removeEventListener(HolderSceneObjectEvent.REMOVE,this.onRemoved);
            this.patientHolder = null;
         }
         if(this.machine)
         {
            this.machine.dispose();
            this.machine = null;
         }
         if(this.nurse)
         {
            this.nurse.dispose();
            this.nurse = null;
         }
         this.timer.stop();
         this.timer = null;
         this.proposalManager.dispose();
         this.proposalManager = null;
         this._disposed = true;
      }
      
      private function removeContextualMennu(param1:DisplayObjectContainer) : void
      {
         if(this.contextualMenuManager.hasMenu(param1))
         {
            this.contextualMenuManager.removeMenu(param1);
         }
      }
      
      public function addAdviser(param1:Sprite) : void
      {
         this.nurse = new NpcHospitalNurse(param1);
      }
      
      public function addHolder(param1:HolderRoomSceneObjectView, param2:String) : void
      {
         if(param2 == HOSPITAL_HOLDER_DOCTOR)
         {
            this.doctorHolder = param1;
            param1.addEventListener(HolderSceneObjectEvent.ADDED,this.onAddedDoctor,false,1);
            param1.addEventListener(HolderSceneObjectEvent.REMOVE,this.onRemovedDoctor,false,1);
         }
         else if(param2 == HOSPITAL_HOLDER_PATIENT)
         {
            this.patientHolder = param1;
            param1.addEventListener(HolderSceneObjectEvent.ADDED,this.onAddedPatient,false,1);
            param1.addEventListener(HolderSceneObjectEvent.REMOVE,this.onRemovedPatient,false,1);
         }
         param1.addEventListener(HolderSceneObjectEvent.ADDED,this.onAdded,false,0);
         param1.addEventListener(HolderSceneObjectEvent.REMOVE,this.onRemoved,false,0);
      }
      
      private function trackFailedAttepmts(param1:String, param2:int) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         if(param2 == 1)
         {
            _loc4_ = "1";
         }
         else if(param2 > 1 && param2 < 6)
         {
            _loc4_ = "2-5";
         }
         else
         {
            _loc4_ = "6";
         }
         _loc3_ = param1 + "_" + _loc4_;
         this.scopedTrack(_loc3_);
      }
      
      private function showPatientContextualMenu() : void
      {
         this.contextualMenuManager.addMenu("hospitalPatient",this.patient,this);
      }
      
      private function onMatchEnds(param1:TimerEvent) : void
      {
         this.timer.removeEventListener(TimerEvent.TIMER,this.onMatchEnds);
         this.timer.stop();
         this.machine.reset();
         this.restart();
      }
      
      public function response(param1:int) : void
      {
         this.proposalManager.response(param1);
         this.machine.showAnswer(param1);
         this.evalResult();
      }
      
      protected function onRemovedPatient(param1:HolderSceneObjectEvent) : void
      {
         trace("HospitalManager > onRemoved > patient = [" + this.patient + "]");
         if(this.patient)
         {
            trace("HospitalManager > onRemoved > (patient.avatar = [" + this.patient.avatar + "]");
            if(this.patient.avatar)
            {
               this.patient.avatar.removeCustomAttributeListener(ProposalManager.PROPOSAL_ATTR,this.onPatientAttributeChanged);
               trace("HospitalManager > onRemoved > doctor.avatar.hasEventListener(ProposalManager.PROPOSAL_ATTR) = [" + this.patient.avatar.hasEventListener(ProposalManager.PROPOSAL_ATTR) + "]");
            }
            this.proposalManager.resetProposal();
            if(api.roomView.userView == this.doctor)
            {
               trace("HospitalManager > onRemoved > doctor = [" + this.doctor + "]");
               this.proposalManager.resetProposerAttr();
               this.removeContextualMennu(this.doctor);
            }
            else if(api.roomView.userView == this.patient)
            {
               trace("HospitalManager > onRemoved > patient = [" + this.patient + "]");
               this.removeContextualMennu(this.patient);
               this.timer.stop();
            }
            this.patient = null;
         }
         else
         {
            trace("there\'s no Patient defined");
         }
      }
      
      protected function kick() : void
      {
         api.moveToTileXY(api.userAvatar.coord.x,api.userAvatar.coord.y + 2);
      }
      
      public function propose(param1:int) : void
      {
         this.proposalManager.propose(param1);
         this.machine.showProposal(param1);
         var _loc2_:Object = this.proposalManager.getSelectedProposalContent();
         if(api.userView == this.patient)
         {
            api.setAvatarAttribute(_loc2_.keyCloth,_loc2_.valueCloth);
         }
         this.nurse.say(ProposalNPCAdviserMessagesEnum.RESPONSE_ACTION);
      }
      
      public function reset() : void
      {
         this.proposalManager.reset();
         if(Boolean(this.patient) && Boolean(this.patient.avatar))
         {
            this.patient.avatar.removeCustomAttributeListener(ProposalManager.PROPOSAL_ATTR,this.onPatientAttributeChanged);
            this.patientHolder = null;
         }
         if(Boolean(this.doctor) && Boolean(this.doctor.avatar))
         {
            this.doctor.avatar.removeCustomAttributeListener(ProposalManager.PROPOSAL_ATTR,this.onDoctorAttributeChanged);
            this.doctorHolder = null;
         }
         this.machine.reset();
      }
      
      protected function setupTracking() : void
      {
         this.trackScope = TRACK_SCOPE;
      }
      
      protected function evalResult() : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:String = null;
         var _loc1_:Boolean = this.proposalManager.checkCoincidence();
         if(api.userView == this.patient)
         {
            if(_loc1_)
            {
               _loc3_ = this.proposalManager.getSelectedProposalContent();
               _loc4_ = this.proposalManager.getSelectedResponseContent();
               if(_loc3_.keyCloth != _loc4_.keyCloth)
               {
                  api.setAvatarAttribute(_loc3_.keyCloth,"");
               }
               api.setAvatarAttribute(_loc4_.keyCloth,_loc4_.valueCloth);
               api.playSound("salitaMedica/cura");
            }
            _loc2_ = _loc1_ ? ProposalNPCAdviserMessagesEnum.PROPOSER_SACCESFULL_RESPONSE : ProposalNPCAdviserMessagesEnum.PROPOSER_WRONG_RESPONSE;
         }
         if(api.roomView.userView == this.doctor)
         {
            _loc5_ = _loc1_ ? "doctor_exito" : "doctor_fallo";
            this.scopedTrack(_loc5_);
            api.playSound("salitaMedica/cura");
            _loc2_ = _loc1_ ? ProposalNPCAdviserMessagesEnum.RESPONSER_SACCESFULL_RESPONSE : ProposalNPCAdviserMessagesEnum.RESPONSER_WRONG_RESPONSE;
         }
         this.nurse.say(_loc2_);
         this.timer.delay = 4000;
         this.timer.addEventListener(TimerEvent.TIMER,this.onMatchEnds);
         this.timer.start();
      }
      
      private function onAddedDoctor(param1:HolderSceneObjectEvent) : void
      {
         var _loc2_:GaturroAvatarView = null;
         if(param1.sceneObject is GaturroAvatarView)
         {
            _loc2_ = GaturroAvatarView(param1.sceneObject);
            if(!this.hasRightCloths(_loc2_,DOCTOR_CLOTH))
            {
               if(api.roomView.userView == _loc2_)
               {
                  ++this.doctorFailedAttemptsCount;
                  this.trackFailedAttepmts(DOCTOR,this.doctorFailedAttemptsCount);
                  this.notifyInvalidDress(HOSPITAL_HOLDER_DOCTOR);
               }
            }
            else if(Boolean(this.doctor) && api.roomView.userView == _loc2_)
            {
               this.kick();
            }
            else
            {
               this.doctor = _loc2_;
               if(api.roomView.userView == this.doctor)
               {
                  if(!this.patient)
                  {
                     this.nurse.say(ProposalNPCAdviserMessagesEnum.NEEDS_PROPOSER);
                  }
                  this.scopedTrack("doctor_ocupaLugar");
               }
            }
         }
      }
      
      protected function onAdded(param1:HolderSceneObjectEvent) : void
      {
         if(Boolean(this.patient) && Boolean(this.doctor))
         {
            if(api.roomView.userView == this.doctor || api.roomView.userView == this.patient)
            {
               this.nurse.say(ProposalNPCAdviserMessagesEnum.PROPOSAL_ACTION);
            }
            if(api.roomView.userView == this.doctor)
            {
               this.proposalManager.proposerAttribute = this.patient.avatar;
               this.patient.avatar.addCustomAttributeListener(ProposalManager.PROPOSAL_ATTR,this.onPatientAttributeChanged);
            }
            else if(api.roomView.userView == this.patient)
            {
               this.proposalManager.responserAttribute = this.doctor.avatar;
               this.doctor.avatar.addCustomAttributeListener(ProposalManager.PROPOSAL_ATTR,this.onDoctorAttributeChanged);
               this.showPatientContextualMenu();
            }
         }
      }
      
      private function hasRightCloths(param1:GaturroAvatarView, param2:String) : Boolean
      {
         var _loc3_:String = param1.avatar.attributes.cloth as String;
         return Boolean(_loc3_) && _loc3_.indexOf(param2) > -1;
      }
      
      private function onAddedPatient(param1:HolderSceneObjectEvent) : void
      {
         var _loc2_:GaturroAvatarView = null;
         if(param1.sceneObject is GaturroAvatarView)
         {
            _loc2_ = GaturroAvatarView(param1.sceneObject);
            if(!this.hasRightCloths(_loc2_,PATIENT_CLOTH))
            {
               if(api.roomView.userView == _loc2_)
               {
                  ++this.patientFailedAttemptsCount;
                  this.trackFailedAttepmts(PATIENT,this.patientFailedAttemptsCount);
                  this.notifyInvalidDress(HOSPITAL_HOLDER_PATIENT);
               }
            }
            else if(Boolean(this.patient) && api.roomView.userView == _loc2_)
            {
               this.kick();
            }
            else
            {
               this.patient = _loc2_;
               if(api.roomView.userView == this.patient)
               {
                  if(!this.doctor)
                  {
                     this.nurse.say(ProposalNPCAdviserMessagesEnum.NEEDS_RESPONSER);
                  }
                  this.scopedTrack("paciente_ocupaLugar");
               }
            }
         }
      }
      
      public function getProposal() : int
      {
         return this.proposalManager.getProposal();
      }
      
      private function notifyInvalidDress(param1:String) : void
      {
         if(param1 == HOSPITAL_HOLDER_DOCTOR)
         {
            this.nurse.say(ProposalNPCAdviserMessagesEnum.USE_RESPONSER_SUIT);
         }
         else if(param1 == HOSPITAL_HOLDER_PATIENT)
         {
            this.nurse.say(ProposalNPCAdviserMessagesEnum.USE_PROPOSER_SUIT);
         }
         this.kick();
      }
      
      protected function onPatientAttributeChanged(param1:CustomAttributeEvent) : void
      {
         var _loc2_:int = 0;
         if(api.roomView.userView == this.doctor)
         {
            this.nurse.say(ProposalNPCAdviserMessagesEnum.RESPONSE_ACTION);
            _loc2_ = this.proposalManager.getProposal();
            this.machine.showProposal(_loc2_);
            this.showDoctorContextualMenu();
         }
      }
      
      private function showDoctorContextualMenu() : void
      {
         this.contextualMenuManager.addMenu("hospitalDoctor",this.doctor,this);
      }
      
      public function addNotifier(param1:Sprite) : void
      {
         this.machine = new NpcHospitalMachine(param1);
      }
      
      private function onDoctorAttributeChanged(param1:CustomAttributeEvent) : void
      {
         var _loc2_:int = this.proposalManager.getAnswer();
         this.machine.showAnswer(_loc2_);
         this.evalResult();
      }
   }
}

import com.qb9.gaturro.commons.dispose.ICheckableDisposable;
import flash.display.MovieClip;
import flash.display.Sprite;

class NpcHospitalMachine implements ICheckableDisposable
{
   
   private static const STAND_BY:String = "standBy";
    
   
   private var answerView:MovieClip;
   
   private var _disposed:Boolean;
   
   private var view:Sprite;
   
   private var proposalView:MovieClip;
   
   public function NpcHospitalMachine(param1:Sprite)
   {
      super();
      this.view = param1;
      this.setup();
   }
   
   public function get disposed() : Boolean
   {
      return this._disposed;
   }
   
   public function showProposal(param1:int) : void
   {
      this.proposalView.gotoAndStop(param1);
   }
   
   public function reset() : void
   {
      this.proposalView.gotoAndStop(STAND_BY);
      this.answerView.gotoAndStop(STAND_BY);
   }
   
   public function showAnswer(param1:int) : void
   {
      this.answerView.gotoAndStop(param1);
   }
   
   private function setup() : void
   {
      this.proposalView = this.view.getChildByName("proposalView") as MovieClip;
      this.answerView = this.view.getChildByName("answerView") as MovieClip;
      this.reset();
   }
   
   public function dispose() : void
   {
      this.proposalView = null;
      this.answerView = null;
      this._disposed = true;
   }
}

import com.qb9.gaturro.commons.dispose.ICheckableDisposable;
import com.qb9.gaturro.manager.proposal.constants.ProposalNPCAdviserMessagesEnum;
import com.qb9.gaturro.view.world.chat.LocalChatBallon;
import flash.display.Sprite;
import flash.utils.Dictionary;

class NpcHospitalNurse implements ICheckableDisposable
{
    
   
   private var _disposed:Boolean;
   
   private var textList:Dictionary;
   
   private var owner:Sprite;
   
   private var chat:LocalChatBallon;
   
   public function NpcHospitalNurse(param1:Sprite)
   {
      super();
      this.owner = param1;
      this.setup();
   }
   
   public function get disposed() : Boolean
   {
      return this._disposed;
   }
   
   public function say(param1:String) : void
   {
      var _loc2_:String = String(this.textList[param1]);
      this.chat.say(_loc2_);
   }
   
   private function setup() : void
   {
      this.chat = new LocalChatBallon(this.owner);
      this.textList = new Dictionary();
      this.textList[ProposalNPCAdviserMessagesEnum.USE_PROPOSER_SUIT] = "NECESITAS UN TRAJE DE PACIENTE";
      this.textList[ProposalNPCAdviserMessagesEnum.USE_RESPONSER_SUIT] = "NECESITAS UN TRAJE DE MÉDICO";
      this.textList[ProposalNPCAdviserMessagesEnum.PROPOSER_WRONG_RESPONSE] = "CREO QUE NO ES LA CURA CORRECTA...";
      this.textList[ProposalNPCAdviserMessagesEnum.RESPONSER_WRONG_RESPONSE] = "CREO QUE NO ES LA CURA CORRECTA...";
      this.textList[ProposalNPCAdviserMessagesEnum.NEEDS_RESPONSER] = "AHORA FALTA QUE LLEGUE UN/A MÉDICO/A";
      this.textList[ProposalNPCAdviserMessagesEnum.NEEDS_PROPOSER] = "AHORA FALTA QUE LLEGUE UN PACIENTE";
      this.textList[ProposalNPCAdviserMessagesEnum.PROPOSAL_ACTION] = "EL PACIENTE NOS DIRÁ PRONTO SU MALESTAR...";
      this.textList[ProposalNPCAdviserMessagesEnum.RESPONSE_ACTION] = "EL MÉDICO O MÉDICA NOS DIRÁ PRONTO EL TRATAMIENTO…";
      this.textList[ProposalNPCAdviserMessagesEnum.PROPOSER_SACCESFULL_RESPONSE] = "¡EL PACIENTE FUE TRATADO!";
      this.textList[ProposalNPCAdviserMessagesEnum.RESPONSER_SACCESFULL_RESPONSE] = "¡EL PACIENTE FUE TRATADO!";
      this.textList[ProposalNPCAdviserMessagesEnum.TIME_REACHED] = "¡TE QUEDASTE SIN TIEMPO!\nVUELVE PRONTO";
      this.textList[ProposalNPCAdviserMessagesEnum.PROMPT] = "ELIGE PRONTO, DEBEMOS ATENDER OTROS CASOS";
   }
   
   public function dispose() : void
   {
      this.chat.dispose();
      this._disposed = true;
   }
}

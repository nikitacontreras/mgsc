package com.qb9.gaturro.manager.proposal.view
{
   import com.qb9.gaturro.commons.constraint.ConstraintManager;
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.event.HolderSceneObjectEvent;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.manager.proposal.ProposalManager;
   import com.qb9.gaturro.manager.proposal.constants.ProposalAudioEnum;
   import com.qb9.gaturro.manager.proposal.constants.ProposalNPCAdviserMessagesEnum;
   import com.qb9.gaturro.manager.proposal.constants.ProposalViewConst;
   import com.qb9.gaturro.manager.proposal.view.audio.ProposalAudioFeedback;
   import com.qb9.gaturro.manager.proposal.view.npc.ProposalNpcAdviserController;
   import com.qb9.gaturro.manager.proposal.view.npc.ProposalNpcNotifierController;
   import com.qb9.gaturro.model.config.proposal.ProposalConfig;
   import com.qb9.gaturro.model.config.proposal.ProposalViewDefinition;
   import com.qb9.gaturro.view.gui.contextual.ContextualMenuManager;
   import com.qb9.gaturro.view.world.avatars.GaturroAvatarView;
   import com.qb9.gaturro.view.world.elements.HolderRoomSceneObjectView;
   import com.qb9.mambo.core.attributes.events.CustomAttributeEvent;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class BaseProposalRoomViewManager extends AbstractProposalRoomViewManager
   {
      
      private static const PATIENT:String = "patient";
      
      private static const DOCTOR:String = "doctor";
       
      
      private var riggeed:Boolean;
      
      private var constraintManager:ConstraintManager;
      
      private var proposerFailedAttemptsCount:int = 0;
      
      private var responserFailedAttemptsCount:int = 0;
      
      private var responserContraint:String;
      
      protected var npcNotifier:ProposalNpcNotifierController;
      
      private var contextualMenuManager:ContextualMenuManager;
      
      private var delayedEvaluationTimeoutId:uint;
      
      protected var proposerHolder:HolderRoomSceneObjectView;
      
      protected var timer:Timer;
      
      protected var trackScope:String;
      
      protected var responser:GaturroAvatarView;
      
      private var proposalConfig:ProposalConfig;
      
      private var proposerContraint:String;
      
      protected var responserHolder:HolderRoomSceneObjectView;
      
      protected var npcAdviser:ProposalNpcAdviserController;
      
      private var trackCategory:String;
      
      protected var proposer:GaturroAvatarView;
      
      protected var audioFeedback:ProposalAudioFeedback;
      
      private var proposalCode:int;
      
      public function BaseProposalRoomViewManager(param1:ProposalViewDefinition)
      {
         super(param1);
         proposalManager = new ProposalManager(param1.code);
         this.timer = new Timer(400000,1);
         this.contextualMenuManager = Context.instance.getByType(ContextualMenuManager) as ContextualMenuManager;
         this.setupConstrint();
         this.setupTracking();
         this.addAudioFeedback();
      }
      
      protected function onRemoved(param1:HolderSceneObjectEvent) : void
      {
         this.npcNotifier.reset();
      }
      
      private function removeContextualMenu(param1:DisplayObjectContainer) : void
      {
         if(this.contextualMenuManager.hasMenu(param1))
         {
            this.contextualMenuManager.removeMenu(param1);
         }
      }
      
      private function onMatchEnds(param1:TimerEvent) : void
      {
         this.timer.removeEventListener(TimerEvent.TIMER,this.onMatchEnds);
         this.timer.stop();
         this.npcNotifier.reset();
         this.restart();
      }
      
      private function onAddedResponser(param1:HolderSceneObjectEvent) : void
      {
         var _loc2_:GaturroAvatarView = null;
         if(param1.sceneObject is GaturroAvatarView)
         {
            if(!this.responser)
            {
               _loc2_ = GaturroAvatarView(param1.sceneObject);
               if(api.roomView.userView == _loc2_)
               {
                  if(!this.constraintManager.accomplishById(this.responserContraint,_loc2_))
                  {
                     ++this.responserFailedAttemptsCount;
                     this.trackFailedAttepmts(DOCTOR,this.responserFailedAttemptsCount);
                     this.adviseForDisability(ProposalViewConst.PROPOSAL_RESPONSER_HOLDER_VALUE);
                  }
                  else if(this.responser)
                  {
                     this.kick();
                  }
                  else
                  {
                     this.responser = _loc2_;
                     if(!this.proposer)
                     {
                        this.npcAdviser.say(ProposalNPCAdviserMessagesEnum.NEEDS_PROPOSER);
                     }
                     this.scopedTrack("repsonser_ocupaLugar");
                  }
               }
               else
               {
                  this.responser = _loc2_;
               }
            }
            else
            {
               this.kick();
            }
         }
      }
      
      protected function onProposerAttributeChanged(param1:CustomAttributeEvent) : void
      {
         var _loc2_:int = 0;
         if(api.roomView.userView == this.responser)
         {
            this.npcAdviser.say(ProposalNPCAdviserMessagesEnum.RESPONSE_ACTION);
            _loc2_ = proposalManager.getProposal();
            this.npcNotifier.showProposal(_loc2_);
            this.showDoctorContextualMenu();
         }
      }
      
      protected function restart() : void
      {
         if(api.roomView.userView == this.proposer)
         {
            this.showPatientContextualMenu();
         }
      }
      
      protected function onRemovedProposer(param1:HolderSceneObjectEvent) : void
      {
         trace("ProposalRoomViewManager > onRemoved > patient = [" + this.proposer + "]");
         if(this.proposer)
         {
            trace("ProposalRoomViewManager > onRemoved > (patient.avatar = [" + this.proposer.avatar + "]");
            if(this.proposer.avatar)
            {
               this.proposer.avatar.removeCustomAttributeListener(ProposalManager.PROPOSAL_ATTR,this.onProposerAttributeChanged);
            }
            if(Boolean(this.responser) && Boolean(this.responser.avatar))
            {
               this.responser.avatar.removeCustomAttributeListener(ProposalManager.PROPOSAL_ATTR,this.onResponserAttributeChanged);
            }
            if(api.roomView.userView == this.responser)
            {
               this.removeContextualMenu(this.responser);
            }
            else if(api.roomView.userView == this.proposer)
            {
               this.removeContextualMenu(this.proposer);
               this.timer.stop();
            }
            this.proposer = null;
         }
         else
         {
            trace("there\'s no Patient defined");
         }
         proposalManager.reset();
         this.riggeed = false;
         this.proposer = null;
      }
      
      override public function dispose() : void
      {
         if(Boolean(this.proposer) && Boolean(this.proposer.avatar))
         {
            this.proposer.avatar.removeCustomAttributeListener(ProposalManager.PROPOSAL_ATTR,this.onProposerAttributeChanged);
         }
         if(Boolean(this.responser) && Boolean(this.responser.avatar))
         {
            this.responser.avatar.removeCustomAttributeListener(ProposalManager.PROPOSAL_ATTR,this.onResponserAttributeChanged);
         }
         if(this.responserHolder)
         {
            this.responserHolder.removeEventListener(HolderSceneObjectEvent.ADDED,this.onAddedResponser);
            this.responserHolder.removeEventListener(HolderSceneObjectEvent.ADDED,this.onAdded);
            this.responserHolder.removeEventListener(HolderSceneObjectEvent.REMOVE,this.onRemoved);
            this.responserHolder.removeEventListener(HolderSceneObjectEvent.REMOVE,this.onRemovedResponser);
            this.responserHolder = null;
         }
         if(this.proposerHolder)
         {
            this.proposerHolder.removeEventListener(HolderSceneObjectEvent.ADDED,this.onAddedProposer);
            this.proposerHolder.removeEventListener(HolderSceneObjectEvent.ADDED,this.onAdded);
            this.proposerHolder.removeEventListener(HolderSceneObjectEvent.REMOVE,this.onRemoved);
            this.proposerHolder.removeEventListener(HolderSceneObjectEvent.REMOVE,this.onRemovedProposer);
            this.proposerHolder = null;
         }
         if(this.npcNotifier)
         {
            this.npcNotifier.dispose();
            this.npcNotifier = null;
         }
         if(this.npcAdviser)
         {
            this.npcAdviser.dispose();
            this.npcAdviser = null;
         }
         this.timer.stop();
         this.timer = null;
         super.dispose();
      }
      
      private function setupConstrint() : void
      {
         this.constraintManager = Context.instance.getByType(ConstraintManager) as ConstraintManager;
         this.proposerContraint = viewDefinition.name + "ProposerProposal";
         if(!this.constraintManager.hasConstraintWithID(this.proposerContraint))
         {
            this.constraintManager.activateDefinition(viewDefinition.proposerAvailableConstraint,this.proposerContraint);
         }
         this.responserContraint = viewDefinition.name + "ResponserProposal";
         if(!this.constraintManager.hasConstraintWithID(this.responserContraint))
         {
            this.constraintManager.activateDefinition(viewDefinition.responserAvailableContraint,this.responserContraint);
         }
      }
      
      override public function addAdviser(param1:Sprite) : void
      {
         this.npcAdviser = new ProposalNpcAdviserController(param1,viewDefinition);
      }
      
      protected function scopedTrack(param1:String) : void
      {
         api.trackEvent(this.trackCategory,this.trackScope + "_" + param1);
      }
      
      override public function addHolder(param1:HolderRoomSceneObjectView, param2:String) : void
      {
         if(param2 == ProposalViewConst.PROPOSAL_RESPONSER_HOLDER_VALUE)
         {
            this.responserHolder = param1;
            param1.addEventListener(HolderSceneObjectEvent.ADDED,this.onAddedResponser,false,1);
            param1.addEventListener(HolderSceneObjectEvent.REMOVE,this.onRemovedResponser,false,1);
         }
         else if(param2 == ProposalViewConst.PROPOSAL_PROPOSER_HOLDER_VALUE)
         {
            this.proposerHolder = param1;
            param1.addEventListener(HolderSceneObjectEvent.ADDED,this.onAddedProposer,false,1);
            param1.addEventListener(HolderSceneObjectEvent.REMOVE,this.onRemovedProposer,false,1);
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
         var _loc1_:String = String(viewDefinition.data.proposerContextualMenu);
         if(!_loc1_)
         {
            throw new Error("Invalid proposerContextualMenu menu identifier. This identifier can´t be null or empty");
         }
         this.contextualMenuManager.addMenu(_loc1_,this.proposer,this);
      }
      
      protected function kick() : void
      {
         api.moveToTileXY(api.userAvatar.coord.x,api.userAvatar.coord.y + 2);
      }
      
      override public function response(param1:int) : void
      {
         proposalManager.response(param1);
         this.npcNotifier.showAnswer(param1);
         this.evalResult();
      }
      
      private function onResponserAttributeChanged(param1:CustomAttributeEvent) : void
      {
         var _loc2_:int = proposalManager.getAnswer();
         this.npcNotifier.showAnswer(_loc2_);
         this.evalResult();
      }
      
      override public function propose(param1:int) : void
      {
         proposalManager.propose(param1);
         this.npcNotifier.showProposal(param1);
         var _loc2_:Object = proposalManager.getSelectedProposalContent();
         if(api.userView == this.proposer && _loc2_.keyCloth && Boolean(_loc2_.valueCloth))
         {
            api.setAvatarAttribute(_loc2_.keyCloth,_loc2_.valueCloth);
         }
         this.npcAdviser.say(ProposalNPCAdviserMessagesEnum.RESPONSE_ACTION);
      }
      
      override public function reset() : void
      {
         proposalManager.reset();
         if(Boolean(this.proposer) && Boolean(this.proposer.avatar))
         {
            this.proposer.avatar.removeCustomAttributeListener(ProposalManager.PROPOSAL_ATTR,this.onProposerAttributeChanged);
            this.proposerHolder = null;
         }
         if(Boolean(this.responser) && Boolean(this.responser.avatar))
         {
            this.responser.avatar.removeCustomAttributeListener(ProposalManager.PROPOSAL_ATTR,this.onResponserAttributeChanged);
            this.responserHolder = null;
         }
         this.npcNotifier.reset();
      }
      
      protected function onRemovedResponser(param1:HolderSceneObjectEvent) : void
      {
         trace("ProposalRoomViewManager > onRemoved > doctor = [" + this.responser + "]");
         if(this.responser)
         {
            trace("ProposalRoomViewManager > onRemoved > doctor.avatar = [" + this.responser.avatar + "]");
            if(this.responser.avatar)
            {
               this.responser.avatar.removeCustomAttributeListener(ProposalManager.PROPOSAL_ATTR,this.onResponserAttributeChanged);
            }
            if(Boolean(this.proposer) && Boolean(this.proposer.avatar))
            {
               this.proposer.avatar.removeCustomAttributeListener(ProposalManager.PROPOSAL_ATTR,this.onProposerAttributeChanged);
            }
            if(api.roomView.userView == this.proposer)
            {
               trace("ProposalRoomViewManager > onRemoved > patient = [" + this.proposer + "]");
               this.removeContextualMenu(this.proposer);
            }
            else if(api.roomView.userView == this.responser)
            {
               trace("ProposalRoomViewManager > onRemoved > doctor = [" + this.responser + "]");
               this.removeContextualMenu(this.responser);
               this.timer.stop();
            }
         }
         else
         {
            trace("there\'s no Docctor defined");
         }
         proposalManager.reset();
         this.riggeed = false;
         this.responser = null;
      }
      
      override public function didntWork() : void
      {
         this.npcAdviser.say(ProposalNPCAdviserMessagesEnum.ERROR);
         this.contextualMenuManager.removeMenu(this.proposer);
         this.contextualMenuManager.removeMenu(this.responser);
         this.kick();
      }
      
      protected function setupTracking() : void
      {
         this.trackCategory = "FEATURES:" + viewDefinition.name.toUpperCase() + " :INTERACCION";
      }
      
      override protected function addAudioFeedback() : void
      {
         this.audioFeedback = new ProposalAudioFeedback(viewDefinition);
      }
      
      protected function delayedEvaluation() : void
      {
         clearTimeout(this.delayedEvaluationTimeoutId);
         if(Boolean(this.proposer) && Boolean(this.responser))
         {
            if(api.roomView.userView == this.responser || api.roomView.userView == this.proposer)
            {
               this.npcAdviser.say(ProposalNPCAdviserMessagesEnum.PROPOSAL_ACTION);
            }
            if(api.roomView.userView == this.responser)
            {
               proposalManager.proposerAttribute = this.proposer.avatar;
               this.proposer.avatar.removeCustomAttributeListener(ProposalManager.PROPOSAL_ATTR,this.onProposerAttributeChanged);
               this.proposer.avatar.addCustomAttributeListener(ProposalManager.PROPOSAL_ATTR,this.onProposerAttributeChanged);
            }
            else if(api.roomView.userView == this.proposer)
            {
               proposalManager.responserAttribute = this.responser.avatar;
               this.responser.avatar.removeCustomAttributeListener(ProposalManager.PROPOSAL_ATTR,this.onResponserAttributeChanged);
               this.responser.avatar.addCustomAttributeListener(ProposalManager.PROPOSAL_ATTR,this.onResponserAttributeChanged);
               this.showPatientContextualMenu();
            }
            this.riggeed = true;
         }
      }
      
      private function showDoctorContextualMenu() : void
      {
         var _loc1_:String = String(viewDefinition.data.responserContextualMenu);
         if(!_loc1_)
         {
            throw new Error("Invalid responserContextualMenu menu identifier. This identifier can´t be null or empty");
         }
         this.contextualMenuManager.addMenu(_loc1_,this.responser,this);
      }
      
      override public function addNotifier(param1:Sprite) : void
      {
         this.npcNotifier = new ProposalNpcNotifierController(param1);
      }
      
      override public function getProposal() : int
      {
         return proposalManager.getProposal();
      }
      
      protected function evalResult() : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:String = null;
         var _loc1_:Boolean = proposalManager.checkCoincidence();
         if(api.userView == this.proposer)
         {
            if(_loc1_)
            {
               _loc4_ = proposalManager.getSelectedProposalContent();
               _loc5_ = proposalManager.getSelectedResponseContent();
               if(_loc4_.keyCloth != _loc5_.keyCloth)
               {
                  api.setAvatarAttribute(_loc4_.keyCloth,"");
               }
               api.setAvatarAttribute(_loc5_.keyCloth,_loc5_.valueCloth);
            }
            _loc2_ = _loc1_ ? ProposalNPCAdviserMessagesEnum.PROPOSER_SACCESFULL_RESPONSE : ProposalNPCAdviserMessagesEnum.PROPOSER_WRONG_RESPONSE;
            _loc3_ = _loc1_ ? ProposalAudioEnum.PROPOSER_SACCESFULL_RESPONSE : ProposalAudioEnum.PROPOSER_WRONG_RESPONSE;
         }
         if(api.roomView.userView == this.responser)
         {
            _loc6_ = _loc1_ ? "responser_succes" : "responser_faild";
            this.scopedTrack(_loc6_);
            _loc2_ = _loc1_ ? ProposalNPCAdviserMessagesEnum.RESPONSER_SACCESFULL_RESPONSE : ProposalNPCAdviserMessagesEnum.RESPONSER_WRONG_RESPONSE;
            _loc3_ = _loc1_ ? ProposalAudioEnum.RESPONSER_SACCESFULL_RESPONSE : ProposalAudioEnum.RESPONSER_WRONG_RESPONSE;
         }
         this.npcAdviser.say(_loc2_);
         this.audioFeedback.play(_loc3_);
         this.timer.delay = 4000;
         this.timer.addEventListener(TimerEvent.TIMER,this.onMatchEnds);
         this.timer.start();
      }
      
      private function onAddedProposer(param1:HolderSceneObjectEvent) : void
      {
         var _loc2_:GaturroAvatarView = null;
         if(param1.sceneObject is GaturroAvatarView)
         {
            if(!this.proposer)
            {
               _loc2_ = GaturroAvatarView(param1.sceneObject);
               if(api.roomView.userView == _loc2_)
               {
                  if(!this.constraintManager.accomplishById(this.proposerContraint,_loc2_))
                  {
                     ++this.proposerFailedAttemptsCount;
                     this.trackFailedAttepmts(PATIENT,this.proposerFailedAttemptsCount);
                     this.adviseForDisability(ProposalViewConst.PROPOSAL_PROPOSER_HOLDER_VALUE);
                  }
                  else if(this.proposer)
                  {
                     this.kick();
                  }
                  else
                  {
                     this.proposer = _loc2_;
                     if(!this.responser)
                     {
                        this.npcAdviser.say(ProposalNPCAdviserMessagesEnum.NEEDS_RESPONSER);
                     }
                     this.scopedTrack("proposer_ocupaLugar");
                  }
               }
               else
               {
                  this.proposer = _loc2_;
               }
            }
            else
            {
               this.kick();
            }
         }
      }
      
      protected function onAdded(param1:HolderSceneObjectEvent) : void
      {
         if(Boolean(this.proposer) && Boolean(this.responser))
         {
            this.delayedEvaluationTimeoutId = setTimeout(this.delayedEvaluation,1000);
         }
      }
      
      private function adviseForDisability(param1:String) : void
      {
         if(param1 == ProposalViewConst.PROPOSAL_RESPONSER_HOLDER_VALUE)
         {
            this.npcAdviser.say(ProposalNPCAdviserMessagesEnum.USE_RESPONSER_SUIT);
         }
         else if(param1 == ProposalViewConst.PROPOSAL_PROPOSER_HOLDER_VALUE)
         {
            this.npcAdviser.say(ProposalNPCAdviserMessagesEnum.USE_PROPOSER_SUIT);
         }
         this.kick();
      }
   }
}

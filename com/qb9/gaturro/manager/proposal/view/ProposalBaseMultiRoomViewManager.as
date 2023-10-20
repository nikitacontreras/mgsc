package com.qb9.gaturro.manager.proposal.view
{
   import com.qb9.gaturro.event.HolderSceneObjectEvent;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.manager.proposal.constants.ProposalNPCAdviserMessagesEnum;
   import com.qb9.gaturro.model.config.proposal.ProposalViewDefinition;
   import com.qb9.mambo.core.attributes.events.CustomAttributeEvent;
   import flash.events.TimerEvent;
   
   public class ProposalBaseMultiRoomViewManager extends BaseProposalRoomViewManager
   {
      
      private static const INACTIVITY_TOLERANCE:int = 15000;
      
      private static const SECOND_INACTIVITY_TOLERANCE:int = 10000;
       
      
      private var roomTimer:com.qb9.gaturro.manager.proposal.view.ProposalRoomViewTimer;
      
      public function ProposalBaseMultiRoomViewManager(param1:ProposalViewDefinition)
      {
         super(param1);
         this.roomTimer = new com.qb9.gaturro.manager.proposal.view.ProposalRoomViewTimer();
      }
      
      private function onDidntResponseMessage(param1:TimerEvent) : void
      {
         this.roomTimer.startTimer(SECOND_INACTIVITY_TOLERANCE,this.onDidntResponseKick,com.qb9.gaturro.manager.proposal.view.ProposalRoomViewTimer.WAITTING_RESPONSE_KICK);
         npcAdviser.say(ProposalNPCAdviserMessagesEnum.PROMPT);
      }
      
      override protected function onAdded(param1:HolderSceneObjectEvent) : void
      {
         super.onAdded(param1);
         if(api.roomView.userView == responser || api.roomView.userView == proposer)
         {
            if(Boolean(proposer) && Boolean(responser))
            {
               if(this.roomTimer.state == com.qb9.gaturro.manager.proposal.view.ProposalRoomViewTimer.WAITTING_COMPANION_MESSAGE || this.roomTimer.state == com.qb9.gaturro.manager.proposal.view.ProposalRoomViewTimer.WAITTING_COMPANION_KICK)
               {
                  this.roomTimer.stopTimer();
               }
               if(api.roomView.userView == proposer)
               {
                  this.roomTimer.startTimer(INACTIVITY_TOLERANCE,this.onDidntStartPlayMessage,com.qb9.gaturro.manager.proposal.view.ProposalRoomViewTimer.WAITTING_PROPOSAL_MESSAGE);
               }
            }
            else
            {
               this.roomTimer.startTimer(INACTIVITY_TOLERANCE,this.onDidntGetCompanionMessage,com.qb9.gaturro.manager.proposal.view.ProposalRoomViewTimer.WAITTING_COMPANION_MESSAGE);
            }
         }
      }
      
      private function onDidntGetCompanionKick(param1:TimerEvent) : void
      {
         var _loc2_:String = !!proposer ? "proposer_noContraparte" : "responser_noContraparte";
         scopedTrack("expulsion_" + _loc2_);
         this.roomTimer.stopTimer();
         this.kick();
      }
      
      private function onDidntGetProposerMessage(param1:TimerEvent) : void
      {
         this.roomTimer.startTimer(SECOND_INACTIVITY_TOLERANCE,this.onDidntGetCompanionKick,com.qb9.gaturro.manager.proposal.view.ProposalRoomViewTimer.WAITTING_COMPANION_KICK);
         npcAdviser.say(ProposalNPCAdviserMessagesEnum.NEEDS_PROPOSER);
      }
      
      override public function dispose() : void
      {
         if(this.roomTimer)
         {
            this.roomTimer.dispose();
            this.roomTimer = null;
         }
         super.dispose();
      }
      
      override public function response(param1:int) : void
      {
         if(this.roomTimer.state == com.qb9.gaturro.manager.proposal.view.ProposalRoomViewTimer.WAITTING_RESPONSE_MESSAGE || this.roomTimer.state == com.qb9.gaturro.manager.proposal.view.ProposalRoomViewTimer.WAITTING_RESPONSE_KICK)
         {
            this.roomTimer.stopTimer();
         }
         super.response(param1);
      }
      
      private function onDidntGetCompanionMessage(param1:TimerEvent) : void
      {
         this.roomTimer.startTimer(SECOND_INACTIVITY_TOLERANCE,this.onDidntGetCompanionKick,com.qb9.gaturro.manager.proposal.view.ProposalRoomViewTimer.WAITTING_COMPANION_KICK);
         npcAdviser.say(ProposalNPCAdviserMessagesEnum.PROMPT);
      }
      
      override protected function kick() : void
      {
         api.moveToTileXY(api.userAvatar.coord.x,api.userAvatar.coord.y - 3);
      }
      
      private function onDidntGetResponserMessage(param1:TimerEvent) : void
      {
         this.roomTimer.startTimer(SECOND_INACTIVITY_TOLERANCE,this.onDidntGetCompanionKick,com.qb9.gaturro.manager.proposal.view.ProposalRoomViewTimer.WAITTING_COMPANION_KICK);
         npcAdviser.say(ProposalNPCAdviserMessagesEnum.NEEDS_RESPONSER);
      }
      
      override protected function restart() : void
      {
         this.kick();
      }
      
      override protected function onRemovedResponser(param1:HolderSceneObjectEvent) : void
      {
         this.roomTimer.stopTimer();
         if(api.roomView.userView == proposer)
         {
            this.roomTimer.startTimer(INACTIVITY_TOLERANCE,this.onDidntGetResponserMessage,com.qb9.gaturro.manager.proposal.view.ProposalRoomViewTimer.WAITTING_COMPANION_MESSAGE);
         }
         super.onRemovedResponser(param1);
      }
      
      override protected function evalResult() : void
      {
         if(api.roomView.userView == responser || api.roomView.userView == proposer)
         {
            super.evalResult();
         }
      }
      
      override protected function onProposerAttributeChanged(param1:CustomAttributeEvent) : void
      {
         super.onProposerAttributeChanged(param1);
         if(api.roomView.userView == responser)
         {
            this.roomTimer.startTimer(INACTIVITY_TOLERANCE,this.onDidntResponseMessage,com.qb9.gaturro.manager.proposal.view.ProposalRoomViewTimer.WAITTING_RESPONSE_MESSAGE);
         }
      }
      
      override protected function onRemovedProposer(param1:HolderSceneObjectEvent) : void
      {
         this.roomTimer.stopTimer();
         if(api.roomView.userView == responser)
         {
            this.roomTimer.startTimer(INACTIVITY_TOLERANCE,this.onDidntGetProposerMessage,com.qb9.gaturro.manager.proposal.view.ProposalRoomViewTimer.WAITTING_COMPANION_MESSAGE);
         }
         super.onRemovedProposer(param1);
      }
      
      private function onDidntStartPlayKick(param1:TimerEvent) : void
      {
         scopedTrack("multi_responser_noAccion");
         this.roomTimer.stopTimer();
         this.kick();
      }
      
      private function onDidntStartPlayMessage(param1:TimerEvent) : void
      {
         this.roomTimer.startTimer(SECOND_INACTIVITY_TOLERANCE,this.onDidntStartPlayKick,com.qb9.gaturro.manager.proposal.view.ProposalRoomViewTimer.WAITTING_PROPOSAL_KICK);
         npcAdviser.say(ProposalNPCAdviserMessagesEnum.PROMPT);
      }
      
      private function onDidntResponseKick(param1:TimerEvent) : void
      {
         scopedTrack("multi_proposer_noAccion");
         this.roomTimer.stopTimer();
         this.kick();
      }
      
      override public function propose(param1:int) : void
      {
         if(this.roomTimer.state == com.qb9.gaturro.manager.proposal.view.ProposalRoomViewTimer.WAITTING_PROPOSAL_MESSAGE || this.roomTimer.state == com.qb9.gaturro.manager.proposal.view.ProposalRoomViewTimer.WAITTING_PROPOSAL_KICK)
         {
            this.roomTimer.stopTimer();
         }
         super.propose(param1);
      }
   }
}

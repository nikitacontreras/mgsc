package com.qb9.gaturro.model.config.proposal
{
   import com.qb9.gaturro.commons.model.config.BaseSettingsConfig;
   import com.qb9.gaturro.globals.logger;
   import flash.utils.Dictionary;
   
   public class ProposalConfig extends BaseSettingsConfig
   {
       
      
      private var mapViewByName:Dictionary;
      
      private var mapViewByCode:Dictionary;
      
      private var mapModel:Dictionary;
      
      public function ProposalConfig()
      {
         super();
      }
      
      private function getProposalViewDefinition(param1:Object) : ProposalViewDefinition
      {
         var _loc2_:ProposalViewDefinition = new ProposalViewDefinition(param1.proposalCode,param1.proposalName);
         _loc2_.singleRoomViewManager = param1.singleRoomViewManager;
         _loc2_.timedRoomViewManager = param1.timedRoomViewManager;
         _loc2_.data = param1.data;
         _loc2_.proposerAvailableConstraint = param1.proposerAvailableConstraint;
         _loc2_.responserAvailableContraint = param1.responserAvailableContraint;
         _loc2_.feedbackMessage = this.getFeedback(param1.feedbackMessage);
         _loc2_.feedbackAudio = this.getFeedback(param1.feedbackAudio);
         return _loc2_;
      }
      
      private function getProposalDefinition(param1:Object) : ProposalDefinition
      {
         var _loc3_:ProposalItemDefinition = null;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc2_:ProposalDefinition = new ProposalDefinition(param1.code,param1.name);
         for each(_loc4_ in param1.proposals)
         {
            _loc3_ = new ProposalItemDefinition(_loc4_.code,_loc4_.content);
            _loc2_.addProposal(_loc3_);
         }
         for each(_loc5_ in param1.answers)
         {
            _loc3_ = new ProposalItemDefinition(_loc5_.code,_loc5_.content);
            _loc2_.addResponse(_loc3_);
         }
         return _loc2_;
      }
      
      private function getFeedback(param1:Object) : Dictionary
      {
         var _loc3_:String = null;
         var _loc2_:Dictionary = new Dictionary();
         for(_loc3_ in param1)
         {
            _loc2_[_loc3_] = param1[_loc3_];
         }
         return _loc2_;
      }
      
      private function setupView() : void
      {
         var _loc1_:ProposalViewDefinition = null;
         var _loc2_:Object = null;
         this.mapViewByCode = new Dictionary();
         this.mapViewByName = new Dictionary();
         for each(_loc2_ in _settings.view)
         {
            _loc1_ = this.getProposalViewDefinition(_loc2_);
            this.mapViewByCode[_loc1_.code] = _loc1_;
            this.mapViewByName[_loc1_.name] = _loc1_;
         }
      }
      
      public function getProposalByCode(param1:int) : ProposalDefinition
      {
         var _loc2_:ProposalDefinition = this.mapModel[param1];
         if(!_loc2_)
         {
            logger.debug("There\'s no definition with the code: " + param1);
            throw new Error("There\'s no definition with the code: " + param1);
         }
         return _loc2_;
      }
      
      public function getViewDefinitionByName(param1:String) : ProposalViewDefinition
      {
         var _loc2_:ProposalViewDefinition = this.mapViewByName[param1];
         if(!_loc2_)
         {
            logger.debug("There\'s no definition with the name: " + param1);
            throw new Error("There\'s no definition with the name: " + param1);
         }
         return _loc2_;
      }
      
      public function getViewDefinitionByCode(param1:int) : ProposalViewDefinition
      {
         var _loc2_:ProposalViewDefinition = this.mapViewByCode[param1];
         if(!_loc2_)
         {
            logger.debug("There\'s no definition with the code: " + param1);
            throw new Error("There\'s no definition with the code: " + param1);
         }
         return _loc2_;
      }
      
      public function getAnswer(param1:int, param2:int) : ProposalItemDefinition
      {
         var _loc3_:ProposalDefinition = this.getProposalByCode(param1);
         return _loc3_.getProposal(param2);
      }
      
      override public function set settings(param1:Object) : void
      {
         super.settings = param1;
         this.setup();
      }
      
      private function setupModel() : void
      {
         var _loc1_:ProposalDefinition = null;
         var _loc2_:Object = null;
         this.mapModel = new Dictionary();
         for each(_loc2_ in _settings.definition)
         {
            _loc1_ = this.getProposalDefinition(_loc2_);
            this.mapModel[_loc1_.code] = _loc1_;
         }
      }
      
      private function setup() : void
      {
         this.setupModel();
         this.setupView();
      }
   }
}

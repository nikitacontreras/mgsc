package com.qb9.gaturro.manager.proposal
{
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.dispose.ICheckableDisposable;
   import com.qb9.gaturro.model.config.proposal.ProposalConfig;
   import com.qb9.gaturro.model.config.proposal.ProposalDefinition;
   import com.qb9.gaturro.model.config.proposal.ProposalItemDefinition;
   import com.qb9.mambo.core.objects.BaseCustomAttributeDispatcher;
   
   public class ProposalManager implements ICheckableDisposable
   {
      
      public static const PROPOSAL_ATTR:String = "proposal";
       
      
      private var _disposed:Boolean;
      
      private var _config:ProposalConfig;
      
      private var model:ProposalModel;
      
      private var proposalCode:int;
      
      public function ProposalManager(param1:int)
      {
         super();
         this.proposalCode = param1;
         this._config = Context.instance.getByType(ProposalConfig) as ProposalConfig;
         this.model = this.getModel(param1);
      }
      
      public function response(param1:int) : void
      {
         this.model.response = param1;
      }
      
      public function reset() : void
      {
         this.model.reset();
      }
      
      public function set proposerAttribute(param1:BaseCustomAttributeDispatcher) : void
      {
         this.model.proposerAttribute = param1;
      }
      
      public function resetResponserAttr() : void
      {
         this.model.resetResponserAttr();
      }
      
      public function getSelectedProposalContent() : Object
      {
         var _loc1_:ProposalItemDefinition = this.model.getSelectedProposalDefinition();
         return _loc1_.content;
      }
      
      public function set responserAttribute(param1:BaseCustomAttributeDispatcher) : void
      {
         this.model.responserAttribute = param1;
      }
      
      public function get disposed() : Boolean
      {
         return this._disposed;
      }
      
      public function dispose() : void
      {
         this.model.dispose();
         this._disposed = true;
      }
      
      public function getSelectedResponseContent() : Object
      {
         var _loc1_:ProposalItemDefinition = this.model.getSelectedResponseDefinition();
         return _loc1_.content;
      }
      
      public function getProposal() : int
      {
         return this.model.proposal;
      }
      
      public function checkCoincidence() : Boolean
      {
         return this.model.coinciding();
      }
      
      private function getModel(param1:int) : ProposalModel
      {
         var _loc2_:ProposalDefinition = this._config.getProposalByCode(param1);
         this.model = new ProposalModel(_loc2_);
         return this.model;
      }
      
      public function resetProposerAttr() : void
      {
         this.model.resetProposerAttr();
      }
      
      public function resetResponse() : void
      {
         this.model.resetResponse();
      }
      
      public function resetProposal() : void
      {
         this.model.resetProposal();
      }
      
      public function getAnswer() : int
      {
         return this.model.response;
      }
      
      public function propose(param1:int) : void
      {
         this.model.proposal = param1;
      }
   }
}

import com.adobe.serialization.json.JSON;
import com.qb9.gaturro.commons.dispose.ICheckableDisposable;
import com.qb9.gaturro.globals.api;
import com.qb9.gaturro.globals.logger;
import com.qb9.gaturro.manager.proposal.ProposalManager;
import com.qb9.gaturro.model.config.proposal.ProposalDefinition;
import com.qb9.gaturro.model.config.proposal.ProposalItemDefinition;
import com.qb9.mambo.core.attributes.events.CustomAttributeEvent;
import com.qb9.mambo.core.objects.BaseCustomAttributeDispatcher;

class ProposalModel implements ICheckableDisposable
{
   
   private static const ITEM:String = "item_";
    
   
   private var proposalSetted:Boolean;
   
   private var _disposed:Boolean;
   
   private var def:ProposalDefinition;
   
   private var _proposerAttribute:BaseCustomAttributeDispatcher;
   
   private var _proposal:int;
   
   private var responseSetted:Boolean;
   
   private var _response:int;
   
   private var _responserAttribute:BaseCustomAttributeDispatcher;
   
   public function ProposalModel(param1:ProposalDefinition)
   {
      super();
      this.def = param1;
   }
   
   public function get response() : int
   {
      var _loc1_:int = 0;
      var _loc2_:String = null;
      var _loc3_:Object = null;
      if(this._responserAttribute)
      {
         _loc1_ = int(this._response);
      }
      else
      {
         _loc2_ = String(this.property(this.def.code));
         _loc3_ = this.proposalAttr;
         if(!_loc3_[_loc2_])
         {
            _loc3_[_loc2_] = new Object();
            _loc1_ = -1;
         }
         else
         {
            _loc1_ = int(_loc3_[_loc2_].response);
         }
      }
      return _loc1_;
   }
   
   public function set response(param1:int) : void
   {
      var _loc2_:String = null;
      var _loc3_:Object = null;
      if(this._responserAttribute)
      {
         this._response = param1;
      }
      else
      {
         _loc2_ = String(this.property(this.def.code));
         _loc3_ = this.proposalAttr;
         if(!_loc3_[_loc2_])
         {
            _loc3_[_loc2_] = new Object();
         }
         _loc3_[_loc2_].response = param1;
         this.setAttribute(_loc3_);
      }
   }
   
   private function onProposerAttributeChanged(param1:CustomAttributeEvent) : void
   {
      var _loc2_:Object = com.adobe.serialization.json.JSON.decode(param1.attribute.value.toString());
      var _loc3_:String = String(this.property(this.def.code));
      var _loc4_:int = int(_loc2_[_loc3_].proposal);
      this.proposal = _loc4_;
   }
   
   public function reset() : void
   {
      this.resetResponse();
      this.resetProposal();
      this.resetProposerAttr();
      this.resetResponserAttr();
   }
   
   private function set proposerAttribute(param1:BaseCustomAttributeDispatcher) : void
   {
      this._proposerAttribute = param1;
      this._proposerAttribute.addCustomAttributeListener(ProposalManager.PROPOSAL_ATTR,this.onProposerAttributeChanged);
      this.proposalSetted = true;
   }
   
   public function resetResponserAttr() : void
   {
      trace("ProposalModel > resetResponserAttr");
      if(this.responseSetted)
      {
         this._responserAttribute.removeCustomAttributeListener(ProposalManager.PROPOSAL_ATTR,this.onResponserAttributeChanged);
         this._responserAttribute = null;
         this.responseSetted = false;
      }
   }
   
   private function property(param1:int) : String
   {
      return ITEM + param1;
   }
   
   public function getSelectedProposalDefinition() : ProposalItemDefinition
   {
      var _loc1_:int = int(this.proposal);
      return this.def.getProposal(_loc1_);
   }
   
   private function setAttribute(param1:Object) : void
   {
      var _loc2_:String = com.adobe.serialization.json.JSON.encode(param1);
      api.setAvatarAttribute(ProposalManager.PROPOSAL_ATTR,_loc2_);
   }
   
   private function get proposalAttr() : Object
   {
      var _loc2_:Object = null;
      var _loc1_:Object = api.getAvatarAttribute(ProposalManager.PROPOSAL_ATTR);
      if(_loc1_)
      {
         _loc2_ = com.adobe.serialization.json.JSON.decode(_loc1_.toString());
      }
      trace("ProposalModel > proposalAttr [" + _loc2_ + "]");
      return !!_loc2_ ? _loc2_ : new Object();
   }
   
   private function set responserAttribute(param1:BaseCustomAttributeDispatcher) : void
   {
      this._responserAttribute = param1;
      this._responserAttribute.addCustomAttributeListener(ProposalManager.PROPOSAL_ATTR,this.onResponserAttributeChanged);
      this.responseSetted = true;
   }
   
   public function resetProposal() : void
   {
      trace("ProposalModel > resetProposal");
      this.proposal = -1;
   }
   
   public function getSelectedResponseDefinition() : ProposalItemDefinition
   {
      var _loc1_:int = int(this.response);
      return this.def.getResponse(_loc1_);
   }
   
   public function dispose() : void
   {
      this.reset();
      this.def = null;
      this._disposed = true;
   }
   
   public function set proposal(param1:int) : void
   {
      var _loc2_:String = null;
      var _loc3_:Object = null;
      if(this._proposerAttribute)
      {
         this._proposal = param1;
      }
      else
      {
         _loc2_ = String(this.property(this.def.code));
         _loc3_ = this.proposalAttr;
         if(!_loc3_[_loc2_])
         {
            _loc3_[_loc2_] = new Object();
         }
         _loc3_[_loc2_].proposal = param1;
         this.setAttribute(_loc3_);
      }
   }
   
   private function onResponserAttributeChanged(param1:CustomAttributeEvent) : void
   {
      var _loc2_:Object = com.adobe.serialization.json.JSON.decode(param1.attribute.value.toString());
      var _loc3_:String = String(this.property(this.def.code));
      var _loc4_:int = int(_loc2_[_loc3_].response);
      this.response = _loc4_;
   }
   
   public function resetResponse() : void
   {
      this.response = -1;
   }
   
   public function get proposal() : int
   {
      var _loc1_:int = 0;
      var _loc2_:String = null;
      var _loc3_:Object = null;
      if(this._proposerAttribute)
      {
         _loc1_ = int(this._proposal);
      }
      else
      {
         _loc2_ = String(this.property(this.def.code));
         _loc3_ = this.proposalAttr;
         if(!_loc3_[_loc2_])
         {
            _loc3_[_loc2_] = new Object();
            _loc1_ = -1;
         }
         else
         {
            _loc1_ = int(_loc3_[_loc2_].proposal);
         }
      }
      return _loc1_;
   }
   
   public function resetProposerAttr() : void
   {
      trace("ProposalModel > resetProposerAttr");
      if(this.proposalSetted)
      {
         this._proposerAttribute.removeCustomAttributeListener(ProposalManager.PROPOSAL_ATTR,this.onProposerAttributeChanged);
         this._proposerAttribute = null;
         this.proposalSetted = false;
      }
   }
   
   public function coinciding() : Boolean
   {
      if(!this.response == -1)
      {
         logger.debug("There isn\'t asnwer configured");
         throw new Error("There isn\'t asnwer configured");
      }
      if(!this.proposal == -1)
      {
         logger.debug("There isn\'t proposal configured ");
         logger.debug("There isn\'t proposal configured ");
         throw new Error("There isn\'t proposal configured ");
      }
      var _loc1_:int = int(this.proposal);
      return this.response == this.def.getProposal(_loc1_).code;
   }
   
   public function get disposed() : Boolean
   {
      return this._disposed;
   }
}

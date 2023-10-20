package com.qb9.gaturro.model.config.proposal
{
   import com.qb9.gaturro.commons.model.definition.IDefinition;
   import flash.utils.Dictionary;
   
   public class ProposalDefinition implements IDefinition
   {
       
      
      private var _name:String;
      
      private var _code:int;
      
      private var proposalMap:Dictionary;
      
      private var responseMap:Dictionary;
      
      public function ProposalDefinition(param1:int, param2:String)
      {
         super();
         this._name = param2;
         this._code = param1;
         this.proposalMap = new Dictionary();
         this.responseMap = new Dictionary();
      }
      
      public function addResponse(param1:ProposalItemDefinition) : void
      {
         this.responseMap[param1.code] = param1;
      }
      
      public function getProposal(param1:int) : ProposalItemDefinition
      {
         var _loc2_:ProposalItemDefinition = this.proposalMap[param1];
         if(!_loc2_)
         {
            throw new Error("There is no definition with the code: " + param1);
         }
         return _loc2_;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get code() : int
      {
         return this._code;
      }
      
      public function getResponse(param1:int) : ProposalItemDefinition
      {
         var _loc2_:ProposalItemDefinition = this.responseMap[param1];
         if(!_loc2_)
         {
            throw new Error("There is no definition with the code: " + param1);
         }
         return _loc2_;
      }
      
      public function addProposal(param1:ProposalItemDefinition) : void
      {
         this.proposalMap[param1.code] = param1;
      }
   }
}

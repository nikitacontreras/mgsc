package com.qb9.gaturro.manager.proposal.constants
{
   import flash.errors.IllegalOperationError;
   
   public class ProposalViewConst
   {
      
      public static const PROPOSAL_RESPONSER_HOLDER_VALUE:String = "responser";
      
      public static const PROPOSAL_PROPOSER_HOLDER_VALUE:String = "proposer";
      
      public static const PROPOSAL_FEATURE_ADVISER_VALUE:String = "adviser";
      
      public static const PROPOSAL_FEATURE:String = "proposalFeature";
      
      public static const PROPOSAL_FEATURE_NOTIFIER_VALUE:String = "notifier";
      
      public static const PROPOSAL_HOLDER:String = "proposalHolder";
       
      
      public function ProposalViewConst()
      {
         super();
         throw new IllegalOperationError("This class shouldn´t be instatiated");
      }
   }
}

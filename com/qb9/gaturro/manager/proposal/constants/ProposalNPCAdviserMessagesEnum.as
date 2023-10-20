package com.qb9.gaturro.manager.proposal.constants
{
   import flash.errors.IllegalOperationError;
   
   public class ProposalNPCAdviserMessagesEnum
   {
      
      public static const RESPONSER_WRONG_RESPONSE:String = "proposerWrongResponse";
      
      public static const RESPONSER_SACCESFULL_RESPONSE:String = "responserSuccesfulResponse";
      
      public static const PROPOSER_SACCESFULL_RESPONSE:String = "proposerSuccesfulResponse";
      
      public static const TIME_REACHED:String = "timeReached";
      
      public static const PROPOSER_WRONG_RESPONSE:String = "responserWrongResponse";
      
      public static const USE_PROPOSER_SUIT:String = "useProposerSuit";
      
      public static const PROPOSAL_ACTION:String = "proposalAction";
      
      public static const PROMPT:String = "prompt";
      
      public static const NEEDS_RESPONSER:String = "needsResponser";
      
      public static const USE_RESPONSER_SUIT:String = "useResponserSuit";
      
      public static const RESPONSE_ACTION:String = "responseAction";
      
      public static const NEEDS_PROPOSER:String = "needsProposer";
      
      public static const ERROR:String = "error";
       
      
      public function ProposalNPCAdviserMessagesEnum()
      {
         super();
         throw new IllegalOperationError("This class shouldn´t be instatiated");
      }
   }
}

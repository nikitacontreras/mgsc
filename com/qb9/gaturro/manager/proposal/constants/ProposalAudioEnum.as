package com.qb9.gaturro.manager.proposal.constants
{
   import flash.errors.IllegalOperationError;
   
   public class ProposalAudioEnum
   {
      
      public static const RESPONSER_WRONG_RESPONSE:String = "proposerWrongResponse";
      
      public static const RESPONSER_SACCESFULL_RESPONSE:String = "responserSuccesfulResponse";
      
      public static const PROPOSER_SACCESFULL_RESPONSE:String = "proposerSuccesfulResponse";
      
      public static const PROPOSER_WRONG_RESPONSE:String = "responserWrongResponse";
       
      
      public function ProposalAudioEnum()
      {
         super();
         throw new IllegalOperationError("This class shouldn´t be instatiated");
      }
   }
}

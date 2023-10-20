package com.qb9.gaturro.manager.proposal.view.audio
{
   import com.qb9.gaturro.globals.audio;
   import com.qb9.gaturro.model.config.proposal.ProposalViewDefinition;
   
   public class ProposalAudioFeedback
   {
       
      
      protected var viewDefinition:ProposalViewDefinition;
      
      public function ProposalAudioFeedback(param1:ProposalViewDefinition)
      {
         super();
         this.viewDefinition = param1;
      }
      
      public function stop(param1:String) : void
      {
         var _loc2_:String = this.viewDefinition.getFeedbackAudio(param1);
         audio.stop(_loc2_);
      }
      
      public function play(param1:String) : void
      {
         var _loc2_:String = this.viewDefinition.getFeedbackAudio(param1);
         if(!this.hasSound(_loc2_))
         {
            this.registerSound(_loc2_);
         }
         audio.play(_loc2_);
      }
      
      private function hasSound(param1:String) : Boolean
      {
         return audio.has(param1);
      }
      
      private function registerSound(param1:String, param2:String = null) : void
      {
         if(!this.hasSound(param1))
         {
            audio.register(param1,param2).start();
         }
      }
   }
}

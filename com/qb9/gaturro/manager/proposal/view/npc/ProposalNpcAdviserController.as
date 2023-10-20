package com.qb9.gaturro.manager.proposal.view.npc
{
   import com.qb9.gaturro.model.config.proposal.ProposalViewDefinition;
   import com.qb9.gaturro.view.world.chat.LocalChatBallon;
   import flash.display.Sprite;
   
   public class ProposalNpcAdviserController
   {
       
      
      private var definition:ProposalViewDefinition;
      
      private var _disposed:Boolean;
      
      private var chat:LocalChatBallon;
      
      private var owner:Sprite;
      
      public function ProposalNpcAdviserController(param1:Sprite, param2:ProposalViewDefinition)
      {
         super();
         this.definition = param2;
         this.owner = param1;
         this.setup();
      }
      
      public function get disposed() : Boolean
      {
         return this._disposed;
      }
      
      public function say(param1:String) : void
      {
         var _loc2_:String = this.definition.getFeedbackMessage(param1);
         this.chat.say(_loc2_);
      }
      
      private function setup() : void
      {
         this.chat = new LocalChatBallon(this.owner);
      }
      
      public function dispose() : void
      {
         this.chat.dispose();
         this._disposed = true;
      }
   }
}

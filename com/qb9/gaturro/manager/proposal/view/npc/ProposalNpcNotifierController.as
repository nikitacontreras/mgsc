package com.qb9.gaturro.manager.proposal.view.npc
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class ProposalNpcNotifierController
   {
      
      private static const STAND_BY:String = "standBy";
       
      
      private var answerView:MovieClip;
      
      private var _disposed:Boolean;
      
      private var view:Sprite;
      
      private var proposalView:MovieClip;
      
      public function ProposalNpcNotifierController(param1:Sprite)
      {
         super();
         this.view = param1;
         this.setup();
      }
      
      public function get disposed() : Boolean
      {
         return this._disposed;
      }
      
      public function showProposal(param1:int) : void
      {
         this.proposalView.gotoAndStop(param1);
      }
      
      public function reset() : void
      {
         this.proposalView.gotoAndStop(STAND_BY);
         this.answerView.gotoAndStop(STAND_BY);
      }
      
      public function showAnswer(param1:int) : void
      {
         this.answerView.gotoAndStop(param1);
      }
      
      private function setup() : void
      {
         this.proposalView = this.view.getChildByName("proposalView") as MovieClip;
         this.answerView = this.view.getChildByName("answerView") as MovieClip;
         this.reset();
      }
      
      public function dispose() : void
      {
         this.proposalView = null;
         this.answerView = null;
         this._disposed = true;
      }
   }
}

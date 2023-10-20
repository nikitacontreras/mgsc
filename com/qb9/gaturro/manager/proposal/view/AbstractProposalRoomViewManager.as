package com.qb9.gaturro.manager.proposal.view
{
   import com.qb9.gaturro.commons.dispose.ICheckableDisposable;
   import com.qb9.gaturro.manager.proposal.ProposalManager;
   import com.qb9.gaturro.model.config.proposal.ProposalViewDefinition;
   import com.qb9.gaturro.view.world.elements.HolderRoomSceneObjectView;
   import flash.display.Sprite;
   import flash.errors.IllegalOperationError;
   
   public class AbstractProposalRoomViewManager implements ICheckableDisposable, IProposalIRoomViewManager
   {
       
      
      private var _disposed:Boolean;
      
      protected var viewDefinition:ProposalViewDefinition;
      
      protected var _proposalManager:ProposalManager;
      
      public function AbstractProposalRoomViewManager(param1:ProposalViewDefinition)
      {
         super();
         this.viewDefinition = param1;
      }
      
      public function propose(param1:int) : void
      {
         throw new IllegalOperationError("This is an abstractad method and should be instatiated by subclass.");
      }
      
      public function reset() : void
      {
         throw new IllegalOperationError("This is an abstractad method and should be instatiated by subclass.");
      }
      
      public function response(param1:int) : void
      {
         throw new IllegalOperationError("This is an abstractad method and should be instatiated by subclass.");
      }
      
      protected function addAudioFeedback() : void
      {
      }
      
      public function get proposalManager() : ProposalManager
      {
         return this._proposalManager;
      }
      
      public function get disposed() : Boolean
      {
         return this._disposed;
      }
      
      public function dispose() : void
      {
         this._proposalManager.dispose();
         this._proposalManager = null;
         this._disposed = true;
      }
      
      public function addAdviser(param1:Sprite) : void
      {
         throw new IllegalOperationError("This is an abstractad method and should be instatiated by subclass.");
      }
      
      public function addHolder(param1:HolderRoomSceneObjectView, param2:String) : void
      {
         throw new IllegalOperationError("This is an abstractad method and should be instatiated by subclass.");
      }
      
      public function addNotifier(param1:Sprite) : void
      {
         throw new IllegalOperationError("This is an abstractad method and should be instatiated by subclass.");
      }
      
      public function getProposal() : int
      {
         throw new IllegalOperationError("This is an abstractad method and should be instatiated by subclass.");
      }
      
      public function didntWork() : void
      {
         throw new IllegalOperationError("This is an abstractad method and should be instatiated by subclass.");
      }
      
      public function set proposalManager(param1:ProposalManager) : void
      {
         this._proposalManager = param1;
      }
   }
}

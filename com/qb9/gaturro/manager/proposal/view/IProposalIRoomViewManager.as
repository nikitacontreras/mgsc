package com.qb9.gaturro.manager.proposal.view
{
   import com.qb9.gaturro.view.world.elements.HolderRoomSceneObjectView;
   import flash.display.Sprite;
   
   public interface IProposalIRoomViewManager
   {
       
      
      function response(param1:int) : void;
      
      function addNotifier(param1:Sprite) : void;
      
      function getProposal() : int;
      
      function addAdviser(param1:Sprite) : void;
      
      function addHolder(param1:HolderRoomSceneObjectView, param2:String) : void;
      
      function propose(param1:int) : void;
      
      function reset() : void;
   }
}

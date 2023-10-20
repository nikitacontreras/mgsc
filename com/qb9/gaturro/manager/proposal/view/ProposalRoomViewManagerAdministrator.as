package com.qb9.gaturro.manager.proposal.view
{
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.dispose.ICheckableDisposable;
   import com.qb9.gaturro.commons.event.ContextEvent;
   import com.qb9.mambo.world.core.events.GeneralEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   
   public class ProposalRoomViewManagerAdministrator extends EventDispatcher implements ICheckableDisposable
   {
       
      
      private var map:Dictionary;
      
      private var _disposed:Boolean;
      
      private var proposalFeature:String;
      
      private var propsalRoomViewManagerFactory:com.qb9.gaturro.manager.proposal.view.ProposalRoomViewManagerFactory;
      
      private var _ready:Boolean;
      
      public function ProposalRoomViewManagerAdministrator(param1:String)
      {
         super();
         this.proposalFeature = param1;
         this.map = new Dictionary();
         this.setupFactory();
      }
      
      private function onAdded(param1:ContextEvent) : void
      {
         if(param1.instanceType == com.qb9.gaturro.manager.proposal.view.ProposalRoomViewManagerFactory)
         {
            Context.instance.removeEventListener(ContextEvent.ADDED,this.onAdded);
            this.propsalRoomViewManagerFactory = Context.instance.getByType(com.qb9.gaturro.manager.proposal.view.ProposalRoomViewManagerFactory) as com.qb9.gaturro.manager.proposal.view.ProposalRoomViewManagerFactory;
            this.setReady();
         }
      }
      
      public function get disposed() : Boolean
      {
         return this._disposed;
      }
      
      public function dispose() : void
      {
         var _loc1_:AbstractProposalRoomViewManager = null;
         this.propsalRoomViewManagerFactory = null;
         for each(_loc1_ in this.map)
         {
            _loc1_.dispose();
         }
         this.map = null;
         this._disposed = true;
      }
      
      public function get ready() : Boolean
      {
         return this._ready;
      }
      
      private function setupFactory() : void
      {
         if(Context.instance.hasByType(com.qb9.gaturro.manager.proposal.view.ProposalRoomViewManagerFactory))
         {
            this.propsalRoomViewManagerFactory = Context.instance.getByType(com.qb9.gaturro.manager.proposal.view.ProposalRoomViewManagerFactory) as com.qb9.gaturro.manager.proposal.view.ProposalRoomViewManagerFactory;
            this.setReady();
         }
         else
         {
            Context.instance.addEventListener(ContextEvent.ADDED,this.onAdded);
         }
      }
      
      private function setReady() : void
      {
         this._ready = true;
         dispatchEvent(new Event(GeneralEvent.READY));
      }
      
      public function getManager(param1:String) : AbstractProposalRoomViewManager
      {
         var _loc2_:AbstractProposalRoomViewManager = this.map[param1];
         if(!_loc2_)
         {
            if(param1)
            {
               _loc2_ = this.propsalRoomViewManagerFactory.buildMulti(this.proposalFeature);
            }
            else
            {
               _loc2_ = this.propsalRoomViewManagerFactory.buildSingle(this.proposalFeature);
            }
            this.map[param1] = _loc2_;
         }
         return _loc2_;
      }
   }
}

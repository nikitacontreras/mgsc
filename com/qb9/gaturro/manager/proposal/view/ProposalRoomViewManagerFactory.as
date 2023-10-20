package com.qb9.gaturro.manager.proposal.view
{
   import com.qb9.gaturro.commons.model.config.IConfig;
   import com.qb9.gaturro.commons.model.config.IConfigHolder;
   import com.qb9.gaturro.model.config.proposal.ProposalConfig;
   import com.qb9.gaturro.model.config.proposal.ProposalViewDefinition;
   import flash.utils.Dictionary;
   
   public class ProposalRoomViewManagerFactory implements IConfigHolder
   {
       
      
      private var _config:ProposalConfig;
      
      private var timedMap:Dictionary;
      
      private var singleMap:Dictionary;
      
      public function ProposalRoomViewManagerFactory()
      {
         super();
         this.setup();
      }
      
      public function set config(param1:IConfig) : void
      {
         this._config = param1 as ProposalConfig;
      }
      
      public function buildMulti(param1:String) : AbstractProposalRoomViewManager
      {
         var _loc2_:ProposalViewDefinition = this._config.getViewDefinitionByName(param1);
         var _loc3_:String = _loc2_.timedRoomViewManager;
         var _loc4_:Class = this.timedMap[_loc3_];
         return this.getInstance(_loc4_,param1);
      }
      
      private function setupSingle() : void
      {
         this.singleMap = new Dictionary();
         this.singleMap["base"] = BaseProposalRoomViewManager;
      }
      
      private function getInstance(param1:Class, param2:String) : AbstractProposalRoomViewManager
      {
         var _loc3_:ProposalViewDefinition = this._config.getViewDefinitionByName(param2);
         return new param1(_loc3_);
      }
      
      public function buildSingle(param1:String) : AbstractProposalRoomViewManager
      {
         var _loc2_:ProposalViewDefinition = this._config.getViewDefinitionByName(param1);
         var _loc3_:String = _loc2_.singleRoomViewManager;
         var _loc4_:Class = this.timedMap[_loc3_];
         return this.getInstance(_loc4_,param1);
      }
      
      private function setupMulti() : void
      {
         this.timedMap = new Dictionary();
         this.timedMap["base"] = ProposalBaseMultiRoomViewManager;
      }
      
      private function setup() : void
      {
         this.setupSingle();
         this.setupMulti();
      }
   }
}

package com.qb9.gaturro.model.config.proposal
{
   public class ProposalItemDefinition
   {
       
      
      private var _content:Object;
      
      private var _code:int;
      
      public function ProposalItemDefinition(param1:int, param2:Object)
      {
         super();
         this._code = param1;
         this._content = param2;
      }
      
      public function get content() : Object
      {
         return this._content;
      }
      
      public function get code() : int
      {
         return this._code;
      }
   }
}

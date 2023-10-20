package com.qb9.gaturro.quest.model
{
   public class CounterQuestDefinition
   {
       
      
      private var source:Object;
      
      public function CounterQuestDefinition(param1:Object)
      {
         super();
         this.source = param1;
      }
      
      public function get name() : String
      {
         return String(this.source.name) || "";
      }
      
      public function get amount() : int
      {
         return int(this.source.amount) || 0;
      }
      
      public function get hasDefinition() : Boolean
      {
         return this.source;
      }
      
      public function get key() : String
      {
         return String(this.source.key) || "";
      }
   }
}

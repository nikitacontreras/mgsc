package com.qb9.gaturro.quest.model
{
   public class EndDateQuestDefinition
   {
       
      
      private var source:Object;
      
      private var _date:Date;
      
      public function EndDateQuestDefinition(param1:Object)
      {
         super();
         this.source = param1;
         this.setupDate();
      }
      
      private function setupDate() : void
      {
         var _loc1_:Number = Date.parse(this.source.date);
         this._date = new Date(_loc1_);
      }
      
      public function get hasDefinition() : Boolean
      {
         return this.source;
      }
      
      public function get date() : Date
      {
         return this._date || null;
      }
   }
}

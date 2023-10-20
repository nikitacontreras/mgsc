package com.qb9.gaturro.commons.event
{
   import com.qb9.gaturro.commons.quest.model.QuestModel;
   import flash.events.Event;
   
   public class QuestEvent extends Event
   {
      
      public static const DEACTIVATED:String = "deactivated";
      
      public static const ACTIVATED:String = "activated";
      
      public static const COMPLETED:String = "completed";
       
      
      private var _quest:QuestModel;
      
      public function QuestEvent(param1:String, param2:QuestModel)
      {
         super(param1);
         this._quest = param2;
      }
      
      public function get quest() : QuestModel
      {
         return this._quest;
      }
      
      override public function toString() : String
      {
         return formatToString("QuestEvent","type","quest");
      }
      
      override public function clone() : Event
      {
         return new QuestEvent(type,this.quest);
      }
   }
}

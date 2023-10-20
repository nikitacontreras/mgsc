package com.qb9.gaturro.commons.quest.model
{
   public class QuestModel
   {
       
      
      private var _definition:com.qb9.gaturro.commons.quest.model.QuestDefinition;
      
      public function QuestModel(param1:com.qb9.gaturro.commons.quest.model.QuestDefinition)
      {
         super();
         this._definition = param1;
      }
      
      public function get activationConstraint() : Object
      {
         return this.definition.activationConstraint;
      }
      
      public function get goToRoomData() : GoToRoomDefinition
      {
         return this.definition.goToRoomData;
      }
      
      public function get iconClassName() : String
      {
         return this.definition.iconClassName;
      }
      
      public function get initializationPopup() : QuestPopUpDefinition
      {
         return this.definition.initializationPopup;
      }
      
      public function get code() : int
      {
         return this.definition.code;
      }
      
      public function get completionPopup() : String
      {
         return this.definition.completionPopup;
      }
      
      public function get title() : String
      {
         return this.definition.title;
      }
      
      protected function get definition() : com.qb9.gaturro.commons.quest.model.QuestDefinition
      {
         return this._definition;
      }
      
      public function get description() : String
      {
         return this.definition.description;
      }
      
      public function get accomplishmentConstraint() : Object
      {
         return this.definition.accomplishmentConstraint;
      }
   }
}

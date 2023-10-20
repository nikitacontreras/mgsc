package com.qb9.gaturro.commons.quest.model.deserializer
{
   import com.qb9.gaturro.commons.quest.model.QuestDefinition;
   
   public class QuestDefinitionDeserializer
   {
       
      
      public function QuestDefinitionDeserializer()
      {
         super();
      }
      
      public function deserialize(param1:Object) : QuestDefinition
      {
         var _loc2_:QuestDefinition = new QuestDefinition();
         _loc2_.code = param1.code;
         _loc2_.accomplishmentConstraint = param1.accomplishConstraint;
         _loc2_.activationConstraint = param1.activeConstraint;
         _loc2_.iconClassName = param1.icon;
         _loc2_.description = param1.description;
         _loc2_.title = param1.title;
         if(param1.initializationPopup)
         {
            _loc2_.setInitializationPopup(param1.initializationPopup);
         }
         if(param1.gotoRoomData)
         {
            _loc2_.setGoToRoomData(param1.gotoRoomData);
         }
         if(param1.completionPopup)
         {
            _loc2_.completionPopup = param1.completionPopup;
         }
         if(!param1.reward)
         {
         }
         return _loc2_;
      }
   }
}

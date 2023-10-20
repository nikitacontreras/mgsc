package com.qb9.gaturro.commons.quest.view
{
   import com.qb9.gaturro.commons.quest.manager.AbstractQuestController;
   import com.qb9.gaturro.commons.quest.model.QuestModel;
   
   public class AbstractSystemQuestView
   {
       
      
      protected var _controller:AbstractQuestController;
      
      public function AbstractSystemQuestView()
      {
         super();
      }
      
      public function deactivate(param1:QuestModel) : void
      {
      }
      
      public function set controller(param1:AbstractQuestController) : void
      {
         this._controller = param1;
      }
      
      public function complete(param1:QuestModel) : void
      {
      }
      
      public function activate(param1:QuestModel) : void
      {
      }
   }
}

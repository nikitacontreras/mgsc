package com.qb9.gaturro.commons.quest.model
{
   import com.qb9.gaturro.commons.constraint.ConstraintManager;
   import com.qb9.gaturro.commons.constraint.containers.ConstraintContainer;
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.event.ContextEvent;
   import com.qb9.gaturro.commons.event.QuestEvent;
   import com.qb9.gaturro.commons.event.QuestSystemEvent;
   import com.qb9.gaturro.commons.iterator.IIterator;
   import com.qb9.gaturro.commons.iterator.Iterator;
   import com.qb9.gaturro.commons.manager.notificator.Notification;
   import com.qb9.gaturro.commons.manager.notificator.NotificationManager;
   import com.qb9.gaturro.commons.manager.notificator.NotificationType;
   import com.qb9.gaturro.commons.quest.factory.QuestFactory;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   
   public class SystemQuestModel extends EventDispatcher
   {
      
      public static const ACTIVE_QUEST_ATTRIBUTE_NAME:String = "activeQuest";
      
      private static const COMPLETION_POSTFIX:String = "Completion";
      
      private static const ACTIVATION_POSTFIX:String = "Activation";
      
      public static const COMPLETED_QUEST_ATTRIBUTE_NAME:String = "completedQuest";
       
      
      protected var prevActiveQuestList:Dictionary;
      
      private var questsActiveLength:int;
      
      protected var constraintManager:ConstraintManager;
      
      protected var completedQuestList:Dictionary;
      
      private var _newsQuestList:Dictionary;
      
      protected var config:com.qb9.gaturro.commons.quest.model.QuestConfig;
      
      private var completionConstraintMap:Dictionary;
      
      private var questFactory:QuestFactory;
      
      private var notificationManager:NotificationManager;
      
      private var activationConstraintMap:Dictionary;
      
      private var _activeQuestList:Dictionary;
      
      public function SystemQuestModel(param1:com.qb9.gaturro.commons.quest.model.QuestConfig, param2:QuestFactory)
      {
         super();
         this.questFactory = param2;
         this.config = param1;
      }
      
      private function isLazyAccomplished(param1:QuestModel, param2:String) : Boolean
      {
         return this.constraintManager.accomplishFromDefinition(param1.accomplishmentConstraint,param2);
      }
      
      private function setupNotificationManager() : void
      {
         if(Context.instance.hasByType(NotificationManager))
         {
            this.setNotificationManger();
         }
         else
         {
            Context.instance.addEventListener(ContextEvent.ADDED,this.onConstraintManagerAdded);
         }
      }
      
      protected function doConstraintManagerHook() : void
      {
      }
      
      public function get newsQuestList() : IIterator
      {
         var _loc1_:IIterator = new Iterator();
         _loc1_.setupIterable(this._newsQuestList);
         return _loc1_;
      }
      
      private function onConstraintManagerAdded(param1:ContextEvent) : void
      {
         if(param1.instanceType == ConstraintManager)
         {
            this.setContraintManager();
            this.setupData();
            Context.instance.removeEventListener(ContextEvent.ADDED,this.onConstraintManagerAdded);
         }
      }
      
      private function setupConstraintManager() : void
      {
         if(Context.instance.hasByType(ConstraintManager))
         {
            this.setContraintManager();
         }
         else
         {
            Context.instance.addEventListener(ContextEvent.ADDED,this.onConstraintManagerAdded);
         }
      }
      
      private function setNotificationManger() : void
      {
         this.notificationManager = Context.instance.getByType(NotificationManager) as NotificationManager;
      }
      
      private function setupLists() : void
      {
         this._activeQuestList = new Dictionary();
         this.questsActiveLength = 0;
         this.activationConstraintMap = new Dictionary();
         this._newsQuestList = new Dictionary();
         this.completionConstraintMap = new Dictionary();
      }
      
      private function completionConstraintChanged(param1:ConstraintContainer) : void
      {
         var _loc2_:String = param1.id;
         this.processCompletion(_loc2_);
      }
      
      private function isActivable(param1:QuestModel) : Boolean
      {
         var _loc3_:Boolean = false;
         var _loc2_:Boolean = Boolean(this.completedQuestList[param1.code]);
         if(!_loc2_)
         {
            _loc3_ = this.isLazyActive(param1);
            if(_loc3_)
            {
               return true;
            }
         }
         return false;
      }
      
      public function init() : void
      {
         this.setup();
      }
      
      private function activationConstraintChanged(param1:ConstraintContainer) : void
      {
         var _loc2_:QuestModel = this.activationConstraintMap[param1.id];
         var _loc3_:Boolean = Boolean(this._activeQuestList[_loc2_.code]);
         var _loc4_:Boolean = this.isStrongActive(_loc2_);
         trace("SystemQuestModel > activationConstraintChanged > quest = [" + _loc2_.code + "]  // (!wasActive && shouldActive)=" + (!_loc3_ && _loc4_));
         if(!_loc3_ && _loc4_)
         {
            this.applyActivation(_loc2_);
            this.observeCompletionConstraint(_loc2_);
         }
         else if(_loc3_ && !_loc4_)
         {
            this.applyDeactivation(_loc2_);
         }
      }
      
      protected function applyActivation(param1:QuestModel) : void
      {
         this._activeQuestList[param1.code] = param1;
         ++this.questsActiveLength;
         if(!this.prevActiveQuestList[param1.code])
         {
            dispatchEvent(new QuestEvent(QuestEvent.ACTIVATED,param1));
            if(this.notificationManager)
            {
               this.notificationManager.brodcast(new com.qb9.gaturro.commons.manager.notificator.Notification(NotificationType.QUEST_ACTIVATED,param1));
            }
         }
      }
      
      public function get questList() : IIterator
      {
         return this.config.getIterator();
      }
      
      protected function processCompletion(param1:String) : void
      {
         var _loc2_:QuestModel = this.completionConstraintMap[param1];
         var _loc3_:Boolean = this.constraintManager.accomplishById(param1);
         if(_loc3_)
         {
            this.applyCompletion(_loc2_,param1);
         }
      }
      
      private function setupModel() : void
      {
         var _loc2_:QuestDefinition = null;
         var _loc3_:QuestModel = null;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:String = null;
         var _loc1_:IIterator = this.config.getIterator();
         while(_loc1_.next())
         {
            _loc2_ = _loc1_.current() as QuestDefinition;
            _loc3_ = this.questFactory.build(_loc2_.code);
            if(_loc5_ = this.isActiveObservable(_loc3_))
            {
               this.observeActivationContraint(_loc3_);
               if(_loc4_ = this.isActivable(_loc3_))
               {
                  this.applyActivation(_loc3_);
                  _loc7_ = _loc3_.code + COMPLETION_POSTFIX;
                  if(_loc6_ = this.isLazyAccomplished(_loc3_,_loc7_))
                  {
                     this.applyCompletion(_loc3_,_loc7_);
                  }
                  else
                  {
                     this.observeCompletionConstraint(_loc3_);
                  }
               }
            }
            trace("SystemQuestModel > setupModel > definition.code = [" + _loc2_.code + "] // activeObservable = [" + _loc5_ + "] // activable = [" + _loc4_ + "]");
         }
         dispatchEvent(new QuestSystemEvent(QuestSystemEvent.MODEL_READY));
      }
      
      private function observeCompletionConstraint(param1:QuestModel) : void
      {
         var _loc2_:String = param1.code + COMPLETION_POSTFIX;
         this.constraintManager.activateDefinition(param1.accomplishmentConstraint,_loc2_);
         this.constraintManager.observe(_loc2_,this.completionConstraintChanged);
         this.completionConstraintMap[_loc2_] = param1;
      }
      
      public function get hasActiveQuests() : Boolean
      {
         return this.questsActiveLength > 0;
      }
      
      private function isActiveObservable(param1:QuestModel) : Boolean
      {
         var _loc2_:Boolean = Boolean(this.completedQuestList[param1.code]);
         return !_loc2_;
      }
      
      protected function setupCompletedQuest() : void
      {
      }
      
      public function complete(param1:int) : void
      {
         var _loc3_:String = null;
         var _loc2_:QuestModel = this._activeQuestList[param1];
         if(_loc2_)
         {
            _loc3_ = _loc2_.code + COMPLETION_POSTFIX;
            this.applyCompletion(_loc2_,_loc3_);
         }
      }
      
      public function getQuest(param1:int) : QuestDefinition
      {
         return this.config.getDefinition(param1);
      }
      
      private function observeActivationContraint(param1:QuestModel) : void
      {
         var _loc2_:String = param1.code + ACTIVATION_POSTFIX;
         this.constraintManager.activateDefinition(param1.activationConstraint,_loc2_);
         this.constraintManager.observe(_loc2_,this.activationConstraintChanged);
         this.activationConstraintMap[_loc2_] = param1;
      }
      
      protected function setupActiveQuest() : void
      {
      }
      
      public function isCompleted(param1:int) : Boolean
      {
         return this.completedQuestList[param1];
      }
      
      private function isStrongActive(param1:QuestModel) : Boolean
      {
         var _loc2_:String = param1.code + ACTIVATION_POSTFIX;
         return this.constraintManager.accomplishById(_loc2_);
      }
      
      protected function setupData() : void
      {
         this.setupLists();
         this.setupCompletedQuest();
         this.setupActiveQuest();
         this.setupModel();
      }
      
      public function reset() : void
      {
         this.setupData();
      }
      
      public function get activeQuestList() : IIterator
      {
         var _loc1_:IIterator = new Iterator();
         _loc1_.setupIterable(this._activeQuestList);
         return _loc1_;
      }
      
      private function setContraintManager() : void
      {
         this.constraintManager = Context.instance.getByType(ConstraintManager) as ConstraintManager;
         this.doConstraintManagerHook();
      }
      
      private function isLazyActive(param1:QuestModel) : Boolean
      {
         var _loc2_:String = param1.code + ACTIVATION_POSTFIX;
         return this.constraintManager.accomplishFromDefinition(param1.activationConstraint,_loc2_);
      }
      
      protected function applyDeactivation(param1:QuestModel) : void
      {
         delete this._activeQuestList[param1.code];
         --this.questsActiveLength;
         var _loc2_:String = param1.code + ACTIVATION_POSTFIX;
         if(this.constraintManager.hasConstraintWithID(_loc2_))
         {
            this.constraintManager.deactivate(_loc2_);
         }
         delete this.activationConstraintMap[_loc2_];
         dispatchEvent(new QuestEvent(QuestEvent.DEACTIVATED,param1));
         this.notificationManager.brodcast(new com.qb9.gaturro.commons.manager.notificator.Notification(NotificationType.QUEST_DEACTIVATED,param1));
      }
      
      protected function applyCompletion(param1:QuestModel, param2:String) : void
      {
         var _loc3_:int = param1.code;
         this.applyDeactivation(param1);
         delete this.completionConstraintMap[param2];
         delete this._newsQuestList[param2];
         if(this.constraintManager.hasConstraintWithID(param2))
         {
            this.constraintManager.deactivate(param2);
         }
         this.completedQuestList[_loc3_] = param1;
         dispatchEvent(new QuestEvent(QuestEvent.COMPLETED,param1));
      }
      
      protected function setup() : void
      {
         this.setupConstraintManager();
         this.setupNotificationManager();
         this.setupData();
      }
   }
}

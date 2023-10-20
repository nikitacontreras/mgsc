package com.qb9.gaturro.quest.model
{
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.event.ContextEvent;
   import com.qb9.gaturro.commons.manager.notificator.Notification;
   import com.qb9.gaturro.commons.manager.notificator.NotificationManager;
   import com.qb9.gaturro.commons.quest.factory.QuestFactory;
   import com.qb9.gaturro.commons.quest.model.QuestConfig;
   import com.qb9.gaturro.commons.quest.model.QuestModel;
   import com.qb9.gaturro.commons.quest.model.SystemQuestModel;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.globals.server;
   import com.qb9.gaturro.notifier.GaturroNotificationType;
   import com.qb9.gaturro.user.GaturroUser;
   import flash.utils.Dictionary;
   
   public class GaturroSystemQuestModel extends SystemQuestModel
   {
      
      private static const CODE_DELIMITER:String = ";";
       
      
      private var user:GaturroUser;
      
      private var setupReady:Boolean;
      
      public function GaturroSystemQuestModel(param1:QuestConfig, param2:QuestFactory)
      {
         super(param1,param2);
      }
      
      private function onServerTimeSetted(param1:com.qb9.gaturro.commons.manager.notificator.Notification) : void
      {
         var _loc2_:NotificationManager = Context.instance.getByType(NotificationManager) as NotificationManager;
         _loc2_.unobserve(GaturroNotificationType.SETTED_SERVER_TIME,this.onServerTimeSetted);
         this.processCleanCompleted();
         this.setupData();
      }
      
      private function appendActiveQuest(param1:int) : void
      {
         var _loc2_:String = this.user.profile.attributes[SystemQuestModel.ACTIVE_QUEST_ATTRIBUTE_NAME] as String;
         _loc2_ = _loc2_ && _loc2_.length && _loc2_ != " " ? _loc2_ + ";" + param1 : param1.toString();
         this.user.profile.attributes[SystemQuestModel.ACTIVE_QUEST_ATTRIBUTE_NAME] = _loc2_;
      }
      
      public function getCompletedQuests() : Dictionary
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc1_:String = this.user.profile.attributes[SystemQuestModel.COMPLETED_QUEST_ATTRIBUTE_NAME] as String;
         var _loc2_:Dictionary = new Dictionary();
         if(_loc1_ != null)
         {
            _loc3_ = !_loc1_ || _loc1_ == " " ? null : _loc1_.split(CODE_DELIMITER);
            for each(_loc4_ in _loc3_)
            {
               _loc2_[_loc4_] = _loc4_;
            }
         }
         return _loc2_;
      }
      
      override protected function setupData() : void
      {
         var _loc1_:NotificationManager = null;
         if(!this.setupReady)
         {
            if(constraintManager && this.user && server && Boolean(server.serverTimeReady))
            {
               super.setupData();
               this.setupReady = true;
            }
            if(!server || !server.serverTimeReady)
            {
               _loc1_ = Context.instance.getByType(NotificationManager) as NotificationManager;
               if(!_loc1_.isObserving(GaturroNotificationType.SETTED_SERVER_TIME,this.onServerTimeSetted))
               {
                  _loc1_.observe(GaturroNotificationType.SETTED_SERVER_TIME,this.onServerTimeSetted);
               }
            }
         }
      }
      
      override protected function doConstraintManagerHook() : void
      {
         if(this.user)
         {
            this.processCleanCompleted();
         }
      }
      
      private function getGetFormattedDate() : String
      {
         var _loc1_:Date = new Date(server.time);
         return _loc1_.getFullYear() + "/" + (_loc1_.getMonth() + 1) + "/" + _loc1_.getDate();
      }
      
      override public function reset() : void
      {
         this.performCleaning();
         super.reset();
      }
      
      private function processCleanCompleted() : void
      {
         var _loc1_:Boolean = false;
         var _loc5_:NotificationManager = null;
         var _loc2_:Object = config.getCleanDefinition();
         var _loc3_:String = String(this.user.profile.attributes.cleanQuest);
         var _loc4_:Date;
         if((Boolean(_loc4_ = this.convertToDate(_loc3_))) && !isNaN(_loc4_.time))
         {
            _loc1_ = constraintManager.accomplishFromDefinition(_loc2_.constraint,"cleanQuest",_loc4_);
         }
         else
         {
            _loc1_ = true;
         }
         if(_loc1_)
         {
            if(this.canGetNewDate())
            {
               this.performCleaning();
               this.user.profile.attributes.cleanQuest = this.getGetFormattedDate();
            }
            else if(!(_loc5_ = Context.instance.getByType(NotificationManager) as NotificationManager).isObserving(GaturroNotificationType.SETTED_SERVER_TIME,this.onServerTimeSetted))
            {
               _loc5_.observe(GaturroNotificationType.SETTED_SERVER_TIME,this.onServerTimeSetted);
            }
         }
      }
      
      private function onUserAdded(param1:ContextEvent) : void
      {
         if(param1.instanceType == GaturroUser)
         {
            this.user = Context.instance.getByType(GaturroUser) as GaturroUser;
            Context.instance.removeEventListener(ContextEvent.ADDED,this.onUserAdded);
            this.setupData();
            this.processCleanCompleted();
         }
      }
      
      private function appendCompletedQuest(param1:int) : void
      {
         var _loc2_:String = this.user.profile.attributes[SystemQuestModel.COMPLETED_QUEST_ATTRIBUTE_NAME] as String;
         _loc2_ = _loc2_ && _loc2_.length && _loc2_ != " " ? _loc2_ + ";" + param1 : param1.toString();
         this.user.profile.attributes[SystemQuestModel.COMPLETED_QUEST_ATTRIBUTE_NAME] = _loc2_;
      }
      
      private function convertToDate(param1:String) : Date
      {
         var _loc2_:Number = Date.parse(param1);
         return new Date(_loc2_);
      }
      
      private function onUserAdded_clean(param1:ContextEvent) : void
      {
         if(param1.instanceType == GaturroUser)
         {
            this.processCleanCompleted();
         }
      }
      
      private function appendDeactiveQuest(param1:int) : void
      {
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:RegExp = null;
         var _loc2_:String = this.user.profile.attributes[SystemQuestModel.ACTIVE_QUEST_ATTRIBUTE_NAME] as String;
         var _loc3_:String = param1.toString();
         if(_loc2_.indexOf(CODE_DELIMITER) >= 0)
         {
            if((_loc4_ = (_loc4_ = _loc2_.indexOf(param1.toString() + CODE_DELIMITER)) < 0 ? _loc2_.indexOf(CODE_DELIMITER + param1.toString()) : _loc4_) < 0)
            {
               logger.debug("Could\'nt find the requested quest code into active code list");
               throw new Error("Could\'nt find the requested quest code into active code list");
            }
            if(_loc4_ == 0)
            {
               _loc6_ = "";
               _loc7_ = ";";
            }
            else
            {
               _loc6_ = ";";
               _loc7_ = "";
            }
            _loc8_ = new RegExp(_loc6_ + _loc3_ + _loc7_);
            _loc5_ = _loc2_.replace(_loc8_,"");
         }
         else
         {
            if(_loc2_ != param1.toString())
            {
               logger.debug("Couldn´t resolve active quest removing  for code. " + param1);
               throw new Error("Couldn´t resolve active quest removing  for code. " + param1);
            }
            _loc5_ = "";
         }
         this.user.profile.attributes[SystemQuestModel.ACTIVE_QUEST_ATTRIBUTE_NAME] = _loc5_;
      }
      
      override protected function applyActivation(param1:QuestModel) : void
      {
         if(!prevActiveQuestList[param1.code])
         {
            this.appendActiveQuest(param1.code);
         }
         super.applyActivation(param1);
      }
      
      override protected function applyDeactivation(param1:QuestModel) : void
      {
         this.appendDeactiveQuest(param1.code);
         super.applyDeactivation(param1);
      }
      
      private function setupUser() : void
      {
         if(Context.instance.hasByType(GaturroUser))
         {
            this.user = Context.instance.getByType(GaturroUser) as GaturroUser;
         }
         else
         {
            Context.instance.addEventListener(ContextEvent.ADDED,this.onUserAdded);
         }
      }
      
      override protected function applyCompletion(param1:QuestModel, param2:String) : void
      {
         this.appendCompletedQuest(param1.code);
         super.applyCompletion(param1,param2);
      }
      
      public function getActiveQuests() : Dictionary
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc1_:String = this.user.profile.attributes[SystemQuestModel.ACTIVE_QUEST_ATTRIBUTE_NAME] as String;
         var _loc2_:Dictionary = new Dictionary();
         if(_loc1_ != null && Boolean(_loc1_.length))
         {
            _loc3_ = _loc1_ != " " ? _loc1_.split(CODE_DELIMITER) : null;
            for each(_loc4_ in _loc3_)
            {
               if(Boolean(config.getDefinition(_loc4_)) && !completedQuestList[_loc4_])
               {
                  _loc2_[_loc4_] = _loc4_;
               }
               else
               {
                  this.appendDeactiveQuest(_loc4_);
               }
            }
         }
         return _loc2_;
      }
      
      private function canGetNewDate() : Boolean
      {
         return server.serverTimeReady;
      }
      
      override protected function setupCompletedQuest() : void
      {
         if(this.user)
         {
            completedQuestList = this.getCompletedQuests();
         }
      }
      
      private function performCleaning() : void
      {
         this.user.profile.attributes[SystemQuestModel.ACTIVE_QUEST_ATTRIBUTE_NAME] = " ";
         this.user.profile.attributes[SystemQuestModel.COMPLETED_QUEST_ATTRIBUTE_NAME] = " ";
      }
      
      override protected function setup() : void
      {
         this.setupUser();
         super.setup();
      }
      
      override protected function setupActiveQuest() : void
      {
         if(this.user)
         {
            prevActiveQuestList = this.getActiveQuests();
         }
      }
   }
}

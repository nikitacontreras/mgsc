package com.qb9.gaturro.tutorial
{
   import com.qb9.flashlib.utils.ArrayUtil;
   import com.qb9.gaturro.globals.net;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.globals.tracker;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.net.metrics.Telemetry;
   import com.qb9.gaturro.tutorial.steps.AchievementStep;
   import com.qb9.gaturro.tutorial.steps.ActivePortalStep;
   import com.qb9.gaturro.tutorial.steps.CoinsStep;
   import com.qb9.gaturro.tutorial.steps.FuncStep;
   import com.qb9.gaturro.tutorial.steps.GiveItemStep;
   import com.qb9.gaturro.tutorial.steps.NpcStateStep;
   import com.qb9.gaturro.tutorial.steps.OpenPopupStep;
   import com.qb9.gaturro.tutorial.steps.QuestlogSignalButton;
   import com.qb9.gaturro.tutorial.steps.ShowArrowStep;
   import com.qb9.gaturro.tutorial.steps.ShowButtonStep;
   import com.qb9.gaturro.tutorial.steps.Step;
   import com.qb9.gaturro.tutorial.steps.TrackStep;
   import com.qb9.gaturro.tutorial.steps.UiArrowsOffStep;
   import com.qb9.gaturro.tutorial.steps.UiOffStep;
   import com.qb9.gaturro.tutorial.steps.WaitStep;
   import com.qb9.gaturro.tutorial.steps.WaitingForClosePopup;
   import com.qb9.gaturro.tutorial.steps.WaitingForOpenCatalog;
   import com.qb9.gaturro.tutorial.steps.WaitingForOpenPopup;
   import com.qb9.gaturro.view.gui.Gui;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.mambo.net.requests.room.ChangeRoomActionRequest;
   import com.qb9.mambo.world.core.RoomLink;
   import flash.utils.setTimeout;
   
   public class TutorialManager
   {
      
      private static const TUTORIAL_STATUS_PROGRESS:int = 1;
      
      private static var attempts:int = 0;
      
      private static const TUTORIAL_STATUS_LABEL:String = "tutorialStatus";
      
      private static const TUTORIAL_STATUS_UNSTARTED:int = 0;
      
      private static const TUTORIAL_STATUS_COMPLETED:int = 2;
      
      private static const TUTORIAL_ATTEMPTS_LABEL:String = "tutorialAttempts";
      
      private static var status:int = -1;
       
      
      private var steps:Array;
      
      private var stateData:Object;
      
      public function TutorialManager()
      {
         super();
      }
      
      private static function recoverPersistedStatus() : void
      {
         var _loc1_:int = int(user.attributes[TutorialManager.TUTORIAL_STATUS_LABEL]);
         status = _loc1_;
      }
      
      public static function autoLaunch() : Boolean
      {
         return settings.tutorial.autoLauch;
      }
      
      public static function isTutorialDone() : Boolean
      {
         return status == TUTORIAL_STATUS_COMPLETED;
      }
      
      private static function complete() : void
      {
         chageStatus(TutorialManager.TUTORIAL_STATUS_COMPLETED);
      }
      
      public static function isRoomTutoriable(param1:GaturroRoom) : Boolean
      {
         var _loc2_:* = status == TUTORIAL_STATUS_PROGRESS;
         var _loc3_:Object = createState(param1);
         return _loc2_ && Boolean(_loc3_);
      }
      
      private static function chageStatus(param1:int) : void
      {
         if(TutorialManager.status != param1)
         {
            user.attributes[TutorialManager.TUTORIAL_STATUS_LABEL] = param1;
            TutorialManager.status = param1;
         }
      }
      
      private static function recoverPersistedAttempts() : void
      {
         var _loc1_:int = int(user.attributes[TutorialManager.TUTORIAL_ATTEMPTS_LABEL]);
         attempts = _loc1_;
      }
      
      private static function changeAttempts(param1:int) : void
      {
         user.attributes[TutorialManager.TUTORIAL_ATTEMPTS_LABEL] = param1;
      }
      
      private static function isFirstSession() : Boolean
      {
         var _loc1_:Number = Number(user.attributes.sessionCount);
         return _loc1_ == 0;
      }
      
      public static function endTutorial() : void
      {
         chageStatus(TUTORIAL_STATUS_COMPLETED);
      }
      
      public static function start() : void
      {
         ++attempts;
         changeAttempts(attempts);
         chageStatus(TUTORIAL_STATUS_PROGRESS);
         var _loc1_:int = int(settings.tutorial.state1.roomId);
         var _loc2_:RoomLink = new RoomLink(null,_loc1_);
         var _loc3_:ChangeRoomActionRequest = new ChangeRoomActionRequest(_loc2_);
         net.sendAction(_loc3_);
         tracker.event("TUTORIAL:ATTEMPTS",attempts.toString());
         Telemetry.getInstance().trackEvent("TUTORIAL:ATTEMPTS",attempts.toString());
      }
      
      private static function createState(param1:GaturroRoom) : Object
      {
         var _loc3_:Object = null;
         var _loc7_:String = null;
         var _loc8_:Object = null;
         var _loc2_:Object = settings.tutorial;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         while((_loc7_ = "state" + (++_loc6_).toString()) in _loc2_)
         {
            if((_loc8_ = _loc2_[_loc7_]).roomId == param1.id || _loc8_.roomId == 0 && param1.ownedByUser)
            {
               _loc3_ = _loc2_[_loc7_];
               _loc4_ = _loc6_;
            }
         }
         _loc5_ = --_loc6_;
         if(Boolean(_loc3_) && _loc4_ == _loc5_)
         {
            _loc3_["isLast"] = true;
         }
         return _loc3_;
      }
      
      public static function isEnabled() : Boolean
      {
         return settings.tutorial.enabled;
      }
      
      public static function isInProgress() : Boolean
      {
         return status == TUTORIAL_STATUS_PROGRESS;
      }
      
      public static function setup() : void
      {
         recoverPersistedStatus();
         recoverPersistedAttempts();
         if(isEnabled() && autoLaunch() && (isInProgress() || TutorialManager.isFirstSession()))
         {
            start();
         }
      }
      
      public function initState(param1:GaturroRoom, param2:TutorialOperations, param3:Gui) : void
      {
         this.stateData = TutorialManager.createState(param1);
         if(!this.stateData)
         {
            return;
         }
         if(this.stateData.isLast)
         {
            TutorialManager.complete();
         }
         this.steps = this.createSteps(param2,param3);
         this.nextStep();
      }
      
      private function createSteps(param1:TutorialOperations, param2:Gui) : Array
      {
         var _loc4_:Object = null;
         var _loc3_:Array = [];
         for each(_loc4_ in this.stateData.steps)
         {
            switch(_loc4_.name)
            {
               case "wait":
                  _loc3_.push(new WaitStep(param1,_loc4_.miliseconds));
                  break;
               case "ui_off":
                  _loc3_.push(new UiOffStep(param1));
                  break;
               case "ui_arrows_off":
                  _loc3_.push(new UiArrowsOffStep(param1));
                  break;
               case "show_arrow":
                  _loc3_.push(new ShowArrowStep(param1,_loc4_.arrow,_loc4_.visible));
                  break;
               case "show_button":
                  _loc3_.push(new ShowButtonStep(param1,_loc4_.buttonName,_loc4_.visible));
                  break;
               case "hightlight_button":
                  _loc3_.push(new ShowButtonStep(param1,_loc4_.buttonName,_loc4_.visible));
                  break;
               case "openPopup":
                  _loc3_.push(new OpenPopupStep(param1,param2,_loc4_.modalName));
                  break;
               case "waitingForOpenPopup":
                  _loc3_.push(new WaitingForOpenPopup(param1,param2,"modalName" in _loc4_ ? String(_loc4_.modalName) : ""));
                  break;
               case "waitingForClosePopup":
                  _loc3_.push(new WaitingForClosePopup(param1,param2,"modalName" in _loc4_ ? String(_loc4_.modalName) : ""));
                  break;
               case "waitingForNpcState":
                  _loc3_.push(new NpcStateStep(param1,_loc4_.npc,_loc4_.initState,_loc4_.endingState));
                  break;
               case "waitingForOpenCatalog":
                  _loc3_.push(new WaitingForOpenCatalog(param1,param2,_loc4_.npc));
                  break;
               case "coins":
                  _loc3_.push(new CoinsStep(param1,param2,_loc4_.mount));
                  break;
               case "questlogSignalButton":
                  _loc3_.push(new QuestlogSignalButton(param1,param2,_loc4_.text,_loc4_.buttonText));
                  break;
               case "activePortal":
                  _loc3_.push(new ActivePortalStep(param1));
                  break;
               case "giveItem":
                  _loc3_.push(new GiveItemStep(param1,_loc4_.itemName));
                  break;
               case "tutorial_func":
                  _loc3_.push(new FuncStep(param1,_loc4_.func));
                  break;
               case "track":
                  param1.lastTrack = _loc4_.action;
                  _loc3_.push(new TrackStep(param1,_loc4_.action));
                  break;
               case "achievement":
                  _loc3_.push(new AchievementStep(param1,_loc4_.ach));
                  break;
            }
         }
         return _loc3_;
      }
      
      private function checkNextStep() : void
      {
         if(!this.steps)
         {
            return;
         }
         if(this.steps.length == 0)
         {
            return;
         }
         var _loc1_:Step = Step(this.steps[0]);
         if(_loc1_.finish)
         {
            _loc1_.dispose();
            ArrayUtil.removeElement(this.steps,_loc1_);
            this.nextStep();
         }
         else
         {
            setTimeout(this.checkNextStep,500);
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:Step = null;
         if(!this.steps)
         {
            return;
         }
         for each(_loc1_ in this.steps)
         {
            _loc1_.dispose();
         }
         this.steps = null;
      }
      
      private function nextStep() : void
      {
         if(!this.steps)
         {
            return;
         }
         if(this.steps.length == 0)
         {
            return;
         }
         var _loc1_:Step = Step(this.steps[0]);
         _loc1_.execute();
         this.checkNextStep();
      }
   }
}

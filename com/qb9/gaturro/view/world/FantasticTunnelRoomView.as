package com.qb9.gaturro.view.world
{
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.logs.ErrorDisplayAppender;
   import com.qb9.gaturro.net.mail.GaturroMailer;
   import com.qb9.gaturro.view.gui.actions.PhotoButton;
   import com.qb9.gaturro.view.world.avatars.Gaturro;
   import com.qb9.gaturro.view.world.elements.NpcRoomSceneObjectView;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.reports.InfoReportQueue;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import com.qb9.mambo.world.avatars.Avatar;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   
   public class FantasticTunnelRoomView extends GaturroRoomView
   {
      
      private static const PULPO_EVENT:String = "pulpo";
      
      private static const SIRENA_EVENT:String = "sirena";
      
      private static const SERPIENTE_EVENT:String = "serpiente";
      
      private static const ARANA_EVENT:String = "arana";
      
      public static const TUNEL_FANTASTICO:String = "tunelFantastico";
       
      
      private var layer1:MovieClip;
      
      private var layer2:MovieClip;
      
      private var layer3:MovieClip;
      
      private var oldFrameRate:int;
      
      private var photoButton:PhotoButton;
      
      private var nameWritten:Boolean = false;
      
      private var cosmusDefeated:Boolean;
      
      private var clicked_1:Boolean = false;
      
      private var clicked_2:Boolean = false;
      
      private var clicked_3:Boolean = false;
      
      private var clicked_4:Boolean = false;
      
      private var logAppenderToStop:ErrorDisplayAppender;
      
      private var grandCosmusNPC:NpcRoomSceneObjectView;
      
      private var moved:Boolean = false;
      
      private var previousFrame:String;
      
      private var timer:Timer;
      
      private var NEW_SCENE:String = "newScene";
      
      public function FantasticTunnelRoomView(param1:GaturroRoom, param2:TaskContainer, param3:InfoReportQueue, param4:GaturroMailer, param5:WhiteListNode)
      {
         super(param1,param3,param4,param5);
         this.logAppenderToStop = logger.getAppender(ErrorDisplayAppender) as ErrorDisplayAppender;
         this.logAppenderToStop.isLogging = false;
      }
      
      override protected function whenReady() : void
      {
         super.whenReady();
         this.oldFrameRate = stage.frameRate;
         stage.frameRate = 18;
      }
      
      override protected function addSceneObject(param1:RoomSceneObject) : void
      {
         var _loc2_:Avatar = null;
         if(param1 is Avatar)
         {
            _loc2_ = param1 as Avatar;
            if(_loc2_.username != room.userAvatar.username && _loc2_.username != room.userAvatar.attributes.tunelFantastico)
            {
               return;
            }
         }
         super.addSceneObject(param1);
      }
      
      private function onLayer3EnterFrame(param1:Event) : void
      {
         if(this.previousFrame != this.layer3.currentLabel)
         {
            this.stopAllLayers();
            this.timer.start();
            this.photoButton.makeVisible();
         }
         this.previousFrame = this.layer3.currentLabel;
         if(this.layer3.currentLabel == "end")
         {
            api.setAvatarAttribute(TUNEL_FANTASTICO," ");
            api.changeRoomXY(51688751,10,10);
         }
      }
      
      private function onBgroundClick(param1:MouseEvent) : void
      {
         switch(this.layer1.currentLabel)
         {
            case "scene1":
               this.checkClickScene1(param1.stageX,param1.stageY);
               break;
            case "scene2":
               this.checkClickScene2(param1.stageX,param1.stageY);
               break;
            case "scene3":
               this.checkClickScene3(param1.stageX,param1.stageY);
               break;
            case "scene5":
            case "exiting":
               this.checkClickScene5(param1.stageX,param1.stageY);
         }
      }
      
      override public function dispose() : void
      {
         if(api)
         {
            api.setAvatarAttribute(TUNEL_FANTASTICO," ");
         }
         this.logAppenderToStop.isLogging = true;
         if(this.photoButton)
         {
            this.photoButton.dispose();
         }
         if(this.timer)
         {
            this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this.timer.stop();
         }
         if(this.layer3)
         {
            this.layer3.removeEventListener(Event.ENTER_FRAME,this.onLayer3EnterFrame);
         }
         if(this.layer1)
         {
            this.layer1.addEventListener(SIRENA_EVENT,this.onSirenaAppear);
         }
         stage.frameRate = this.oldFrameRate;
         super.dispose();
      }
      
      private function startAllLayers() : void
      {
         this.layer1.play();
         this.layer2.play();
         this.layer3.play();
      }
      
      private function checkClickScene1(param1:int, param2:int) : void
      {
         var _loc3_:MovieClip = null;
         if(Boolean(this.layer3.click1) && Boolean(this.layer3.target1) && !this.clicked_1)
         {
            _loc3_ = this.layer3.click1;
            if(_loc3_.hitTestPoint(param1,param2))
            {
               this.layer3.target1.play();
               api.playSound("parqueDiversiones/fantastic_aranias");
               this.clicked_1 = true;
            }
         }
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         this.startAllLayers();
         this.timer.stop();
      }
      
      private function checkClickScene3(param1:int, param2:int) : void
      {
         var _loc3_:MovieClip = null;
         if(Boolean(this.layer3.click3) && Boolean(this.layer3.target3) && !this.clicked_3)
         {
            _loc3_ = this.layer3.click3;
            if(_loc3_.hitTestPoint(param1,param2))
            {
               this.layer3.target3.play();
               api.playSound("parqueDiversiones/fantastic_pulpo");
               this.clicked_3 = true;
            }
         }
      }
      
      private function checkClickScene5(param1:int, param2:int) : void
      {
         var _loc3_:MovieClip = null;
         if(Boolean(this.layer3.click5) && Boolean(this.layer3.target5) && !this.clicked_4)
         {
            _loc3_ = this.layer3.click5;
            if(_loc3_.hitTestPoint(param1,param2))
            {
               this.layer3.target5.play();
               api.playSound("parqueDiversiones/fantastic_serpientes");
               this.clicked_4 = true;
            }
         }
      }
      
      override protected function finalInit() : void
      {
         super.finalInit();
         this.photoButton = new PhotoButton(gRoom,api,tasks,false);
         gui.dance_ph.addChild(this.photoButton);
         this.layer1 = (background as MovieClip).layer1;
         this.layer2 = (background as MovieClip).layer2;
         this.layer3 = (background as MovieClip).layer3;
         this.timer = new Timer(1500);
         this.timer.addEventListener(TimerEvent.TIMER,this.onTimer);
         this.timer.start();
         this.layer3.addEventListener(Event.ENTER_FRAME,this.onLayer3EnterFrame);
         this.layer1.addEventListener(SIRENA_EVENT,this.onSirenaAppear);
         addEventListener(MouseEvent.CLICK,this.onBgroundClick);
         this.photoButton.makeVisible();
         setTimeout(this.setMoved,500 + Math.random() * 500);
      }
      
      private function onSirenaAppear(param1:Event) : void
      {
         api.playSound("parqueDiversiones/fantastic_sirenas");
      }
      
      private function checkClickScene2(param1:int, param2:int) : void
      {
         var _loc3_:MovieClip = null;
         if(Boolean(this.layer3.click2) && Boolean(this.layer3.target2) && !this.clicked_2)
         {
            _loc3_ = this.layer3.click2;
            if(_loc3_.hitTestPoint(param1,param2))
            {
               this.layer3.target2.play();
               api.playSound("abreMenu");
               api.playSound("parqueDiversiones/pajaro",2);
               this.clicked_2 = true;
            }
         }
      }
      
      override protected function checkIfTileSelected(param1:MouseEvent) : void
      {
         if(!this.moved)
         {
            super.checkIfTileSelected(param1);
         }
      }
      
      private function stopAllLayers() : void
      {
         this.layer1.stop();
         this.layer2.stop();
         this.layer3.stop();
      }
      
      private function setMoved() : void
      {
         api.setAvatarAttribute(Gaturro.ACTION_KEY,"sit");
         var _loc1_:String = room.userAvatar.attributes.tunelFantastico as String;
         var _loc2_:String = room.userAvatar.username as String;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         while(_loc5_ < _loc1_.length)
         {
            _loc3_ += _loc1_.charCodeAt(_loc5_);
            _loc5_++;
         }
         _loc5_ = 0;
         while(_loc5_ < _loc2_.length)
         {
            _loc4_ += _loc2_.charCodeAt(_loc5_);
            _loc5_++;
         }
         if(_loc3_ >= _loc4_)
         {
            api.moveToTileXY(4,7);
         }
         else
         {
            api.moveToTileXY(5,6);
         }
         this.moved = true;
      }
   }
}

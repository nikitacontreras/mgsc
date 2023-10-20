package com.qb9.gaturro.view.world
{
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.logs.ErrorDisplayAppender;
   import com.qb9.gaturro.net.mail.GaturroMailer;
   import com.qb9.gaturro.view.camera.BossFightRoomCamera;
   import com.qb9.gaturro.view.camera.CameraSwitcher;
   import com.qb9.gaturro.view.world.misc.CollectablesRobot;
   import com.qb9.gaturro.view.world.misc.DisparoRobot;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.core.elements.HomeInteractiveRoomSceneObject;
   import com.qb9.gaturro.world.houseInteractive.bosses.BossRobotBehavior;
   import com.qb9.gaturro.world.reports.InfoReportQueue;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import com.qb9.mambo.world.avatars.Avatar;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.setTimeout;
   
   public class GaturroBossRoomView extends GaturroRoomView
   {
      
      public static const FAR_RIGHT:int = 800;
      
      public static const FAR_LEFT:int = 200;
       
      
      private var bossStateMachine:BossRobotBehavior;
      
      private var avatarMoving:Boolean = true;
      
      private var bossFinal1_String:String;
      
      public var customAnimGUIText:Object;
      
      public var state:int = 0;
      
      private var disparadores:Array;
      
      private var fightStatus:int;
      
      private var camera:BossFightRoomCamera;
      
      private var logAppenderToStop:ErrorDisplayAppender;
      
      public var customAnimTrans:Object;
      
      private var difficulty:int = 9;
      
      public const bossFinal1_KEY:String = "bossFinal1_P_ATTR";
      
      private var step:int = 0;
      
      private var guiIcon:MovieClip;
      
      private var bossFinal1_P_ATTR:Object;
      
      private var waitinToHit:Boolean = false;
      
      private var collectables:CollectablesRobot;
      
      private var fightStep:int;
      
      public function GaturroBossRoomView(param1:GaturroRoom, param2:TaskContainer, param3:InfoReportQueue, param4:GaturroMailer, param5:WhiteListNode)
      {
         this.customAnimGUIText = {
            "x":-300,
            "y":-200,
            "scaleX":3.5,
            "scaleY":3.5
         };
         this.customAnimTrans = {"transition":"easeIn"};
         super(param1,param3,param4,param5);
         this.logAppenderToStop = logger.getAppender(ErrorDisplayAppender) as ErrorDisplayAppender;
         this.logAppenderToStop.isLogging = false;
      }
      
      override protected function whenReady() : void
      {
         this.bossFinal1_String = api.getProfileAttribute(this.bossFinal1_KEY) as String;
         this.bossFinal1_P_ATTR = api.JSONDecode(this.bossFinal1_String);
         if(!this.bossFinal1_P_ATTR)
         {
            api.setProfileAttribute(this.bossFinal1_KEY + "/state",0);
            api.setProfileAttribute(this.bossFinal1_KEY + "/step",0);
         }
         api.setProfileAttribute(this.bossFinal1_KEY + "/derrota",0);
         this.state = api.getProfileAttribute(this.bossFinal1_KEY + "/state") as int;
         super.whenReady();
      }
      
      override protected function addSceneObject(param1:RoomSceneObject) : void
      {
         if(param1 is Avatar && (param1 as Avatar).username != room.userAvatar.username)
         {
            return;
         }
         if(param1 is HomeInteractiveRoomSceneObject && (param1 as HomeInteractiveRoomSceneObject).name == "bossFinal.mech_so")
         {
            this.bossStateMachine = (param1 as HomeInteractiveRoomSceneObject).stateMachine as BossRobotBehavior;
         }
         super.addSceneObject(param1);
      }
      
      private function onPanToGaturroCOmplete(param1:Event) : void
      {
         CameraSwitcher.instance.removeEventListener(Event.COMPLETE,this.onPanToGaturroCOmplete);
         this.changeCameraNextX();
         this.avatarMoving = true;
      }
      
      override public function dispose() : void
      {
         var _loc1_:int = 0;
         this.logAppenderToStop.isLogging = true;
         if(this.disparadores)
         {
            _loc1_ = 0;
            while(_loc1_ < this.disparadores.length)
            {
               this.disparadores[_loc1_].dispose();
               _loc1_++;
            }
         }
         this.removeEventListener(Event.ENTER_FRAME,this.update);
         if(this.collectables)
         {
            this.collectables.dispose();
         }
         super.dispose();
      }
      
      private function addIconToGUI(param1:DisplayObject) : void
      {
         this.guiIcon = param1 as MovieClip;
         gui.phTop.addChild(this.guiIcon);
         this.guiIcon.escudo.gotoAndStop(1);
         this.guiIcon.barra.gotoAndStop("state" + this.state.toString());
      }
      
      private function onInitialPanCOmplete(param1:Event) : void
      {
         CameraSwitcher.instance.removeEventListener(Event.COMPLETE,this.onInitialPanCOmplete);
         setTimeout(this.panToGaturro,1500);
      }
      
      override protected function finalInit() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         super.finalInit();
         gui.questlog_ph.visible = false;
         api.libraries.fetch("bossFinal.bossGUI",this.addIconToGUI);
         if(this.state < 4)
         {
            this.disparadores = [];
            this.collectables = new CollectablesRobot(api,this);
            _loc1_ = background as MovieClip;
            if(Boolean(_loc1_) && Boolean(_loc1_.layer2))
            {
               _loc2_ = 0;
               while(_loc2_ < _loc1_.layer2.numChildren)
               {
                  _loc3_ = _loc1_.layer2.getChildAt(_loc2_) as MovieClip;
                  if(_loc3_)
                  {
                     if(_loc3_.fuego)
                     {
                        this.disparadores.push(new DisparoRobot(_loc3_,api,this));
                     }
                     if(_loc3_.collectable)
                     {
                        this.collectables.addCollectableHolder(_loc3_);
                     }
                  }
                  _loc2_++;
               }
            }
            this.collectables.whenAllReady();
            this.addEventListener(Event.ENTER_FRAME,this.update);
            setTimeout(api.textMessageToGUI,1500,"¡DERROTA AL ROBOT!");
         }
      }
      
      private function changeCameraCustomMove(param1:int) : void
      {
         CameraSwitcher.instance.switchCamera(CameraSwitcher.BOSS_FIGHT_ROOM_CAMERA,tileLayer,layers,int(room.attributes.bounds) || 0);
         CameraSwitcher.instance.move(new Point(param1));
      }
      
      public function toggleGuiShieldVisible() : void
      {
         this.guiIcon.escudo.visible = !this.guiIcon.escudo.visible;
      }
      
      public function triggerGuiShieldHit() : void
      {
         this.guiIcon.escudo.play();
         api.textMessageToGUI("¡SU ESCUDO ESTÁ CEDIENDO!");
      }
      
      private function update(param1:Event) : void
      {
         var _loc2_:int = 0;
         if(this.collectables.count >= 3)
         {
            this.bossStateMachine.returnToSize();
            if(this.bossStateMachine.hitThisUpdate())
            {
               this.collectables.count = 0;
               api.setProfileAttribute(this.bossFinal1_KEY + "/step",this.collectables.count);
               ++this.state;
               api.setProfileAttribute(this.bossFinal1_KEY + "/state",this.state);
               this.guiIcon.barra.gotoAndStop("state" + this.state.toString());
               if(this.state >= 4)
               {
                  trace("esta buscando destruir el comportamiento de los objetos utiles");
                  _loc2_ = 0;
                  while(_loc2_ < this.disparadores.length)
                  {
                     this.disparadores[_loc2_].removeFromRoom();
                     _loc2_++;
                  }
                  this.collectables.removeFromRoom();
                  api.setProfileAttribute("cuest/sh/status","end");
                  this.bossStateMachine.defeat();
                  api.textMessageToGUI("¡LO DERROTASTE!");
                  setTimeout(api.changeRoomXY,1200,25368,16,9);
               }
               else
               {
                  trace("RESET TODO");
                  this.toggleGuiShieldVisible();
                  this.bossStateMachine.toggleSize();
                  this.collectables.toggleVisible();
                  api.textMessageToGUI("¡LO HAS DAÑADO!");
               }
            }
         }
      }
      
      override protected function checkIfTileSelected(param1:MouseEvent) : void
      {
         if(this.avatarMoving)
         {
            super.checkIfTileSelected(param1);
         }
      }
      
      private function panToGaturro() : void
      {
         var _loc1_:Point = new Point(FAR_RIGHT);
         CameraSwitcher.instance.addEventListener(Event.COMPLETE,this.onPanToGaturroCOmplete);
         CameraSwitcher.instance.move(_loc1_);
      }
      
      private function changeCameraNextX() : void
      {
         CameraSwitcher.instance.switchCamera(CameraSwitcher.ROOM_CAMERA,tileLayer,layers,int(room.attributes.bounds) || 0,userView);
      }
      
      override protected function roomCamera() : void
      {
         CameraSwitcher.instance.taskRunner = tasks;
         this.changeCameraCustomMove(FAR_LEFT);
         CameraSwitcher.instance.addEventListener(Event.COMPLETE,this.onInitialPanCOmplete);
         this.avatarMoving = false;
      }
      
      public function gaturroHit() : void
      {
         if(room.userAvatar.coord.x > this.difficulty)
         {
            api.setProfileAttribute(this.bossFinal1_KEY + "/derrota",1);
            setTimeout(api.changeRoomXY,1200,25368,16,9);
         }
         else
         {
            api.moveToTileXY(room.userAvatar.coord.x + 5,room.userAvatar.coord.y);
         }
         api.shakeRoom(800,8);
         api.textMessageToGUI("TE HAN GOLPEADO!");
      }
   }
}

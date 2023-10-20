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
   
   public class LoveTunnelRoomView extends GaturroRoomView
   {
       
      
      private var layer1:MovieClip;
      
      private var layer2:MovieClip;
      
      private var layer3:MovieClip;
      
      private var timer:Timer;
      
      private var photoButton:PhotoButton;
      
      private var nameWritten:Boolean = false;
      
      private var cosmusDefeated:Boolean;
      
      private var logAppenderToStop:ErrorDisplayAppender;
      
      private var grandCosmusNPC:NpcRoomSceneObjectView;
      
      private var previousFrame:String;
      
      private var moved:Boolean = false;
      
      public function LoveTunnelRoomView(param1:GaturroRoom, param2:TaskContainer, param3:InfoReportQueue, param4:GaturroMailer, param5:WhiteListNode)
      {
         super(param1,param3,param4,param5);
         this.logAppenderToStop = logger.getAppender(ErrorDisplayAppender) as ErrorDisplayAppender;
         this.logAppenderToStop.isLogging = false;
      }
      
      override protected function addSceneObject(param1:RoomSceneObject) : void
      {
         var _loc2_:Avatar = null;
         if(param1 is Avatar)
         {
            _loc2_ = param1 as Avatar;
            if(_loc2_.username != room.userAvatar.username && _loc2_.username != room.userAvatar.attributes.loveTunnel)
            {
               return;
            }
         }
         super.addSceneObject(param1);
      }
      
      override protected function checkIfTileSelected(param1:MouseEvent) : void
      {
         if(!this.moved)
         {
            super.checkIfTileSelected(param1);
         }
      }
      
      private function startAllLayers() : void
      {
         this.layer1.play();
         this.layer2.play();
         this.layer3.play();
      }
      
      private function onLayer3EnterFrame(param1:Event) : void
      {
         if(this.previousFrame != this.layer3.currentLabel)
         {
            this.stopAllLayers();
            this.timer.start();
            this.photoButton.makeVisible();
            if(this.layer3.currentLabel == "scene2")
            {
               api.playSound("parqueDiversiones/loveTunnel1");
            }
            else if(this.layer3.currentLabel == "scene3")
            {
               api.playSound("parqueDiversiones/loveTunnel3");
            }
            else if(this.layer3.currentLabel == "scene5")
            {
               api.playSound("parqueDiversiones/loveTunnel2");
            }
         }
         if(Boolean(this.layer3.foreground) && !this.nameWritten)
         {
            this.layer3.foreground.uno.t.text = room.userAvatar.attributes.loveTunnel;
            this.layer3.foreground.dos.t.text = room.userAvatar.username;
            this.nameWritten = true;
         }
         this.previousFrame = this.layer3.currentLabel;
         if(this.layer3.currentLabel == "end")
         {
            api.setAvatarAttribute("loveTunnel"," ");
            api.changeRoomXY(51688279,10,10);
         }
      }
      
      override public function dispose() : void
      {
         if(api)
         {
            api.setAvatarAttribute("loveTunnel"," ");
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
         super.dispose();
      }
      
      private function stopAllLayers() : void
      {
         this.layer1.stop();
         this.layer2.stop();
         this.layer3.stop();
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
         this.photoButton.makeVisible();
         setTimeout(this.setMoved,500 + Math.random() * 500);
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         this.startAllLayers();
         this.timer.stop();
      }
      
      private function setMoved() : void
      {
         api.setAvatarAttribute(Gaturro.ACTION_KEY,"sit");
         var _loc1_:String = room.userAvatar.attributes.loveTunnel as String;
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
            api.moveToTileXY(5,5);
         }
         else
         {
            api.moveToTileXY(6,6);
         }
         this.moved = true;
      }
   }
}

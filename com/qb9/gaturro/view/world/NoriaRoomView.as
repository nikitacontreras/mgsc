package com.qb9.gaturro.view.world
{
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.logs.ErrorDisplayAppender;
   import com.qb9.gaturro.net.mail.GaturroMailer;
   import com.qb9.gaturro.view.gui.actions.PhotoButton;
   import com.qb9.gaturro.view.world.avatars.Gaturro;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.reports.InfoReportQueue;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import com.qb9.mambo.world.avatars.Avatar;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   
   public class NoriaRoomView extends GaturroRoomView
   {
       
      
      private var layer1:MovieClip;
      
      private var photoButton:PhotoButton;
      
      private var logAppenderToStop:ErrorDisplayAppender;
      
      private var randomScene:int;
      
      private var moved:Boolean = false;
      
      private var previousFrameLabel:String;
      
      public function NoriaRoomView(param1:GaturroRoom, param2:TaskContainer, param3:InfoReportQueue, param4:GaturroMailer, param5:WhiteListNode)
      {
         super(param1,param3,param4,param5);
         this.logAppenderToStop = logger.getAppender(ErrorDisplayAppender) as ErrorDisplayAppender;
         this.logAppenderToStop.isLogging = false;
      }
      
      override public function dispose() : void
      {
         if(api)
         {
            api.setAvatarAttribute("noria"," ");
         }
         this.logAppenderToStop.isLogging = true;
         if(this.photoButton)
         {
            this.photoButton.dispose();
         }
         if(this.layer1)
         {
            this.layer1.removeEventListener(Event.ENTER_FRAME,this.onFirstLoop);
            this.layer1.removeEventListener(Event.ENTER_FRAME,this.onSecondLoop);
            this.layer1.removeEventListener(Event.ENTER_FRAME,this.onEnding);
         }
         super.dispose();
      }
      
      override protected function addSceneObject(param1:RoomSceneObject) : void
      {
         var _loc2_:Avatar = null;
         if(param1 is Avatar)
         {
            _loc2_ = param1 as Avatar;
            if(_loc2_.username != room.userAvatar.username && _loc2_.username != room.userAvatar.attributes.noria)
            {
               return;
            }
         }
         super.addSceneObject(param1);
      }
      
      override protected function finalInit() : void
      {
         super.finalInit();
         this.photoButton = new PhotoButton(gRoom,api,tasks,false);
         gui.dance_ph.addChild(this.photoButton);
         this.layer1 = (background as MovieClip).layer1;
         this.randomScene = int(Math.random() * 5) + 1;
         this.photoButton.makeVisible();
         setTimeout(this.setMoved,1000 + Math.random() * 500);
      }
      
      override protected function checkIfTileSelected(param1:MouseEvent) : void
      {
         if(!this.moved)
         {
            super.checkIfTileSelected(param1);
         }
      }
      
      private function setMoved() : void
      {
         api.setAvatarAttribute(Gaturro.ACTION_KEY,"sit");
         var _loc1_:String = room.userAvatar.attributes.noria as String;
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
            api.moveToTileXY(5,6);
         }
         this.moved = true;
         if(this.layer1)
         {
            api.playSound("parqueDiversiones/pajaro");
            this.layer1.addEventListener(Event.ENTER_FRAME,this.onFirstLoop);
         }
      }
      
      private function onFirstLoop(param1:Event) : void
      {
         var _loc2_:String = null;
         if(this.layer1.currentLabel == "triggerNext")
         {
            this.layer1.removeEventListener(Event.ENTER_FRAME,this.onFirstLoop);
            this.layer1.addEventListener(Event.ENTER_FRAME,this.onSecondLoop);
            _loc2_ = "escena_" + this.randomScene.toString();
            this.previousFrameLabel = _loc2_;
            this.layer1.gotoAndPlay(_loc2_);
            api.playSound("parqueDiversiones/" + _loc2_);
         }
      }
      
      private function onSecondLoop(param1:Event) : void
      {
         if(this.layer1.currentLabel != this.previousFrameLabel)
         {
            this.layer1.gotoAndPlay("ending");
            api.playSound("parqueDiversiones/pajaro");
            this.layer1.removeEventListener(Event.ENTER_FRAME,this.onSecondLoop);
            this.layer1.addEventListener(Event.ENTER_FRAME,this.onEnding);
         }
      }
      
      private function onEnding(param1:Event) : void
      {
         if(this.layer1.currentLabel == "end")
         {
            this.layer1.stop();
            this.layer1.removeEventListener(Event.ENTER_FRAME,this.onEnding);
            api.changeRoomXY(51688667,5,10);
         }
      }
   }
}

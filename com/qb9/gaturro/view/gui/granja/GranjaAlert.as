package com.qb9.gaturro.view.gui.granja
{
   import com.qb9.flashlib.easing.Tween;
   import com.qb9.flashlib.tasks.Sequence;
   import com.qb9.flashlib.tasks.TaskRunner;
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.view.gui.Gui;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import farm.ReadyFarmIndicator;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class GranjaAlert extends ReadyFarmIndicator
   {
      
      public static const profAttr:String = "cultivosTimer";
      
      public static const LOADED_ATTR:String = "granjaLoaded";
       
      
      private var timer:Timer;
      
      private var room:GaturroRoom;
      
      private var tasks:TaskRunner;
      
      private var attr:String;
      
      private var timeToGrow:Number;
      
      private var api:GaturroRoomAPI;
      
      private var gui:Gui;
      
      public function GranjaAlert(param1:GaturroRoomAPI, param2:Gui, param3:TaskRunner, param4:GaturroRoom)
      {
         super();
         this.api = param1;
         this.gui = param2;
         this.tasks = param3;
         this.room = param4;
         this.attr = String(param1.getProfileAttribute(profAttr));
         this.glow.visible = false;
         if(this.attr != "null")
         {
            this.init();
         }
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         this.mouseOverText.visible = true;
         this.glow.visible = true;
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         this.addToGui();
         var _loc2_:int = width;
         var _loc3_:int = height;
         this.tasks.add(new Sequence(new Tween(this,300,{
            "width":_loc2_ * 1.5,
            "height":_loc3_ * 1.5
         },{"transition":"easeIn"}),new Tween(this,300,{
            "width":_loc2_,
            "height":_loc3_
         },{"transition":"easeIn"})));
         this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         var _loc3_:MouseEvent = null;
         var _loc2_:int = this.api.getSession(LOADED_ATTR) as int;
         if(_loc2_)
         {
            this.room.changeRoomById(_loc2_,19,5);
         }
         else if(this.room.houseRooms.length > 0)
         {
            _loc3_ = new MouseEvent(MouseEvent.CLICK);
            this.gui.houseMap.btn10.dispatchEvent(_loc3_);
         }
         else
         {
            this.room.visit(this.room.userAvatar.username);
         }
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         this.mouseOverText.visible = false;
         this.glow.visible = false;
      }
      
      private function init() : void
      {
         if(!(this.attr == "done" || this.attr == "0"))
         {
            this.timeToGrow = Number(this.attr) - this.api.serverTime;
            if(this.timeToGrow < 0)
            {
               this.addToGui();
            }
            else
            {
               this.timer = new Timer(this.timeToGrow);
               this.timer.addEventListener(TimerEvent.TIMER,this.onTimer);
               this.timer.start();
            }
         }
      }
      
      public function dispose() : void
      {
         if(this.timer)
         {
            this.timer.stop();
            this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
         }
         if(this.hasEventListener(MouseEvent.CLICK))
         {
            this.removeEventListener(MouseEvent.CLICK,this.onClick);
         }
         if(this.hasEventListener(MouseEvent.MOUSE_OVER))
         {
            this.removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         }
         if(this.hasEventListener(MouseEvent.MOUSE_OUT))
         {
            this.removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         }
      }
      
      private function addToGui() : void
      {
         this.gui.jobSidebar.addChild(this);
         this.buttonMode = true;
         this.mouseOverText.visible = false;
         this.addEventListener(MouseEvent.CLICK,this.onClick);
         this.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         this.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
      }
   }
}

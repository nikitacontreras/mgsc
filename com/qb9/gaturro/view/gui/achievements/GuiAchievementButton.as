package com.qb9.gaturro.view.gui.achievements
{
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.gaturro.globals.achievements;
   import com.qb9.gaturro.view.gui.Gui;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public final class GuiAchievementButton extends MovieClip implements IDisposable
   {
       
      
      private var room:GaturroRoom;
      
      private var gui:Gui;
      
      private var tasks:TaskContainer;
      
      public function GuiAchievementButton(param1:Gui, param2:GaturroRoom, param3:TaskContainer)
      {
         super();
         this.room = param2;
         this.tasks = param3;
         this.gui = param1;
         param1.achievements.buttonMode = true;
         param1.achievements.addEventListener(MouseEvent.CLICK,this.clicked);
         com.qb9.gaturro.globals.achievements.addEventListener(com.qb9.gaturro.globals.achievements.NEW_ACHIEVEMENT_REACHED,this.showAchievOnUI);
      }
      
      private function showAchievOnUI(param1:Event) : void
      {
         this.gui.achievements.gotoAndStop(2);
      }
      
      private function clicked(param1:MouseEvent) : void
      {
         this.room.visit(this.room.userAvatar.username);
      }
      
      public function dispose() : void
      {
         com.qb9.gaturro.globals.achievements.removeEventListener(com.qb9.gaturro.globals.achievements.NEW_ACHIEVEMENT_REACHED,this.showAchievOnUI);
         this.gui.achievements.removeEventListener(MouseEvent.CLICK,this.clicked);
         this.gui = null;
         this.tasks = null;
         this.room = null;
      }
   }
}

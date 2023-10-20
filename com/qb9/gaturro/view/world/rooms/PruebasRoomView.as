package com.qb9.gaturro.view.world.rooms
{
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.gaturro.view.world.GaturroRoomView;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.reports.InfoReportQueue;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import com.qb9.mambo.net.mail.Mailer;
   import com.qb9.mambo.world.avatars.Avatar;
   import flash.display.DisplayObject;
   
   public class PruebasRoomView extends GaturroRoomView
   {
       
      
      public function PruebasRoomView(param1:GaturroRoom, param2:TaskContainer, param3:InfoReportQueue, param4:Mailer, param5:WhiteListNode)
      {
         super(param1,param3,param4,param5);
      }
      
      override protected function createAvatar(param1:Avatar) : DisplayObject
      {
         return super.createAvatar(param1);
      }
      
      override protected function finalInit() : void
      {
         super.finalInit();
      }
   }
}

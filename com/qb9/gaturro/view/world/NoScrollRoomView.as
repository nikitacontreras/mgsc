package com.qb9.gaturro.view.world
{
   import com.qb9.flashlib.tasks.TaskRunner;
   import com.qb9.gaturro.view.camera.CameraSwitcher;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.reports.InfoReportQueue;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import com.qb9.mambo.net.mail.Mailer;
   
   public class NoScrollRoomView extends GaturroRoomView
   {
       
      
      public function NoScrollRoomView(param1:GaturroRoom, param2:TaskRunner, param3:InfoReportQueue, param4:Mailer, param5:WhiteListNode)
      {
         super(param1,param3,param4,param5);
      }
      
      override protected function roomCamera() : void
      {
         CameraSwitcher.instance.taskRunner = tasks;
         CameraSwitcher.instance.switchCamera(CameraSwitcher.CUMPLE_ROOM_CAMERA,tileLayer,layers,int(room.attributes.bounds) || 0,userView,room.userAvatar);
      }
   }
}

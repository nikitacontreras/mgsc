package com.qb9.gaturro.view.world
{
   import com.qb9.flashlib.tasks.TaskRunner;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.reports.InfoReportQueue;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import com.qb9.mambo.net.mail.Mailer;
   import com.qb9.mambo.world.avatars.Avatar;
   import flash.display.DisplayObject;
   
   public class SinglePlayerRoomView extends GaturroRoomView
   {
       
      
      public function SinglePlayerRoomView(param1:GaturroRoom, param2:TaskRunner, param3:InfoReportQueue, param4:Mailer, param5:WhiteListNode)
      {
         super(param1,param3,param4,param5);
      }
      
      override protected function createAvatar(param1:Avatar) : DisplayObject
      {
         var _loc2_:DisplayObject = super.createAvatar(param1);
         if(param1 != api.userAvatar)
         {
            _loc2_.visible = false;
         }
         return _loc2_;
      }
   }
}

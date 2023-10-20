package com.qb9.gaturro.view.world
{
   import com.qb9.flashlib.tasks.TaskRunner;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.reports.InfoReportQueue;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import com.qb9.mambo.net.mail.Mailer;
   
   public class CampamentoNocheRoomView extends GaturroRoomView
   {
       
      
      public function CampamentoNocheRoomView(param1:GaturroRoom, param2:TaskRunner, param3:InfoReportQueue, param4:Mailer, param5:WhiteListNode)
      {
         super(param1,param3,param4,param5);
      }
      
      override protected function finalInit() : void
      {
         super.finalInit();
         if(api.timezone.isNight)
         {
            api.playSound("ambience/ambiente_terror",99);
         }
         else
         {
            api.playSound("ambience/cbse_ambiente",99);
         }
      }
      
      override public function dispose() : void
      {
         api.stopSound("ambience/ambiente_terror");
         api.stopSound("ambience/cbse_ambiente");
         super.dispose();
      }
   }
}

package com.qb9.gaturro.view.world
{
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.view.gui.actions.PhotoButton;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.reports.InfoReportQueue;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import com.qb9.mambo.net.mail.Mailer;
   import com.qb9.mambo.world.avatars.Avatar;
   import com.qb9.mambo.world.core.RoomSceneObject;
   
   public class CaminataLunarRoomView extends GaturroRoomView
   {
       
      
      private var roomViewReady:Boolean;
      
      private var photoButton:PhotoButton;
      
      public function CaminataLunarRoomView(param1:GaturroRoom, param2:InfoReportQueue, param3:Mailer, param4:WhiteListNode)
      {
         super(param1,param2,param3,param4);
      }
      
      override protected function addSceneObject(param1:RoomSceneObject) : void
      {
         super.addSceneObject(param1);
         if(param1 is Avatar && this.roomViewReady)
         {
            api.antigravityOn();
         }
      }
      
      override protected function finalInit() : void
      {
         super.finalInit();
         api.antigravityOn();
         this.roomViewReady = true;
         this.photoButton = new PhotoButton(gRoom,api,tasks);
         gui.dance_ph.addChild(this.photoButton);
      }
   }
}

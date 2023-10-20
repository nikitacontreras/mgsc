package com.qb9.gaturro.view.world
{
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.manager.cinema.CinemaManager;
   import com.qb9.gaturro.model.config.cinema.CinemaMovieDefinition;
   import com.qb9.gaturro.net.requests.URLUtil;
   import com.qb9.gaturro.view.world.elements.NpcRoomSceneObjectView;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.reports.InfoReportQueue;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import com.qb9.mambo.net.mail.Mailer;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import fl.video.FLVPlayback;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   
   public class CineGatuberRoomView extends GaturroRoomView
   {
       
      
      private var layer2:MovieClip;
      
      private var currentVideo:CinemaMovieDefinition;
      
      private var videoWall:NpcRoomSceneObjectView;
      
      private var flvPlayback:FLVPlayback;
      
      private var manager:CinemaManager;
      
      public function CineGatuberRoomView(param1:GaturroRoom, param2:TaskContainer, param3:InfoReportQueue, param4:Mailer, param5:WhiteListNode)
      {
         super(param1,param3,param4,param5);
      }
      
      override protected function finalInit() : void
      {
         super.finalInit();
         this.manager = Context.instance.getByType(CinemaManager) as CinemaManager;
         this.currentVideo = this.manager.getDefinition("gate6");
         this.layer2 = (background as MovieClip).layer2;
         this.flvPlayback = new FLVPlayback();
         this.layer2.videoWallPh.addChild(this.flvPlayback);
         this.flvPlayback.source = this.currentVideo.url;
         this.flvPlayback.play();
      }
      
      private function getSkin() : String
      {
         var _loc1_:String = URLUtil.getUrl("banners/SkinUnderPlayStopSeekMuteVol.swf");
         return URLUtil.versionedPath(_loc1_);
      }
      
      override protected function createOtherSceneObject(param1:RoomSceneObject) : DisplayObject
      {
         var _loc2_:DisplayObject = super.createOtherSceneObject(param1);
         if(_loc2_ is NpcRoomSceneObjectView)
         {
            this.captureNPC(_loc2_ as NpcRoomSceneObjectView);
         }
         return _loc2_;
      }
      
      private function captureNPC(param1:NpcRoomSceneObjectView) : void
      {
         if(param1.object.name.indexOf("videoWall_so") != -1)
         {
            this.videoWall = param1;
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}

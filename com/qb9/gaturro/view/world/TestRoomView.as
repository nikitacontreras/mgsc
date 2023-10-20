package com.qb9.gaturro.view.world
{
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.net.secure.MessageAPIMethod;
   import com.qb9.gaturro.net.secure.SecureMessageAPIService;
   import com.qb9.gaturro.service.events.EventsService;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.reports.InfoReportQueue;
   import com.qb9.mambo.geom.Coord;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import com.qb9.mambo.net.mail.Mailer;
   import com.qb9.mambo.world.avatars.Avatar;
   import com.qb9.mambo.world.avatars.events.MovingRoomSceneObjectEvent;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   
   public class TestRoomView extends GaturroRoomView
   {
       
      
      private var secureMessage:SecureMessageAPIService;
      
      public function TestRoomView(param1:GaturroRoom, param2:TaskContainer, param3:InfoReportQueue, param4:Mailer, param5:WhiteListNode)
      {
         var room:GaturroRoom = param1;
         var tasks:TaskContainer = param2;
         var reports:InfoReportQueue = param3;
         var mailer:Mailer = param4;
         var iphoneWhitelist:WhiteListNode = param5;
         super(room,reports,mailer,iphoneWhitelist);
         logger.debug(this,"what you hear is not a test");
         this.secureMessage = new SecureMessageAPIService();
         this.secureMessage.getNewestMessages(10,0);
         this.secureMessage.addEventListener(MessageAPIMethod.GET_NEWEST,function(param1:Event):void
         {
            trace(param1);
         });
         this.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
      }
      
      private function stop(param1:MovingRoomSceneObjectEvent) : void
      {
         var _loc2_:EventsService = null;
         var _loc3_:Object = null;
         logger.debug(this,param1);
         if(param1.object.coord.distance(new Coord(8,8)) == 0)
         {
            if(Context.instance.getByType(EventsService) as EventsService)
            {
               logger.debug(this,"sending mail");
               _loc2_ = Context.instance.getByType(EventsService) as EventsService;
               _loc3_ = !!_loc2_.eventData ? _loc2_.eventData.asJSONString() : "noData";
               gaturroMailer.sendMail(api.user.username,api.user.username + " te invito a su fiesta|" + _loc3_,"TE INVITARON A UNA FIESTA");
            }
         }
      }
      
      private function onKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.charCode == Keyboard.SPACE)
         {
            this.secureMessage.newMessage("hola","probando la mensajeria","KORBEN");
         }
      }
      
      override protected function createAvatar(param1:Avatar) : DisplayObject
      {
         var _loc2_:DisplayObject = super.createAvatar(param1);
         if(param1 == api.userAvatar)
         {
            param1.addEventListener(MovingRoomSceneObjectEvent.STOPPED_MOVING,this.stop);
         }
         return _loc2_;
      }
   }
}

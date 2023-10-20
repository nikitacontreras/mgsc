package com.qb9.gaturro.view.world
{
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.logs.ErrorDisplayAppender;
   import com.qb9.gaturro.net.mail.GaturroMailer;
   import com.qb9.gaturro.view.world.elements.NpcRoomSceneObjectView;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.npc.struct.behavior.NpcBehaviorEvent;
   import com.qb9.gaturro.world.reports.InfoReportQueue;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import com.qb9.mambo.view.world.tiling.TileView;
   import com.qb9.mambo.world.avatars.Avatar;
   import com.qb9.mambo.world.avatars.UserAvatar;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import com.qb9.mambo.world.tiling.Tile;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class GaturroCamugataFightRoomView extends GaturroRoomView
   {
       
      
      private var leftBorderX:int;
      
      private var enemyAttrKey:String;
      
      private var logAppenderToStop:ErrorDisplayAppender;
      
      private var enemyName:String;
      
      private var fightPosY:int;
      
      private var fightingNPC:NpcRoomSceneObjectView;
      
      private var enemyDefeated:Boolean;
      
      private var fightPosX:int;
      
      public function GaturroCamugataFightRoomView(param1:GaturroRoom, param2:TaskContainer, param3:InfoReportQueue, param4:GaturroMailer, param5:WhiteListNode)
      {
         super(param1,param3,param4,param5);
         this.logAppenderToStop = logger.getAppender(ErrorDisplayAppender) as ErrorDisplayAppender;
         this.logAppenderToStop.isLogging = false;
         this.leftBorderX = param1.attributes.leftBorderX;
         this.fightPosX = param1.attributes.fightPosX;
         this.fightPosY = param1.attributes.fightPosY;
         this.enemyName = param1.attributes.enemyName;
         this.enemyAttrKey = param1.attributes.enemyAttrKey;
      }
      
      private function isBeyondCoords(param1:TileView) : Boolean
      {
         if(!param1)
         {
            return false;
         }
         var _loc2_:Tile = param1.tile;
         return _loc2_.coord.x < this.fightingNPC.object.coord.x + 3;
      }
      
      override protected function checkIfTileSelected(param1:MouseEvent) : void
      {
         var _loc2_:TileView = getTileViewFromEvent(param1);
         var _loc3_:Object = api.JSONDecode(api.user.attributes.quest1);
         this.enemyDefeated = Boolean(_loc3_) && Boolean(_loc3_.gatoons) && Boolean(_loc3_.gatoons[this.enemyAttrKey]);
         var _loc4_:UserAvatar = api.userAvatar;
         if(!this.enemyDefeated && this.isBeyondCoords(_loc2_))
         {
            if(_loc4_.coord.x != this.leftBorderX)
            {
               api.moveToTileXY(this.fightPosX,this.fightPosY);
            }
            this.fightingNPC.dispatchEvent(new Event(NpcBehaviorEvent.SPECIAL_ROOM_ACTIVATE));
         }
         else
         {
            super.checkIfTileSelected(param1);
         }
      }
      
      override protected function createOtherSceneObject(param1:RoomSceneObject) : DisplayObject
      {
         var _loc2_:DisplayObject = super.createOtherSceneObject(param1);
         if(_loc2_ is NpcRoomSceneObjectView)
         {
            if((_loc2_ as NpcRoomSceneObjectView).object.name == this.enemyName)
            {
               this.fightingNPC = _loc2_ as NpcRoomSceneObjectView;
            }
         }
         return _loc2_;
      }
      
      override protected function addSceneObject(param1:RoomSceneObject) : void
      {
         if(param1 is Avatar && (param1 as Avatar).username != room.userAvatar.username)
         {
            return;
         }
         super.addSceneObject(param1);
      }
      
      override public function dispose() : void
      {
         this.logAppenderToStop.isLogging = true;
         super.dispose();
      }
   }
}

package com.qb9.gaturro.view.world.rooms
{
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.event.ContextEvent;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.manager.movement.MovementManager;
   import com.qb9.gaturro.view.gui.actions.PistaPatinButton;
   import com.qb9.gaturro.view.world.GaturroRoomView;
   import com.qb9.gaturro.view.world.movement.MovementsEnum;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.core.elements.NpcRoomSceneObject;
   import com.qb9.gaturro.world.reports.InfoReportQueue;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import com.qb9.mambo.net.mail.Mailer;
   import com.qb9.mambo.view.world.tiling.TileView;
   import com.qb9.mambo.world.avatars.Avatar;
   import com.qb9.mambo.world.avatars.UserAvatar;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class PistaPatinRoomView extends GaturroRoomView
   {
       
      
      private var _timeoutId:uint;
      
      private var _whiteListTransp:Array;
      
      private var _whiteListFoot:Array;
      
      private var _celebrateButton:PistaPatinButton;
      
      private var movementManager:MovementManager;
      
      public function PistaPatinRoomView(param1:GaturroRoom, param2:TaskContainer, param3:InfoReportQueue, param4:Mailer, param5:WhiteListNode)
      {
         this._whiteListFoot = ["nieve2017/","sportClothes"];
         this._whiteListTransp = ["nieve2017/","transport.motoNieve"];
         super(param1,param3,param4,param5);
         this.setup();
      }
      
      override protected function finalInit() : void
      {
         super.finalInit();
         this._celebrateButton = new PistaPatinButton(gRoom,room.userAvatar,this.doKick,stage);
         gui.dance_ph.addChild(this._celebrateButton);
         if(!this.checkValidShoe())
         {
            this.kick();
         }
         room.userAvatar.addCustomAttributeListener("foot",this.onShoeChange);
      }
      
      private function setupMovementManager() : void
      {
         if(Context.instance.hasByType(MovementManager))
         {
            this.movementManager = Context.instance.getByType(MovementManager) as MovementManager;
         }
         else
         {
            Context.instance.addEventListener(ContextEvent.ADDED,this.onMovementManagerAdded);
         }
      }
      
      private function onShoeChange(param1:Event) : void
      {
         if(!this.checkValidShoe())
         {
            this.kick();
         }
      }
      
      override protected function createAvatar(param1:Avatar) : DisplayObject
      {
         var _loc2_:DisplayObject = super.createAvatar(param1);
         this.movementManager.addMovement(MovementsEnum.HORIZONTAL_FLIPPING,_loc2_);
         this.movementManager.addMovement(MovementsEnum.SKI,_loc2_);
         this.movementManager.start();
         return _loc2_;
      }
      
      private function checkValidShoe() : Boolean
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._whiteListFoot.length)
         {
            if(Boolean(room.userAvatar.attributes["foot"]) && (room.userAvatar.attributes["foot"] as String).indexOf(this._whiteListFoot[_loc1_]) != -1)
            {
               return true;
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this._whiteListTransp.length)
         {
            if(Boolean(room.userAvatar.attributes["transport"]) && (room.userAvatar.attributes["transport"] as String).indexOf(this._whiteListTransp[_loc1_]) != -1)
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      override protected function createSceneObject(param1:RoomSceneObject) : DisplayObject
      {
         var _loc2_:DisplayObject = super.createSceneObject(param1);
         if(param1 is NpcRoomSceneObject)
         {
            this.movementManager.addMovement(MovementsEnum.HORIZONTAL_FLIPPING,_loc2_);
            this.movementManager.addMovement(MovementsEnum.SKI,_loc2_);
         }
         return _loc2_;
      }
      
      private function doKick() : void
      {
         clearTimeout(this._timeoutId);
         api.changeRoomXY(25368,10,10);
      }
      
      override protected function whenAddedToStage() : void
      {
         super.whenAddedToStage();
      }
      
      override protected function createOtherSceneObject(param1:RoomSceneObject) : DisplayObject
      {
         trace("PistaPatinRoomView > createOtherSceneObject > obj: " + param1);
         return super.createOtherSceneObject(param1);
      }
      
      private function onMovementManagerAdded(param1:ContextEvent) : void
      {
         if(param1.instanceType == MovementManager)
         {
            Context.instance.removeEventListener(ContextEvent.ADDED,this.onMovementManagerAdded);
            this.movementManager = Context.instance.getByType(MovementManager) as MovementManager;
         }
      }
      
      override protected function checkIfTileSelected(param1:MouseEvent) : void
      {
         var _loc2_:TileView = getTileViewFromEvent(param1);
         var _loc3_:UserAvatar = api.userAvatar;
         if(_loc2_)
         {
            api.moveToTileXY(_loc3_.coord.x,_loc2_.tile.coord.y);
         }
      }
      
      private function setup() : void
      {
         this.setupMovementManager();
      }
      
      private function kick() : void
      {
         api.showModal("CUIDADO! LA PISTA DE HIELO ES PELIGROSO SIN PATINES, EQUIPATE LOS PATINES PARA ENTRAR","information");
         this._timeoutId = setTimeout(this.doKick,5000);
      }
   }
}

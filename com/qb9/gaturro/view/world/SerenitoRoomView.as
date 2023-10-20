package com.qb9.gaturro.view.world
{
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.gaturro.view.world.elements.NpcRoomSceneObjectView;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.npc.struct.behavior.NpcBehaviorEvent;
   import com.qb9.gaturro.world.reports.InfoReportQueue;
   import com.qb9.mambo.core.attributes.events.CustomAttributeEvent;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import com.qb9.mambo.net.mail.Mailer;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import flash.display.DisplayObject;
   import flash.events.Event;
   
   public class SerenitoRoomView extends GaturroRoomView
   {
       
      
      private var contador:NpcRoomSceneObjectView;
      
      private var emojimetro:NpcRoomSceneObjectView;
      
      public function SerenitoRoomView(param1:GaturroRoom, param2:TaskContainer, param3:InfoReportQueue, param4:Mailer, param5:WhiteListNode)
      {
         super(param1,param3,param4,param5);
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
         if(param1.object.name.indexOf("emojimetro_so") != -1)
         {
            this.emojimetro = param1;
         }
         else if(param1.object.name.indexOf("emojimetroCuenta_so") != -1)
         {
            this.contador = param1;
         }
      }
      
      override protected function finalInit() : void
      {
         super.finalInit();
         this.emojimetro.object.addCustomAttributeListener("carga",this.onCarga);
      }
      
      override public function dispose() : void
      {
         this.emojimetro.object.removeCustomAttributeListener("carga",this.onCarga);
         super.dispose();
      }
      
      private function onCarga(param1:CustomAttributeEvent) : void
      {
         var _loc2_:Event = new Event(NpcBehaviorEvent.MULTIPLAYER_ACTIVATE);
         this.emojimetro.dispatchEvent(_loc2_);
         this.contador.dispatchEvent(_loc2_);
      }
   }
}

package com.qb9.gaturro.view.world
{
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.reports.InfoReportQueue;
   import com.qb9.mambo.core.attributes.events.CustomAttributeEvent;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import com.qb9.mambo.net.mail.Mailer;
   import com.qb9.mambo.world.avatars.Avatar;
   import com.qb9.mambo.world.avatars.UserAvatar;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import com.qb9.mambo.world.core.events.RoomEvent;
   
   public class ParqueDiversionesRoomView extends GaturroRoomView
   {
       
      
      public function ParqueDiversionesRoomView(param1:GaturroRoom, param2:InfoReportQueue, param3:Mailer, param4:WhiteListNode)
      {
         super(param1,param2,param3,param4);
      }
      
      private function onNoriaSet(param1:CustomAttributeEvent) : void
      {
         var _loc2_:Avatar = null;
         if(api.user.username == param1.attribute.value.toString())
         {
            _loc2_ = param1.currentTarget as Avatar;
            api.textMessageToGUI(_loc2_.username + ": SUBE CONMIGO");
            api.playSound("alturaDeseada");
         }
      }
      
      private function onLoveTunnelSet(param1:CustomAttributeEvent) : void
      {
         var _loc2_:Avatar = null;
         trace("HospitalRoomView > onLoveTunnelSet > attribute= " + param1.attribute.value + " ___> " + api.user.username);
         if(api.user.username == param1.attribute.value.toString())
         {
            _loc2_ = param1.currentTarget as Avatar;
            api.textMessageToGUI(_loc2_.username + ": VEN A LA GRUTA DEL AMOR");
            api.playSound("alturaDeseada");
         }
      }
      
      override protected function addSceneObject(param1:RoomSceneObject) : void
      {
         var _loc2_:Avatar = null;
         if(param1 is Avatar)
         {
            _loc2_ = param1 as Avatar;
            if(_loc2_.username == room.userAvatar.username)
            {
               room.userAvatar.attributes.tunelFantastico = " ";
               room.userAvatar.attributes.loveTunnel = " ";
               room.userAvatar.attributes.noria = " ";
            }
            if(room.id == 51688280)
            {
               _loc2_.addCustomAttributeListener("loveTunnel",this.onLoveTunnelSet);
            }
            else if(room.id == 51688667)
            {
               _loc2_.addCustomAttributeListener("noria",this.onNoriaSet);
            }
            else if(room.id == 51688751)
            {
               _loc2_.addCustomAttributeListener(FantasticTunnelRoomView.TUNEL_FANTASTICO,this.onTunelFantasticoSet);
            }
         }
         super.addSceneObject(param1);
      }
      
      private function onTunelFantasticoSet(param1:CustomAttributeEvent) : void
      {
         var _loc2_:Avatar = null;
         if(api.user.username == param1.attribute.value.toString())
         {
            _loc2_ = param1.currentTarget as Avatar;
            api.textMessageToGUI(_loc2_.username + ": SUBE CONMIGO");
            api.playSound("alturaDeseada");
         }
      }
      
      override protected function removeSceneObject(param1:RoomEvent) : void
      {
         var _loc3_:UserAvatar = null;
         var _loc2_:RoomSceneObject = param1.sceneObject;
         if(_loc2_ is UserAvatar)
         {
            _loc3_ = _loc2_ as UserAvatar;
            if(room.id == 51688309)
            {
               _loc3_.removeCustomAttributeListener("loveTunnel",this.onLoveTunnelSet);
            }
            else if(room.id == 51688668)
            {
               _loc3_.removeCustomAttributeListener("noria",this.onNoriaSet);
            }
            else if(room.id == 51688751)
            {
               _loc3_.removeCustomAttributeListener(FantasticTunnelRoomView.TUNEL_FANTASTICO,this.onTunelFantasticoSet);
            }
         }
         super.removeSceneObject(param1);
      }
   }
}

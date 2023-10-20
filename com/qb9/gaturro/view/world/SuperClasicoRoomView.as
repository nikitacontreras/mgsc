package com.qb9.gaturro.view.world
{
   import com.qb9.flashlib.tasks.TaskRunner;
   import com.qb9.gaturro.editor.NetActionManager;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.net;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.reports.InfoReportQueue;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import com.qb9.mambo.net.mail.Mailer;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class SuperClasicoRoomView extends GaturroRoomView
   {
       
      
      private var arrow:MovieClip;
      
      private var actions:NetActionManager;
      
      public function SuperClasicoRoomView(param1:GaturroRoom, param2:TaskRunner, param3:InfoReportQueue, param4:Mailer, param5:WhiteListNode)
      {
         super(param1,param3,param4,param5);
      }
      
      private function onArrowLoad(param1:DisplayObject) : void
      {
         this.arrow = param1 as MovieClip;
         this.arrow.gotoAndStop(2);
         gui.interactionDisplayer.addChild(this.arrow);
         gui.interactionDisplayer.addEventListener(MouseEvent.CLICK,this.onFirstClick);
      }
      
      private function onSecondClick(param1:MouseEvent) : void
      {
         gui.interactionDisplayer.removeChild(this.arrow);
         gui.interactionDisplayer.removeEventListener(MouseEvent.CLICK,this.onSecondClick);
         this.arrow = null;
      }
      
      override protected function finalInit() : void
      {
         super.finalInit();
         api.libraries.fetch("superclasico/props.arrowInteraction",this.onArrowLoad);
         var _loc1_:String = api.getAvatarAttribute("superClasico2018TEAM") as String;
         if(_loc1_ == "RIVER")
         {
            api.setAvatarAttribute("medal","river");
         }
         else if(_loc1_ == "BOCA")
         {
            api.setAvatarAttribute("medal","boca");
         }
         else if(_loc1_ == "" || _loc1_ == "empty" || _loc1_ == null || _loc1_ == " ")
         {
            api.showBannerModal("superclasicoBocaRiver");
         }
         var _loc2_:Object = api.getProfileAttribute("premioLibertadores18");
         this.actions = new NetActionManager(net,gRoom);
         if(_loc1_ == "RIVER" && _loc2_ != "true")
         {
            api.setProfileAttribute("premioLibertadores18","true");
            api.showAwardModal("\n\n¡CAMPEON DE LA COPA!","superclasico/props.copa");
            this.actions.inventoryAdd("superclasico/props.copa",1);
         }
         else if(_loc1_ == "BOCA" && _loc2_ != "true")
         {
            api.setProfileAttribute("premioLibertadores18","true");
            api.showAwardModal("¡GRACIAS POR COMPETIR EN ESTE SUPERCLASICO!"," ");
         }
      }
      
      private function onFirstClick(param1:MouseEvent) : void
      {
         gui.interactionDisplayer.addEventListener(MouseEvent.CLICK,this.onSecondClick);
         gui.interactionDisplayer.removeEventListener(MouseEvent.CLICK,this.onFirstClick);
         this.arrow.gotoAndStop(3);
      }
   }
}

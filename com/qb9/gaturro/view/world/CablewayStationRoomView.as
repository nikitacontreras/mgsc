package com.qb9.gaturro.view.world
{
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.net.mail.GaturroMailer;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.core.avatar.GaturroUserAvatar;
   import com.qb9.gaturro.world.reports.InfoReportQueue;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class CablewayStationRoomView extends GaturroRoomView
   {
      
      private static const FREQ_SUBTE_TIMER:uint = 10000;
       
      
      private var _subteFreq:Array;
      
      private var gate:MovieClip;
      
      private var _currentSubte:String;
      
      private var _currentIndexSubte:int;
      
      private var _timeoutId:uint;
      
      private var tubeGui:Object;
      
      private var _layer2:MovieClip;
      
      private var _layer3:MovieClip;
      
      private var _userAvatar:GaturroUserAvatar;
      
      private var _arrowEntrance:MovieClip;
      
      private var cablewayMC:MovieClip;
      
      private var _textoEstacion:MovieClip;
      
      private var _cantidadDeTrenesDejaronPasar:int;
      
      private var _subteTimer:uint;
      
      private var _subio:Boolean = false;
      
      public function CablewayStationRoomView(param1:GaturroRoom, param2:TaskContainer, param3:InfoReportQueue, param4:GaturroMailer, param5:WhiteListNode)
      {
         this._subteFreq = ["VIP","NORMAL"];
         super(param1,param3,param4,param5);
      }
      
      private function setupDisplay() : void
      {
         this._layer3 = background["layer3"];
         this.gate = this._layer3["hitAreaSubte"];
         this._arrowEntrance = this._layer3["arrowEntrance"];
         gui.dance_ph.addChild(this.gate);
         this.gate.addEventListener(MouseEvent.CLICK,this.getIn);
         this.gate.visible = false;
         this.gate.buttonMode = true;
         this._arrowEntrance.visible = false;
         this._layer2 = background["layer2"];
         this._textoEstacion = this._layer2["nombreEstacionMC"];
         this._userAvatar = room.userAvatar as GaturroUserAvatar;
         this.setupStation();
      }
      
      private function update(param1:Event) : void
      {
         if(this.cablewayMC && this.cablewayMC.currentLabel == "estacion" && !this.gate.visible)
         {
            this.gate.visible = true;
            this._arrowEntrance.visible = true;
            api.playSound("nieve2017/abrenPuertas");
         }
         else if(Boolean(this.cablewayMC) && this.cablewayMC.currentLabel != "estacion")
         {
            this._arrowEntrance.visible = false;
            this._layer3.hitAreaSubte.visible = false;
         }
         if(Boolean(this.cablewayMC) && this.cablewayMC.totalFrames == this.cablewayMC.currentFrame)
         {
            this.cablewayMC.removeEventListener(Event.ENTER_FRAME,this.update);
            this.cablewayMC.gotoAndStop(0);
            ++this._cantidadDeTrenesDejaronPasar;
            this.startFrequency();
         }
      }
      
      private function setupStation() : void
      {
      }
      
      private function startFrequency() : void
      {
         this._subteTimer = setTimeout(this.subteArriving,FREQ_SUBTE_TIMER);
      }
      
      private function getIn(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         if(Boolean(this.cablewayMC) && this.cablewayMC.currentLabel == "estacion")
         {
            if(this._currentSubte == "VIP")
            {
               if(!this._userAvatar.isCitizen)
               {
                  api.showBannerModal("pasaporte2");
                  api.trackEvent("FEATURES:CABLEWAY:STATION:VAGON_VIP:USER_PUB","");
                  return;
               }
               _loc3_ = "FEATURES:CABLEWAY:STATION:VAGON_VIP:USER_VIP";
               _loc2_ = 51689163;
            }
            else
            {
               _loc3_ = this._userAvatar.isCitizen ? "FEATURES:CABLEWAY:STATION:VAGON_PUB:USER_VIP" : "FEATURES:CABLEWAY:STATION:VAGON_PUB:NO_VIP";
               _loc2_ = 51689164;
            }
            api.setSession("cablewayStation",room.id);
            api.trackEvent(_loc3_,this._cantidadDeTrenesDejaronPasar.toString());
            this._subio = true;
            api.changeRoomXY(_loc2_,5,7);
         }
      }
      
      override public function dispose() : void
      {
         if(!this._subio)
         {
            if(this._userAvatar.isCitizen)
            {
               api.trackEvent("FEATURES:CABLEWAY:STATION:NO_USO:USER_VIP",this._cantidadDeTrenesDejaronPasar.toString());
            }
            else
            {
               api.trackEvent("FEATURES:CABLEWAY:STATION:NO_USO:USER_PUB",this._cantidadDeTrenesDejaronPasar.toString());
            }
         }
         clearTimeout(this._timeoutId);
         clearTimeout(this._subteTimer);
         this.gate.removeEventListener(MouseEvent.CLICK,this.getIn);
         super.dispose();
      }
      
      private function subteArriving() : void
      {
         clearTimeout(this._subteTimer);
         this._currentSubte = this._subteFreq[this._currentIndexSubte];
         if(this._currentSubte == "VIP")
         {
            this.cablewayMC = this._layer3["telefericoPasaporteroMC"];
         }
         else
         {
            this.cablewayMC = this._layer3["telefericoMC"];
         }
         api.playSound("nieve2017/telefericoVarado");
         this.cablewayMC.gotoAndPlay(0);
         this.cablewayMC.addEventListener(Event.ENTER_FRAME,this.update);
         this.nextSubte();
      }
      
      override protected function finalInit() : void
      {
         this.setupDisplay();
         this.startFrequency();
         super.finalInit();
      }
      
      private function nextSubte() : void
      {
         ++this._currentIndexSubte;
         if(this._currentIndexSubte > 1)
         {
            this._currentIndexSubte = 0;
         }
      }
   }
}

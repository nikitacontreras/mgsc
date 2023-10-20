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
   
   public class EstacionSubteRoomView extends GaturroRoomView
   {
      
      private static const FREQ_SUBTE_TIMER:uint = 10000;
       
      
      private var _subteMC:MovieClip;
      
      private var _subteFreq:Array;
      
      private var _currentSubte:String;
      
      private var _currentIndexSubte:int;
      
      private var _timeoutId:uint;
      
      private var tubeGui:Object;
      
      private var _layer2:MovieClip;
      
      private var _layer3:MovieClip;
      
      private var _userAvatar:GaturroUserAvatar;
      
      private var _arrowEntrance:MovieClip;
      
      private var _textoEstacion:MovieClip;
      
      private var _cantidadDeTrenesDejaronPasar:int;
      
      private var _subteTimer:uint;
      
      private var _subio:Boolean = false;
      
      private var _subtePortal:MovieClip;
      
      public function EstacionSubteRoomView(param1:GaturroRoom, param2:TaskContainer, param3:InfoReportQueue, param4:GaturroMailer, param5:WhiteListNode)
      {
         this._subteFreq = ["VIP","NORMAL"];
         super(param1,param3,param4,param5);
      }
      
      private function nextSubte() : void
      {
         ++this._currentIndexSubte;
         if(this._currentIndexSubte > 1)
         {
            this._currentIndexSubte = 0;
         }
      }
      
      private function update(param1:Event) : void
      {
         var e:Event = param1;
         if(this._subteMC && this._subteMC.currentLabel == "estacion" && !this._subtePortal.visible)
         {
            this._subtePortal.visible = true;
            this._arrowEntrance.visible = true;
            api.playSound("subte2017/puertaAbre");
            this._timeoutId = setTimeout(function():void
            {
               api.playSound("subte2017/avisoCierre");
               api.playSound("subte2017/puertaCierra");
            },3000);
         }
         else if(Boolean(this._subteMC) && this._subteMC.currentLabel != "estacion")
         {
            this._arrowEntrance.visible = false;
            this._layer3.hitAreaSubte.visible = false;
         }
         if(Boolean(this._subteMC) && this._subteMC.totalFrames == this._subteMC.currentFrame)
         {
            this._subteMC.removeEventListener(Event.ENTER_FRAME,this.update);
            this._subteMC.gotoAndStop(0);
            ++this._cantidadDeTrenesDejaronPasar;
            this.startFrequency();
         }
      }
      
      private function setupDisplay() : void
      {
         this._layer3 = background["layer3"];
         this._subtePortal = this._layer3["hitAreaSubte"];
         this._arrowEntrance = this._layer3["arrowEntrance"];
         gui.dance_ph.addChild(this._subtePortal);
         gui.dance_ph.addChild(this._arrowEntrance);
         this._subtePortal.addEventListener(MouseEvent.CLICK,this.subirAlSubte);
         this._subtePortal.visible = false;
         this._subtePortal.buttonMode = true;
         this._arrowEntrance.visible = false;
         this._layer2 = background["layer2"];
         this._textoEstacion = this._layer2["nombreEstacionMC"];
         this._userAvatar = room.userAvatar as GaturroUserAvatar;
         this.setupStation();
      }
      
      private function setupStation() : void
      {
      }
      
      private function startFrequency() : void
      {
         this._subteTimer = setTimeout(this.subteArriving,FREQ_SUBTE_TIMER);
         api.stopSound("subte2017/subteLlega");
         api.playSound("subte2017/subteLlega");
      }
      
      override public function dispose() : void
      {
         if(!this._subio)
         {
            if(this._userAvatar.isCitizen)
            {
               api.trackEvent("FEATURES:SUBTE:ESTACION:NO_USO:USER_VIP",this._cantidadDeTrenesDejaronPasar.toString());
            }
            else
            {
               api.trackEvent("FEATURES:SUBTE:ESTACION:NO_USO:USER_PUB",this._cantidadDeTrenesDejaronPasar.toString());
            }
         }
         api.stopSound("subte2017/subteLlega");
         clearTimeout(this._timeoutId);
         clearTimeout(this._subteTimer);
         this._subtePortal.removeEventListener(MouseEvent.CLICK,this.subirAlSubte);
         super.dispose();
      }
      
      private function subirAlSubte(param1:MouseEvent) : void
      {
         if(Boolean(this._subteMC) && this._subteMC.currentLabel == "estacion")
         {
            if(this._currentSubte == "VIP")
            {
               if(!this._userAvatar.isCitizen)
               {
                  api.showBannerModal("pasaporte2");
                  api.trackEvent("FEATURES:SUBTE:ESTACION:VAGON_VIP:USER_PUB","");
                  return;
               }
               api.setSession("station",room.id);
               api.trackEvent("FEATURES:SUBTE:ESTACION:VAGON_VIP:USER_VIP",this._cantidadDeTrenesDejaronPasar.toString());
               this._subio = true;
               api.changeRoomXY(51689114,10,10);
            }
            else
            {
               api.setSession("station",room.id);
               if(this._userAvatar.isCitizen)
               {
                  api.trackEvent("FEATURES:SUBTE:ESTACION:VAGON_PUB:USER_VIP",this._cantidadDeTrenesDejaronPasar.toString());
               }
               else
               {
                  api.trackEvent("FEATURES:SUBTE:ESTACION:VAGON_PUB:NO_VIP",this._cantidadDeTrenesDejaronPasar.toString());
               }
               this._subio = true;
               api.changeRoomXY(51688995,10,10);
            }
         }
      }
      
      private function subteArriving() : void
      {
         clearTimeout(this._subteTimer);
         this._currentSubte = this._subteFreq[this._currentIndexSubte];
         if(this._currentSubte == "VIP")
         {
            this._subteMC = this._layer3["subtePasaporteMC"];
         }
         else
         {
            this._subteMC = this._layer3["subteMC"];
         }
         this._subteMC.gotoAndPlay(0);
         startShake(4500,2,false);
         this._subteMC.addEventListener(Event.ENTER_FRAME,this.update);
         this.nextSubte();
      }
      
      override protected function finalInit() : void
      {
         this.setupDisplay();
         this.startFrequency();
         super.finalInit();
      }
   }
}

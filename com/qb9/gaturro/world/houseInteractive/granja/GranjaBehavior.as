package com.qb9.gaturro.world.houseInteractive.granja
{
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.net.metrics.Telemetry;
   import com.qb9.gaturro.net.metrics.TrackActions;
   import com.qb9.gaturro.net.metrics.TrackCategories;
   import com.qb9.gaturro.view.world.GaturroHomeGranjaView;
   import com.qb9.gaturro.view.world.elements.HomeInteractiveRoomSceneObjectView;
   import com.qb9.gaturro.world.houseInteractive.HomeBehavior;
   import com.qb9.gaturro.world.houseInteractive.silo.SiloManager;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.filters.GlowFilter;
   import flash.utils.Timer;
   
   public class GranjaBehavior extends HomeBehavior implements IDisposable
   {
       
      
      private const STATE_GROWING:int = 1;
      
      private var timer:Timer;
      
      private var locked:Boolean;
      
      private var amountToRemove:int;
      
      private const STATE_LOCKED:int = 3;
      
      private var previousState:int;
      
      private var siloManager:SiloManager;
      
      private var changedFrame:Boolean;
      
      private var granjaView:GaturroHomeGranjaView;
      
      private var view:HomeInteractiveRoomSceneObjectView;
      
      private var plant:MovieClip;
      
      private const STATE_READY:int = 2;
      
      private const STATE_PLANT:int = 0;
      
      public function GranjaBehavior()
      {
         super();
         this.previousState = int.MIN_VALUE;
      }
      
      private function onTimerVisitor(param1:TimerEvent = null) : void
      {
         var _loc2_:MovieClip = null;
         if(this.previousState != int.MIN_VALUE && this.previousState != this.currentState)
         {
            if(this.previousState == this.STATE_PLANT && this.currentState == this.STATE_GROWING)
            {
               roomAPI.libraries.fetch(objectAPI.getAttribute("plant").toString(),this.addPlant);
            }
            else if(this.previousState == this.STATE_GROWING && this.currentState == this.STATE_READY)
            {
               _loc2_ = asset.plantPH.getChildAt(0);
               _loc2_.gotoAndStop(_loc2_.currentLabels[this.currentState - 1].name);
            }
            else if(this.previousState == this.STATE_READY && this.currentState == this.STATE_PLANT)
            {
               asset.plantPH.removeChildAt(0);
            }
         }
         this.previousState = this.currentState;
      }
      
      private function addPlant(param1:DisplayObject) : void
      {
         this.plant = param1 as MovieClip;
         asset.plantPH.addChild(this.plant);
         this.plant.gotoAndStop(this.plant.currentLabels[this.currentState - 1].name);
         if(this.currentState == this.STATE_GROWING && isOwner)
         {
            this.timer.addEventListener(TimerEvent.TIMER,this.onTimer);
         }
      }
      
      public function removePlant() : void
      {
         this.currentState = this.STATE_PLANT;
         asset.plantPH.removeChildAt(0);
         objectAPI.setAttribute("plant","none");
         objectAPI.setAttribute("time",0);
         roomAPI.playSound("granja/eliminar");
      }
      
      override public function set currentState(param1:int) : void
      {
         if(Boolean(states) && param1 > states.length)
         {
            param1 = 0;
         }
         if(objectAPI)
         {
            objectAPI.setAttribute("state",param1);
         }
         super.currentState = param1;
         this.changeTooltip();
      }
      
      private function changeTooltip() : void
      {
         if(!asset)
         {
            return;
         }
         if(this.locked)
         {
            asset.tooltip.text = roomAPI.getText(settings.granjaHome.parcelaTooltips.locked);
            return;
         }
         switch(this.currentState)
         {
            case this.STATE_PLANT:
               asset.tooltip.text = roomAPI.getText(settings.granjaHome.parcelaTooltips.plant);
               break;
            case this.STATE_GROWING:
               asset.tooltip.text = this.tooltipTime;
               break;
            case this.STATE_READY:
               asset.tooltip.text = roomAPI.getText(settings.granjaHome.parcelaTooltips.ready);
         }
      }
      
      override public function dispose() : void
      {
         if(Boolean(this.timer) && this.timer.hasEventListener(TimerEvent.TIMER))
         {
            this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this.timer.removeEventListener(TimerEvent.TIMER,this.onTimerVisitor);
         }
         super.dispose();
      }
      
      private function onSiloFullAnimationEnterFrame(param1:Event) : void
      {
         if(asset.siloFull.currentFrame == asset.siloFull.totalFrames)
         {
            asset.siloFull.stop();
            asset.siloFull.visible = false;
            asset.siloFull.removeEventListener(Event.ENTER_FRAME,this.onSiloFullAnimationEnterFrame);
         }
      }
      
      override public function activate() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:String = null;
         if(!isOwner)
         {
            return;
         }
         if(this.locked)
         {
            roomAPI.showParcelaUnlockModal(objectAPI);
            asset.filters = [new GlowFilter(16777215,1,6,6,5)];
            roomAPI.playSound("cosas2");
         }
         else if(this.currentState == this.STATE_PLANT)
         {
            objectAPI.view.addEventListener(Event.ACTIVATE,this.bannerClosed);
            if(this.granjaView.planting)
            {
               this.granjaView.plantActiveCrop(objectAPI);
               roomAPI.playSound("granja/saleBrote");
            }
            else
            {
               roomAPI.showGranjaModal(objectAPI);
               asset.filters = [new GlowFilter(16777215,1,6,6,5)];
            }
         }
         else if(this.currentState == this.STATE_GROWING)
         {
            roomAPI.showCropTimeModal(objectAPI,this);
            asset.filters = [new GlowFilter(16777215,1,6,6,5)];
         }
         else if(this.currentState == this.STATE_READY && !this.siloManager.isFull)
         {
            this.currentState = this.STATE_PLANT;
            _loc1_ = asset.plantPH.removeChildAt(0);
            _loc2_ = String(_loc1_.toString().split(" ")[1]);
            _loc2_ = _loc2_.substr(0,_loc2_.length - 1);
            this.siloManager.addCrop(_loc2_);
            (roomAPI.roomView as GaturroHomeGranjaView).buyingManager.checkReady();
            roomAPI.libraries.fetch("granja." + _loc2_ + "Crop",this.animateCollectedCrop);
            objectAPI.setAttribute("plant","none");
            objectAPI.setAttribute("time",0);
         }
         else if(this.currentState == this.STATE_READY && this.siloManager.isFull)
         {
            asset.siloFull.visible = true;
            asset.siloFull.gotoAndPlay(1);
            asset.siloFull.addEventListener(Event.ENTER_FRAME,this.onSiloFullAnimationEnterFrame);
         }
      }
      
      private function animateCollectedCrop(param1:DisplayObject) : void
      {
         roomAPI.stopSound("granja/cosechar");
         roomAPI.playSound("granja/cosechar");
         asset.siloSmall.visible = true;
         param1.scaleY = 1.6;
         param1.scaleX = 1.6;
         asset.siloSmall.animate.addChild(param1);
         asset.siloSmall.gotoAndPlay(1);
         asset.siloSmall.addEventListener(Event.ENTER_FRAME,this.onSiloSmallAnimationEnterFrame);
      }
      
      private function turnOffFilter(param1:Event = null) : void
      {
         asset.filters = [];
         asset.tooltip.visible = false;
      }
      
      private function onTimer(param1:TimerEvent = null) : void
      {
         var _loc4_:int = 0;
         var _loc5_:MovieClip = null;
         this.changeTooltip();
         var _loc2_:Number = Number(objectAPI.getAttribute("time"));
         var _loc3_:String = String(String(objectAPI.getAttribute("plant")).split(".")[1]);
         if(_loc3_)
         {
            _loc4_ = int(settings.granjaHome.crops[_loc3_].timeToGrow);
         }
         if(this.currentState == this.STATE_GROWING && roomAPI.serverTime > _loc2_ + _loc4_)
         {
            this.currentState = this.STATE_READY;
            _loc5_ = asset.plantPH.getChildAt(0);
            _loc5_.gotoAndStop(_loc5_.currentLabels[this.currentState - 1].name);
            this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
            roomAPI.stopSound("granja/tiempoCumplido");
            roomAPI.playSound("granja/tiempoCumplido");
            return;
         }
      }
      
      override public function get currentState() : int
      {
         var _loc1_:int = 0;
         if(objectAPI)
         {
            _loc1_ = int(objectAPI.getAttribute("state"));
            if(_loc1_ > states.length)
            {
               _loc1_ = 0;
            }
         }
         return _loc1_;
      }
      
      private function onSiloSmallAnimationEnterFrame(param1:Event) : void
      {
         if(!asset)
         {
            asset.siloSmall.removeEventListener(Event.ENTER_FRAME,this.onSiloSmallAnimationEnterFrame);
            return;
         }
         if(asset.siloSmall.currentFrame == asset.siloSmall.totalFrames)
         {
            asset.siloSmall.stop();
            while(asset.siloSmall.animate.numChildren > 0)
            {
               asset.siloSmall.animate.removeChildAt(0);
            }
            asset.siloSmall.visible = false;
            asset.siloSmall.removeEventListener(Event.ENTER_FRAME,this.onSiloSmallAnimationEnterFrame);
         }
      }
      
      public function discountTime() : void
      {
         var _loc1_:Number = Number(objectAPI.getAttribute("time"));
         var _loc2_:String = String(String(objectAPI.getAttribute("plant")).split(".")[1]);
         var _loc3_:int = int(settings.granjaHome.crops[_loc2_].timeToGrow);
         var _loc4_:int = (_loc1_ + _loc3_ - roomAPI.serverTime) / 1000;
         this.amountToRemove = Math.ceil(_loc4_ / 30);
         if(this.siloManager.aceleradorQty >= this.amountToRemove)
         {
            asset.effect.addEventListener(Event.ENTER_FRAME,this.onEfectoFrame);
            asset.effect.visible = true;
            asset.effect.gotoAndPlay(1);
         }
      }
      
      override protected function atStart() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         this.granjaView = GaturroHomeGranjaView(roomAPI.roomView);
         asset.siloSmall.visible = false;
         asset.siloSmall.stop();
         asset.siloFull.visible = false;
         asset.siloFull.stop();
         asset.effect.visible = false;
         asset.effect.stop();
         var _loc1_:Object = objectAPI.getAttribute("state");
         if(_loc1_ == null)
         {
            objectAPI.setAttribute("state",0);
            objectAPI.setAttribute("time",0);
            objectAPI.setAttribute("plant","none");
            _loc2_ = objectAPI.object.coord.x;
            _loc3_ = objectAPI.object.coord.y;
            _loc4_ = settings.granjaHome.parcelaCoord;
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               if((_loc6_ = _loc4_[_loc5_]).x == _loc2_ && _loc6_.y == _loc3_)
               {
                  if(_loc6_.unlockAt <= this.granjaView.farmerLevel)
                  {
                     objectAPI.setAttribute("unlockAt",_loc6_.unlockAt);
                     objectAPI.setAttribute("unlockPrice",_loc6_.unlockPrice);
                     objectAPI.setAttribute("locked",false);
                     this.locked = false;
                  }
                  else
                  {
                     objectAPI.setAttribute("unlockAt",_loc6_.unlockAt);
                     objectAPI.setAttribute("unlockPrice",_loc6_.unlockPrice);
                     objectAPI.setAttribute("locked",true);
                     this.locked = true;
                  }
               }
               _loc5_++;
            }
         }
         this.siloManager = this.granjaView.siloManager;
         this.timer = this.granjaView.timer;
         this.view = roomAPI.getView(objectAPI.object) as HomeInteractiveRoomSceneObjectView;
         objectAPI.view.addEventListener("CLOSE",this.turnOffFilter);
         this.locked = objectAPI.getAttribute("locked");
         asset.tooltip.visible = false;
         if(isOwner)
         {
            this.view.addEventListener(HomeInteractiveRoomSceneObjectView.TOOLTIP_IN,this.onMouseOver);
            this.view.addEventListener(HomeInteractiveRoomSceneObjectView.TOOLTIP_OUT,this.onMouseOut);
            this.changeTooltip();
         }
         if(this.locked)
         {
            asset.gotoAndStop("blocked");
            objectAPI.view.addEventListener("UNLOCK",this.onUnlockParcela);
         }
         else
         {
            asset.gotoAndStop("idle");
            if(this.currentState != this.STATE_PLANT)
            {
               roomAPI.libraries.fetch(objectAPI.getAttribute("plant").toString(),this.addPlant);
            }
            if(this.currentState != this.STATE_GROWING)
            {
               return;
            }
            if(isOwner)
            {
               this.timer.addEventListener(TimerEvent.TIMER,this.onTimer);
            }
            else
            {
               this.timer.addEventListener(TimerEvent.TIMER,this.onTimerVisitor);
            }
         }
      }
      
      private function onMouseOut(param1:Event) : void
      {
         asset.tooltip.visible = false;
      }
      
      private function bannerClosed(param1:Event) : void
      {
         if(Boolean(objectAPI) && objectAPI.getAttribute("plant") != "none")
         {
            this.currentState = this.STATE_GROWING;
            roomAPI.libraries.fetch(objectAPI.getAttribute("plant").toString(),this.addPlant);
            objectAPI.view.removeEventListener(Event.ACTIVATE,this.bannerClosed);
         }
         if(asset)
         {
            asset.filters = [];
         }
      }
      
      private function onMouseOver(param1:Event) : void
      {
         asset.tooltip.visible = true;
      }
      
      private function onEfectoFrame(param1:Event) : void
      {
         if(!(asset || asset.effect))
         {
            return;
         }
         if(!this.changedFrame && asset.effect.currentFrame >= asset.effect.totalFrames / 2)
         {
            objectAPI.setAttribute("time",1000);
            this.siloManager.quitarAcelerador(this.amountToRemove);
            this.granjaView.aceleradorIcon.aceleradorAmount.text = this.siloManager.aceleradorQty.toString();
            this.onTimer();
            this.changedFrame = true;
         }
         if(asset.effect.currentFrame == asset.effect.totalFrames)
         {
            this.activate();
            asset.effect.stop();
            asset.effect.visible = false;
            asset.effect.removeEventListener(Event.ENTER_FRAME,this.onEfectoFrame);
            this.changedFrame = false;
         }
      }
      
      private function onUnlockParcela(param1:Event = null) : void
      {
         asset.removeEventListener("UNLOCK",this.onUnlockParcela);
         this.locked = false;
         objectAPI.setAttribute("locked",false);
         asset.gotoAndStop("idle");
         this.changeTooltip();
         Telemetry.getInstance().trackEvent(TrackCategories.GRANJA,TrackActions.GRANJA_PARCEL_UNLOCK);
      }
      
      private function get tooltipTime() : String
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc1_:String = String(String(objectAPI.getAttribute("plant")).split(".")[1]);
         var _loc2_:int = int(settings.granjaHome.crops[_loc1_].timeToGrow);
         var _loc3_:Number = Number(objectAPI.getAttribute("time"));
         _loc3_ = (_loc3_ + _loc2_ - roomAPI.serverTime) / 1000;
         var _loc5_:int = _loc3_;
         _loc9_ = Math.floor(_loc5_ / 86400);
         _loc5_ -= _loc9_ * 86400;
         _loc8_ = Math.floor(_loc5_ / 3600);
         _loc5_ -= _loc8_ * 3600;
         _loc7_ = Math.floor(_loc5_ / 60);
         _loc6_ = _loc5_ -= _loc7_ * 60;
         var _loc10_:String = _loc7_ > 9 ? _loc7_.toString() : "0" + _loc7_.toString();
         var _loc11_:String = _loc6_ > 9 ? _loc6_.toString() : "0" + _loc6_.toString();
         return _loc8_ + ":" + _loc10_ + ":" + _loc11_;
      }
   }
}

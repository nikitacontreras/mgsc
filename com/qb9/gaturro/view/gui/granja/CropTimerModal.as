package com.qb9.gaturro.view.gui.granja
{
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.external.roomObjects.GaturroSceneObjectAPI;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.view.gui.base.BaseGuiModal;
   import com.qb9.gaturro.view.world.GaturroHomeGranjaView;
   import com.qb9.gaturro.world.houseInteractive.granja.GranjaBehavior;
   import com.qb9.gaturro.world.houseInteractive.silo.SiloManager;
   import farm.CropTimeBanner;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   
   public class CropTimerModal extends BaseGuiModal
   {
       
      
      private var config:Object;
      
      private var timer:Timer;
      
      private var _siloManager:SiloManager;
      
      private var _api:GaturroRoomAPI;
      
      private var _objectAPI:GaturroSceneObjectAPI;
      
      private var _time:int;
      
      private var asset:CropTimeBanner;
      
      private var _behavior:GranjaBehavior;
      
      private var _acelAmountNeeded:int;
      
      private var _timeToGrow:int;
      
      public function CropTimerModal(param1:GaturroRoomAPI, param2:GaturroSceneObjectAPI, param3:GranjaBehavior)
      {
         var _loc4_:Point = null;
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         super();
         this._api = param1;
         this._objectAPI = param2;
         this._behavior = param3;
         this._siloManager = (this._api.roomView as GaturroHomeGranjaView).siloManager;
         this.asset = new CropTimeBanner();
         addChild(this.asset);
         _loc4_ = param2.view.localToGlobal(new Point(param2.view.x,param2.view.y));
         this.asset.x = _loc4_.x;
         this.asset.y = _loc4_.y;
         this.timer = new Timer(1000);
         this.timer.addEventListener(TimerEvent.TIMER,this.updateTimeLeft);
         this.timer.start();
         for each(_loc5_ in settings.granjaHome.crops)
         {
            if(this._objectAPI.object.attributes.plant == _loc5_.name)
            {
               this.config = _loc5_;
            }
         }
         this.asset.cropName.text = this.config.gameName;
         param1.libraries.fetch(this.config.name + "Crop",this.addCropToPH);
         this._time = this.getTime();
         this._timeToGrow = this.config.timeToGrow;
         this.asset.timeLeft.text = this.time_string;
         _loc6_ = 100 - Math.ceil(100 * this._time / (this._timeToGrow / 1000));
         this.asset.reloj.gotoAndStop(_loc6_);
         addEventListener(MouseEvent.CLICK,this.handleCloseClicks);
         this.asset.cancelarCultivo.visible = false;
         this.asset.cancelarCultivo.yes.addEventListener(MouseEvent.CLICK,this.removePlant);
         this.asset.cancelarCultivo.no.addEventListener(MouseEvent.CLICK,this.hideConfirmationToCancel);
         this._acelAmountNeeded = Math.ceil(this.getTime() / 30);
         this.asset.acelerarAmount.text = this._acelAmountNeeded.toString();
         this.asset.acelerarBoton.addEventListener(MouseEvent.CLICK,this.onAcelerarClick);
      }
      
      private function getTime() : int
      {
         return int((this._objectAPI.object.attributes.time + this.config.timeToGrow - this._api.serverTime) / 1000);
      }
      
      private function removePlant(param1:Event) : void
      {
         this._behavior.removePlant();
         this.close();
      }
      
      private function onAcelerarClick(param1:MouseEvent) : void
      {
         if(this._acelAmountNeeded <= this._siloManager.aceleradorQty)
         {
            this._behavior.discountTime();
            this._time = this.getTime();
            this.updateTimeLeft();
            this.close();
         }
         else
         {
            (this._api.roomView as GaturroHomeGranjaView).aceleradorIcon.dispatchEvent(new AceleradorEvent(AceleradorEvent.OPEN,this._behavior));
         }
      }
      
      private function hideConfirmationToCancel(param1:Event) : void
      {
         this.asset.cancelarCultivo.visible = false;
      }
      
      private function get time_string() : String
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:int = this._time;
         _loc6_ = Math.floor(_loc2_ / 86400);
         _loc2_ -= _loc6_ * 86400;
         _loc5_ = Math.floor(_loc2_ / 3600);
         _loc2_ -= _loc5_ * 3600;
         _loc4_ = Math.floor(_loc2_ / 60);
         _loc2_ -= _loc4_ * 60;
         _loc3_ = _loc2_;
         var _loc7_:String = _loc4_ > 9 ? _loc4_.toString() : "0" + _loc4_.toString();
         var _loc8_:String = _loc3_ > 9 ? _loc3_.toString() : "0" + _loc3_.toString();
         return _loc5_ + ":" + _loc7_ + ":" + _loc8_;
      }
      
      private function openConfirmationToCancel(param1:Event) : void
      {
         this.asset.cancelarCultivo.visible = true;
      }
      
      private function updateTimeLeft(param1:TimerEvent = null) : void
      {
         if(this._time <= 0)
         {
            this.close();
            this.timer.stop();
            return;
         }
         --this._time;
         this.asset.timeLeft.text = this.time_string;
         var _loc2_:int = 100 - Math.ceil(100 * this._time / (this._timeToGrow / 1000));
         this.asset.reloj.gotoAndStop(_loc2_);
      }
      
      override public function dispose() : void
      {
         removeEventListener(MouseEvent.CLICK,this.handleCloseClicks);
         this.timer.removeEventListener(TimerEvent.TIMER,this.updateTimeLeft);
         super.dispose();
      }
      
      private function addCropToPH(param1:DisplayObject) : void
      {
         this.asset.cropPH.addChild(param1);
         this.asset.addChild(this.asset.cancelarCultivo);
      }
      
      private function handleCloseClicks(param1:Event) : void
      {
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         while(Boolean(_loc2_) && _loc2_ !== this)
         {
            if(_loc2_.name === "close")
            {
               return this.close();
            }
            _loc2_ = _loc2_.parent;
         }
      }
      
      override public function close() : void
      {
         this._objectAPI.view.dispatchEvent(new Event("CLOSE"));
         super.close();
      }
   }
}

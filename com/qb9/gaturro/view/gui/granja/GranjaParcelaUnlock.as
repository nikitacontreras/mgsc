package com.qb9.gaturro.view.gui.granja
{
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.external.roomObjects.GaturroSceneObjectAPI;
   import com.qb9.gaturro.view.gui.base.BaseGuiModal;
   import com.qb9.gaturro.view.world.GaturroHomeGranjaView;
   import farm.ParcelaUnlockBanner;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class GranjaParcelaUnlock extends BaseGuiModal
   {
       
      
      private var unlockPrice:int;
      
      private var _roomAPI:GaturroRoomAPI;
      
      private var asset:ParcelaUnlockBanner;
      
      private var granjaView:GaturroHomeGranjaView;
      
      private var unlockAt:int;
      
      private var userLevel:int;
      
      private var _objectAPI:GaturroSceneObjectAPI;
      
      public function GranjaParcelaUnlock(param1:GaturroSceneObjectAPI, param2:GaturroRoomAPI)
      {
         super();
         this.asset = new ParcelaUnlockBanner();
         this._objectAPI = param1;
         this._roomAPI = param2;
         this.granjaView = param2.roomView as GaturroHomeGranjaView;
         this.unlockAt = this._objectAPI.getAttribute("unlockAt") as int;
         this.unlockPrice = this._objectAPI.getAttribute("unlockPrice") as int;
         this.userLevel = this.granjaView.farmerLevel;
         if(this.userLevel >= this.unlockAt)
         {
            this.asset.notEnough.visible = false;
            this.asset.priceTag.price.text = this.unlockPrice.toString();
            this.asset.aceptar.addEventListener(MouseEvent.CLICK,this.onBuyClick);
         }
         else
         {
            this.asset.ready.visible = false;
            this.asset.priceTag.visible = false;
            this.asset.aceptar.visible = false;
            this.asset.notEnough.text = param2.getText("NECESITAS NIVEL ") + this.unlockAt.toString();
         }
         this.asset.addEventListener(MouseEvent.CLICK,this.handleCloseClicks);
         addChild(this.asset);
      }
      
      private function onBuyClick(param1:MouseEvent) : void
      {
         var _loc2_:int = this._roomAPI.getProfileAttribute("coins") as int;
         if(_loc2_ >= this.unlockPrice)
         {
            this._objectAPI.view.dispatchEvent(new Event("UNLOCK"));
            this._roomAPI.setProfileAttribute("system_coins",_loc2_ - this.unlockPrice);
            (this._roomAPI.roomView as GaturroHomeGranjaView).jobStats.updateCoins(_loc2_ - this.unlockPrice);
            this._roomAPI.playSound("granja/venta");
            this.close();
         }
         else
         {
            this.asset.notEnough.visible = true;
            this.asset.notEnough.text = this._roomAPI.getText("NO TIENES SUFICIENTES GATUCOINS");
            this.asset.priceTag.visible = false;
            this.asset.aceptar.visible = false;
            this.asset.ready.visible = false;
            this._roomAPI.playSound("cosas2");
         }
      }
      
      override public function dispose() : void
      {
         removeEventListener(MouseEvent.CLICK,this.handleCloseClicks);
         super.dispose();
      }
      
      private function handleCloseClicks(param1:Event) : void
      {
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         while(Boolean(_loc2_) && _loc2_ !== this)
         {
            if(_loc2_.name === "close")
            {
               this._roomAPI.playSound("granja/BotonCancelar");
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

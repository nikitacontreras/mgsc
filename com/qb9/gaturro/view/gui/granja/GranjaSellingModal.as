package com.qb9.gaturro.view.gui.granja
{
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.view.gui.base.BaseGuiModal;
   import com.qb9.gaturro.view.world.GaturroHomeGranjaView;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.core.elements.HomeInteractiveRoomSceneObject;
   import com.qb9.gaturro.world.houseInteractive.buyer.BuyerBehavior;
   import com.qb9.gaturro.world.houseInteractive.silo.SiloManager;
   import com.qb9.mambo.core.objects.SceneObject;
   import farm.GranjaSellingBanner;
   import farm.ProductInfo;
   import farm.SeparationLine;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   
   public class GranjaSellingModal extends BaseGuiModal
   {
       
      
      private var canSell:Boolean;
      
      private var _siloManager:SiloManager;
      
      private var _request:com.qb9.gaturro.view.gui.granja.FarmRequest;
      
      private var _api:GaturroRoomAPI;
      
      private var info:Array;
      
      private var asset:GranjaSellingBanner;
      
      private var _roomView:GaturroHomeGranjaView;
      
      public function GranjaSellingModal(param1:GaturroRoomAPI, param2:com.qb9.gaturro.view.gui.granja.FarmRequest)
      {
         var _loc6_:int = 0;
         super();
         this._api = param1;
         this._request = param2;
         this._roomView = this._api.roomView as GaturroHomeGranjaView;
         this._siloManager = this._roomView.siloManager;
         this.asset = new GranjaSellingBanner();
         addChild(this.asset);
         addEventListener(MouseEvent.CLICK,this.handleCloseClicks);
         this.asset.sellButton.button.addEventListener(MouseEvent.CLICK,this.onSellButtonClick);
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < settings.granjaHome.buyers.length)
         {
            _loc3_.push(param1.getText(settings.granjaHome.buyers[_loc4_]));
            _loc4_++;
         }
         var _loc5_:Object;
         if(_loc5_ = param1.getSession("pedidoTexto" + param2.pedido.id))
         {
            this.asset.BGtop.buyerName.text = _loc3_[int(_loc5_)];
         }
         else
         {
            _loc6_ = Math.random() * _loc3_.length;
            this.asset.BGtop.buyerName.text = _loc3_[_loc6_];
            param1.setSession("pedidoTexto" + param2.pedido.id,_loc6_);
         }
         param1.libraries.fetch("granja.Comprador" + param2.pedido.id + "Cara",this.addFace,{"ph":this.asset.BGtop.buyerFace});
         this.init();
      }
      
      private function init() : void
      {
         var _loc3_:ProductInfo = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc8_:SeparationLine = null;
         var _loc9_:ProductInfo = null;
         var _loc10_:String = null;
         var _loc11_:Object = null;
         var _loc12_:String = null;
         var _loc13_:Boolean = false;
         var _loc14_:String = null;
         this.info = this._request.pedido.crops;
         var _loc1_:int = int(this._request.pedido.coins);
         var _loc2_:String = String(this._request.pedido.xp);
         this.asset.coins.text = "+" + _loc1_.toString();
         this.asset.xp.text = "+" + _loc2_.toString();
         this.canSell = true;
         var _loc4_:Array = [];
         if(this.info.length == 1)
         {
            _loc3_ = new ProductInfo();
            _loc3_.y = _loc3_.height;
            this.asset.container.addChild(_loc3_);
            _loc4_.push(_loc3_);
         }
         else
         {
            _loc5_ = [];
            _loc6_ = 1;
            while(_loc6_ < this.info.length)
            {
               (_loc8_ = new SeparationLine()).y = this.asset.container.height * _loc6_ / this.info.length;
               _loc5_.push(_loc8_);
               this.asset.container.addChild(_loc8_);
               _loc6_++;
            }
            _loc7_ = _loc5_.length > 1 ? (_loc5_[1].y - _loc5_[0].y) / 2 : new ProductInfo().height / 1.5;
            _loc3_ = new ProductInfo();
            _loc3_.y = _loc5_[0].y - _loc7_;
            this.asset.container.addChild(_loc3_);
            _loc4_.push(_loc3_);
            _loc6_ = 0;
            while(_loc6_ < _loc5_.length)
            {
               _loc3_ = new ProductInfo();
               _loc3_.y = _loc5_[_loc6_].y + _loc7_;
               this.asset.container.addChild(_loc3_);
               _loc4_.push(_loc3_);
               _loc6_++;
            }
         }
         _loc6_ = 0;
         while(_loc6_ < _loc4_.length)
         {
            (_loc9_ = _loc4_[_loc6_]).totalAmount.text = this.info[_loc6_].amount;
            _loc10_ = String(this.info[_loc6_].type.split(".")[1]);
            if(_loc11_ = this._siloManager.cropByName(_loc10_))
            {
               _loc12_ = String(int(_loc11_.qty) > int(this.info[_loc6_].amount) ? String(this.info[_loc6_].amount) : String(_loc11_.qty) || "0");
            }
            else
            {
               _loc12_ = "0";
            }
            _loc9_.userAmount.text = _loc12_;
            this._api.libraries.fetch(this.info[_loc6_].type + "Crop",this.addCropToPH,{"ph":_loc9_.image.ph});
            _loc14_ = (_loc13_ = this._siloManager.cropHasQty(_loc10_,this.info[_loc6_].amount)) ? "complete" : "incomplete";
            _loc9_.infoImage.gotoAndStop(_loc14_);
            if(!_loc13_)
            {
               this.canSell = false;
            }
            _loc6_++;
         }
         if(this.canSell)
         {
            this.asset.sellButton.gotoAndStop("available");
         }
         else
         {
            this.asset.sellButton.gotoAndStop("disabled");
         }
      }
      
      private function addFace(param1:DisplayObject, param2:Object) : void
      {
         param1.scaleX = 1.25;
         param1.scaleY = 1.25;
         param2.ph.addChild(param1);
      }
      
      override public function dispose() : void
      {
         removeEventListener(MouseEvent.CLICK,this.handleCloseClicks);
         super.dispose();
      }
      
      private function triggerBuyer() : void
      {
         var _loc2_:SceneObject = null;
         var _loc3_:BuyerBehavior = null;
         var _loc1_:GaturroRoom = this._api.room;
         for each(_loc2_ in _loc1_.sceneObjects)
         {
            if(_loc2_.name == "granja.Comprador_" + this._request.pedido.id.toString())
            {
               _loc3_ = (_loc2_ as HomeInteractiveRoomSceneObject).stateMachine as BuyerBehavior;
               _loc3_.currentState += 1;
               _loc3_.activate();
            }
         }
      }
      
      private function addCropToPH(param1:DisplayObject, param2:Object) : void
      {
         param2.ph.addChild(param1);
      }
      
      private function onSellButtonClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         if(this.canSell)
         {
            _loc2_ = 0;
            while(_loc2_ < this.info.length)
            {
               _loc4_ = String(this.info[_loc2_].type);
               _loc5_ = int(this.info[_loc2_].amount);
               this._siloManager.sellCrop(this.info[_loc2_].type.split(".")[1],_loc5_);
               _loc2_++;
            }
            _loc3_ = this._api.getProfileAttribute("coins") as int;
            this._api.setProfileAttribute("system_coins",_loc3_ + this._request.pedido.coins);
            this._roomView.buyingManager.deleteRequest(this._request.pedido.id);
            this._roomView.jobStats.increaseXP(this._request.pedido.xp as int);
            this._roomView.jobStats.updateCoins(_loc3_ + this._request.pedido.coins);
            this._api.setSession("pedidoTexto" + this._request.pedido.id,null);
            this._api.playSound("granja/venta");
            setTimeout(this.asset.sellButton.addEventListener,400,MouseEvent.CLICK,this.onAceptarClick);
            this.asset.container.visible = false;
            this.asset.sellButton.gotoAndStop("closing");
            this.asset.BGcenter.visible = false;
            this.asset.BGtop.y = this.asset.BGbottom.y - this.asset.BGtop.height;
            this.asset.BGtop.buyerName.text = api.getText("¡MUCHAS GRACIAS!");
            this.asset.y -= 100;
            this.triggerBuyer();
         }
      }
      
      override protected function get openSound() : String
      {
         return "granja/pedido";
      }
      
      private function onAceptarClick(param1:MouseEvent) : void
      {
         if(this.asset.sellButton.currentLabel == "closing")
         {
            close();
         }
      }
      
      override protected function get closeSound() : String
      {
         return null;
      }
      
      public function get userLevel() : int
      {
         return this._roomView.jobStats.currentLevel;
      }
      
      private function handleCloseClicks(param1:Event) : void
      {
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         while(Boolean(_loc2_) && _loc2_ !== this)
         {
            if(_loc2_.name === "close" || _loc2_.name == "okButton")
            {
               this._api.playSound("granja/cierraSemilla");
               return close();
            }
            _loc2_ = _loc2_.parent;
         }
      }
   }
}

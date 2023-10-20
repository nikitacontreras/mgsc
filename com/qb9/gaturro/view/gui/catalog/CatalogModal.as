package com.qb9.gaturro.view.gui.catalog
{
   import com.qb9.flashlib.easing.Tween;
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.flashlib.math.QMath;
   import com.qb9.flashlib.tasks.ITask;
   import com.qb9.flashlib.tasks.Parallel;
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.flashlib.utils.StringUtil;
   import com.qb9.gaturro.globals.*;
   import com.qb9.gaturro.net.metrics.Telemetry;
   import com.qb9.gaturro.net.metrics.TrackActions;
   import com.qb9.gaturro.net.metrics.TrackCategories;
   import com.qb9.gaturro.user.profile.GaturroProfile;
   import com.qb9.gaturro.view.gui.base.BaseGuiModal;
   import com.qb9.gaturro.view.gui.base.scroll.CatalogScrollDrag;
   import com.qb9.gaturro.view.gui.catalog.items.CatalogModalItemView;
   import com.qb9.gaturro.view.gui.catalog.screens.CatalogModalConfirmation;
   import com.qb9.gaturro.view.gui.catalog.screens.CatalogModalErrorScreen;
   import com.qb9.gaturro.view.gui.catalog.utils.CatalogUtils;
   import com.qb9.gaturro.world.catalog.Catalog;
   import com.qb9.gaturro.world.catalog.CatalogItem;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.mambo.net.manager.NetworkManager;
   import com.qb9.mambo.world.avatars.UserAvatar;
   import config.PassportControl;
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class CatalogModal extends BaseGuiModal
   {
       
      
      private var tasks:TaskContainer;
      
      private var error:CatalogModalErrorScreen;
      
      protected var catalog:Catalog;
      
      private var net:NetworkManager;
      
      private var scrollbar:CatalogScrollDrag;
      
      protected var confirmation:CatalogModalConfirmation;
      
      private var initial:int;
      
      private var preview:com.qb9.gaturro.view.gui.catalog.CatalogPreview;
      
      private var destIndex:int = 0;
      
      private var index:int = 0;
      
      private var temp:CatalogModalItemView;
      
      private var itemsPh:Sprite;
      
      private var avatar:UserAvatar;
      
      private var _options:Object;
      
      private var asset;
      
      private var cols:uint = 0;
      
      private var currentRoom:String;
      
      private var moveTask:ITask;
      
      private var _currency:String;
      
      private var rows:uint = 0;
      
      public function CatalogModal(param1:Catalog, param2:NetworkManager, param3:TaskContainer, param4:GaturroRoom, param5:Object = null)
      {
         super();
         this.catalog = param1;
         this.net = param2;
         this.tasks = param3;
         this.avatar = param4.userAvatar;
         this.currentRoom = param4.name;
         this._options = param5;
         this._currency = Boolean(this._options) && Boolean(this._options.currency) ? String(this._options.currency) : "monedas";
         this.init();
      }
      
      private function updateFromBar(param1:MouseEvent) : void
      {
         var _loc2_:Number = param1.localX / CatalogUtils.BAR_WIDTH;
         var _loc3_:int = QMath.sign(_loc2_ - this.scrollbar.progress);
         this.moveBy(_loc3_ * CatalogUtils.COLS,true);
      }
      
      public function get coins() : uint
      {
         return parseInt(this.coinsField.text.replace(/,/g,""));
      }
      
      public function set coins(param1:uint) : void
      {
         this.coinsField.text = StringUtil.numberSeparator(param1);
      }
      
      protected function buy(param1:Event) : void
      {
         CatalogUtils.substractCoins(this._currency,this.temp.item.price);
         this.coins = CatalogUtils.getCoins(this._currency);
         api.giveUser(this.tempName);
         api.trackEvent(TrackCategories.MARKET + ":" + TrackCategories.YEAR + ":" + this._currency + ":" + this.catalog.name,this.tempName);
      }
      
      private function afterBuy() : void
      {
         if(Boolean(this.catalog) && this.asset)
         {
            this.coins = CatalogUtils.getCoins(this._currency);
         }
      }
      
      private function showPreview(param1:CatalogModalItemView) : void
      {
         if(param1 === this.temp)
         {
            return;
         }
         if(this.temp)
         {
            this.temp.unselect();
         }
         this.temp = param1;
         this.temp.select();
         this.preview.show(param1);
         if(this._currency)
         {
            this.coins = CatalogUtils.getCoins(this._currency);
         }
      }
      
      protected function showError(param1:String, param2:int = 1, param3:String = "", param4:String = "") : void
      {
         this.error.showMessage(this.temp.item,param1,param2,param3,param4);
      }
      
      private function get bar() : Sprite
      {
         return this.asset.bar;
      }
      
      private function showFirstPreview(param1:DisplayObject, param2:CatalogModalItemView) : void
      {
         param2.add(param1);
         this.showPreview(param2);
      }
      
      private function get coinsField() : TextField
      {
         return this.asset.coins;
      }
      
      private function handleWheel(param1:MouseEvent) : void
      {
         this.moveBy(QMath.sign(param1.delta));
      }
      
      protected function init() : void
      {
         var _loc2_:CatalogItem = null;
         var _loc3_:CatalogModalItemView = null;
         var _loc1_:Class = CatalogUtils.catalogByCurrency(this._currency);
         this.asset = new _loc1_();
         addChild(this.asset);
         this.preview = new com.qb9.gaturro.view.gui.catalog.CatalogPreview(this.asset.preview,this.avatar,this._options);
         this.initEvents();
         this.itemsPh = new Sprite();
         this.contentPh.addChild(this.itemsPh);
         this.asset.currency_sign.gotoAndStop(this._currency);
         this.asset.tus_currency_text.text = CatalogUtils.currencyText(this._currency);
         this.coins = CatalogUtils.getCoins(this._currency);
         var _loc4_:Boolean = true;
         var _loc5_:Array = this.catalog.items;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_.length)
         {
            if(!this.isNotCatalogable(_loc5_[_loc6_]))
            {
               _loc2_ = _loc5_[_loc6_] as CatalogItem;
               _loc3_ = new CatalogModalItemView(_loc2_);
               if(this.rows === CatalogUtils.ROWS)
               {
                  this.rows = 0;
                  ++this.cols;
               }
               _loc3_.x = CatalogUtils.ITEM_WIDTH * this.cols;
               _loc3_.y = (_loc3_.height + CatalogUtils.MARGIN) * this.rows;
               if(_loc4_)
               {
                  _loc4_ = false;
                  libs.fetch(_loc2_.name,this.showFirstPreview,_loc3_);
               }
               else
               {
                  libs.fetch(_loc2_.name,_loc3_.add);
               }
               this.itemsPh.addChild(_loc3_);
               ++this.rows;
               _loc3_.currency_sign.gotoAndStop(this._currency);
               _loc3_.oldPrice.currency_sign.gotoAndStop(this._currency);
            }
            _loc6_++;
         }
         this.setupScrolling();
         this.updatePagers();
         this.confirmation = new CatalogModalConfirmation();
         this.confirmation.currency_sign.gotoAndStop(this._currency);
         this.confirmation.addEventListener(Event.SELECT,this.buy);
         this.addScreen(this.confirmation);
         this.error = new CatalogModalErrorScreen();
         this.addScreen(this.error);
         tracker.event(TrackCategories.MARKET,TrackActions.OPENS_CATALOG,this.catalog.name);
         Telemetry.getInstance().trackEvent(TrackCategories.MARKET,TrackActions.OPENS_CATALOG + ":" + this.catalog.name,this.currentRoom,0);
      }
      
      private function isWearable(param1:MovieClip) : Boolean
      {
         return "wearable" in param1 && Boolean(param1.wearable);
      }
      
      private function get profile() : GaturroProfile
      {
         return user.profile as GaturroProfile;
      }
      
      private function moveBy(param1:int, param2:Boolean = true) : void
      {
         this.moveTo(this.index + param1,param2);
      }
      
      private function moveTo(param1:int, param2:Boolean = true) : void
      {
         param1 = QMath.clamp(param1,0,this.maxIndex);
         if(param1 === this.index)
         {
            return;
         }
         this.disposeMoveTask();
         var _loc3_:Number = param1 / this.maxIndex;
         this.moveTask = this.makeTween(this.itemsPh,-CatalogUtils.ITEM_WIDTH * param1);
         if(Boolean(this.scrollbar) && param2)
         {
            this.scrollbar.cancelDrag();
            this.moveTask = new Parallel(this.moveTask,this.makeTween(this.scrollbar,this.scrollbar.scrollingArea * _loc3_));
         }
         this.tasks.add(this.moveTask);
         this.index = param1;
         this.updatePagers();
      }
      
      override public function dispose() : void
      {
         var _loc1_:DisplayObject = null;
         if(!this.profile)
         {
            return;
         }
         this.disposeMoveTask();
         if(this.scrollbar)
         {
            this.scrollbar.dispose();
            this.scrollbar.removeEventListener(Event.CHANGE,this.updateFromScrollBar);
         }
         this.bar.removeEventListener(MouseEvent.MOUSE_DOWN,this.updateFromBar);
         this.avatar = null;
         this.tasks = null;
         this.catalog = null;
         this.asset = null;
         for each(_loc1_ in DisplayUtil.children(this.itemsPh))
         {
            if(_loc1_ is IDisposable)
            {
               IDisposable(_loc1_).dispose();
            }
         }
         this.itemsPh = null;
         removeEventListener(MouseEvent.CLICK,this.checkClick);
         removeEventListener(MouseEvent.MOUSE_WHEEL,this.handleWheel);
         this.confirmation.removeEventListener(Event.SELECT,this.buy);
         this.confirmation.dispose();
         this.confirmation = null;
         this.temp = null;
         super.dispose();
      }
      
      private function updateFromScrollBar(param1:Event) : void
      {
         this.moveToProgress(this.scrollbar.progress,false);
      }
      
      private function trackBuy() : void
      {
         var _loc1_:Array = this.tempName.split(".");
         var _loc2_:String = TrackActions.BUYS;
         _loc2_ += ":" + this.catalog.name;
         _loc2_ += _loc1_[0] != null ? ":" + _loc1_[0] : TrackActions.NO_PACK;
         _loc2_ += _loc1_[1] != null ? ":" + _loc1_[1] : TrackActions.NO_NAME;
      }
      
      private function get itemCount() : uint
      {
         return Math.ceil(this.itemsPh.numChildren / CatalogUtils.ROWS);
      }
      
      private function tryToBuy() : void
      {
         if(!this.temp)
         {
            return;
         }
         var _loc1_:MovieClip = this.temp.asset;
         if(!_loc1_)
         {
            return this.showError(region.key("item_not_available"));
         }
         var _loc2_:CatalogItem = this.temp.item;
         if(_loc2_.vip && !this.avatar.isCitizen)
         {
            Telemetry.getInstance().trackEvent(TrackCategories.MARKET,TrackActions.NO_PREMIUM);
            this.visible = false;
            if(PassportControl.isVipPack(_loc2_.name))
            {
               api.showBannerModal("pasaporte3");
            }
            else
            {
               api.showBannerModal("pasaporte2");
            }
         }
         if(_loc2_.vip && !this.profile.canBuyPremium)
         {
            Telemetry.getInstance().trackEvent(TrackCategories.MARKET,TrackActions.PREMIUM_LIMIT);
            return this.error.showMessage(_loc2_,StringUtil.format(region.key("vip_limit"),server.maxPremiumItems),2,region.key("vip_limit_title"));
         }
         if(_loc2_.price > this.coins)
         {
            return this.showError(CatalogUtils.errorMessage(this._currency),1,CatalogUtils.errorTitle(this._currency),CatalogUtils.errorSub(this._currency));
         }
         this.showConfirmation(_loc2_);
      }
      
      private function makeTween(param1:DisplayObject, param2:Number) : ITask
      {
         return new Tween(param1,CatalogUtils.SLIDE_TIME,{"x":param2},{"transition":"easeOut"});
      }
      
      private function updatePagers() : void
      {
         this.updatePager(this.asset.back,this.index > 0);
         this.updatePager(this.asset.next,this.index < this.maxIndex);
      }
      
      protected function showConfirmation(param1:CatalogItem) : void
      {
         this.confirmation.show(param1);
      }
      
      private function disposeMoveTask() : void
      {
         if(Boolean(this.moveTask) && this.moveTask.running)
         {
            this.tasks.remove(this.moveTask);
         }
         this.moveTask = null;
      }
      
      private function get maxIndex() : int
      {
         return this.itemCount - CatalogUtils.COLS;
      }
      
      private function get contentPh() : Sprite
      {
         return this.asset.ph;
      }
      
      private function initEvents() : void
      {
         addEventListener(MouseEvent.CLICK,this.checkClick);
      }
      
      private function isNotCatalogable(param1:CatalogItem) : Boolean
      {
         if(!param1.countries)
         {
            return false;
         }
         return param1.countries.indexOf(api.country) < 0;
      }
      
      private function addScreen(param1:DisplayObject) : void
      {
         param1.x = this.contentPh.x;
         param1.y = this.contentPh.y;
         addChild(param1);
      }
      
      private function get views() : Array
      {
         return DisplayUtil.children(this.itemsPh);
      }
      
      private function checkClick(param1:MouseEvent) : void
      {
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         while(Boolean(_loc2_) && _loc2_ !== this)
         {
            if(_loc2_ is CatalogModalItemView)
            {
               return this.showPreview(_loc2_ as CatalogModalItemView);
            }
            switch(_loc2_.name)
            {
               case "buy":
                  this.tryToBuy();
                  break;
               case "close":
                  close();
                  break;
               case "back":
                  this.moveBy(-1);
                  break;
               case "next":
                  this.moveBy(1);
                  break;
            }
            _loc2_ = _loc2_.parent;
         }
      }
      
      private function setupScrolling() : void
      {
         var _loc1_:Number = this.itemCount / CatalogUtils.COLS;
         if(_loc1_ <= 1)
         {
            return;
         }
         this.scrollbar = new CatalogScrollDrag(_loc1_,this.bar.height,CatalogUtils.BAR_WIDTH);
         this.scrollbar.addEventListener(Event.CHANGE,this.updateFromScrollBar);
         this.bar.addChild(this.scrollbar);
         addEventListener(MouseEvent.MOUSE_WHEEL,this.handleWheel);
         this.bar.buttonMode = true;
         this.bar.addEventListener(MouseEvent.MOUSE_DOWN,this.updateFromBar);
      }
      
      private function moveToProgress(param1:Number, param2:Boolean) : void
      {
         var _loc3_:uint = param1 * this.itemCount;
         this.moveTo(_loc3_,param2);
      }
      
      private function updatePager(param1:InteractiveObject, param2:Boolean) : void
      {
         param1.mouseEnabled = param2;
         param1.alpha = param2 ? 1 : 0.5;
      }
      
      private function get tempName() : String
      {
         return this.temp.item.name;
      }
   }
}

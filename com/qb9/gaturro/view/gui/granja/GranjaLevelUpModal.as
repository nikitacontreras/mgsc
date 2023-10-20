package com.qb9.gaturro.view.gui.granja
{
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.net.metrics.Telemetry;
   import com.qb9.gaturro.net.metrics.TrackActions;
   import com.qb9.gaturro.net.metrics.TrackCategories;
   import com.qb9.gaturro.view.gui.base.BaseGuiModal;
   import com.qb9.gaturro.view.world.GaturroHomeGranjaView;
   import farm.CoinAsset;
   import farm.GranjaLevelUp;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class GranjaLevelUpModal extends BaseGuiModal
   {
       
      
      private var level:int;
      
      private var acquired:Object;
      
      private var items:Array;
      
      private var asset:GranjaLevelUp;
      
      private const unlockButtonOffset:int = 50;
      
      public function GranjaLevelUpModal(param1:int, param2:Object)
      {
         super();
         this.asset = new GranjaLevelUp();
         this.level = param1;
         this.acquired = param2;
         addChild(this.asset);
         this.asset.addEventListener(MouseEvent.CLICK,this.handleCloseClicks);
         this.asset.levelNumber.text = api.getText("ALCANZASTE EL NIVEL") + " " + param1.toString() + "!";
         Telemetry.getInstance().trackEvent(TrackCategories.GRANJA,TrackActions.GRANJA_LEVEL + ":" + param1.toString());
         this.loadUnlocks();
      }
      
      private function phUnlockLoaded(param1:Event) : void
      {
         var _loc3_:DisplayObject = null;
         if(this.items.length == 0)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.items.length)
         {
            _loc3_ = this.asset.phUnlock.getChildAt(_loc2_);
            if(_loc3_)
            {
               this.items[_loc2_].x = _loc3_.x;
               this.items[_loc2_].y = _loc3_.y;
               this.asset.phUnlock.addChild(this.items[_loc2_]);
            }
            _loc2_++;
         }
         this.asset.phUnlock.removeEventListener(Event.ENTER_FRAME,this.phUnlockLoaded);
      }
      
      private function resizeGift(param1:DisplayObject) : void
      {
         var _loc2_:Number = NaN;
         if(param1.width < 80 && param1.height < 80)
         {
            return;
         }
         if(param1.height > param1.width)
         {
            _loc2_ = param1.width / param1.height;
            param1.height = 80;
            param1.width = param1.height * _loc2_;
         }
         else
         {
            _loc2_ = param1.height / param1.width;
            param1.width = 80;
            param1.height = param1.width * _loc2_;
         }
      }
      
      private function loadUnlocks() : void
      {
         var _loc1_:LevelUpHolder = null;
         var _loc3_:CoinAsset = null;
         var _loc4_:int = 0;
         this.items = [];
         var _loc2_:int = 0;
         while(_loc2_ < this.acquired.crops.length)
         {
            _loc1_ = new LevelUpHolder();
            api.libraries.fetch(this.acquired.crops[_loc2_].name + "Seed",this.addToPh,{"mc":_loc1_});
            this.items.push(_loc1_);
            _loc2_++;
         }
         if(this.acquired.parcelaUnlock)
         {
            _loc1_ = new LevelUpHolder();
            api.libraries.fetch("granja.parcelaUnlocked",this.addToPh,{"mc":_loc1_});
            this.items.push(_loc1_);
            _loc1_.x = _loc2_ * _loc1_.width + this.unlockButtonOffset;
         }
         if(this.acquired.premio != null)
         {
            api.libraries.fetch(this.acquired.premio,this.addPremioToPH);
            api.giveUser(this.acquired.premio);
         }
         else
         {
            _loc3_ = new CoinAsset();
            _loc3_.price.text = "+" + settings.granjaHome.levelUpBonus.fixedCoins;
            _loc3_.scaleX = 3;
            _loc3_.scaleY = 3;
            this.asset.premioPH.addChild(_loc3_);
            _loc4_ = (_loc4_ = api.getProfileAttribute("coins") as int) + (settings.granjaHome.levelUpBonus.fixedCoins as int);
            api.setProfileAttribute("system_coins",_loc4_);
            (api.roomView as GaturroHomeGranjaView).jobStats.updateCoins(_loc4_);
         }
         this.asset.phUnlock.gotoAndStop(this.items.length);
         this.asset.phUnlock.addEventListener(Event.ENTER_FRAME,this.phUnlockLoaded);
      }
      
      private function addPremioToPH(param1:DisplayObject) : void
      {
         this.resizeGift(param1);
         this.asset.premioPH.addChild(param1);
      }
      
      private function addToPh(param1:DisplayObject, param2:Object) : void
      {
         param1.scaleX = 0.8;
         param1.scaleY = 0.8;
         param2.mc.ph.addChild(param1);
      }
      
      private function handleCloseClicks(param1:Event) : void
      {
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         while(Boolean(_loc2_) && _loc2_ !== this)
         {
            if(_loc2_.name === "close")
            {
               api.playSound("granja/cierraSemilla");
               return close();
            }
            _loc2_ = _loc2_.parent;
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}

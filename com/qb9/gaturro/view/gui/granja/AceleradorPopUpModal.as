package com.qb9.gaturro.view.gui.granja
{
   import com.qb9.flashlib.easing.Tween;
   import com.qb9.flashlib.tasks.Parallel;
   import com.qb9.flashlib.tasks.Sequence;
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.net.metrics.Telemetry;
   import com.qb9.gaturro.net.metrics.TrackActions;
   import com.qb9.gaturro.net.metrics.TrackCategories;
   import com.qb9.gaturro.view.gui.base.BaseGuiModal;
   import com.qb9.gaturro.view.gui.jobs.JobStats;
   import com.qb9.gaturro.view.world.GaturroHomeGranjaView;
   import com.qb9.gaturro.world.houseInteractive.granja.GranjaBehavior;
   import com.qb9.gaturro.world.houseInteractive.silo.SiloManager;
   import farm.AceleradorPopUp;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class AceleradorPopUpModal extends BaseGuiModal
   {
       
      
      private var price:int;
      
      private var tasks:TaskContainer;
      
      private var siloManager:SiloManager;
      
      private var amount:int = 5;
      
      private var granjaView:GaturroHomeGranjaView;
      
      public var animating:Boolean;
      
      private var behavior:GranjaBehavior;
      
      private var jobStats:JobStats;
      
      private var asset:AceleradorPopUp;
      
      public function AceleradorPopUpModal(param1:JobStats, param2:TaskContainer, param3:SiloManager, param4:GaturroHomeGranjaView, param5:GranjaBehavior = null)
      {
         super();
         this.asset = new AceleradorPopUp();
         this.jobStats = param1;
         this.tasks = param2;
         this.siloManager = param3;
         this.granjaView = param4;
         this.behavior = param5;
         this.price = int(settings.granjaHome.acelerador.price);
         addChild(this.asset);
         this.init();
      }
      
      private function updateAmount() : void
      {
         this.asset.priceAmount.text = (this.amount * this.price).toString();
         this.asset.buyAmount.text = this.amount.toString();
      }
      
      private function init() : void
      {
         this.updateAmount();
         this.asset.buy.addEventListener(MouseEvent.CLICK,this.onBuy);
         this.asset.plus.addEventListener(MouseEvent.CLICK,this.onPlus);
         this.asset.minus.addEventListener(MouseEvent.CLICK,this.onMinus);
      }
      
      private function onMinus(param1:MouseEvent) : void
      {
         if(this.amount <= 1)
         {
            return;
         }
         if(this.amount == 5)
         {
            this.amount = 1;
         }
         else
         {
            this.amount -= 5;
         }
         this.updateAmount();
      }
      
      private function onPlus(param1:MouseEvent) : void
      {
         if(this.amount == 1)
         {
            this.amount = 5;
         }
         else if(this.amount <= 95)
         {
            this.amount += 5;
         }
         this.updateAmount();
      }
      
      override public function dispose() : void
      {
         removeEventListener(MouseEvent.CLICK,this.handleCloseClicks);
         super.dispose();
      }
      
      private function onBuy(param1:MouseEvent) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Sequence = null;
         var _loc6_:Sequence = null;
         var _loc2_:int = api.getProfileAttribute("coins") as int;
         var _loc3_:int = this.amount * this.price;
         if(_loc2_ < _loc3_)
         {
            Telemetry.getInstance().trackEvent(TrackCategories.GRANJA,TrackActions.NOT_ENOUGH_COINS + ":" + "fertilizer");
            if(this.animating)
            {
               return;
            }
            this.animating = true;
            _loc4_ = this.asset.priceAmount.x;
            _loc5_ = new Sequence(new Tween(this.asset.priceAmount,200,{"x":_loc4_ + 5},{"transition":"easeIn"}),new Tween(this.asset.priceAmount,200,{"x":_loc4_ - 5},{"transition":"easeIn"}),new Tween(this.asset.priceAmount,200,{"x":_loc4_},{"transition":"easeIn"}));
            _loc4_ = this.jobStats.coinsAsset.x;
            _loc6_ = new Sequence(new Tween(this.jobStats.coinsAsset,200,{"x":_loc4_ + 5},{"transition":"easeIn"}),new Tween(this.jobStats.coinsAsset,200,{"x":_loc4_ - 5},{"transition":"easeIn"}),new Tween(this.jobStats.coinsAsset,200,{"x":_loc4_},{"transition":"easeIn"}),new Tween(this,1,{"animating":false}));
            this.tasks.add(new Parallel(_loc5_,_loc6_));
            return;
         }
         api.setProfileAttribute("system_coins",_loc2_ - _loc3_);
         this.jobStats.updateCoins(_loc2_ - _loc3_);
         this.siloManager.agregarAcelerador(this.amount);
         this.granjaView.updateAcelerador();
         Telemetry.getInstance().trackEvent(TrackCategories.GRANJA,TrackActions.GRANJA_FERTILIZER_BUY,"",_loc3_);
         if(this.behavior)
         {
            this.behavior.discountTime();
         }
         close();
      }
      
      private function handleCloseClicks(param1:Event) : void
      {
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         while(Boolean(_loc2_) && _loc2_ !== this)
         {
            if(_loc2_.name === "close" || _loc2_.name == "okButton")
            {
               return close();
            }
            _loc2_ = _loc2_.parent;
         }
      }
   }
}

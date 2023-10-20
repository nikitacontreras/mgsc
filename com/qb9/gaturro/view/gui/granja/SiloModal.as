package com.qb9.gaturro.view.gui.granja
{
   import com.qb9.flashlib.easing.Tween;
   import com.qb9.flashlib.tasks.Func;
   import com.qb9.flashlib.tasks.Sequence;
   import com.qb9.flashlib.tasks.TaskRunner;
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.net.metrics.Telemetry;
   import com.qb9.gaturro.net.metrics.TrackActions;
   import com.qb9.gaturro.net.metrics.TrackCategories;
   import com.qb9.gaturro.view.gui.base.BaseGuiModal;
   import com.qb9.gaturro.view.world.GaturroHomeGranjaView;
   import com.qb9.gaturro.world.houseInteractive.silo.SiloManager;
   import farm.AssetHolder;
   import farm.SiloModalAsset;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   
   public class SiloModal extends BaseGuiModal
   {
       
      
      private var buttons:Array;
      
      private var pages:Array;
      
      private var pagePos:int;
      
      private const MAX_COLS:uint = 3;
      
      private var _tasks:TaskRunner;
      
      private var _siloManager:SiloManager;
      
      private var _siloAsset:MovieClip;
      
      private var _api:GaturroRoomAPI;
      
      private const MARGIN:int = 10;
      
      public var deleting:Boolean;
      
      private var asset:SiloModalAsset;
      
      private const MAX_ROWS:int = 2;
      
      public function SiloModal(param1:TaskRunner, param2:GaturroRoomAPI, param3:MovieClip)
      {
         super();
         this._tasks = param1;
         this._api = param2;
         this._siloAsset = param3;
         addEventListener(MouseEvent.CLICK,this.handleCloseClicks);
         this.asset = new SiloModalAsset();
         addChild(this.asset);
         this._siloManager = GaturroHomeGranjaView(param2.roomView).siloManager;
         this.init();
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         while(Boolean(_loc2_) && _loc2_ != this)
         {
            if(_loc2_ is AssetHolder)
            {
               (_loc2_ as MovieClip).filters = [];
               return;
            }
            _loc2_ = _loc2_.parent;
         }
      }
      
      private function init() : void
      {
         Telemetry.getInstance().trackEvent(TrackCategories.GRANJA,TrackActions.GRANJA_SILO_OPEN);
         this.setupHolders();
         if(!this.asset.leftScroll.hasEventListener(MouseEvent.CLICK))
         {
            this.asset.leftScroll.addEventListener(MouseEvent.CLICK,this.scrollLeft);
            this.asset.rightScroll.addEventListener(MouseEvent.CLICK,this.scrollRight);
         }
         if(this._siloManager.qty < this.MAX_COLS * this.MAX_ROWS)
         {
            this.asset.rightScroll.gotoAndStop("disabled");
         }
         else
         {
            this.asset.rightScroll.gotoAndStop("idle");
         }
         this.asset.leftScroll.gotoAndStop("disabled");
         this.createButtons();
         this.asset.capacityAmount.text = this._siloManager.capacity.toString() + "/" + this._siloManager.maxCapacity.toString();
      }
      
      private function setupHolders() : void
      {
         var _loc5_:AssetHolder = null;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         this.pages = new Array();
         this.pagePos = 0;
         var _loc1_:int = int(this._siloManager.qty);
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         while(_loc1_ > 0)
         {
            if(_loc2_.length >= this.MAX_COLS * this.MAX_ROWS)
            {
               this.pages.push(_loc2_);
               _loc2_ = new Array();
               _loc3_ = 0;
               _loc4_ = 0;
            }
            _loc5_ = new AssetHolder();
            _loc6_ = _loc3_ + this.MAX_COLS * this.MAX_ROWS * this.pages.length;
            _loc7_ = this._siloManager.cropByPosition(_loc6_);
            this._api.libraries.fetch("granja." + _loc7_.name + "Crop2",this.addCropToButton,{
               "button":_loc5_,
               "qty":_loc7_.qty,
               "cropName":_loc7_.gameName
            });
            _loc5_.name = this._api.getText(_loc7_.name);
            _loc5_.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
            _loc5_.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
            _loc9_ = Math.floor(_loc3_ % this.MAX_COLS);
            _loc10_ = _loc4_;
            if(_loc9_ + 1 == this.MAX_COLS)
            {
               _loc4_++;
            }
            _loc5_.x = _loc5_.width * _loc9_ + this.MARGIN * _loc9_;
            _loc5_.y = _loc5_.width * _loc10_ + this.MARGIN * 3 * _loc10_;
            if(!_loc5_.tirarCultivo.hasEventListener(MouseEvent.CLICK))
            {
               _loc5_.tirarCultivo.addEventListener(MouseEvent.CLICK,this.onTirarCultivo);
            }
            _loc2_.push(_loc5_);
            _loc3_++;
            _loc1_--;
            if(_loc1_ == 0)
            {
               this.pages.push(_loc2_);
            }
         }
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
      
      private function scrollRight(param1:MouseEvent) : void
      {
         if(this.pages.length > 1)
         {
            this.asset.leftScroll.gotoAndStop("idle");
         }
         var _loc2_:int = this.pagePos;
         if(this.pagePos < this.pages.length - 1)
         {
            ++this.pagePos;
         }
         if(this.pagePos == this.pages.length - 1)
         {
            this.asset.rightScroll.gotoAndStop("disabled");
         }
         if(_loc2_ != this.pagePos)
         {
            this._api.playSound("granja/pasarPantalla");
            this.createButtons();
         }
      }
      
      override public function dispose() : void
      {
         removeEventListener(MouseEvent.CLICK,this.handleCloseClicks);
         super.dispose();
      }
      
      override protected function get openSound() : String
      {
         return "granja/abreSilo";
      }
      
      private function createButtons() : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         while(this.asset.buttonContainer.numChildren)
         {
            this.asset.buttonContainer.removeChildAt(0);
         }
         if(this.pages.length > 0)
         {
            _loc1_ = this.pages[this.pagePos];
            _loc2_ = 0;
            while(_loc2_ < _loc1_.length)
            {
               this.asset.buttonContainer.addChild(_loc1_[_loc2_]);
               _loc2_++;
            }
         }
      }
      
      override protected function get closeSound() : String
      {
         return "granja/abreSilo";
      }
      
      override public function close() : void
      {
         this._siloAsset.gotoAndStop("cerrado");
         Telemetry.getInstance().trackEvent(TrackCategories.GRANJA,TrackActions.GRANJA_SILO_REMOVED);
         super.close();
      }
      
      private function onTirarCultivo(param1:MouseEvent) : void
      {
         if(this.deleting)
         {
            return;
         }
         this.deleting = true;
         var _loc2_:AssetHolder = param1.target.parent;
         var _loc3_:int = int(_loc2_.qty.text.substr(1));
         _loc3_--;
         this._siloManager.sellCrop(param1.target.parent.name,1);
         _loc2_.qty.text = "x " + _loc3_.toString();
         this.asset.capacityAmount.text = this._siloManager.capacity.toString() + "/" + this._siloManager.maxCapacity.toString();
         this._api.stopSound("granja/botonCancelar");
         this._api.playSound("granja/botonCancelar");
         var _loc4_:MovieClip;
         var _loc5_:int = (_loc4_ = _loc2_.ph).width;
         var _loc6_:int = _loc4_.height;
         if(_loc3_ <= 0)
         {
            this._tasks.add(new Sequence(new Tween(_loc2_,300,{
               "width":1,
               "height":1
            },{"transition":"easeIn"}),new Func(this.init),new Tween(this,1,{"deleting":false})));
         }
         else
         {
            this._tasks.add(new Sequence(new Tween(_loc4_,200,{
               "width":1,
               "height":1
            },{"transition":"easeIn"}),new Tween(_loc4_,200,{
               "width":_loc5_,
               "height":_loc6_
            },{"transition":"easeIn"}),new Tween(this,1,{"deleting":false})));
         }
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         while(Boolean(_loc2_) && _loc2_ != this)
         {
            if(_loc2_ is AssetHolder)
            {
               (_loc2_ as MovieClip).filters = [new GlowFilter(16777215)];
               return;
            }
            _loc2_ = _loc2_.parent;
         }
      }
      
      private function scrollLeft(param1:MouseEvent) : void
      {
         if(this.pages.length > 1)
         {
            this.asset.rightScroll.gotoAndStop("idle");
         }
         var _loc2_:int = this.pagePos;
         if(this.pagePos >= 1)
         {
            --this.pagePos;
         }
         if(this.pagePos == 0)
         {
            this.asset.leftScroll.gotoAndStop("disabled");
         }
         if(_loc2_ != this.pagePos)
         {
            this._api.playSound("granja/pasarPantalla");
            this.createButtons();
         }
      }
      
      private function addCropToButton(param1:DisplayObject, param2:Object) : void
      {
         param2.button.ph.addChild(param1);
         param2.button.qty.text = "x " + String(param2.qty);
         param2.button.cropName.text = this._api.getText(param2.cropName);
      }
   }
}

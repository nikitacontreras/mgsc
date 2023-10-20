package com.qb9.gaturro.view.world
{
   import com.qb9.flashlib.easing.Tween;
   import com.qb9.flashlib.tasks.Func;
   import com.qb9.flashlib.tasks.ITask;
   import com.qb9.flashlib.tasks.Sequence;
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.gaturro.editor.NetActionManager;
   import com.qb9.gaturro.external.roomObjects.GaturroSceneObjectAPI;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.net;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.net.mail.GaturroMailer;
   import com.qb9.gaturro.net.metrics.Telemetry;
   import com.qb9.gaturro.net.metrics.TrackActions;
   import com.qb9.gaturro.net.metrics.TrackCategories;
   import com.qb9.gaturro.user.inventory.GaturroInventory;
   import com.qb9.gaturro.user.inventory.GaturroInventorySceneObject;
   import com.qb9.gaturro.view.camera.CameraSwitcher;
   import com.qb9.gaturro.view.gui.granja.AceleradorEvent;
   import com.qb9.gaturro.view.gui.granja.AceleradorPopUpModal;
   import com.qb9.gaturro.view.gui.granja.GranjaAlert;
   import com.qb9.gaturro.view.gui.jobs.JobStats;
   import com.qb9.gaturro.view.screens.GaturroLoadingScreen;
   import com.qb9.gaturro.view.world.elements.HomeInteractiveRoomSceneObjectView;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.houseInteractive.buyer.BuyingManager;
   import com.qb9.gaturro.world.houseInteractive.silo.SiloManager;
   import com.qb9.gaturro.world.reports.InfoReportQueue;
   import com.qb9.mambo.geom.Coord;
   import com.qb9.mambo.net.chat.whitelist.WhiteListNode;
   import com.qb9.mambo.net.manager.NetworkManagerEvent;
   import farm.AceleradorIcon;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class GaturroHomeGranjaView extends GaturroHomeView
   {
      
      public static const TUTORIAL_NAME:String = "tutorialGranja";
       
      
      private var _tasks:TaskContainer;
      
      private const PARCELA_NAME:String = "granja.parcela";
      
      public var planting:Boolean;
      
      private var _farmerLevel:int;
      
      private var _cropCursor:MovieClip;
      
      private var _aceleradorIcon:AceleradorIcon;
      
      private var houseInv:GaturroInventory;
      
      private var _buyers:Array;
      
      private var _timer:Timer;
      
      private var _cancelCrop:CancelCrop;
      
      private var _mouseTimer:Timer;
      
      private var _mouseHighlightActive:Boolean;
      
      private var _siloManager:SiloManager;
      
      private var _siloSceneObjectView:HomeInteractiveRoomSceneObjectView;
      
      private var _hasSilo:Boolean;
      
      private var _activeCrop:Object;
      
      private var parcelaCoord:Array;
      
      public var jobStats:JobStats;
      
      private var _buyingManager:BuyingManager;
      
      private var compradores:int;
      
      private var _farmerXP:int;
      
      private var parcelas:int;
      
      private var actions:NetActionManager;
      
      private var maxParcelas:int;
      
      public function GaturroHomeGranjaView(param1:GaturroRoom, param2:TaskContainer, param3:InfoReportQueue, param4:GaturroMailer, param5:WhiteListNode)
      {
         super(param1,param3,param4,param5);
         this._tasks = param2;
         this.parcelas = this.parcelasCount();
         this.compradores = this.buyersCount();
         this._hasSilo = this.hasSilo();
         this.parcelaCoord = this.getCoordsFromConfig();
         this.maxParcelas = settings.granjaHome.parcelaCoord.length;
         this._timer = new Timer(1000);
         this._mouseTimer = new Timer(100);
         this._mouseTimer.start();
         this._mouseTimer.addEventListener(TimerEvent.TIMER,this.onMouseTimer);
         this.houseInv = param1.userAvatar.user.inventory("house") as GaturroInventory;
         this.actions = new NetActionManager(net,gRoom);
         this._siloManager = new SiloManager();
         this._siloManager.firstLoad(param1.userAvatar.user.attributes["silo"]);
         this._buyers = [];
         this._cropCursor = new MovieClip();
         this._cropCursor.addEventListener(Event.ENTER_FRAME,this.followMouse);
         this._cancelCrop = new CancelCrop();
         this._cancelCrop.close.addEventListener(MouseEvent.CLICK,this.onCancelActiveCrop);
         this._aceleradorIcon = new AceleradorIcon();
      }
      
      private function followMouse(param1:Event) : void
      {
         if(!cursor.active)
         {
            return;
         }
         this._cropCursor.x = cursor.x + 32;
         this._cropCursor.y = cursor.y + 15;
      }
      
      private function checkDisposeActions() : void
      {
         if(this.parcelas == this.maxParcelas && this.hasSilo() && this.compradores >= 3)
         {
            this.actions.dispose();
         }
      }
      
      public function plantActiveCrop(param1:GaturroSceneObjectAPI) : void
      {
         this.plantCrop(this._activeCrop,param1);
      }
      
      private function removeMouseGUI(param1:MouseEvent) : void
      {
         this.onCancelActiveCrop();
         gui.removeEventListener(MouseEvent.CLICK,this.removeMouseGUI);
      }
      
      override protected function whenMouseChangesPosition(param1:MouseEvent) : void
      {
         if(this._mouseHighlightActive)
         {
            this._mouseHighlightActive = false;
            super.whenMouseChangesPosition(param1);
         }
      }
      
      private function hasSilo() : Boolean
      {
         var _loc1_:int = 0;
         while(_loc1_ < room.sceneObjects.length)
         {
            if(room.sceneObjects[_loc1_].name == "granja.silo")
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      private function onAceleradorClick(param1:MouseEvent) : void
      {
         if(api.user.isCitizen)
         {
            gui.addModal(new AceleradorPopUpModal(this.jobStats,tasks,this._siloManager,this));
         }
         else
         {
            api.showBannerModal("pasaporteGranja");
         }
      }
      
      public function get aceleradorIcon() : AceleradorIcon
      {
         return this._aceleradorIcon;
      }
      
      private function parcelasCount() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < room.sceneObjects.length)
         {
            if(room.sceneObjects[_loc2_].name == this.PARCELA_NAME)
            {
               _loc1_++;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function plantCrop(param1:Object, param2:GaturroSceneObjectAPI) : void
      {
         var _loc4_:int = 0;
         var _loc3_:int = api.getProfileAttribute("coins") as int;
         if(_loc3_ < param1.price)
         {
            this.jobStats.coinsAsset.userCoins.textColor = 16711680;
            this.jobStats.coinsAsset.g.gotoAndStop("red");
            _loc4_ = this.jobStats.coinsAsset.x;
            this.onCancelActiveCrop();
            tasks.add(new Sequence(new Tween(this.jobStats.coinsAsset,200,{"x":_loc4_ + 5},{"transition":"easeIn"}),new Tween(this.jobStats.coinsAsset,200,{"x":_loc4_ - 5},{"transition":"easeIn"}),new Tween(this.jobStats.coinsAsset,100,{"x":_loc4_},{"transition":"easeIn"}),new Tween(this.jobStats.coinsAsset.userCoins,1,{"textColor":0}),new Func(this.jobStats.coinsAsset.g.gotoAndStop,"black")));
            return;
         }
         param2.setAttribute("plant",param1.name);
         param2.setAttribute("time",param2.serverTime);
         this.saveGlobalPlantingTime(Number(param1.timeToGrow));
         param2.view.dispatchEvent(new Event(Event.ACTIVATE));
         api.setProfileAttribute("system_coins",_loc3_ - param1.price);
         this.jobStats.updateCoins(_loc3_ - param1.price);
      }
      
      private function removeMouseSilo(param1:MouseEvent) : void
      {
         this.onCancelActiveCrop();
         this.searchInSceneObjects("granja.silo").removeEventListener(MouseEvent.CLICK,this.removeMouseSilo);
      }
      
      private function addingToGUI() : void
      {
         this.displayFarmerLevel();
         this.initBuyingManager();
         gui.questlog_ph.visible = false;
         gui.kickHouseBtn.visible = false;
         gui.actionDisplayer.visible = false;
         this.setupAcelerador();
         var _loc1_:Number = api.getProfileAttribute(GranjaAlert.profAttr) as Number;
         if(!isNaN(_loc1_))
         {
            Telemetry.getInstance().trackEvent(TrackCategories.GRANJA,TrackActions.GRANJA_ENTER_FIRSTTIME);
            if(_loc1_ > api.serverTime || _loc1_ == 0)
            {
               api.setProfileAttribute(GranjaAlert.profAttr,"done");
            }
         }
         var _loc2_:int = api.getSession(GranjaAlert.LOADED_ATTR) as int;
         if(_loc2_ == 0)
         {
            api.setSession(GranjaAlert.LOADED_ATTR,room.id);
         }
         var _loc3_:int = api.getProfileAttribute(TUTORIAL_NAME) as int;
         if(_loc3_ == 2)
         {
            Telemetry.getInstance().trackEvent(TrackCategories.GRANJA,TrackActions.GRANJA_ENTER);
            api.setProfileAttribute(TUTORIAL_NAME,3);
            gui.houseMap.tutorialArrow.visible = false;
            _loc3_ = 3;
            gui.phTop.getChildAt(0).visible = false;
         }
         if(_loc3_ == 3)
         {
            api.showBannerModal("tutorialGranjaBLOG");
            Telemetry.getInstance().trackEvent(TrackCategories.GRANJA,TrackActions.GRANJA_HELP_OPEN_BANNER);
            gui.modal.scaleX = 0.1;
            gui.modal.scaleY = 0.1;
            tasks.add(new Sequence(new Tween(gui.modal,1000,{
               "scaleX":0.2,
               "scaleY":0.2
            },{"transition":"easeIn"}),new Tween(gui.modal,500,{
               "scaleX":1,
               "scaleY":1
            },{"transition":"easeIn"})));
         }
      }
      
      public function get siloManager() : SiloManager
      {
         return this._siloManager;
      }
      
      override public function dispose() : void
      {
         this.actions.dispose();
         this._siloManager = null;
         this.parcelaCoord = null;
         this._timer = null;
         this._cropCursor.removeEventListener(Event.ENTER_FRAME,this.followMouse);
         GaturroLoadingScreen.TYPE = GaturroLoadingScreen.DEFAULT;
         super.dispose();
      }
      
      private function agregoSilo(param1:NetworkManagerEvent) : void
      {
         var _loc2_:Array = null;
         if(this.houseInv.hasAnyOf("granja.silo"))
         {
            _loc2_ = this.houseInv.byType("granja.silo");
            this.houseInv.drop(_loc2_[0].id,new Coord(19,9));
            net.removeEventListener(NetworkManagerEvent.ADDED_TO_INVENTORY,this.agregoSilo);
            this.askCompradores();
         }
      }
      
      private function addToCursorCrop(param1:DisplayObject) : void
      {
         param1.scaleX = 0.6;
         param1.scaleY = 0.6;
         this._cropCursor.addChild(param1);
         this._cropCursor.visible = true;
         gui.parent.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         gui.addEventListener(MouseEvent.CLICK,this.removeMouseGUI);
      }
      
      private function saveGlobalPlantingTime(param1:Number) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:String = null;
         var _loc2_:String = api.getProfileAttribute(GranjaAlert.profAttr) as String;
         param1 += api.serverTime;
         if(_loc2_ != "null")
         {
            _loc3_ = Number(Number(_loc2_) || 0);
            _loc4_ = "";
            if(_loc3_ < param1 || _loc3_ < api.serverTime)
            {
               _loc3_ = param1;
            }
            if((_loc4_ = _loc3_.toString()) != _loc2_)
            {
               api.setProfileAttribute(GranjaAlert.profAttr,_loc4_);
            }
         }
         else
         {
            _loc4_ = param1.toString();
            api.setProfileAttribute(GranjaAlert.profAttr,_loc4_);
         }
      }
      
      public function updateAcelerador() : void
      {
         this._aceleradorIcon.aceleradorAmount.text = this._siloManager.aceleradorQty.toString();
      }
      
      public function get activeCrop() : Object
      {
         return this._activeCrop;
      }
      
      private function agregoCompradores(param1:NetworkManagerEvent) : void
      {
         var _loc3_:Array = null;
         var _loc4_:GaturroInventorySceneObject = null;
         var _loc2_:int = 1;
         while(_loc2_ <= 3)
         {
            if(param1.mobject.getMobject("sceneObject").getString("name") == "granja.Comprador_" + _loc2_)
            {
               _loc3_ = this.houseInv.byType("granja.Comprador_" + _loc2_);
               _loc4_ = _loc3_[0];
               this.houseInv.drop(_loc4_.id,new Coord(18 + _loc2_,4));
               ++this.compradores;
               if(this.compradores >= 3)
               {
                  this.askParcelas();
                  net.removeEventListener(NetworkManagerEvent.ADDED_TO_INVENTORY,this.agregoCompradores);
               }
               else
               {
                  this.actions.inventoryAdd("granja.Comprador_" + (this.compradores + 1));
               }
               return;
            }
            _loc2_++;
         }
      }
      
      private function askCompradores() : void
      {
         var _loc1_:int = 0;
         if(this.compradores < 3)
         {
            net.addEventListener(NetworkManagerEvent.ADDED_TO_INVENTORY,this.agregoCompradores);
            _loc1_ = this.compradores + 1;
            this.actions.inventoryAdd("granja.Comprador_" + _loc1_);
         }
      }
      
      private function getCoordsFromConfig() : Array
      {
         var _loc1_:Array = settings.granjaHome.parcelaCoord;
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_.length)
         {
            _loc2_.push(new Coord(_loc1_[_loc3_].x,_loc1_[_loc3_].y));
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function onMouseUp(param1:MouseEvent) : void
      {
         if(cursor.pointer == "walk")
         {
            gui.parent.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
            this.onCancelActiveCrop();
         }
      }
      
      public function get timer() : Timer
      {
         return this._timer;
      }
      
      private function initBuyingManager() : void
      {
         this._buyingManager = new BuyingManager(api,gui,tasks);
      }
      
      private function addToCancelCrop(param1:DisplayObject) : void
      {
         this._cancelCrop.cropPH.addChild(param1);
         this._cancelCrop.visible = true;
      }
      
      private function onCancelActiveCrop(param1:MouseEvent = null) : void
      {
         while(this._cropCursor.numChildren > 0)
         {
            this._cropCursor.removeChildAt(0);
         }
         while(this._cancelCrop.cropPH.numChildren > 0)
         {
            this._cancelCrop.cropPH.removeChildAt(0);
         }
         this._cropCursor.visible = false;
         this._cancelCrop.visible = false;
         this.planting = false;
      }
      
      private function buyersCount() : int
      {
         var _loc3_:String = null;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < room.sceneObjects.length)
         {
            _loc3_ = String(room.sceneObjects[_loc2_].name);
            _loc3_ = _loc3_.substring(0,_loc3_.length - 1);
            if(_loc3_ == "granja.Comprador_")
            {
               _loc1_++;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      private function displayFarmerLevel() : void
      {
         this.jobStats = new JobStats(JobStats.GRANJA,gui,settings.granjaHome.levelUp,this._tasks);
      }
      
      private function setupAcelerador() : void
      {
         this._aceleradorIcon.buttonMode = true;
         this._aceleradorIcon.aceleradorAmount.text = this._siloManager.aceleradorQty.toString();
         this._aceleradorIcon.addEventListener(MouseEvent.CLICK,this.onAceleradorClick);
         this._aceleradorIcon.addEventListener(AceleradorEvent.OPEN,this.onAceleraCreceClick);
         gui.phTop.addChild(this._aceleradorIcon);
      }
      
      private function askParcelas() : void
      {
         if(this.parcelas < this.maxParcelas)
         {
            net.addEventListener(NetworkManagerEvent.ADDED_TO_INVENTORY,this.agregoParcelas);
            this.actions.inventoryAdd(this.PARCELA_NAME);
         }
      }
      
      public function addTask(param1:ITask) : void
      {
         this._tasks.add(param1);
      }
      
      private function onMouseTimer(param1:TimerEvent) : void
      {
         this._mouseHighlightActive = true;
      }
      
      override protected function roomCamera() : void
      {
         CameraSwitcher.instance.taskRunner = tasks;
         CameraSwitcher.instance.switchCamera(CameraSwitcher.GRANJA_ROOM_CAMERA,tileLayer,layers,int(room.attributes.bounds) || 0,userView,room.userAvatar);
      }
      
      public function get farmerLevel() : int
      {
         return this.jobStats.currentLevel;
      }
      
      private function onAceleraCreceClick(param1:AceleradorEvent) : void
      {
         if(api.user.isCitizen)
         {
            gui.addModal(new AceleradorPopUpModal(this.jobStats,tasks,this._siloManager,this,param1.behavior));
         }
         else
         {
            api.showBannerModal("pasaporteGranja");
         }
      }
      
      public function isBuying(param1:int) : Boolean
      {
         switch(param1)
         {
            case 1:
               return this._buyingManager.pedido1 != null;
            case 2:
               return this._buyingManager.pedido2 != null;
            case 3:
               return this._buyingManager.pedido3 != null;
            default:
               return false;
         }
      }
      
      public function set activeCrop(param1:Object) : void
      {
         this._activeCrop = param1;
         gui.addChild(this._cropCursor);
         api.libraries.fetch(param1.name + "Seed",this.addToCursorCrop);
      }
      
      override protected function addSceneObjects() : void
      {
         var _loc1_:int = 0;
         super.addSceneObjects();
         if(!this._hasSilo)
         {
            api.debug("PIDE SILO!!!!");
            net.addEventListener(NetworkManagerEvent.ADDED_TO_INVENTORY,this.agregoSilo);
            this.actions.inventoryAdd("granja.silo");
         }
         else if(this.compradores < 3)
         {
            net.addEventListener(NetworkManagerEvent.ADDED_TO_INVENTORY,this.agregoCompradores);
            _loc1_ = this.compradores + 1;
            this.actions.inventoryAdd("granja.Comprador_" + _loc1_);
         }
         else if(this.parcelas < this.maxParcelas)
         {
            net.addEventListener(NetworkManagerEvent.ADDED_TO_INVENTORY,this.agregoParcelas);
            this.actions.inventoryAdd(this.PARCELA_NAME);
         }
         this.checkDisposeActions();
         this._timer.start();
         if(room.ownedByUser)
         {
            this.addingToGUI();
         }
      }
      
      private function agregoParcelas(param1:NetworkManagerEvent) : void
      {
         var _loc2_:Coord = null;
         var _loc3_:Array = null;
         if(param1.mobject.getMobject("sceneObject").getString("name") == this.PARCELA_NAME)
         {
            if(this.parcelas < this.maxParcelas - 1)
            {
               this.actions.inventoryAdd(this.PARCELA_NAME);
            }
            else
            {
               net.removeEventListener(NetworkManagerEvent.ADDED_TO_INVENTORY,this.agregoParcelas);
            }
            _loc2_ = this.parcelaCoord[this.parcelas];
            _loc3_ = this.houseInv.byType("granja.parcela");
            this.houseInv.drop(_loc3_[0].id,_loc2_);
            ++this.parcelas;
         }
      }
      
      public function get buyingManager() : BuyingManager
      {
         return this._buyingManager;
      }
      
      private function searchInSceneObjects(param1:String) : HomeInteractiveRoomSceneObjectView
      {
         var _loc2_:int = 0;
         while(_loc2_ < room.sceneObjects.length)
         {
            if(room.sceneObjects[_loc2_].name == param1)
            {
               return sceneObjects.getItem(room.sceneObjects[_loc2_]) as HomeInteractiveRoomSceneObjectView;
            }
            _loc2_++;
         }
         return null;
      }
   }
}

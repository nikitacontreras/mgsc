package com.qb9.gaturro.view.components.banner.dressingRoom
{
   import com.adobe.serialization.json.JSON;
   import com.qb9.flashlib.config.Settings;
   import com.qb9.flashlib.net.LoadFile;
   import com.qb9.flashlib.net.LoadFileFormat;
   import com.qb9.flashlib.net.LoadFileParsers;
   import com.qb9.flashlib.tasks.TaskEvent;
   import com.qb9.flashlib.tasks.TaskRunner;
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.net.requests.URLUtil;
   import com.qb9.gaturro.view.gui.banner.properties.IHasOptions;
   import com.qb9.gaturro.view.gui.banner.properties.IHasRoomAPI;
   import com.qb9.gaturro.view.gui.base.modal.AbstractCanvasFrameBanner;
   import com.qb9.gaturro.view.world.avatars.AvatarDresser;
   import flash.events.Event;
   import flash.utils.setTimeout;
   
   public class LooksColegioBanner extends AbstractCanvasFrameBanner implements IHasRoomAPI, IHasOptions
   {
       
      
      private var _roomAPI:GaturroRoomAPI;
      
      private var costumesDefinition:Settings;
      
      private var selectedCostumes:Array;
      
      private var legs:PartSelector;
      
      private var foots:PartSelector;
      
      private var dresserDefinition:Array;
      
      private var cloths:PartSelector;
      
      private var heads:PartSelector;
      
      private var _options:String;
      
      private var arms:PartSelector;
      
      private var _dresser:AvatarDresser;
      
      private var hats:PartSelector;
      
      private var bannersDefinitions:Settings;
      
      private var _taskRunner:TaskRunner;
      
      public function LooksColegioBanner()
      {
         this.dresserDefinition = [];
         this.selectedCostumes = [];
         super("ColegioWears","DressingRoomBannerAsset");
      }
      
      public function randomizeAll() : void
      {
         this.heads.randomize();
         this.hats.randomize();
         this.cloths.randomize();
         this.arms.randomize();
         this.legs.randomize();
         this.foots.randomize();
      }
      
      private function onBannersDefinitionLoaded(param1:Event = null) : void
      {
         this.costumesDefinition = new Settings();
         LoadFileParsers.registerParser(LoadFileFormat.JSON,com.adobe.serialization.json.JSON.decode);
         var _loc2_:String = URLUtil.getUrl("cfgs/banners/CostumesColegio.json");
         var _loc3_:LoadFile = new LoadFile(_loc2_,"json");
         this.costumesDefinition.addFile(_loc3_);
         _loc3_.addEventListener(TaskEvent.COMPLETE,this.onCostumesLoaded);
         _loc3_.start();
      }
      
      public function get costumes() : Array
      {
         return this.selectedCostumes;
      }
      
      public function get taskRunner() : TaskRunner
      {
         return this._taskRunner;
      }
      
      private function storeCostumes() : void
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc1_:int = 0;
         while(_loc1_ < this.costumes.length)
         {
            trace(this.costumes[_loc1_]);
            if(this.costumes[_loc1_])
            {
               _loc2_ = this.costumes[_loc1_].parts;
               _loc3_ = 0;
               while(_loc3_ < _loc2_.length)
               {
                  switch(_loc2_[_loc3_].part)
                  {
                     case this.heads.part:
                        this.heads.parts.push(_loc2_[_loc3_]);
                        break;
                     case this.hats.part:
                        this.hats.parts.push(_loc2_[_loc3_]);
                        break;
                     case this.cloths.part:
                        this.cloths.parts.push(_loc2_[_loc3_]);
                        break;
                     case this.arms.part:
                        this.arms.parts.push(_loc2_[_loc3_]);
                        break;
                     case this.legs.part:
                        this.legs.parts.push(_loc2_[_loc3_]);
                        break;
                     case this.foots.part:
                        this.foots.parts.push(_loc2_[_loc3_]);
                        break;
                  }
                  trace(_loc2_[_loc3_].part,_loc2_[_loc3_].name);
                  _loc3_++;
               }
            }
            _loc1_++;
         }
      }
      
      public function get options() : String
      {
         return this._options;
      }
      
      override protected function ready() : void
      {
         this.loadSettings();
         super.ready();
      }
      
      public function get dresser() : AvatarDresser
      {
         return this._dresser;
      }
      
      override protected function setInitialCanvasName() : void
      {
         initialCanvasName = "loading";
      }
      
      public function get currentCostume() : Object
      {
         var _loc1_:Object = {"parts":[]};
         if(this.heads.currentCostume)
         {
            _loc1_.parts.push(this.heads.currentCostume);
         }
         if(this.hats.currentCostume)
         {
            _loc1_.parts.push(this.hats.currentCostume);
         }
         if(this.cloths.currentCostume)
         {
            _loc1_.parts.push(this.cloths.currentCostume);
         }
         if(this.arms.currentCostume)
         {
            _loc1_.parts.push(this.arms.currentCostume);
         }
         if(this.legs.currentCostume)
         {
            _loc1_.parts.push(this.legs.currentCostume);
         }
         if(this.foots.currentCostume)
         {
            _loc1_.parts.push(this.foots.currentCostume);
         }
         _loc1_.vip = Math.random() > 0.75;
         return _loc1_;
      }
      
      private function loadSettings() : void
      {
         this.bannersDefinitions = new Settings();
         LoadFileParsers.registerParser(LoadFileFormat.JSON,com.adobe.serialization.json.JSON.decode);
         var _loc1_:String = URLUtil.getUrl("cfgs/banners/DresserBanner.json");
         var _loc2_:LoadFile = new LoadFile(_loc1_,"json");
         this.bannersDefinitions.addFile(_loc2_);
         _loc2_.addEventListener(TaskEvent.COMPLETE,this.onBannersDefinitionLoaded);
         _loc2_.start();
      }
      
      public function get partSelector() : Array
      {
         return [this.heads,this.hats,this.arms,this.cloths,this.legs,this.foots];
      }
      
      public function switchCanvas(param1:String, param2:Object = null) : void
      {
         switchTo(param1,param2);
      }
      
      override protected function setupCanvas() : void
      {
         addCanvas(new LooksColegioCanvas("building","building",canvasContainer,this));
         addCanvas(new LoadingCanvas("loading","loading",canvasContainer,this));
      }
      
      private function onCostumesLoaded(param1:Event = null) : void
      {
         this.dresserDefinition = this.bannersDefinitions.banners[!!this._options ? this._options : "default"];
         while(this.dresserDefinition.length > 0)
         {
            this.selectedCostumes.push(this.costumesDefinition.costumes[this.dresserDefinition.pop()]);
         }
         this._dresser = new AvatarDresser();
         this._taskRunner = new TaskRunner(view);
         this._taskRunner.start();
         this.setupCostumes();
         setTimeout(switchTo,500,"building");
      }
      
      public function set options(param1:String) : void
      {
         this._options = param1;
      }
      
      public function set roomAPI(param1:GaturroRoomAPI) : void
      {
         this._roomAPI = param1;
      }
      
      private function setupCostumes() : void
      {
         this.heads = new PartSelector("hairs");
         this.hats = new PartSelector("hats");
         this.cloths = new PartSelector("cloth");
         this.arms = new PartSelector("arm");
         this.legs = new PartSelector("leg");
         this.foots = new PartSelector("foot");
         this.storeCostumes();
         this.randomizeAll();
      }
   }
}

import com.qb9.gaturro.globals.api;
import flash.display.DisplayObjectContainer;
import flash.display.SimpleButton;
import flash.events.MouseEvent;

class PartSelector
{
    
   
   public var parts:Array;
   
   public var data:Object;
   
   public var prev:SimpleButton;
   
   private var setPage:Function;
   
   public var next:SimpleButton;
   
   private var currentIndex:int = 0;
   
   public var part:String;
   
   public function PartSelector(param1:String, param2:Object = null)
   {
      this.parts = new Array();
      super();
      this.part = param1;
      this.data = param2;
   }
   
   public function onNext(param1:MouseEvent) : void
   {
      ++this.currentIndex;
      if(this.currentIndex >= this.parts.length)
      {
         this.currentIndex = 0;
      }
      api.info("VESTIDOR GATOONS " + this.part + "- INDEX: " + this.currentIndex);
      this.setPage();
   }
   
   public function get currentCostume() : Object
   {
      return this.parts[this.currentIndex];
   }
   
   public function setupButton(param1:DisplayObjectContainer, param2:Function) : void
   {
      this.next = param1.getChildByName("next_" + this.part) as SimpleButton;
      this.prev = param1.getChildByName("prev_" + this.part) as SimpleButton;
      this.next.addEventListener(MouseEvent.CLICK,this.onNext);
      this.prev.addEventListener(MouseEvent.CLICK,this.onPrevious);
      this.setPage = param2;
   }
   
   public function onPrevious(param1:MouseEvent) : void
   {
      --this.currentIndex;
      if(this.currentIndex < 0)
      {
         this.currentIndex = this.parts.length - 1;
      }
      api.info("VESTIDOR GATOONS " + this.part + "- INDEX: " + this.currentIndex);
      this.setPage();
   }
   
   public function randomize() : void
   {
      this.currentIndex = int(this.parts.length * Math.random());
      api.info(this.part + " index: " + this.currentIndex + " L: " + this.parts.length);
   }
}

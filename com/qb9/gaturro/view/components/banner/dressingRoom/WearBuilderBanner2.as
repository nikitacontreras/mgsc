package com.qb9.gaturro.view.components.banner.dressingRoom
{
   import com.adobe.serialization.json.JSON;
   import com.qb9.flashlib.config.Settings;
   import com.qb9.flashlib.net.LoadFile;
   import com.qb9.flashlib.net.LoadFileFormat;
   import com.qb9.flashlib.net.LoadFileParsers;
   import com.qb9.flashlib.tasks.TaskEvent;
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.net.requests.URLUtil;
   import com.qb9.gaturro.view.components.canvas.common.ISwitchPostExplanation;
   import com.qb9.gaturro.view.gui.banner.properties.IHasOptions;
   import com.qb9.gaturro.view.gui.banner.properties.IHasRoomAPI;
   import com.qb9.gaturro.view.gui.base.modal.AbstractCanvasFrameBanner;
   import flash.events.Event;
   import flash.utils.setTimeout;
   
   public class WearBuilderBanner2 extends AbstractCanvasFrameBanner implements IHasRoomAPI, ISwitchPostExplanation, IHasOptions
   {
       
      
      private var _roomAPI:GaturroRoomAPI;
      
      private var costumesDefinition:Settings;
      
      private var selectedCostumes:Array;
      
      private var dresserDefinition:Array;
      
      private var _options:String;
      
      private var bannersDefinitions:Settings;
      
      public function WearBuilderBanner2()
      {
         this.dresserDefinition = [];
         this.selectedCostumes = [];
         super("DressingRoomBanner","DressingRoomBannerAsset");
      }
      
      public function switchToPostExplanation() : void
      {
         close();
      }
      
      private function onBannersDefinitionLoaded(param1:Event = null) : void
      {
         this.costumesDefinition = new Settings();
         LoadFileParsers.registerParser(LoadFileFormat.JSON,com.adobe.serialization.json.JSON.decode);
         var _loc2_:String = URLUtil.getUrl("cfgs/banners/CostumesFashion.json");
         var _loc3_:LoadFile = new LoadFile(_loc2_,"json");
         this.costumesDefinition.addFile(_loc3_);
         _loc3_.addEventListener(TaskEvent.COMPLETE,this.onCostumesLoaded);
         _loc3_.start();
      }
      
      public function get costumes() : Array
      {
         return this.selectedCostumes;
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
      
      override protected function setInitialCanvasName() : void
      {
         initialCanvasName = "loading";
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
      
      public function switchCanvas(param1:String, param2:Object = null) : void
      {
         switchTo(param1,param2);
      }
      
      override protected function setupCanvas() : void
      {
         addCanvas(new CostumeBuilderCanvas("building2","building2",canvasContainer,this));
         addCanvas(new LoadingCanvas("loading","loading",canvasContainer,this));
      }
      
      private function onCostumesLoaded(param1:Event = null) : void
      {
         this.dresserDefinition = this.bannersDefinitions.banners[!!this._options ? this._options : "default"];
         while(this.dresserDefinition.length > 0)
         {
            this.selectedCostumes.push(this.costumesDefinition.costumes[this.dresserDefinition.pop()]);
         }
         setTimeout(switchTo,1200,"building2");
      }
      
      public function set options(param1:String) : void
      {
         this._options = param1;
      }
      
      public function set roomAPI(param1:GaturroRoomAPI) : void
      {
         this._roomAPI = param1;
      }
   }
}

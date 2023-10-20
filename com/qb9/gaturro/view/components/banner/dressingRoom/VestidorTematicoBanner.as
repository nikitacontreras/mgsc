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
   
   public class VestidorTematicoBanner extends AbstractCanvasFrameBanner implements IHasRoomAPI, ISwitchPostExplanation, IHasOptions
   {
       
      
      private var _roomAPI:GaturroRoomAPI;
      
      private var _options:String;
      
      private var costumesDefinition:Settings;
      
      private var selectedCostumes:Array;
      
      private var dresserDefinition:Array;
      
      private var bannersDefinitions:Settings;
      
      public function VestidorTematicoBanner()
      {
         this.dresserDefinition = [];
         this.selectedCostumes = [];
         super("VestidoresTematicos","DressingRoomBannerAsset");
      }
      
      private function finalSwitch() : void
      {
         if(!disposed)
         {
            switchTo("building2");
         }
      }
      
      private function onBannersDefinitionLoaded(param1:Event = null) : void
      {
         this.costumesDefinition = new Settings();
         LoadFileParsers.registerParser(LoadFileFormat.JSON,com.adobe.serialization.json.JSON.decode);
         var _loc2_:String = URLUtil.getUrl("cfgs/banners/tematicos/" + this._options + ".json");
         var _loc3_:LoadFile = new LoadFile(_loc2_,"json");
         this.costumesDefinition.addFile(_loc3_);
         _loc3_.addEventListener(TaskEvent.COMPLETE,this.onCostumesLoaded);
         _loc3_.start();
      }
      
      public function switchToPostExplanation() : void
      {
         close();
      }
      
      public function get costumes() : Array
      {
         return this.selectedCostumes;
      }
      
      public function get dresserGlobalEffect() : String
      {
         return String(this.costumesDefinition.global_effect) || "";
      }
      
      public function get options() : String
      {
         return this._options;
      }
      
      override public function dispose() : void
      {
         this._roomAPI = null;
         this._options = null;
         this.bannersDefinitions = null;
         this.costumesDefinition = null;
         this.dresserDefinition = null;
         this.selectedCostumes = null;
         super.dispose();
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
         var _loc1_:String = URLUtil.getUrl("cfgs/banners/DresserBanner_Tematicos.json");
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
         addCanvas(new TematicaBuilderCanvas("building2","building2",canvasContainer,this));
         addCanvas(new LoadingCanvas("loading","loading",canvasContainer,this));
      }
      
      private function onCostumesLoaded(param1:Event = null) : void
      {
         this.dresserDefinition = this.bannersDefinitions.banners[this._options];
         while(this.dresserDefinition.length > 0)
         {
            this.selectedCostumes.push(this.costumesDefinition.costumes[this.dresserDefinition.pop()]);
         }
         setTimeout(this.finalSwitch,1200);
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

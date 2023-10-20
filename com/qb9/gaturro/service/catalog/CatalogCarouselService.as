package com.qb9.gaturro.service.catalog
{
   import com.adobe.serialization.json.JSON;
   import com.qb9.flashlib.config.Settings;
   import com.qb9.flashlib.net.LoadFile;
   import com.qb9.flashlib.net.LoadFileFormat;
   import com.qb9.flashlib.net.LoadFileParsers;
   import com.qb9.flashlib.tasks.TaskEvent;
   import com.qb9.gaturro.globals.server;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.net.requests.URLUtil;
   import flash.events.Event;
   
   public class CatalogCarouselService
   {
       
      
      private var configReady:Boolean = false;
      
      private var _settings:Settings;
      
      public function CatalogCarouselService()
      {
         super();
         this.setup();
      }
      
      public function getCurrentCatalogCarouselMessage(param1:String) : String
      {
         var _loc2_:Object = this.getSelectedCurrentCatalog(param1);
         return _loc2_.message;
      }
      
      private function onSettings(param1:Event) : void
      {
         this.configReady = true;
      }
      
      public function getCatalogCarouselDeff(param1:String, param2:String) : CatalogCarouselDefinition
      {
         var _loc3_:CatalogCarouselDefinition = null;
         var _loc7_:Object = null;
         var _loc5_:Object;
         var _loc4_:Object;
         var _loc6_:Array = (_loc5_ = (_loc4_ = settings.carouselCatalog).catalogs[param1]).list;
         for each(_loc7_ in _loc6_)
         {
            if(_loc7_.name == param2)
            {
               _loc3_ = new CatalogCarouselDefinition(_loc7_);
               break;
            }
         }
         return _loc3_;
      }
      
      public function getCurrentCatalogName(param1:String) : String
      {
         var _loc2_:Object = this.getSelectedCurrentCatalog(param1);
         return _loc2_.name;
      }
      
      private function setup() : void
      {
         this._settings = new Settings();
         LoadFileParsers.registerParser(LoadFileFormat.JSON,com.adobe.serialization.json.JSON.decode);
         var _loc1_:String = URLUtil.getUrl("cfgs/catalogosRotativos.json");
         var _loc2_:LoadFile = new LoadFile(_loc1_,"json");
         this._settings.addFile(_loc2_);
         _loc2_.addEventListener(TaskEvent.COMPLETE,this.onSettings);
         _loc2_.start();
      }
      
      private function getSelectedCurrentCatalog(param1:String) : Object
      {
         var _loc2_:Object = this._settings.carouselCatalog;
         var _loc3_:String = String(_loc2_.dateStamp.toString());
         var _loc4_:Date = new Date(Date.parse(_loc3_));
         var _loc6_:Number;
         var _loc5_:Date;
         var _loc7_:int = (_loc6_ = (_loc5_ = new Date(server.time)).time - _loc4_.time) / 1000 / 60 / 60 / 24;
         var _loc8_:Object;
         var _loc9_:Array = (_loc8_ = _loc2_.catalogs[param1]).list;
         var _loc10_:int = _loc7_ % _loc9_.length;
         trace("CatalogService > selectCatalog > days % selectedCatalogList.length: " + _loc7_ % _loc9_.length);
         return _loc9_[_loc10_];
      }
      
      public function getCurrentCatalogCarouselIcon(param1:String) : String
      {
         var _loc2_:Object = this.getSelectedCurrentCatalog(param1);
         return _loc2_.icon;
      }
   }
}

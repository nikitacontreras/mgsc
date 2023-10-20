package com.qb9.gaturro.world.gatucine
{
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.world.gatucine.elements.GatucineHeader;
   import com.qb9.gaturro.world.gatucine.elements.GatucineReproduction;
   import com.qb9.gaturro.world.gatucine.elements.GatucineSerieSeason;
   import com.qb9.gaturro.world.gatucine.services.SecureLogin;
   import com.qb9.gaturro.world.gatucine.services.WebServiceElement;
   import com.qb9.gaturro.world.gatucine.services.WebServiceLogin;
   import com.qb9.gaturro.world.gatucine.services.WebServicePlay;
   import com.qb9.gaturro.world.gatucine.services.WebServiceSearch;
   import com.qb9.gaturro.world.gatucine.services.WebServicesConnection;
   import flash.external.ExternalInterface;
   
   public class GatucineManager
   {
      
      private static const CINEMA:String = "cinema";
      
      private static const TV:String = "tv";
      
      private static const SERIES_CRITERIA:String = "categoria_series2";
       
      
      private var headersTotalPages:int = 0;
      
      private var lastPlayCallback:Function;
      
      private var lastSelectedCriteria:String = "categoria_series2";
      
      private var dictionaryHeaders:Array;
      
      private var headersTotalCount:int = 0;
      
      private var lastReproduction:GatucineReproduction;
      
      private var lastSelectedType:String = "tv";
      
      private var conn:WebServicesConnection;
      
      private var gatucineTracker:com.qb9.gaturro.world.gatucine.GatucineTracker;
      
      private var lastPlayableItem:Object;
      
      private var gatucineSessionId:String = "";
      
      public function GatucineManager()
      {
         this.dictionaryHeaders = new Array();
         super();
         this.gatucineTracker = new com.qb9.gaturro.world.gatucine.GatucineTracker();
      }
      
      public function get isSessionActive() : Boolean
      {
         return this.gatucineSessionId != "";
      }
      
      public function get totalPages() : int
      {
         return this.headersTotalPages;
      }
      
      public function play(param1:Object, param2:Function) : void
      {
         this.lastPlayableItem = param1;
         this.lastPlayCallback = param2;
         var _loc3_:WebServicePlay = new WebServicePlay(this,this.playResponse,this.lastPlayableItem.playId);
         this.conn.request(_loc3_);
      }
      
      public function set totalPages(param1:int) : void
      {
         this.headersTotalPages = param1;
      }
      
      public function search(param1:String, param2:int, param3:int, param4:Function) : void
      {
         var _loc5_:WebServiceSearch = new WebServiceSearch(this,param4,param2,param3,param1);
         this.conn.request(_loc5_);
      }
      
      public function set totalHeaders(param1:int) : void
      {
         this.headersTotalCount = param1;
      }
      
      public function selectCinema() : void
      {
         this.destroyHeaders();
         this.lastSelectedType = CINEMA;
      }
      
      public function addHeader(param1:GatucineHeader) : void
      {
         this.dictionaryHeaders.push(param1);
      }
      
      public function get sessionId() : String
      {
         return this.gatucineSessionId;
      }
      
      public function playResponse(param1:UIResponse) : void
      {
         var rep:GatucineReproduction = null;
         var responseObj:UIResponse = param1;
         try
         {
            if(responseObj.success)
            {
               rep = this.getReproduction();
               logger.debug("GATUCINE --> gatucineShowVideo()");
               ExternalInterface.call("gatucineShowVideo",rep.wrapper);
               this.gatucineTracker.pagePlay(this.lastPlayableItem);
            }
         }
         catch(e:Error)
         {
         }
         finally
         {
            if(this.lastPlayCallback != null)
            {
               this.lastPlayCallback(responseObj);
            }
         }
      }
      
      public function get selectedCriteria() : String
      {
         return this.lastSelectedCriteria;
      }
      
      public function setReproduction(param1:GatucineReproduction) : void
      {
         this.lastReproduction = param1;
      }
      
      public function selectTv() : void
      {
         this.destroyHeaders();
         this.lastSelectedCriteria = SERIES_CRITERIA;
         this.lastSelectedType = TV;
      }
      
      public function init() : void
      {
         this.conn = new WebServicesConnection();
      }
      
      public function destroyAll() : void
      {
         this.gatucineSessionId = "";
         this.dictionaryHeaders = null;
         this.lastReproduction = null;
      }
      
      public function login(param1:Function) : void
      {
         var _loc2_:WebServiceLogin = null;
         var _loc3_:SecureLogin = null;
         if(settings.gatucine.loginFromFlash)
         {
            _loc2_ = new WebServiceLogin(this,param1);
            this.conn.request(_loc2_);
         }
         else
         {
            _loc3_ = new SecureLogin(this,param1);
            this.conn.request(_loc3_);
         }
      }
      
      public function set sessionId(param1:String) : void
      {
         this.gatucineSessionId = param1;
      }
      
      public function set selectedCriteria(param1:String) : void
      {
         this.lastSelectedCriteria = param1;
      }
      
      public function get selectedType() : String
      {
         return this.lastSelectedType;
      }
      
      public function getReproduction() : GatucineReproduction
      {
         return this.lastReproduction;
      }
      
      public function get tracker() : com.qb9.gaturro.world.gatucine.GatucineTracker
      {
         return this.gatucineTracker;
      }
      
      public function get totalHeaders() : int
      {
         return this.headersTotalCount;
      }
      
      public function destroyHeaders() : void
      {
         this.headersTotalCount = 0;
         this.headersTotalPages = 0;
         this.dictionaryHeaders = new Array();
      }
      
      public function element(param1:GatucineSerieSeason, param2:Function) : void
      {
         var _loc3_:WebServiceElement = new WebServiceElement(this,param2,param1);
         this.conn.request(_loc3_);
      }
      
      public function getHeaders() : Array
      {
         return this.dictionaryHeaders;
      }
   }
}

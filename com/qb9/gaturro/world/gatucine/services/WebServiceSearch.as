package com.qb9.gaturro.world.gatucine.services
{
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.world.gatucine.GatucineManager;
   import com.qb9.gaturro.world.gatucine.UIResponse;
   import com.qb9.gaturro.world.gatucine.elements.GatucineMovie;
   import com.qb9.gaturro.world.gatucine.elements.GatucineSerieSeason;
   
   public class WebServiceSearch extends WebService
   {
       
      
      private var pageSize:int;
      
      private var page:int;
      
      private const SERIES_STRING:String = "series";
      
      private const ORDER_BY_CRITERIA:String = "-relevance";
      
      private var criteria:String;
      
      public function WebServiceSearch(param1:GatucineManager, param2:Function, param3:int, param4:int, param5:String)
      {
         super(param1,param2);
         this.page = param3;
         this.pageSize = param4;
         this.criteria = param5;
      }
      
      override public function receive(param1:String) : void
      {
         var obj:Object = null;
         var status:Boolean = false;
         var data:String = param1;
         try
         {
            obj = decodeResponse(data);
            status = Boolean(obj.status);
            if(status && obj.response && Boolean(obj.response.groups))
            {
               if(this.criteria.indexOf(this.SERIES_STRING) >= 0)
               {
                  this.parseSeries(obj.response.groups);
               }
               else
               {
                  this.parseMovies(obj.response.groups);
               }
               call(new UIResponse(true));
            }
            else
            {
               if(obj.response)
               {
                  logger.debug("GATUCINE -> " + obj.response);
               }
               receiveRequestError();
            }
         }
         catch(e:Error)
         {
            receiveRequestError();
         }
      }
      
      override public function get json() : String
      {
         var _loc1_:* = "{" + "\"session_id\": \"" + manager.sessionId + "\"," + "\"page\": \"" + this.page.toString() + "\"," + "\"page_size\": \"" + this.pageSize.toString() + "\"," + "\"device\": \"PC\", " + "\"operator\": \"gaturro\", " + "\"named_criteria\": \"" + this.criteria + "\"," + "\"orderby\": \"" + this.ORDER_BY_CRITERIA + "\" " + "}";
         trace(_loc1_);
         return _loc1_;
      }
      
      private function parseSeries(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:GatucineSerieSeason = null;
         for each(_loc2_ in param1)
         {
            for each(_loc3_ in _loc2_.element)
            {
               (_loc4_ = new GatucineSerieSeason()).id = _loc3_.id;
               _loc4_.title = _loc3_.title;
               _loc4_.criteria = this.criteria;
               _loc4_.color = _loc3_.color;
               _loc4_.trackerId = _loc3_.ref_id;
               _loc4_.createThumbnail(_loc3_.thumbnail.hd);
               manager.addHeader(_loc4_);
            }
            manager.totalHeaders = _loc2_.count;
            manager.totalPages = _loc2_.total_pages;
         }
      }
      
      private function parseMovies(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:GatucineMovie = null;
         for each(_loc2_ in param1)
         {
            for each(_loc3_ in _loc2_.element)
            {
               (_loc4_ = new GatucineMovie()).id = _loc3_.id;
               _loc4_.title = _loc3_.title;
               _loc4_.playId = _loc3_.id;
               _loc4_.criteria = this.criteria;
               _loc4_.color = _loc3_.color;
               _loc4_.trackerId = _loc3_.ref_id;
               _loc4_.createThumbnail(_loc3_.thumbnail.hd);
               manager.addHeader(_loc4_);
            }
            manager.totalHeaders = _loc2_.count;
            manager.totalPages = _loc2_.total_pages;
         }
      }
      
      override public function get url() : String
      {
         return settings.gatucine.WSSearchURL;
      }
   }
}

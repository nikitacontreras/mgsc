package com.qb9.gaturro.world.collection
{
   import com.qb9.gaturro.globals.logger;
   import com.qb9.gaturro.net.GaturroNetResponses;
   import com.qb9.gaturro.net.requests.catalog.CatalogDataRequest;
   import com.qb9.gaturro.world.catalog.Catalog;
   import com.qb9.mambo.net.library.BaseLoadedItemCollection;
   import com.qb9.mambo.net.manager.NetworkManager;
   import com.qb9.mambo.net.manager.NetworkManagerEvent;
   import com.qb9.mines.mobject.Mobject;
   
   public final class CatalogList extends BaseLoadedItemCollection
   {
       
      
      private var net:NetworkManager;
      
      public function CatalogList(param1:NetworkManager)
      {
         super(this.execute);
         this.net = param1;
         this.init();
      }
      
      private function init() : void
      {
         this.net.addEventListener(GaturroNetResponses.CATALOG_DATA,this.whenCatalogIsReceived);
      }
      
      private function execute(param1:Function, param2:Catalog, param3:Object = null) : void
      {
         param1(param2,param3);
      }
      
      override protected function load(param1:String) : void
      {
         logger.debug("Loading catalog",param1);
         this.net.sendAction(new CatalogDataRequest(param1));
      }
      
      private function whenCatalogIsReceived(param1:NetworkManagerEvent) : void
      {
         var _loc2_:Mobject = param1.mobject;
         var _loc3_:String = _loc2_.getString("name");
         logger.debug("Catalog",_loc3_,"was loaded");
         var _loc4_:Catalog;
         (_loc4_ = new Catalog()).buildFromMobject(_loc2_);
         loaded(_loc3_,_loc4_);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.net.removeEventListener(GaturroNetResponses.CATALOG_DATA,this.whenCatalogIsReceived);
         this.net = null;
      }
   }
}

package com.qb9.gaturro.view.components.banner.boca
{
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.service.events.EventsService;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import flash.display.MovieClip;
   
   public class BocaTorneoInscripcion extends InstantiableGuiModal
   {
      
      public static const USER_INSCRIPCION:String = "USER_INSCRIPCION";
       
      
      private var _finishedInscription:MovieClip;
      
      private var _intro:MovieClip;
      
      private var _asset:MovieClip;
      
      private var _next:MovieClip;
      
      private var _prize:MovieClip;
      
      private var _allTournamentsRunning:Array;
      
      private var _eventService:EventsService;
      
      private var _contTime:uint;
      
      public function BocaTorneoInscripcion(param1:String = "", param2:String = "")
      {
         super("BocaTorneoInscripcion","BocaTorneoInscripcion");
      }
      
      private function setupView() : void
      {
         this._asset = view as MovieClip;
         this._prize = this._asset["prize"] as MovieClip;
         var _loc1_:int = api.getSession("posicionTorneo") as int;
         this._prize.gotoAndStop(_loc1_);
      }
      
      override protected function onAssetReady() : void
      {
         this.setupView();
      }
   }
}

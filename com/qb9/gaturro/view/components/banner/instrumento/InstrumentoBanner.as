package com.qb9.gaturro.view.components.banner.instrumento
{
   import com.qb9.gaturro.external.roomObjects.GaturroRoomAPI;
   import com.qb9.gaturro.external.roomObjects.GaturroSceneObjectAPI;
   import com.qb9.gaturro.view.gui.banner.properties.IHasOptions;
   import com.qb9.gaturro.view.gui.banner.properties.IHasRoomAPI;
   import com.qb9.gaturro.view.gui.banner.properties.IHasSceneAPI;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   
   public class InstrumentoBanner extends InstantiableGuiModal implements IHasSceneAPI, IHasRoomAPI, IHasOptions
   {
       
      
      private var _roomAPI:GaturroRoomAPI;
      
      private var _sceneAPI:GaturroSceneObjectAPI;
      
      private var trackA:SimpleButton;
      
      private var trackB:SimpleButton;
      
      private var trackC:SimpleButton;
      
      public function InstrumentoBanner()
      {
         super("instrumento","InstrumentoAsset");
      }
      
      public function set options(param1:String) : void
      {
         trace(param1);
      }
      
      public function set roomAPI(param1:GaturroRoomAPI) : void
      {
         this._roomAPI = param1;
      }
      
      private function onTrackBClick(param1:MouseEvent) : void
      {
         trace("click B");
         this._sceneAPI.setAttributePersist("song","trackB");
      }
      
      override protected function ready() : void
      {
         this.setup();
      }
      
      override public function dispose() : void
      {
         this.trackA.removeEventListener(MouseEvent.CLICK,this.onTrackAClick);
         this.trackB.removeEventListener(MouseEvent.CLICK,this.onTrackBClick);
         this.trackC.removeEventListener(MouseEvent.CLICK,this.onTrackCClick);
         super.dispose();
      }
      
      public function set sceneAPI(param1:GaturroSceneObjectAPI) : void
      {
         this._sceneAPI = param1;
      }
      
      private function onTrackCClick(param1:MouseEvent) : void
      {
         trace("click C");
         this._sceneAPI.setAttributePersist("song","trackC");
      }
      
      private function onTrackAClick(param1:MouseEvent) : void
      {
         trace("click A");
         this._sceneAPI.setAttributePersist("song","trackA");
      }
      
      override public function close() : void
      {
         super.close();
      }
      
      private function setup() : void
      {
         this.trackA = view.getChildByName("trackA") as SimpleButton;
         this.trackB = view.getChildByName("trackB") as SimpleButton;
         this.trackC = view.getChildByName("trackC") as SimpleButton;
         this.trackA.addEventListener(MouseEvent.CLICK,this.onTrackAClick);
         this.trackB.addEventListener(MouseEvent.CLICK,this.onTrackBClick);
         this.trackC.addEventListener(MouseEvent.CLICK,this.onTrackCClick);
      }
   }
}

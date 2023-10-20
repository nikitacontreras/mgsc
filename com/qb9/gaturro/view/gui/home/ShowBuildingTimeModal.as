package com.qb9.gaturro.view.gui.home
{
   import assets.ModalMC;
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.view.gui.base.BaseGuiModal;
   import flash.events.MouseEvent;
   
   public class ShowBuildingTimeModal extends BaseGuiModal
   {
       
      
      private var asset:ModalMC;
      
      private var _time:int;
      
      public function ShowBuildingTimeModal(param1:int)
      {
         super();
         this._time = param1;
         this.init();
      }
      
      override public function dispose() : void
      {
         this.asset.close.removeEventListener(MouseEvent.CLICK,_close);
      }
      
      private function init() : void
      {
         this.asset = new ModalMC();
         addChild(this.asset);
         this.asset.stop();
         this.asset.image.gotoAndStop("error");
         this.asset.field.text = region.key("time_notify") + " " + this._time.toString() + " " + (this._time > 1 ? region.key("time_units") : region.key("time_unit"));
         this.asset.close.addEventListener(MouseEvent.CLICK,_close);
      }
   }
}

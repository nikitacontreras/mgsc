package com.qb9.gaturro.view.gui.home
{
   import assets.CityModalMC;
   import com.qb9.flashlib.input.Hotkey;
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.view.gui.base.BaseGuiModal;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public final class HouseEntranceGuiModal extends BaseGuiModal
   {
       
      
      private var asset:CityModalMC;
      
      private var hotkey:Hotkey;
      
      private var room:GaturroRoom;
      
      public function HouseEntranceGuiModal(param1:GaturroRoom)
      {
         super();
         this.room = param1;
         this.init();
      }
      
      override public function dispose() : void
      {
         this.asset.go.removeEventListener(MouseEvent.CLICK,this.changeRoom);
         this.asset.close.removeEventListener(MouseEvent.CLICK,_close);
         this.asset = null;
         this.room = null;
         super.dispose();
      }
      
      private function changeRoom(param1:Event = null) : void
      {
         if(this.user)
         {
            this.room.visit(this.user);
         }
      }
      
      private function init() : void
      {
         this.asset = new CityModalMC();
         region.setText(this.asset.go.text,"IR");
         this.asset.go.addEventListener(MouseEvent.CLICK,this.changeRoom);
         this.asset.close.addEventListener(MouseEvent.CLICK,_close);
         addChild(this.asset);
      }
      
      private function get user() : String
      {
         return this.asset.inputField.text;
      }
      
      override protected function whenAddedToStage() : void
      {
         super.whenAddedToStage();
         stage.focus = this.asset.inputField;
      }
      
      override protected function keyboardSubmit() : void
      {
         this.changeRoom();
      }
   }
}

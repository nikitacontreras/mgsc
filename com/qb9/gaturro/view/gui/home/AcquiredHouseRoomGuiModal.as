package com.qb9.gaturro.view.gui.home
{
   import assets.AcquiredHouseRoomConfirmationMC;
   import com.qb9.gaturro.globals.region;
   import com.qb9.gaturro.view.gui.base.BaseGuiModal;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class AcquiredHouseRoomGuiModal extends BaseGuiModal
   {
      
      public static const BUY:String = "buyNewHouseRoomEvent";
       
      
      private var coins:int;
      
      private var roomName:String;
      
      private var contiguous:Boolean;
      
      private var price:int;
      
      private var hours:Number;
      
      private var hasPassport:Boolean;
      
      private var needPassport:Boolean;
      
      private var roomNum:int;
      
      private var buildingAnother:Boolean;
      
      private var asset:AcquiredHouseRoomConfirmationMC;
      
      private var buildingThis:Boolean;
      
      private var buildMinutesLeft:int = 0;
      
      public function AcquiredHouseRoomGuiModal(param1:int, param2:String, param3:Boolean, param4:int, param5:int, param6:Number, param7:Boolean, param8:Boolean, param9:Boolean, param10:Boolean, param11:int)
      {
         super();
         this.roomNum = param1;
         this.roomName = param2;
         this.contiguous = param3;
         this.coins = param4;
         this.price = param5;
         this.hours = param6;
         this.hasPassport = param7;
         this.needPassport = param8;
         this.buildingThis = param9;
         this.buildingAnother = param10;
         this.buildMinutesLeft = param11;
         this.init();
      }
      
      override public function dispose() : void
      {
         this.removeHandlers();
         super.dispose();
      }
      
      public function get roomNumber() : int
      {
         return this.roomNum;
      }
      
      private function removeHandlers() : void
      {
         if(!this.asset)
         {
            return;
         }
         this.asset.buy.removeEventListener(MouseEvent.CLICK,this.handleBuyClick);
         this.asset.close.removeEventListener(MouseEvent.CLICK,this.handleCancelClick);
      }
      
      private function initBuy() : void
      {
         this.dispatchEvent(new Event(BUY));
         this.dispatchEvent(new Event(Event.CLOSE));
      }
      
      private function handleCancelClick(param1:Event) : void
      {
         this.removeHandlers();
         this.dispatchEvent(new Event(Event.CLOSE));
      }
      
      private function setState() : void
      {
         var _loc1_:* = null;
         var _loc2_:int = 0;
         if(this.buildingThis)
         {
            this.asset.buildIcon.alpha = 1;
            if(this.buildMinutesLeft > 60)
            {
               _loc2_ = int(this.buildMinutesLeft / 60);
               _loc1_ = region.getText(region.absoluteKey("building_room_time_1") + " " + this.roomName + " " + region.absoluteKey("building_room_time_2")) + " " + _loc2_.toString() + " " + (_loc2_ >= 2 ? region.absoluteKey("time_units") : region.absoluteKey("time_unit")) + ".";
            }
            else
            {
               _loc1_ = String(region.getText(region.absoluteKey("building_room_soon_1") + " " + this.roomName + " " + region.absoluteKey("building_room_soon_2")));
            }
            this.cancelBuy("buildingNotice",_loc1_);
         }
         else if(this.buildingAnother)
         {
            this.cancelBuy("buildingAnother",region.key("only_one_room_at_time"));
         }
         else if(!this.contiguous)
         {
            this.cancelBuy("buildingNotice",region.key("only_contiguous"));
         }
         else
         {
            this.asset.field.text = region.getText(region.absoluteKey("buy_question") + this.roomName + "?");
            this.asset.buy.text.text = region.key("room_buy");
            this.asset.buy.addEventListener(MouseEvent.CLICK,this.handleBuyClick);
         }
         this.asset.close.addEventListener(MouseEvent.CLICK,this.handleCancelClick);
      }
      
      private function init() : void
      {
         this.asset = new AcquiredHouseRoomConfirmationMC();
         addChild(this.asset);
         this.asset.price.text = this.price.toString();
         this.asset.time.text = region.key("build_delay") + " " + this.hours.toString() + " " + (this.hours >= 2 ? region.key("time_units") : region.key("time_unit"));
         this.asset.image.gotoAndStop(this.roomNum);
         this.asset.stop();
         this.setState();
      }
      
      private function handleBuyClick(param1:Event) : void
      {
         this.removeHandlers();
         this.validatePurchase();
      }
      
      private function cancelBuy(param1:String, param2:String) : void
      {
         this.asset.gotoAndStop(param1);
         this.asset.field.text = param2;
         this.asset.buy.visible = false;
         this.asset.close.addEventListener(MouseEvent.CLICK,this.handleCancelClick);
      }
      
      public function get roomPrice() : int
      {
         return this.price;
      }
      
      private function validatePurchase() : void
      {
         if(this.needPassport && !this.hasPassport)
         {
            this.cancelBuy("passportMissing",region.getText(region.absoluteKey("needs_passport") + this.roomName + "."));
         }
         else if(this.price > this.coins)
         {
            this.cancelBuy("moneyMissing",region.getText(region.absoluteKey("not_have_enough_money") + this.roomName + "."));
         }
         else
         {
            this.initBuy();
         }
      }
   }
}

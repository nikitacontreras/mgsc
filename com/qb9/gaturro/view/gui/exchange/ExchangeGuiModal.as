package com.qb9.gaturro.view.gui.exchange
{
   import assets.MedalMC;
   import com.qb9.flashlib.events.QEvent;
   import com.qb9.flashlib.utils.DisplayUtil;
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.manager.notificator.Notification;
   import com.qb9.gaturro.commons.manager.notificator.NotificationManager;
   import com.qb9.gaturro.globals.*;
   import com.qb9.gaturro.net.metrics.TrackActions;
   import com.qb9.gaturro.net.metrics.TrackCategories;
   import com.qb9.gaturro.notifier.GaturroNotificationType;
   import com.qb9.gaturro.user.inventory.InventoryUtil;
   import com.qb9.gaturro.view.gui.closet.ExchangeClosetGuiModal;
   import com.qb9.gaturro.view.gui.interaction.InteractionGuiModal;
   import com.qb9.gaturro.view.gui.util.GuiUtil;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.mambo.world.avatars.Avatar;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   
   public class ExchangeGuiModal extends InteractionGuiModal
   {
      
      public static const ACCEPT_EXCHANGE:String = "A";
      
      public static const OBJECT_SELECTED:String = "O";
       
      
      protected var lastSelectionItemMsg:String = "";
      
      protected var myItemName:String = "";
      
      private var closet:ExchangeClosetGuiModal;
      
      protected var myInventory:String;
      
      protected var numObjectOffered:Number = 0;
      
      protected var mateInventory:String;
      
      protected var myItemId:String;
      
      protected var mateItemName:String = "";
      
      protected var mateItemId:String;
      
      public function ExchangeGuiModal(param1:GaturroRoom, param2:String, param3:Function)
      {
         super(param1,param2,param3,"");
      }
      
      public function meAccept() : void
      {
         asset.myIcons.visible = true;
      }
      
      private function addToMyPreview(param1:DisplayObject) : void
      {
         if(canceled)
         {
            return;
         }
         asset.inventory.visible = false;
         asset.myIcons.visible = false;
         this.addItemToPanel(asset.avatar1,param1);
      }
      
      public function get acceptedByMate() : Boolean
      {
         return Boolean(asset.icons.visible) && asset.icons.currentFrame == 3;
      }
      
      private function sendExchangeRequest() : void
      {
         InventoryUtil.swapObjects(this.myItemId,this.myInventory,mateUsername,this.mateItemId,this.mateInventory);
         tracker.event(TrackCategories.MMO,TrackActions.EXCHANGE,"success");
         api.trackEvent("Comercio","Canje_entrega:" + this.myItemName);
         api.trackEvent("Comercio","Canje_recibe:" + this.mateItemName);
         this.dispatchEvent(new Event(CLOSE_OPERATION_EVENT));
      }
      
      public function mateAccept() : void
      {
         asset.icons.visible = true;
         asset.icons.gotoAndStop(3);
      }
      
      override public function rejection(param1:Boolean) : void
      {
         if(!asset)
         {
            return;
         }
         if(this.acceptedByMe && this.acceptedByMate)
         {
            return;
         }
         super.rejection(param1);
         asset.loadingAsset.visible = false;
         asset.field_reply.visible = true;
         asset.buttons.visible = false;
         asset.field_reply.text = region.key("cancel_exchange");
         asset.buttons.visible = false;
         asset.myIcons.visible = false;
         asset.icons.visible = true;
         asset.icons.gotoAndStop(2);
         asset.objectButton.removeEventListener(MouseEvent.CLICK,this._openInventoryItem);
         asset.myIcons.visible = true;
         asset.myIcons.signOk.visible = false;
         asset.inventory.visible = false;
         this.removePanel();
      }
      
      private function checkAcceptation(param1:String) : void
      {
         var _loc4_:NotificationManager = null;
         var _loc2_:Boolean = this.acceptedByMe;
         var _loc3_:Boolean = this.acceptedByMate;
         if(param1 == mateUsername)
         {
            this.mateAccept();
         }
         if(param1 == room.userAvatar.username)
         {
            this.meAccept();
         }
         if(this.acceptedByMate == this.acceptedByMe == true)
         {
            this.showAcceptation();
            if(_loc3_ && !_loc2_)
            {
               this.sendExchangeRequest();
            }
            (_loc4_ = Context.instance.getByType(NotificationManager) as NotificationManager).brodcast(new com.qb9.gaturro.commons.manager.notificator.Notification(GaturroNotificationType.EXCHANGED,{"item":this.myItemName}));
         }
      }
      
      private function removePanel() : void
      {
         if(asset.avatar1.objectPh.numChildren == 1)
         {
            asset.avatar1.objectPh.removeChildAt(0);
         }
         if(asset.avatar2.objectPh.numChildren == 1)
         {
            asset.avatar2.objectPh.removeChildAt(0);
         }
      }
      
      public function removeAcceptations(param1:String) : void
      {
         asset.myIcons.visible = false;
         asset.icons.visible = param1 == "";
      }
      
      private function checkIfTradingSanValentin() : void
      {
         var _loc1_:Object = null;
         if(this.myItemName.indexOf("cartaNarciso") != -1)
         {
            _loc1_ = api.getProfileAttribute("puntosSanValentin2019");
            if(_loc1_ == null)
            {
               _loc1_ = 0;
            }
            _loc1_ += 1;
            api.setProfileAttribute("puntosSanValentin2019",_loc1_);
         }
         if(this.myItemName.indexOf("ramoFloresNaranjas") != -1)
         {
            _loc1_ = api.getProfileAttribute("floresSanValentin2019");
            if(_loc1_ == null)
            {
               _loc1_ = 0;
            }
            _loc1_ += 1;
            api.setProfileAttribute("floresSanValentin2019",_loc1_);
         }
      }
      
      public function showMateItem(param1:String) : void
      {
         if(canceled)
         {
            return;
         }
         libs.fetch(param1,this.addToMatePreview);
      }
      
      private function addItemToPanel(param1:Object, param2:DisplayObject) : void
      {
         DisplayUtil.disableMouse(DisplayObject(param1));
         DisplayUtil.disableMouse(param1.objectPh);
         DisplayUtil.empty(DisplayObjectContainer(param1.objectPh));
         GuiUtil.fit(param2,100,80,25,20);
         param1.objectPh.addChild(param2);
         ++this.numObjectOffered;
         asset.buttons.field.text = "ESPERA...";
         asset.buttons.accept.visible = false;
         asset.buttons.cancel.visible = false;
         setTimeout(this.checkQuestionState,2000,this.numObjectOffered);
         asset.spending.visible = this.haveItems;
      }
      
      public function get acceptedByMe() : Boolean
      {
         return asset.myIcons.visible;
      }
      
      public function showMyItem(param1:String) : void
      {
         if(canceled)
         {
            return;
         }
         libs.fetch(param1,this.addToMyPreview);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(this.acceptedByMate == this.acceptedByMe == true)
         {
            api.levelManager.addSocialExp(25);
         }
         if(asset)
         {
            asset.close.removeEventListener(MouseEvent.CLICK,this._close);
            asset.cancel.removeEventListener(MouseEvent.CLICK,this._close);
            asset.objectButton.removeEventListener(MouseEvent.CLICK,this._openInventoryItem);
            asset.buttons.accept.removeEventListener(MouseEvent.CLICK,this._accept);
            asset.buttons.cancel.removeEventListener(MouseEvent.CLICK,this._close);
         }
         if(this.closet)
         {
            this.closet.removeEventListener(ExchangeClosetGuiModal.SELECT_ITEM,this.selectItem);
         }
      }
      
      override public function initInteraction(param1:String) : void
      {
         super.initInteraction(param1);
         if(this.lastSelectionItemMsg != "")
         {
            sendOperationFunc(ExchangeGuiModal.OBJECT_SELECTED,this.lastSelectionItemMsg);
         }
         asset.loadingAsset.visible = false;
         asset.field_reply.text = region.key("chosing_object");
         asset.icons.visible = true;
         asset.icons.gotoAndStop(1);
      }
      
      private function addToMatePreview(param1:DisplayObject) : void
      {
         if(canceled)
         {
            return;
         }
         asset.icons.visible = false;
         asset.field_reply.visible = false;
         this.addItemToPanel(asset.avatar2,param1);
      }
      
      private function receiveSelection(param1:String, param2:String, param3:String, param4:String) : void
      {
         if(param1 == mateUsername)
         {
            this.mateItemName = param2;
            this.mateItemId = param3;
            this.mateInventory = param4;
            this.showMateItem(this.mateItemName);
         }
         else
         {
            this.myItemName = param2;
            this.myItemId = param3;
            this.myInventory = param4;
            this.showMyItem(this.myItemName);
         }
         this.removeAcceptations(this.mateItemName);
      }
      
      private function checkQuestionState(param1:Number) : void
      {
         if(param1 != this.numObjectOffered)
         {
            return;
         }
         var _loc2_:Boolean = this.haveItems;
         asset.buttons.visible = _loc2_;
         asset.buttons.accept.visible = _loc2_;
         asset.buttons.cancel.visible = _loc2_;
         asset.buttons.field.text = region.key("accept_question");
         asset.spending.visible = false;
      }
      
      private function _openInventoryItem(param1:MouseEvent = null) : void
      {
         if(!this.acceptedByMe)
         {
            asset.inventory.visible = true;
         }
      }
      
      private function selectItem(param1:QEvent) : void
      {
         var _loc2_:String = String(param1.data.name);
         var _loc3_:String = String(param1.data.id);
         var _loc4_:String = InventoryUtil.getInventoryFromAttributes(param1.data.attributes).name;
         var _loc5_:String = mateUsername + ";" + _loc3_ + ";" + _loc2_ + ";" + _loc4_;
         sendOperationFunc(ExchangeGuiModal.OBJECT_SELECTED,_loc5_);
         this.lastSelectionItemMsg = _loc5_;
      }
      
      override public function executeOperation(param1:String, param2:Avatar, param3:Avatar, param4:Array) : void
      {
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         switch(param1)
         {
            case ExchangeGuiModal.OBJECT_SELECTED:
               _loc5_ = String(param4[0]);
               _loc6_ = String(param4[1]);
               _loc7_ = String(param4[2]);
               this.receiveSelection(param2.username,_loc6_,_loc5_,_loc7_);
               break;
            case ExchangeGuiModal.ACCEPT_EXCHANGE:
               this.checkAcceptation(param2.username);
         }
      }
      
      private function _accept(param1:MouseEvent) : void
      {
         asset.buttons.field.text = region.key("accept_exchange_spending");
         asset.buttons.accept.visible = true;
         asset.buttons.cancel.visible = true;
         asset.buttons.accept.visible = false;
         asset.buttons.cancel.visible = false;
         sendOperationFunc(ExchangeGuiModal.ACCEPT_EXCHANGE,mateUsername);
      }
      
      public function showAcceptation() : void
      {
         asset.buttons.field.text = region.key("exchange_success");
         asset.buttons.accept.visible = false;
         asset.buttons.cancel.visible = false;
         asset.cancel.visible = true;
         asset.cancel.text.text = region.key("exchange_close");
         this.checkIfTradingSanValentin();
      }
      
      private function get haveItems() : Boolean
      {
         return asset.avatar1.objectPh.numChildren == 1 && asset.avatar2.objectPh.numChildren == 1;
      }
      
      override public function busy() : void
      {
         this.rejection(false);
         asset.field_reply.text = region.key("busy");
      }
      
      override protected function initPopup() : void
      {
         super.initPopup();
         api.setAvatarAttribute("action","showObjectUp.interacciones.intercambio");
         asset = new ExchangeMC();
         asset.objectButton.counter.visible = false;
         asset.avatar1.visible = false;
         asset.avatar2.visible = false;
         asset.cancel.visible = false;
         asset.buttons.visible = false;
         asset.myIcons.visible = false;
         asset.icons.gotoAndStop(1);
         region.setText(asset.buttons.accept.text,"SI");
         region.setText(asset.buttons.cancel.text,"NO");
         asset.close.addEventListener(MouseEvent.CLICK,this._close);
         asset.cancel.addEventListener(MouseEvent.CLICK,this._close);
         asset.objectButton.addEventListener(MouseEvent.CLICK,this._openInventoryItem);
         asset.buttons.accept.addEventListener(MouseEvent.CLICK,this._accept);
         asset.buttons.cancel.addEventListener(MouseEvent.CLICK,this._close);
         this.closet = new ExchangeClosetGuiModal(room);
         asset.inventory.ph.addChild(this.closet);
         asset.inventory.ph.scaleX = asset.inventory.ph.scaleY = asset.inventory.ph.scaleY * 0.68;
         asset.inventory.ph.x += 170;
         asset.inventory.ph.y += 50;
         this.addChild(asset);
         this.closet.addEventListener(ExchangeClosetGuiModal.SELECT_ITEM,this.selectItem);
         asset.spending.visible = false;
      }
      
      override public function saveAvatars(param1:Avatar, param2:Avatar) : void
      {
         var _loc3_:MovieClip = null;
         super.saveAvatars(param1,param2);
         if(param2.attributes.passportType)
         {
            if(param2.attributes.passportType != "none")
            {
               _loc3_ = new MedalMC();
               asset.medalPh2.addChild(_loc3_);
               if(param2.attributes.passportType == "boca")
               {
                  _loc3_.gotoAndStop(2);
               }
            }
         }
      }
   }
}

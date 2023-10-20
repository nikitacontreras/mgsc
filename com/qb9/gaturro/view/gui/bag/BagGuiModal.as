package com.qb9.gaturro.view.gui.bag
{
   import assets.InventoryBagTabsMC;
   import com.qb9.gaturro.external.roomObjects.GaturroSceneObjectAPI;
   import com.qb9.gaturro.globals.*;
   import com.qb9.gaturro.net.metrics.TrackActions;
   import com.qb9.gaturro.net.metrics.TrackCategories;
   import com.qb9.gaturro.user.inventory.ConsumableInventorySceneObject;
   import com.qb9.gaturro.user.inventory.GaturroInventory;
   import com.qb9.gaturro.user.inventory.PetCareSceneObject;
   import com.qb9.gaturro.user.inventory.PetFoodSceneObject;
   import com.qb9.gaturro.user.inventory.PetInventorySceneObject;
   import com.qb9.gaturro.user.inventory.PetToySceneObject;
   import com.qb9.gaturro.user.inventory.UsableInventorySceneObject;
   import com.qb9.gaturro.view.gui.base.inventory.BaseInventoryTabsModal;
   import com.qb9.gaturro.view.gui.base.inventory.HouseInventoryWidget;
   import com.qb9.gaturro.view.gui.base.inventory.InventoryWidgetEvent;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.mambo.core.attributes.CustomAttributes;
   import com.qb9.mambo.user.inventory.InventorySceneObject;
   import com.qb9.mambo.user.inventory.events.InventoryEvent;
   import config.AttributeControl;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.setTimeout;
   
   public class BagGuiModal extends BaseInventoryTabsModal
   {
      
      protected static const ROWS:uint = 7;
      
      protected static const COLS:uint = 9;
       
      
      protected const CATEGORY_CARDS:int = 4;
      
      protected const CATEGORY_USABLE:int = 2;
      
      private var room:GaturroRoom;
      
      private var cardsState:int = 0;
      
      protected const CATEGORY_OTHER:int = 1;
      
      protected const CATEGORY_COLECCIONES:int = 3;
      
      private var cardsTab:MovieClip;
      
      public function BagGuiModal(param1:GaturroRoom)
      {
         var _loc2_:Array = this.getWidgets();
         super(_loc2_,new InventoryBagTabsMC());
         this.room = param1;
         this.initModal();
      }
      
      private function onHelpClicked(param1:Event) : void
      {
         api.showBannerModal("cardsTutorial",new GaturroSceneObjectAPI(null,new Sprite(),api.room));
      }
      
      private function initEvents() : void
      {
         this.inventory.addEventListener(InventoryEvent.ITEM_ADDED,this.updateItems);
         this.inventory.addEventListener(InventoryEvent.ITEM_REMOVED,this.updateItems);
         var _loc1_:int = 0;
         while(_loc1_ < widgets.length)
         {
            widgets[_loc1_].addEventListener(InventoryWidgetEvent.SELECTED,this.whenItemIsSelected);
            _loc1_++;
         }
      }
      
      private function whenItemIsSelected(param1:InventoryWidgetEvent) : void
      {
         var _loc6_:ConsumableInventorySceneObject = null;
         var _loc7_:String = null;
         var _loc2_:InventorySceneObject = param1.item as InventorySceneObject;
         var _loc3_:Number = _loc2_.id;
         if(_loc2_.name.indexOf("mundial2018/album.card") != -1)
         {
            api.setAvatarAttribute("action","showObjectUp." + _loc2_.name);
            api.trackEvent("FEATURES:MUNDIAL2018:CARTAS:MUESTRA:",_loc2_.name);
            setTimeout(close,10);
            return;
         }
         if(_loc2_.name.indexOf("halloween2018/album.card") != -1)
         {
            api.setAvatarAttribute("action","showObjectUp." + _loc2_.name);
            api.trackEvent("FEATURES:HALLOWEEN_2018:CARTAS:MUESTRA:",_loc2_.name);
            setTimeout(close,10);
            return;
         }
         if(_loc2_ is UsableInventorySceneObject === false)
         {
            return;
         }
         var _loc4_:UsableInventorySceneObject;
         var _loc5_:Object = (_loc4_ = UsableInventorySceneObject(_loc2_)).providedAttributes;
         if("action" in _loc5_ && AttributeControl.isProhibitedInAction(_loc5_.action))
         {
            return;
         }
         this.room.userAvatar.attributes.mergeObject(_loc5_,true);
         if(_loc2_ is ConsumableInventorySceneObject)
         {
            if((_loc6_ = _loc2_ as ConsumableInventorySceneObject).uses < 1000000)
            {
               if(_loc6_.uses === 1)
               {
                  this.inventory.remove(_loc3_);
               }
               else
               {
                  --_loc6_.uses;
               }
            }
            _loc7_ = !!_loc6_.name ? _loc6_.name : "";
            tracker.event(TrackCategories.MMO,TrackActions.SET_CONSUMABLE,_loc7_);
         }
         setTimeout(close,10);
      }
      
      private function setupCardsTab(param1:MovieClip) : void
      {
         var pts:* = undefined;
         var txt:* = undefined;
         var mc:MovieClip = param1;
         with(mc)
         {
            if(!api.cardsManager.isLoaded)
            {
               title.text = api.getText("CARTAS");
               field.text = api.getText("SIN SERVICIO");
               btn.visible = false;
            }
            else if(!api.cardsManager.cards || api.cardsManager.cards.length < 1)
            {
               title.text = api.getText("NO TIENES CARTAS");
               field.text = api.getText("NO TIENES CARTAS PARA JUGAR CON TUS AMIGOS. VE A VER AL CAPITÁN ESTUPENDO, EL TE DARÁ LAS CARTAS PARA JUGAR.");
               cardsState = 1;
               btn.field.text = api.getText("CONSEGUIR");
            }
            else if(!api.cardsManager.decks || api.cardsManager.decks.length < 1)
            {
               title.text = api.getText("NO TIENES MAZOS");
               field.text = api.getText("PARA PODER JUGAR A LAS CARTAS DEBES TENER HECHO POR LO MENOS UN MAZO.");
               cardsState = 2;
               btn.field.text = api.getText("CREAR UN MAZO");
            }
            else if(!api.cardsManager.activeDeck)
            {
               title.text = api.getText("NO TIENES MAZO");
               field.text = api.getText("PARA PODER JUGAR A LAS CARTAS DEBES TENER UN MAZO ASIGNADO COMO MAZO DE BATALLA");
               cardsState = 2;
               btn.field.text = api.getText("ELEGIR UN MAZO");
            }
            else if(api.getProfileAttribute("upgradeCardPoints") > 0)
            {
               title.text = api.getText("PUNTOS DE MEJORA");
               pts = api.getProfileAttribute("upgradeCardPoints");
               if(pts == 1)
               {
                  field.text = api.getText("TIENES 1 PUNTO DE MEJORA PARA ASIGNAR A UNA DE TUS CARTAS");
               }
               else
               {
                  txt = api.getText("TIENES {puntos} PUNTOS DE MEJORA PARA ASIGNAR A UNA DE TUS CARTAS");
                  txt = txt.replace("{puntos}",pts.toString());
                  field.text = txt;
               }
               cardsState = 3;
               btn.field.text = api.getText("ASIGNAR PUNTOS");
            }
            else
            {
               title.text = api.getText("TUS MAZOS");
               field.text = api.getText("TIENES {mazos} MAZO/S Y {cartas} CARTAS");
               field.text = (field as TextField).text.replace("{mazos}",api.cardsManager.decks.length).replace("{cartas}",api.cardsManager.cards.length);
               cardsState = 2;
               btn.field.text = api.getText("EDITAR");
            }
            btn.addEventListener(MouseEvent.CLICK,clicked);
            help.addEventListener(MouseEvent.CLICK,onHelpClicked);
            help.buttonMode = true;
            help.mouseChildren = false;
         }
      }
      
      protected function get allItems() : Array
      {
         return this.inventory.itemsGrouped;
      }
      
      private function initCardsTab() : void
      {
         this.cardsTab = new cardsTabMC();
         this.widgets[this.widgets.length - 1].addChild(this.cardsTab);
         this.setupCardsTab(this.cardsTab);
      }
      
      private function get inventory() : GaturroInventory
      {
         return user.bag;
      }
      
      override protected function get openSound() : String
      {
         return "mochi1";
      }
      
      override public function dispose() : void
      {
         this.inventory.removeEventListener(InventoryEvent.ITEM_ADDED,this.updateItems);
         this.inventory.removeEventListener(InventoryEvent.ITEM_REMOVED,this.updateItems);
         this.disposeCardsTab(this.cardsTab);
         var _loc1_:int = 0;
         while(_loc1_ < widgets.length)
         {
            widgets[_loc1_].removeEventListener(InventoryWidgetEvent.SELECTED,this.whenItemIsSelected);
            _loc1_++;
         }
         this.room = null;
         super.dispose();
      }
      
      private function clicked(param1:Event) : void
      {
         switch(this.cardsState)
         {
            case 1:
               api.changeRoomXY(47717,7,7);
               break;
            case 2:
               api.showBannerModal("decks",null);
               break;
            case 3:
               api.showBannerModal("cardsUpg",null);
         }
      }
      
      private function shouldAppear(param1:Object) : Boolean
      {
         if(!param1.name)
         {
            return false;
         }
         if(param1 is PetInventorySceneObject)
         {
            return false;
         }
         if(param1 is PetFoodSceneObject)
         {
            return false;
         }
         if(param1 is PetCareSceneObject)
         {
            return false;
         }
         if(param1 is PetToySceneObject)
         {
            return false;
         }
         if(param1.name == "")
         {
            return false;
         }
         if(param1.name.substr(0,11) == "privateRoom")
         {
            return false;
         }
         if(param1.name.substr(0,7) == "penguin")
         {
            return false;
         }
         return true;
      }
      
      private function disposeCardsTab(param1:MovieClip) : void
      {
         var mc:MovieClip = param1;
         if(mc)
         {
            with(mc)
            {
               
               btn.removeEventListener(MouseEvent.CLICK,clicked);
               help.removeEventListener(MouseEvent.CLICK,onHelpClicked);
            }
         }
      }
      
      protected function getCategory(param1:Object) : int
      {
         var _loc2_:CustomAttributes = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         if(!this.shouldAppear(param1[0]))
         {
            return -1;
         }
         if(param1[0]["attributes"])
         {
            _loc2_ = CustomAttributes(param1[0]["attributes"]);
            for each(_loc3_ in settings.collectibles)
            {
               if(param1[0].name.indexOf(_loc3_) >= 0)
               {
                  return this.CATEGORY_COLECCIONES;
               }
            }
            for(_loc4_ in _loc2_)
            {
               if(_loc4_ == "session" && Boolean(param1[0]["attributes"][_loc4_]))
               {
                  return this.CATEGORY_OTHER;
               }
               if(_loc4_ == "questItem")
               {
                  return this.CATEGORY_OTHER;
               }
               if(_loc4_.substr(0,4) == "attr")
               {
                  return this.CATEGORY_USABLE;
               }
               if((param1[0].name as String).indexOf("mundial2018/album.") > -1)
               {
                  return this.CATEGORY_CARDS;
               }
               if((param1[0].name as String).indexOf("halloween2018/album.") > -1)
               {
                  return this.CATEGORY_CARDS;
               }
               if((param1[0].name as String).indexOf("navidad2018/album.") > -1)
               {
                  return this.CATEGORY_CARDS;
               }
            }
         }
         return this.CATEGORY_OTHER;
      }
      
      protected function updateItems(param1:Event = null) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         for each(_loc2_ in this.widgets)
         {
            HouseInventoryWidget(_loc2_).elements = new Array();
         }
         _loc3_ = new Array();
         _loc4_ = 0;
         while(_loc4_ < this.widgets.length)
         {
            _loc3_.push(new Array());
            _loc4_++;
         }
         for each(_loc5_ in this.allItems)
         {
            if((_loc7_ = this.getCategory(_loc5_)) != -1)
            {
               _loc3_[_loc7_ - 1].push(_loc5_);
            }
         }
         _loc6_ = 0;
         while(_loc6_ < _loc3_.length)
         {
            HouseInventoryWidget(this.widgets[_loc6_]).elements = _loc3_[_loc6_];
            _loc6_++;
         }
      }
      
      protected function getWidgets() : Array
      {
         var _loc1_:Array = null;
         return [new HouseInventoryWidget(COLS,ROWS,true,null,{"cat":this.CATEGORY_OTHER}),new HouseInventoryWidget(COLS,ROWS,true,null,{"cat":this.CATEGORY_USABLE}),new HouseInventoryWidget(COLS,ROWS,true,null,{"cat":this.CATEGORY_COLECCIONES}),new HouseInventoryWidget(COLS,ROWS,true,null,{"cat":this.CATEGORY_CARDS})];
      }
      
      protected function initModal() : void
      {
         this.updateItems();
         this.initEvents();
         this.selectTab(2);
      }
      
      override protected function get closeSound() : String
      {
         return "";
      }
   }
}

package com.qb9.gaturro.view.components.banner.gift
{
   import com.qb9.gaturro.commons.view.component.canvas.switcher.FrameCanvasSwitcher;
   import com.qb9.gaturro.external.roomObjects.GaturroSceneObjectAPI;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.view.gui.banner.properties.IHasSceneAPI;
   import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
   import com.qb9.gaturro.view.gui.catalog.utils.CatalogUtils;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   
   public class GiftBanner extends InstantiableGuiModal implements IHasSceneAPI
   {
      
      public static const EXPLANATION:String = "EXPLANATION";
      
      public static const NOTIFICATION_KEY:String = "darRegaloDeReyes";
      
      public static const ITEM_SELECTOR:String = "ITEM_SELECTOR";
      
      public static const CARD_SHOWCASE:String = "CARD_SHOWCASE";
      
      public static const USER_GIFT_COUNTER_ATTR:String = "giftCounterReyes";
       
      
      private var closeBtn:SimpleButton;
      
      private var _sceneAPI:GaturroSceneObjectAPI;
      
      private var canvasSwitcher:FrameCanvasSwitcher;
      
      public function GiftBanner()
      {
         super("GiftBanner","GiftBannerAsset");
      }
      
      public function toSelector() : void
      {
         this.canvasSwitcher.switchCanvas(ITEM_SELECTOR);
      }
      
      public function start() : void
      {
         this.canvasSwitcher.switchCanvas(ITEM_SELECTOR);
      }
      
      override protected function ready() : void
      {
         super.ready();
         this.setupCanvas();
      }
      
      override public function dispose() : void
      {
         this.canvasSwitcher.dispose();
         this.canvasSwitcher = null;
         super.dispose();
      }
      
      public function toShowcase(param1:String) : void
      {
         this.canvasSwitcher.switchCanvas(CARD_SHOWCASE,param1);
         var _loc2_:int = 0;
         _loc2_ = int(CatalogUtils.getCoins("reyes"));
         CatalogUtils.giveCoins("reyes",1);
      }
      
      public function offerGift(param1:String) : void
      {
         var _loc2_:String = this._sceneAPI.getAttribute("materials") as String;
         var _loc3_:Object = api.JSONDecode(_loc2_) || {};
         _loc3_.ready = param1;
         _loc3_.gifter = api.user.username;
         this._sceneAPI.setAttributePersist("materials",api.JSONEncode(_loc3_));
         api.takeFromUser(param1,1);
         close();
      }
      
      private function setupCanvas() : void
      {
         var _loc1_:MovieClip = view.getChildByName("canvasContainer") as MovieClip;
         this.canvasSwitcher = new FrameCanvasSwitcher(_loc1_);
         this.canvasSwitcher.addCanvas(new ElementSelectorCanvas(ITEM_SELECTOR,"selector",_loc1_,this));
         this.canvasSwitcher.addCanvas(new CardShowcaseCanvas(CARD_SHOWCASE,"showcase",_loc1_,this));
         this.canvasSwitcher.addCanvas(new ExplanationCanvas(EXPLANATION,"explanation",_loc1_,this));
         this.canvasSwitcher.switchCanvas(EXPLANATION);
      }
      
      public function set sceneAPI(param1:GaturroSceneObjectAPI) : void
      {
         this._sceneAPI = param1;
      }
   }
}

import com.qb9.flashlib.utils.ObjectUtil;
import com.qb9.gaturro.commons.event.ItemRendererEvent;
import com.qb9.gaturro.commons.paginator.PaginatorFactory;
import com.qb9.gaturro.globals.api;
import com.qb9.gaturro.globals.user;
import com.qb9.gaturro.user.inventory.GaturroInventorySceneObject;
import com.qb9.gaturro.user.inventory.InventoryUtil;
import com.qb9.gaturro.view.components.banner.gift.GiftBanner;
import com.qb9.gaturro.view.components.canvas.FrameCanvas;
import com.qb9.gaturro.view.components.repeater.NavegableRepeater;
import com.qb9.gaturro.view.components.repeater.Repeater;
import com.qb9.gaturro.view.components.repeater.config.NavegableRepeaterConfig;
import com.qb9.gaturro.view.gui.base.inventory.repeater.inventory.InventoryWidgetItemRendererFactory;
import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
import com.qb9.gaturro.world.core.GaturroRoom;
import com.qb9.gaturro.world.core.avatar.ownednpc.OwnedNpcFactory;
import com.qb9.gaturro.world.core.elements.NpcRoomSceneObject;
import com.qb9.gaturro.world.tiling.MovingHomeObjects;
import com.qb9.mambo.world.avatars.Avatar;
import com.qb9.mambo.world.core.RoomSceneObject;
import com.qb9.mambo.world.elements.MovingRoomSceneObject;
import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;

class ElementSelectorCanvas extends FrameCanvas
{
   
   private static const REPEATER_CONTAINER_NAME:String = "repeaterContainer";
   
   private static const MENU_CONTAINER_NAME:String = "menuContainer";
    
   
   private var items:Array;
   
   private var repeater:NavegableRepeater;
   
   private var selectedItem:String;
   
   private var menuContainer:Sprite;
   
   private var repeaterSetContainer:DisplayObjectContainer;
   
   private var acceptBtn:Sprite;
   
   public function ElementSelectorCanvas(param1:String, param2:String, param3:DisplayObjectContainer, param4:InstantiableGuiModal)
   {
      super(param1,param2,param3,param4);
      this.items = this.setupItemList();
   }
   
   protected function get inventoryItems() : Array
   {
      return InventoryUtil.removeQuestItems(user.allItemsGrouped);
   }
   
   private function onItemSelected(param1:ItemRendererEvent) : void
   {
      trace("ElementSelectorCanvas > onItemSelected > e.itemRenderer.data = [" + param1.itemRenderer.data + "]");
      var _loc2_:Array = param1.itemRenderer.data as Array;
      var _loc3_:GaturroInventorySceneObject = _loc2_[0];
      trace("ElementSelectorCanvas > onItemSelected > item.name = [" + _loc3_.name + "]");
      this.selectedItem = _loc3_.name;
      this.evalButtonEnable();
   }
   
   private function isGrabbableRoomObject(param1:RoomSceneObject) : Boolean
   {
      if(!param1)
      {
         return false;
      }
      return (param1 is NpcRoomSceneObject && !(param1 is Avatar) || !(param1 is MovingRoomSceneObject)) && param1.name.indexOf(MovingHomeObjects.PRIVATE_PACKAGE) !== 0;
   }
   
   private function evalButtonEnable() : void
   {
      this.acceptBtn.mouseEnabled = Boolean(this.selectedItem);
   }
   
   private function setupButton() : void
   {
      this.acceptBtn = view.getChildByName("acceptBtn") as Sprite;
      this.acceptBtn.addEventListener(MouseEvent.CLICK,this.onClick);
      var _loc1_:TextField = this.acceptBtn.getChildByName("field") as TextField;
      _loc1_.text = api.getText("¡BUENO!");
      this.acceptBtn.mouseChildren = false;
      this.evalButtonEnable();
   }
   
   protected function getRepeaterConfig() : NavegableRepeaterConfig
   {
      var _loc1_:NavegableRepeaterConfig = new NavegableRepeaterConfig(PaginatorFactory.SIMPLE_TYPE,this.items,this.repeaterSetContainer as MovieClip,this.menuContainer as MovieClip,32);
      _loc1_.itemRendererFactory = new InventoryWidgetItemRendererFactory();
      _loc1_.columns = 8;
      _loc1_.selectable = Repeater.SINGLE_SELECTABLE;
      return _loc1_;
   }
   
   private function get roomItems() : Array
   {
      var _loc4_:RoomSceneObject = null;
      var _loc1_:Object = {};
      var _loc2_:int = 0;
      var _loc3_:GaturroRoom = api.room;
      for each(_loc4_ in _loc3_.sceneObjects)
      {
         if(this.isGrabbableRoomObject(_loc4_) !== false)
         {
            if(OwnedNpcFactory.isOwnedNpcItem(_loc4_))
            {
               _loc1_[_loc4_.name + "_" + _loc2_.toString()] = [_loc4_];
            }
            else if(_loc4_.name in _loc1_)
            {
               _loc1_[_loc4_.name].push(_loc4_);
            }
            else
            {
               _loc1_[_loc4_.name] = [_loc4_];
            }
            _loc2_++;
         }
      }
      return ObjectUtil.values(_loc1_);
   }
   
   override protected function setupShowView() : void
   {
      this.repeaterSetContainer = view.getChildByName(REPEATER_CONTAINER_NAME) as DisplayObjectContainer;
      this.menuContainer = view.getChildByName(MENU_CONTAINER_NAME) as Sprite;
      this.setupButton();
      this.setupRepeater();
   }
   
   private function onClick(param1:MouseEvent) : void
   {
      GiftBanner(owner).toShowcase(this.selectedItem);
   }
   
   private function setupRepeater() : void
   {
      var _loc1_:NavegableRepeaterConfig = this.getRepeaterConfig();
      this.repeater = new NavegableRepeater(_loc1_);
      this.repeater.init();
      this.repeater.repeaterFacade.repeater.addEventListener(ItemRendererEvent.ITEM_SELECTED,this.onItemSelected);
   }
   
   private function setupItemList() : Array
   {
      var _loc1_:Array = new Array();
      _loc1_ = _loc1_.concat(api.user.house.itemsStacked);
      return _loc1_.concat(api.user.visualizer.itemsStacked);
   }
   
   override public function dispose() : void
   {
      if(this.acceptBtn)
      {
         this.acceptBtn.removeEventListener(MouseEvent.CLICK,this.onClick);
      }
      super.dispose();
   }
}

import com.qb9.gaturro.globals.api;
import com.qb9.gaturro.view.components.banner.gift.GiftBanner;
import com.qb9.gaturro.view.components.canvas.FrameCanvas;
import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;

class ExplanationCanvas extends FrameCanvas
{
    
   
   private var acceptBtn:Sprite;
   
   private var retrytBtn:Sprite;
   
   public function ExplanationCanvas(param1:String, param2:String, param3:DisplayObjectContainer, param4:InstantiableGuiModal)
   {
      super(param1,param2,param3,param4);
   }
   
   private function onClickAccept(param1:MouseEvent) : void
   {
      GiftBanner(owner).start();
   }
   
   private function setupButton() : void
   {
      this.acceptBtn = view.getChildByName("acceptBtn") as Sprite;
      this.acceptBtn.addEventListener(MouseEvent.CLICK,this.onClickAccept);
      var _loc1_:TextField = this.acceptBtn.getChildByName("field") as TextField;
      _loc1_.text = api.getText("LISTO");
   }
   
   override public function dispose() : void
   {
      if(this.acceptBtn)
      {
         this.acceptBtn.removeEventListener(MouseEvent.CLICK,this.onClickAccept);
      }
      super.dispose();
   }
   
   override protected function setupShowView() : void
   {
      this.setupButton();
   }
}

import com.qb9.gaturro.globals.api;
import com.qb9.gaturro.view.components.banner.gift.GiftBanner;
import com.qb9.gaturro.view.components.canvas.FrameCanvas;
import com.qb9.gaturro.view.gui.base.modal.InstantiableGuiModal;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.text.TextField;

class CardShowcaseCanvas extends FrameCanvas
{
   
   private static const REPEATER_SET_CONTAINER_NAME:String = "elementContainer";
   
   private static const REPEATER_CONTAINER_PREFIX:String = "itemContainer";
    
   
   private var itemContainer:Sprite;
   
   private var retrytBtn:Sprite;
   
   private var sizeRef:Sprite;
   
   private var acceptBtn:Sprite;
   
   private var selectedItem:String;
   
   public function CardShowcaseCanvas(param1:String, param2:String, param3:DisplayObjectContainer, param4:InstantiableGuiModal)
   {
      super(param1,param2,param3,param4);
   }
   
   override public function dispose() : void
   {
      if(this.acceptBtn)
      {
         this.acceptBtn.removeEventListener(MouseEvent.CLICK,this.onClickAccept);
      }
      if(this.retrytBtn)
      {
         this.retrytBtn.addEventListener(MouseEvent.CLICK,this.onClickRetry);
      }
      super.dispose();
   }
   
   private function onClickRetry(param1:MouseEvent) : void
   {
      GiftBanner(owner).toSelector();
   }
   
   private function seupButtonAccept() : void
   {
      this.acceptBtn = view.getChildByName("acceptBtn") as Sprite;
      this.acceptBtn.addEventListener(MouseEvent.CLICK,this.onClickAccept);
      var _loc1_:TextField = this.acceptBtn.getChildByName("field") as TextField;
      _loc1_.text = api.getText("LISTO");
   }
   
   private function setupSizeRef() : void
   {
      this.sizeRef = view.getChildByName("sizeRef") as Sprite;
      this.sizeRef.visible = false;
   }
   
   private function setupButton() : void
   {
      this.setupSizeRef();
      this.setupImage();
      this.seupButtonAccept();
      this.setupButtonRetry();
   }
   
   private function onClickAccept(param1:MouseEvent) : void
   {
      GiftBanner(owner).offerGift(this.selectedItem);
      api.showModal("GANASTE 1 CORONITA","reyes2018/props.coronitasAward");
   }
   
   protected function onFetchCompleted(param1:DisplayObject) : void
   {
      this.itemContainer.addChild(param1);
      this.itemContainer.height = this.sizeRef.height;
      this.itemContainer.scaleX = this.itemContainer.scaleY;
      var _loc2_:Rectangle = this.sizeRef.getBounds(view);
      var _loc3_:Rectangle = this.itemContainer.getBounds(view);
      var _loc4_:Number = _loc2_.top - _loc3_.top;
      this.itemContainer.y += _loc4_;
   }
   
   private function setupButtonRetry() : void
   {
      this.retrytBtn = view.getChildByName("retrytBtn") as Sprite;
      this.retrytBtn.addEventListener(MouseEvent.CLICK,this.onClickRetry);
      var _loc1_:TextField = this.retrytBtn.getChildByName("field") as TextField;
      _loc1_.text = api.getText("VOLVER");
   }
   
   override public function show(param1:Object = null) : void
   {
      this.selectedItem = param1.toString();
      super.show(param1);
   }
   
   private function setupImage() : void
   {
      this.itemContainer = view.getChildByName(REPEATER_CONTAINER_PREFIX) as Sprite;
      api.libraries.fetch(this.selectedItem,this.onFetchCompleted);
   }
   
   override protected function setupShowView() : void
   {
      this.setupButton();
   }
}

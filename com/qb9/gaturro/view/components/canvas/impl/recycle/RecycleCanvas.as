package com.qb9.gaturro.view.components.canvas.impl.recycle
{
   import com.qb9.gaturro.commons.event.ItemRendererEvent;
   import com.qb9.gaturro.commons.event.PaginatorEvent;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.user.inventory.GaturroInventorySceneObject;
   import com.qb9.gaturro.view.components.banner.recicle.RecycleBanner;
   import com.qb9.gaturro.view.components.canvas.FrameCanvas;
   import com.qb9.gaturro.view.gui.base.inventory.repeater.inventory.InventoryWidgetItemRenderer;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.core.avatar.ownednpc.OwnedNpcFactory;
   import com.qb9.gaturro.world.core.elements.OwnedNpcRoomSceneObject;
   import com.qb9.mambo.core.objects.SceneObject;
   import com.qb9.mambo.world.core.RoomSceneObject;
   import flash.display.*;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.Dictionary;
   
   public class RecycleCanvas extends FrameCanvas
   {
      
      private static const ROWS:uint = 2;
      
      private static const COLS:uint = 10;
       
      
      private const CATEGORY_HEAD:int = 0;
      
      private var contentHolder:Sprite;
      
      private var minRequirement:int;
      
      private const CATEGORY_WALL_FLOOR:int = 7;
      
      private const SELECTED:String = "selected";
      
      private const CATEGORY_ACCESORIOS:int = 2;
      
      private const CATEGORY_ZAPATOS:int = 3;
      
      private var holder:MovieClip;
      
      private var widgets:Array;
      
      private const UNSELECTED:String = "unselected";
      
      private const CATEGORY_OBJECTS:int = 6;
      
      private const CATEGORY_TRANSPORTES:int = 4;
      
      private const CATEGORY_CUERPO:int = 1;
      
      private var items:Array;
      
      private var countTF:TextField;
      
      private const CATEGORY_OWNEDNPC:int = 5;
      
      private var recycleBtn:MovieClip;
      
      private var room:GaturroRoom;
      
      private var selectedItemCount:int = 0;
      
      private var selectedItems:Dictionary;
      
      private var wraps:Array;
      
      private var tabs:MovieClip;
      
      public function RecycleCanvas(param1:String, param2:String, param3:DisplayObjectContainer, param4:RecycleBanner, param5:int)
      {
         super(param1,param2,param3,param4);
         this.minRequirement = param5;
         this.setup();
      }
      
      private function setup() : void
      {
         var _loc1_:RecycleWidget = null;
         this.room = api.room;
         this.widgets = [new RecycleWidget(COLS,ROWS,true,this.isOnRoom,{"cat":this.CATEGORY_HEAD}),new RecycleWidget(COLS,ROWS,true,this.isOnRoom,{"cat":this.CATEGORY_CUERPO}),new RecycleWidget(COLS,ROWS,true,this.isOnRoom,{"cat":this.CATEGORY_ACCESORIOS}),new RecycleWidget(COLS,ROWS,true,this.isOnRoom,{"cat":this.CATEGORY_ZAPATOS}),new RecycleWidget(COLS,ROWS,true,this.isOnRoom,{"cat":this.CATEGORY_TRANSPORTES}),new RecycleWidget(COLS,ROWS,true,this.isOnRoom,{"cat":this.CATEGORY_OWNEDNPC}),new RecycleWidget(COLS,ROWS,true,this.isOnRoom,{"cat":this.CATEGORY_OBJECTS}),new RecycleWidget(COLS,ROWS,true,this.isOnRoom,{"cat":this.CATEGORY_WALL_FLOOR})];
         this.selectedItems = new Dictionary();
         for each(_loc1_ in this.widgets)
         {
            _loc1_.addEventListener(ItemRendererEvent.ITEM_SELECTED,this.onItemSelected);
            _loc1_.addEventListener(ItemRendererEvent.ITEM_DESELECTED,this.onItemDeselected);
            _loc1_.addEventListener(PaginatorEvent.PAGE_CHANGED,this.onPageChanged,true);
         }
      }
      
      private function setupContentHolder(param1:DisplayObjectContainer) : void
      {
         this.contentHolder = param1.getChildByName("holder") as Sprite;
      }
      
      private function clickOnTab(param1:MouseEvent) : void
      {
         var _loc2_:String = DisplayObject(param1.currentTarget).name;
         var _loc3_:Array = _loc2_.split("tab");
         var _loc4_:int = int(_loc3_[1]);
         this.selectTab(_loc4_);
      }
      
      private function setupButton() : void
      {
         this.recycleBtn = view.getChildByName("recycleBtn") as MovieClip;
         this.recycleBtn.addEventListener(MouseEvent.CLICK,this.onClickRecycle);
         this.recycleBtn.mouseChildren = false;
         this.recycleBtn.buttonMode = true;
         this.changeButtonState(false);
      }
      
      private function init(param1:Sprite, param2:Sprite) : void
      {
         param2.addChild(param1);
      }
      
      private function recycle() : void
      {
         var _loc1_:String = null;
         for each(_loc1_ in this.selectedItems)
         {
            api.trackEvent("FEATURE:RECYCLE:BANNER:ITEM",_loc1_);
            api.takeFromUser(_loc1_,1);
         }
      }
      
      private function isWall(param1:Object) : Boolean
      {
         var _loc2_:String = null;
         if(param1.name)
         {
            _loc2_ = String(param1.name);
            if(_loc2_.indexOf("privateHomeWalls") > -1 || _loc2_.indexOf("privateHomeSkys") > -1)
            {
               return true;
            }
         }
         return false;
      }
      
      private function isFloor(param1:Object) : Boolean
      {
         var _loc2_:String = null;
         if(param1.name)
         {
            _loc2_ = String(param1.name);
            if(_loc2_.indexOf("privateHomeFloors") > -1 || _loc2_.indexOf("privateHomeRoofs") > -1)
            {
               return true;
            }
         }
         return false;
      }
      
      private function isOnRoom(param1:SceneObject) : Boolean
      {
         return param1 is RoomSceneObject;
      }
      
      override public function dispose() : void
      {
         var _loc1_:int = 0;
         var _loc2_:RecycleWidget = null;
         var _loc3_:int = 0;
         var _loc4_:RecycleWidget = null;
         if(this.tabs)
         {
            _loc1_ = 0;
            while(_loc1_ < this.widgets.length)
            {
               if(this.tabs["tab" + (_loc1_ + 1).toString()])
               {
                  this.tabs["tab" + (_loc1_ + 1).toString()].removeEventListener(MouseEvent.CLICK,this.clickOnTab);
               }
               _loc1_++;
            }
         }
         if(this.widgets)
         {
            for each(_loc2_ in this.widgets)
            {
               _loc2_.removeEventListener(ItemRendererEvent.ITEM_SELECTED,this.onItemSelected);
               _loc2_.removeEventListener(ItemRendererEvent.ITEM_DESELECTED,this.onItemDeselected);
            }
            _loc3_ = 0;
            while(_loc3_ < this.widgets.length)
            {
               if(_loc4_ = this.widgets[_loc3_])
               {
                  _loc4_.dispose();
               }
               _loc3_++;
            }
         }
         this.widgets = null;
         this.wraps = null;
         this.selectedItems = null;
         if(this.recycleBtn)
         {
            this.recycleBtn.removeEventListener(MouseEvent.CLICK,this.onClickRecycle);
         }
         super.dispose();
      }
      
      private function itemHasAttr(param1:Object, param2:Array) : Boolean
      {
         var _loc3_:int = 0;
         while(_loc3_ < param2.length)
         {
            if(param1[param2[_loc3_]])
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      private function shouldAppear(param1:Object) : Boolean
      {
         if(!param1.name)
         {
            return false;
         }
         if(param1.name == "")
         {
            return false;
         }
         if(param1 is OwnedNpcRoomSceneObject)
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
         if(param1.name.substr(0,6) == "granja")
         {
            return false;
         }
         if(param1.name == "navidad2015.SantaPrueba")
         {
            return false;
         }
         if(param1.name.indexOf("serenito.trajePixelado") > -1)
         {
            return false;
         }
         if(this.room.id == this.room.getRoomId(11) && param1.name.substr(0,17) == "privateHomeFloors")
         {
            return false;
         }
         if(this.room.id == this.room.getRoomId(11) && param1.name.substr(0,16) == "privateHomeWalls")
         {
            return false;
         }
         if(this.room.id != this.room.getRoomId(11) && param1.name.substr(0,16) == "privateHomeRoofs")
         {
            return false;
         }
         if(this.room.id != this.room.getRoomId(11) && param1.name.substr(0,15) == "privateHomeSkys")
         {
            return false;
         }
         return true;
      }
      
      private function initTabs(param1:MovieClip) : void
      {
         var _loc3_:MovieClip = null;
         var _loc5_:MovieClip = null;
         this.tabs = param1;
         var _loc2_:int = 0;
         while(_loc2_ < this.widgets.length)
         {
            this.tabs.getChildByName("tab" + (_loc2_ + 1).toString()).addEventListener(MouseEvent.CLICK,this.clickOnTab);
            _loc2_++;
         }
         while(this.tabs.getChildByName("tab" + (++_loc2_).toString()) != null)
         {
            (_loc5_ = MovieClip(this.tabs.getChildByName("tab" + _loc2_.toString()))).visible = false;
         }
         var _loc4_:int = 1;
         while(_loc4_ <= this.widgets.length)
         {
            _loc3_ = MovieClip(MovieClip(this.tabs.getChildByName("tab" + _loc4_)).getChildByName("image"));
            _loc3_.gotoAndStop(_loc4_);
            _loc3_.mouseChildren = false;
            _loc3_.mouseEnabled = false;
            _loc4_++;
         }
         this.selectTab(1);
      }
      
      private function onPageChanged(param1:Event) : void
      {
         trace("RecycleCanvas > onPageChanged > e: " + param1);
      }
      
      private function changeButtonState(param1:Boolean) : void
      {
         this.recycleBtn.mouseEnabled = param1;
         var _loc2_:String = param1 ? "enable" : "disable";
         this.recycleBtn.gotoAndStop(_loc2_);
      }
      
      private function onItemSelected(param1:ItemRendererEvent) : void
      {
         var _loc2_:InventoryWidgetItemRenderer = param1.target as InventoryWidgetItemRenderer;
         if(_loc2_)
         {
            if(!this.selectedItems[_loc2_.cell.item.name])
            {
               this.selectedItems[_loc2_.cell.item.name] = _loc2_.cell.item.name;
               ++this.selectedItemCount;
               this.countTF.text = String(this.selectedItemCount);
               if(this.selectedItemCount >= this.minRequirement)
               {
                  this.changeTextColor(true);
                  this.changeButtonState(true);
               }
            }
            else
            {
               _loc2_.select();
            }
         }
      }
      
      private function onItemDeselected(param1:ItemRendererEvent) : void
      {
         var _loc2_:InventoryWidgetItemRenderer = param1.target as InventoryWidgetItemRenderer;
         if(_loc2_)
         {
            delete this.selectedItems[_loc2_.cell.item.name];
            --this.selectedItemCount;
            this.countTF.text = String(this.selectedItemCount);
            if(this.selectedItemCount < this.minRequirement)
            {
               this.changeTextColor(false);
               this.changeButtonState(false);
            }
         }
      }
      
      public function get tabNumber() : int
      {
         return !!this.widgets ? int(this.widgets.length) : 0;
      }
      
      private function addToList(param1:Array, param2:Object) : void
      {
         var _loc5_:GaturroInventorySceneObject = null;
         var _loc3_:Array = param2 as Array;
         var _loc4_:GaturroInventorySceneObject;
         if((Boolean(_loc4_ = _loc3_[0] as GaturroInventorySceneObject)) && OwnedNpcFactory.isOwnedNpcItem(_loc4_))
         {
            for each(_loc5_ in _loc3_)
            {
               param1.push([_loc5_]);
            }
         }
         else
         {
            param1.push(param2);
         }
      }
      
      override protected function setupShowView() : void
      {
         this.wraps = new Array();
         this.holder = view.getChildByName("tabs") as MovieClip;
         this.setupContentHolder(this.holder);
         this.countTF = view.getChildByName("countTF") as TextField;
         this.setupButton();
         var _loc1_:int = 0;
         while(_loc1_ < this.widgets.length)
         {
            this.wraps.push(this.widgets[_loc1_]);
            this.init(this.widgets[_loc1_],this.contentHolder);
            _loc1_++;
         }
         this.initTabs(this.holder);
      }
      
      private function onClickRecycle(param1:MouseEvent) : void
      {
         this.recycle();
         RecycleBanner(owner).reward(this.selectedItemCount);
      }
      
      private function changeTextColor(param1:Boolean) : void
      {
         this.countTF.textColor = param1 ? 3381504 : 16711680;
      }
      
      private function getCategory(param1:Object) : int
      {
         var _loc2_:Object = param1[0]["attributes"];
         var _loc3_:int = -1;
         if(this.itemHasAttr(_loc2_,["wear_neck","wear_accesories","wear_mouths"]))
         {
            _loc3_ = this.CATEGORY_ACCESORIOS;
         }
         if(this.itemHasAttr(_loc2_,["wear_head","wear_hairs","wear_hats"]))
         {
            _loc3_ = this.CATEGORY_HEAD;
         }
         if(_loc2_["vehicle"])
         {
            _loc3_ = this.CATEGORY_TRANSPORTES;
         }
         if(_loc2_["wear_foot"])
         {
            _loc3_ = this.CATEGORY_ZAPATOS;
         }
         if(this.itemHasAttr(_loc2_,["wear_leg","wear_arm","wear_armFore","wear_armBack","wear_gloveFore","wear_gloveBack","wear_gripFore","wear_gripBack","wear_cloth"]))
         {
            _loc3_ = this.CATEGORY_CUERPO;
         }
         if(this.isWall(param1[0]) || this.isFloor(param1[0]))
         {
            _loc3_ = this.CATEGORY_WALL_FLOOR;
         }
         if(_loc3_ == -1)
         {
            _loc3_ = this.CATEGORY_OBJECTS;
         }
         return _loc3_;
      }
      
      private function updateItems(param1:Event = null) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         for each(_loc2_ in this.widgets)
         {
            RecycleWidget(_loc2_).elements = new Array();
         }
         _loc3_ = new Array();
         _loc4_ = 0;
         while(_loc4_ < this.widgets.length)
         {
            _loc3_.push(new Array());
            _loc4_++;
         }
         for each(_loc5_ in this.items)
         {
            if((_loc7_ = this.getCategory(_loc5_)) != -1)
            {
               this.addToList(_loc3_[_loc7_] as Array,_loc5_);
            }
         }
         _loc6_ = 0;
         while(_loc6_ < _loc3_.length)
         {
            RecycleWidget(this.widgets[_loc6_]).elements = _loc3_[_loc6_];
            _loc6_++;
         }
      }
      
      public function selectTab(param1:int) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.widgets.length)
         {
            MovieClip(this.tabs.getChildByName("tab" + (_loc2_ + 1).toString())).gotoAndStop(this.UNSELECTED);
            _loc2_++;
         }
         MovieClip(this.tabs.getChildByName("tab" + param1.toString())).gotoAndStop(this.SELECTED);
         var _loc3_:int = 0;
         while(_loc3_ < this.widgets.length)
         {
            this.widgets[_loc3_].visible = false;
            _loc3_++;
         }
         var _loc4_:int = param1 - 1;
         this.widgets[_loc4_].visible = true;
      }
      
      override public function show(param1:Object = null) : void
      {
         this.items = param1 as Array;
         super.show(param1);
         this.updateItems();
      }
   }
}

import com.qb9.gaturro.view.components.repeater.item.AbstractItemRenderer;
import com.qb9.gaturro.view.gui.base.inventory.repeater.inventory.InventoryWidgetItemRendererFactory;

class RecycleWidgetItemRendererFactory extends InventoryWidgetItemRendererFactory
{
    
   
   public function RecycleWidgetItemRendererFactory()
   {
      super();
   }
   
   override public function buildItemRenderer(param1:Object) : AbstractItemRenderer
   {
      var _loc2_:RecycleWidgetItemRenderer = new RecycleWidgetItemRenderer();
      _loc2_.data = param1;
      return _loc2_;
   }
}

import com.qb9.gaturro.view.gui.base.inventory.repeater.inventory.InventoryWidgetItemRenderer;

class RecycleWidgetItemRenderer extends InventoryWidgetItemRenderer
{
    
   
   public function RecycleWidgetItemRenderer()
   {
      super();
   }
}

import com.qb9.gaturro.commons.event.ItemRendererEvent;
import com.qb9.gaturro.commons.event.RepeaterEvent;
import com.qb9.gaturro.commons.paginator.PaginatorFactory;
import com.qb9.gaturro.view.components.repeater.Repeater;
import com.qb9.gaturro.view.components.repeater.config.NavegableRepeaterConfig;
import com.qb9.gaturro.view.gui.base.inventory.InventoryWidget;
import com.qb9.gaturro.view.gui.base.inventory.InventoryWidgetEvent;
import com.qb9.gaturro.view.gui.base.inventory.repeater.inventory.InventoryWidgetItemRenderer;
import com.qb9.gaturro.view.gui.base.inventory.repeater.inventory.InventoryWidgetItemRendererFactory;
import flash.utils.Dictionary;

class RecycleWidget extends InventoryWidget
{
    
   
   private var items:Array;
   
   private var selectedItems:Dictionary;
   
   public function RecycleWidget(param1:uint, param2:uint, param3:Boolean, param4:Function = null, param5:Object = null, param6:String = null)
   {
      super(param1,param2,param3,param4,param5,param6);
      this.selectedItems = new Dictionary();
   }
   
   private function removeSelected(param1:InventoryWidgetItemRenderer) : void
   {
      var _loc2_:Dictionary = this.selectedItems[repeater.paginator.currentPage];
      delete _loc2_[param1.itemId];
   }
   
   override public function dispose() : void
   {
      if(repeater)
      {
         repeater.repeater.removeEventListener(RepeaterEvent.CREATION_COMPLETE,this.onCreationComplete);
      }
      this.selectedItems = null;
      super.dispose();
   }
   
   override protected function setupRepeater() : void
   {
      super.setupRepeater();
      repeater.repeater.addEventListener(RepeaterEvent.CREATION_COMPLETE,this.onCreationComplete);
   }
   
   override protected function onItemSelected(param1:ItemRendererEvent) : void
   {
      var _loc2_:InventoryWidgetItemRenderer = param1.itemRenderer as InventoryWidgetItemRenderer;
      if(_loc2_)
      {
         this.addSelectedItem(_loc2_);
      }
      dispatchEvent(new InventoryWidgetEvent(InventoryWidgetEvent.SELECTED,InventoryWidgetItemRenderer(param1.itemRenderer).cell));
   }
   
   override protected function onItemDeselected(param1:ItemRendererEvent) : void
   {
      var _loc2_:InventoryWidgetItemRenderer = param1.itemRenderer as InventoryWidgetItemRenderer;
      if(_loc2_)
      {
         this.removeSelected(_loc2_);
      }
      dispatchEvent(new InventoryWidgetEvent(InventoryWidgetEvent.UNSELECTED,InventoryWidgetItemRenderer(param1.itemRenderer).cell));
   }
   
   override protected function getRepeaterConfig() : NavegableRepeaterConfig
   {
      var _loc1_:NavegableRepeaterConfig = new NavegableRepeaterConfig(PaginatorFactory.SIMPLE_TYPE,getItems(),this,null,20);
      _loc1_.itemRendererFactory = new InventoryWidgetItemRendererFactory();
      _loc1_.columns = 10;
      _loc1_.selectable = Repeater.MULTI_SELECTABLE;
      return _loc1_;
   }
   
   override protected function drawBackground() : void
   {
   }
   
   override protected function outerMarginX() : int
   {
      return 0;
   }
   
   private function onCreationComplete(param1:RepeaterEvent) : void
   {
      var _loc3_:int = 0;
      var _loc2_:Dictionary = this.selectedItems[repeater.paginator.currentPage];
      for each(_loc3_ in _loc2_)
      {
         repeater.repeater.addSelectedIndex(_loc3_);
      }
   }
   
   private function addSelectedItem(param1:InventoryWidgetItemRenderer) : void
   {
      var _loc2_:Dictionary = null;
      if(!this.selectedItems[repeater.paginator.currentPage])
      {
         _loc2_ = new Dictionary();
         this.selectedItems[repeater.paginator.currentPage] = _loc2_;
      }
      else
      {
         _loc2_ = this.selectedItems[repeater.paginator.currentPage];
      }
      _loc2_[param1.itemId] = param1.itemId;
   }
}

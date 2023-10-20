package com.qb9.gaturro.view.components.banner.emoting
{
   import com.qb9.gaturro.commons.event.ItemRendererEvent;
   import com.qb9.gaturro.commons.event.PaginatorEvent;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.globals.user;
   import com.qb9.gaturro.user.inventory.ConsumableInventorySceneObject;
   import com.qb9.gaturro.user.inventory.GaturroInventorySceneObject;
   import com.qb9.gaturro.user.inventory.InventoryUtil;
   import com.qb9.gaturro.user.inventory.PetCareSceneObject;
   import com.qb9.gaturro.user.inventory.PetFoodSceneObject;
   import com.qb9.gaturro.user.inventory.PetInventorySceneObject;
   import com.qb9.gaturro.user.inventory.PetToySceneObject;
   import com.qb9.gaturro.view.components.canvas.FrameCanvas;
   import com.qb9.gaturro.view.components.repeater.Repeater;
   import com.qb9.gaturro.view.gui.base.inventory.repeater.inventory.InventoryWidgetItemRenderer;
   import com.qb9.gaturro.world.core.GaturroRoom;
   import com.qb9.gaturro.world.core.elements.OwnedNpcRoomSceneObject;
   import com.qb9.mambo.core.attributes.CustomAttributes;
   import com.qb9.mambo.user.inventory.InventorySceneObject;
   import com.qb9.mambo.world.avatars.UserAvatar;
   import com.qb9.mines.mobject.MobjectCreator;
   import flash.display.*;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class ActionConfigCanvas extends FrameCanvas
   {
      
      private static const COLS:uint = 10;
      
      private static const ROWS:uint = 2;
      
      public static const SLOTS_MAX:uint = 9;
      
      public static const ACTIONS:Array = [{
         "n":"amazed",
         "s":"acc1"
      },{
         "n":"celebrate",
         "s":"acc2"
      },{
         "n":"dance",
         "s":"acc3"
      },{
         "n":"greet",
         "s":"acc4"
      },{
         "n":"idea",
         "s":"acc5"
      },{
         "n":"joke",
         "s":"acc6"
      },{
         "n":"jump",
         "s":"acc7"
      },{
         "n":"laugh",
         "s":"acc8"
      },{
         "n":"love",
         "s":"acc9"
      },{
         "n":"sad",
         "s":"acc10"
      },{
         "n":"vertical",
         "s":"acc11"
      },{
         "n":"sit",
         "s":"acc12"
      },{
         "n":"dance2",
         "s":"acc13"
      },{
         "n":"dance3",
         "s":"acc14"
      },{
         "n":"dance4",
         "s":"acc15"
      },{
         "n":"dance5",
         "s":"acc16"
      },{
         "n":"wink",
         "s":"acc17"
      },{
         "n":"shy",
         "s":"acc18"
      },{
         "n":"blank",
         "s":"acc19"
      },{
         "n":"dormido2",
         "s":"acc20"
      }];
       
      
      private const CATEGORY_HEAD:int = 0;
      
      private var contentHolder:Sprite;
      
      private var actionsHolder:MovieClip;
      
      private const SELECTED:String = "selected";
      
      private const CATEGORY_ACTIONS:int = 100;
      
      private const CATEGORY_ZAPATOS:int = 3;
      
      private var actionsWidget:RecycleWidget;
      
      private const CATEGORY_ACCESORIOS:int = 2;
      
      private var holder:MovieClip;
      
      private var widgets:Array;
      
      private const CATEGORY_OBJECTS:int = 5;
      
      private const UNSELECTED:String = "unselected";
      
      private const CATEGORY_TRANSPORTES:int = 4;
      
      private var items:Array;
      
      private var needReload:Boolean = false;
      
      private const CATEGORY_CUERPO:int = 1;
      
      private var room:GaturroRoom;
      
      private var selectedActionWidget:InventoryWidgetItemRenderer;
      
      private const CATEGORY_PRE_SET_ACTIONS:int = 6;
      
      private var wraps:Array;
      
      private var tabs:MovieClip;
      
      public function ActionConfigCanvas(param1:String, param2:String, param3:DisplayObjectContainer, param4:ActionConfigurationBanner)
      {
         super(param1,param2,param3,param4);
         this.setup();
      }
      
      private function deselectAllItems() : void
      {
         var _loc1_:RecycleWidget = null;
         var _loc2_:InventoryWidgetItemRenderer = null;
         var _loc3_:Repeater = null;
         var _loc4_:int = 0;
         for each(_loc1_ in this.widgets)
         {
            _loc3_ = _loc1_.repeaterConfig.itemContainer.getChildAt(0) as Repeater;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.itemList.length)
            {
               _loc2_ = InventoryWidgetItemRenderer(_loc3_.itemList[_loc4_]);
               _loc2_.deselect();
               _loc4_++;
            }
         }
      }
      
      private function get userAvatar() : UserAvatar
      {
         return api.userAvatar;
      }
      
      private function initPreSetActions() : void
      {
         var _loc4_:CustomAttributes = null;
         var _loc5_:MobjectCreator = null;
         var _loc6_:GaturroInventorySceneObject = null;
         var _loc1_:RecycleWidget = new RecycleWidget(COLS,ROWS,false,{"cat":this.CATEGORY_PRE_SET_ACTIONS});
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < ACTIONS.length)
         {
            _loc4_ = new CustomAttributes();
            _loc5_ = new MobjectCreator();
            (_loc6_ = InventoryUtil.createInventoryObject(_loc4_)).buildFromMobject(_loc5_.convert({
               "name":"acciones.action_" + ACTIONS[_loc3_].n,
               "id":987 + _loc3_,
               "size":[1,1],
               "action":ACTIONS[_loc3_].n,
               "sound":"acc1"
            }));
            this.addToList(_loc2_,[_loc6_]);
            _loc3_++;
         }
         _loc1_.elements = _loc2_;
         _loc1_.addEventListener(ItemRendererEvent.ITEM_SELECTED,this.onItemSelected);
         _loc1_.addEventListener(ItemRendererEvent.ITEM_DESELECTED,this.onItemDeselected);
         this.widgets.push(_loc1_);
      }
      
      private function clickOnTab(param1:MouseEvent) : void
      {
         var _loc2_:String = DisplayObject(param1.currentTarget).name;
         var _loc3_:Array = _loc2_.split("tab");
         var _loc4_:int = int(_loc3_[1]);
         this.selectTab(_loc4_);
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
      
      override public function dispose() : void
      {
         var _loc1_:int = 0;
         var _loc2_:RecycleWidget = null;
         var _loc3_:int = 0;
         var _loc4_:RecycleWidget = null;
         this.saveUserCfg();
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
         if(this.needReload)
         {
            api.changeRoomXY(api.room.id,api.userAvatar.coord.x,api.userAvatar.coord.y);
         }
         super.dispose();
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
      
      private function onActionSelected(param1:ItemRendererEvent) : void
      {
         var _loc2_:InventoryWidgetItemRenderer = null;
         var _loc3_:Repeater = this.actionsWidget.repeaterConfig.itemContainer.getChildAt(0) as Repeater;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.itemList.length)
         {
            _loc2_ = InventoryWidgetItemRenderer(_loc3_.itemList[_loc4_]);
            _loc2_.deselect();
            _loc4_++;
         }
         _loc2_ = param1.target as InventoryWidgetItemRenderer;
         if(_loc2_)
         {
            this.selectedActionWidget = _loc2_;
            _loc2_.select();
            api.trackEvent("FEATURES:ACTION_CONFIG:SELECT_TOP",_loc2_.cell.item.name);
         }
      }
      
      private function readUserCfg() : void
      {
         var _loc3_:Object = null;
         var _loc4_:GaturroInventorySceneObject = null;
         var _loc5_:CustomAttributes = null;
         var _loc6_:MobjectCreator = null;
         var _loc7_:InventorySceneObject = null;
         this.actionsWidget = new RecycleWidget(COLS,1,false,{"cat":this.CATEGORY_ACTIONS});
         this.actionsWidget.wantSort = false;
         var _loc1_:Array = [];
         var _loc2_:int = 0;
         while(_loc2_ < SLOTS_MAX)
         {
            _loc3_ = api.getProfileAttribute("ActionBarCFG_SLOT_" + _loc2_.toString());
            _loc5_ = new CustomAttributes();
            _loc6_ = new MobjectCreator();
            if(Boolean(_loc3_) && (_loc3_ as String).indexOf("acciones") != -1)
            {
               (_loc4_ = InventoryUtil.createInventoryObject(_loc5_)).buildFromMobject(_loc6_.convert({
                  "name":_loc3_,
                  "id":100 + _loc2_,
                  "size":[1,1],
                  "action":"",
                  "sound":"acc1"
               }));
            }
            else if(_loc3_)
            {
               _loc4_ = (_loc7_ = user.bag.byId(Number(_loc3_)) || user.visualizer.byId(Number(_loc3_))) as GaturroInventorySceneObject;
            }
            if(_loc4_ == null)
            {
               (_loc4_ = InventoryUtil.createInventoryObject(_loc5_)).buildFromMobject(_loc6_.convert({
                  "name":"acciones.holder_" + _loc2_.toString(),
                  "id":100 + _loc2_,
                  "size":[1,1],
                  "action":"",
                  "sound":"acc1"
               }));
            }
            this.addToList(_loc1_,[_loc4_]);
            _loc2_++;
         }
         this.actionsWidget.elements = _loc1_;
         this.actionsWidget.addEventListener(ItemRendererEvent.ITEM_SELECTED,this.onActionSelected);
         this.actionsWidget.addEventListener(ItemRendererEvent.ITEM_DESELECTED,this.onActionDeselected);
         this.actionsHolder.addChild(this.actionsWidget);
      }
      
      private function addToList(param1:Array, param2:Object) : void
      {
         var _loc5_:GaturroInventorySceneObject = null;
         var _loc3_:Array = param2 as Array;
         var _loc4_:GaturroInventorySceneObject;
         if(_loc4_ = _loc3_[0] as GaturroInventorySceneObject)
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
      
      private function onItemSelected(param1:ItemRendererEvent) : void
      {
         var _loc2_:InventoryWidgetItemRenderer = param1.target as InventoryWidgetItemRenderer;
         if(_loc2_)
         {
            _loc2_.select();
            if(this.selectedActionWidget != null)
            {
               api.trackEvent("FEATURES:ACTION_CONFIG:SELECT_BOTTOM",_loc2_.cell.item.name);
               this.selectedActionWidget.cell.setItems([_loc2_.cell.item]);
               this.deselectAllItems();
            }
         }
      }
      
      private function onItemDeselected(param1:ItemRendererEvent) : void
      {
         var _loc2_:InventoryWidgetItemRenderer = param1.target as InventoryWidgetItemRenderer;
         if(_loc2_)
         {
            _loc2_.deselect();
         }
      }
      
      private function initActions() : void
      {
         var _loc3_:CustomAttributes = null;
         var _loc4_:MobjectCreator = null;
         var _loc5_:GaturroInventorySceneObject = null;
         this.actionsWidget = new RecycleWidget(COLS,1,false,{"cat":this.CATEGORY_ACTIONS});
         this.actionsWidget.wantSort = false;
         var _loc1_:Array = [];
         var _loc2_:int = 1;
         while(_loc2_ <= 9)
         {
            _loc3_ = new CustomAttributes();
            _loc4_ = new MobjectCreator();
            (_loc5_ = InventoryUtil.createInventoryObject(_loc3_)).buildFromMobject(_loc4_.convert({
               "name":"acciones.holder_" + _loc2_.toString(),
               "id":100 + _loc2_,
               "size":[1,1],
               "action":"",
               "sound":"acc1"
            }));
            this.addToList(_loc1_,[_loc5_]);
            _loc2_++;
         }
         this.actionsWidget.elements = _loc1_;
         this.actionsWidget.addEventListener(ItemRendererEvent.ITEM_SELECTED,this.onActionSelected);
         this.actionsWidget.addEventListener(ItemRendererEvent.ITEM_DESELECTED,this.onActionDeselected);
         this.actionsHolder.addChild(this.actionsWidget);
      }
      
      private function onPageChanged(param1:Event) : void
      {
         trace(this,"onPageChanged",param1);
      }
      
      public function get tabNumber() : int
      {
         return !!this.widgets ? int(this.widgets.length) : 0;
      }
      
      override protected function setupShowView() : void
      {
         this.items = ActionConfigurationBanner(owner).items;
         this.updateItems();
         this.initPreSetActions();
         this.wraps = new Array();
         this.holder = view.getChildByName("tabs") as MovieClip;
         this.contentHolder = this.holder.getChildByName("holder") as Sprite;
         this.actionsHolder = view.getChildByName("actions") as MovieClip;
         var _loc1_:int = 0;
         while(_loc1_ < this.widgets.length)
         {
            this.wraps.push(this.widgets[_loc1_]);
            this.contentHolder.addChild(this.widgets[_loc1_]);
            _loc1_++;
         }
         this.initTabs(this.holder);
         this.readUserCfg();
      }
      
      private function saveUserCfg() : void
      {
         var _loc3_:InventoryWidgetItemRenderer = null;
         var _loc6_:Object = null;
         var _loc4_:Repeater = this.actionsWidget.repeaterConfig.itemContainer.getChildAt(0) as Repeater;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_.itemList.length)
         {
            _loc3_ = InventoryWidgetItemRenderer(_loc4_.itemList[_loc5_]);
            _loc6_ = api.getProfileAttribute("ActionBarCFG_SLOT_" + _loc5_.toString());
            if(_loc3_.cell.item.id > 0)
            {
               user.profile.attributes["ActionBarCFG_SLOT_" + _loc5_] = _loc3_.cell.item.id.toString();
               if(_loc6_ != _loc3_.cell.item.id.toString())
               {
                  this.needReload = true;
               }
            }
            else
            {
               if(_loc6_ != _loc3_.cell.item.name)
               {
                  this.needReload = true;
               }
               user.profile.attributes["ActionBarCFG_SLOT_" + _loc5_] = _loc3_.cell.item.name;
            }
            _loc5_++;
         }
      }
      
      private function onActionDeselected(param1:ItemRendererEvent) : void
      {
         var _loc2_:InventoryWidgetItemRenderer = param1.target as InventoryWidgetItemRenderer;
         if(_loc2_)
         {
            this.selectedActionWidget = null;
            _loc2_.deselect();
         }
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
         if(param1[0] is ConsumableInventorySceneObject && this.shouldAppear(param1[0]))
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
            trace(_loc3_[_loc6_]);
            RecycleWidget(this.widgets[_loc6_]).elements = _loc3_[_loc6_];
            _loc6_++;
         }
      }
      
      public function selectTab(param1:int) : void
      {
         this.deselectAllItems();
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
         (view.getChildByName("categoryTitle") as TextField).text = param1.toString();
      }
      
      private function setup() : void
      {
         var _loc1_:RecycleWidget = null;
         this.room = api.room;
         this.widgets = [new RecycleWidget(COLS,ROWS,true,{"cat":this.CATEGORY_HEAD}),new RecycleWidget(COLS,ROWS,true,{"cat":this.CATEGORY_CUERPO}),new RecycleWidget(COLS,ROWS,true,{"cat":this.CATEGORY_ACCESORIOS}),new RecycleWidget(COLS,ROWS,true,{"cat":this.CATEGORY_ZAPATOS}),new RecycleWidget(COLS,ROWS,true,{"cat":this.CATEGORY_TRANSPORTES}),new RecycleWidget(COLS,ROWS,true,{"cat":this.CATEGORY_OBJECTS})];
         for each(_loc1_ in this.widgets)
         {
            _loc1_.addEventListener(ItemRendererEvent.ITEM_SELECTED,this.onItemSelected);
            _loc1_.addEventListener(ItemRendererEvent.ITEM_DESELECTED,this.onItemDeselected);
            _loc1_.addEventListener(PaginatorEvent.PAGE_CHANGED,this.onPageChanged,true);
         }
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
   
   public function RecycleWidget(param1:uint, param2:uint, param3:Boolean, param4:Object = null, param5:String = null)
   {
      super(param1,param2,param3,null,param4,param5);
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
   
   public function get repeaterConfig() : NavegableRepeaterConfig
   {
      return this.getRepeaterConfig();
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

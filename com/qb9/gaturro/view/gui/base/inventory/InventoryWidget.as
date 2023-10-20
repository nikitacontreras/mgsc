package com.qb9.gaturro.view.gui.base.inventory
{
   import assets.InventoryArrowsMC;
   import com.qb9.flashlib.interfaces.IDisposable;
   import com.qb9.gaturro.commons.event.ItemRendererEvent;
   import com.qb9.gaturro.commons.event.PaginatorEvent;
   import com.qb9.gaturro.commons.iterator.iterable.IIterable;
   import com.qb9.gaturro.commons.iterator.iterable.IterableFactory;
   import com.qb9.gaturro.commons.paginator.PaginatorFactory;
   import com.qb9.gaturro.globals.api;
   import com.qb9.gaturro.manager.paginator.GaturroPaginatorFactory;
   import com.qb9.gaturro.view.components.repeater.Repeater;
   import com.qb9.gaturro.view.components.repeater.RepeaterPaginatedFacade;
   import com.qb9.gaturro.view.components.repeater.config.NavegableRepeaterConfig;
   import com.qb9.gaturro.view.components.repeater.config.RepeaterConfig;
   import com.qb9.gaturro.view.components.repeater.item.AbstractItemRenderer;
   import com.qb9.gaturro.view.gui.base.inventory.repeater.inventory.InventoryWidgetItemRenderer;
   import com.qb9.gaturro.view.gui.base.inventory.repeater.inventory.InventoryWidgetItemRendererFactory;
   import com.qb9.gaturro.view.gui.base.inventory.repeater.navigation.ArrowInventoryPageItemRenderer;
   import com.qb9.gaturro.view.gui.base.inventory.repeater.navigation.InventoryPageItemRenderer;
   import com.qb9.gaturro.view.gui.base.inventory.repeater.navigation.InventoryPageItemRendererFactory;
   import com.qb9.gaturro.view.gui.base.inventory.repeater.navigation.InventoryPageMenuRepeaterFacade;
   import com.qb9.mambo.core.objects.SceneObject;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class InventoryWidget extends Sprite implements IDisposable
   {
      
      private static const BG_COLOR:uint = 14729487;
      
      private static const ARROWS_MARGIN:uint = 7;
       
      
      protected var repeater:RepeaterPaginatedFacade;
      
      private var arrows:InventoryArrowsMC;
      
      private var pageMenu:InventoryPageMenuRepeaterFacade;
      
      private var surfaceRef:Sprite;
      
      private var sortMethod:Function;
      
      private var showCounter:Boolean;
      
      private var items:Array;
      
      private var tName:String = "";
      
      public var wantSort:Boolean = true;
      
      private var cat:int = 0;
      
      private var rows:uint;
      
      private var cols:uint;
      
      private var selectedFilter:Function;
      
      public function InventoryWidget(param1:uint, param2:uint, param3:Boolean, param4:Function = null, param5:Object = null, param6:String = null)
      {
         this.sortMethod = this.sortByName;
         super();
         this.cols = param1;
         this.rows = param2;
         this.selectedFilter = param4;
         addEventListener(Event.ADDED_TO_STAGE,this.onAdded);
         if(param5)
         {
            this.cat = param5.cat;
            this.tName = param5.tabName;
         }
         this.init();
      }
      
      public function get category() : int
      {
         return this.cat;
      }
      
      public function get elements() : Array
      {
         var _loc2_:Array = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this.items)
         {
            if(_loc2_[0])
            {
               _loc1_.push(_loc2_[0]);
            }
         }
         return _loc1_;
      }
      
      final protected function getItems() : Array
      {
         return this.items;
      }
      
      protected function drawBackground() : void
      {
      }
      
      private function init() : void
      {
         this.drawBackground();
      }
      
      protected function setupRepeater() : void
      {
         var _loc1_:NavegableRepeaterConfig = this.getRepeaterConfig();
         this.repeater = new RepeaterPaginatedFacade(_loc1_);
         this.repeater.init();
         this.repeater.repeater.addEventListener(ItemRendererEvent.ITEM_SELECTED,this.onItemSelected);
         this.repeater.repeater.addEventListener(ItemRendererEvent.ITEM_DESELECTED,this.onItemDeselected);
      }
      
      private function createArrows() : void
      {
         this.arrows = new InventoryArrowsMC();
         addChild(this.arrows);
      }
      
      private function selectPage(param1:int) : void
      {
         var _loc2_:AbstractItemRenderer = null;
         for each(_loc2_ in this.pageMenu.repeater.itemList)
         {
            if(_loc2_.data == param1)
            {
               this.pageMenu.selectItem(_loc2_);
               return;
            }
         }
      }
      
      public function updateSelectedItem() : void
      {
         var _loc1_:InventoryWidgetItemRenderer = null;
         if(this.selectedFilter === null)
         {
            return;
         }
         for each(_loc1_ in this.repeater.repeater.itemList)
         {
            if(_loc1_.cell.item)
            {
               _loc1_.cell.selected = this.selectedFilter(_loc1_.cell.item);
            }
         }
      }
      
      private function displace() : void
      {
         var _loc1_:int = 0;
         if(this.pageMenu.paginator.itemsPerPage < this.pageMenu.paginator.itemsAmount)
         {
            if(this.pageMenu.repeater.selectedIndex[0] <= Math.ceil(this.pageMenu.paginator.itemsPerPage - 2) / 3)
            {
               _loc1_ = Math.floor(this.pageMenu.repeater.selectedIndex[0] - Math.ceil(this.pageMenu.paginator.itemsPerPage / 3));
               this.pageMenu.displaceElements(_loc1_);
            }
            else if(this.pageMenu.repeater.selectedIndex[0] > Math.ceil((this.pageMenu.paginator.itemsPerPage - 2) / 3 * 2))
            {
               _loc1_ = this.pageMenu.repeater.selectedIndex[0] - Math.ceil((this.pageMenu.paginator.itemsPerPage - 2) / 3 * 2);
               this.pageMenu.displaceElements(_loc1_);
            }
         }
      }
      
      private function onClickNavigationArrow(param1:PaginatorEvent) : void
      {
         this.displace();
         this.selectPage(param1.currentPage + 1);
      }
      
      private function onArrowClick(param1:Event) : void
      {
         var _loc2_:ArrowInventoryPageItemRenderer = param1.target as ArrowInventoryPageItemRenderer;
         if(_loc2_.data.toString() == "prev")
         {
            this.repeater.gotoPrevPage();
         }
         else if(_loc2_.data.toString() == "next")
         {
            this.repeater.gotoNextPage();
         }
         this.displace();
         this.selectPage(this.repeater.paginator.currentPage + 1);
         this.updateSelectedItem();
      }
      
      private function sortByName(param1:Array, param2:Array) : int
      {
         var _loc3_:SceneObject = param1[0];
         var _loc4_:SceneObject = param2[0];
         return _loc3_.name < _loc4_.name ? -1 : 1;
      }
      
      public function changeFilter(param1:Function) : void
      {
         this.sortMethod = param1;
         if(this.wantSort)
         {
            this.items.sort(this.sortMethod);
         }
         this.update();
      }
      
      private function onPageSelected(param1:ItemRendererEvent) : void
      {
         var _loc2_:int = 0;
         if(param1.itemRenderer is InventoryPageItemRenderer)
         {
            _loc2_ = int(param1.itemRenderer.data);
            this.changePage(_loc2_ - 1);
            this.displace();
            this.selectPage(_loc2_);
         }
         else
         {
            if(param1.itemRenderer.data.toString() == "prev")
            {
               this.repeater.gotoPrevPage();
            }
            else if(param1.itemRenderer.data.toString() == "next")
            {
               this.repeater.gotoNextPage();
            }
            this.displace();
            this.selectPage(this.repeater.paginator.currentPage + 1);
         }
         this.updateSelectedItem();
      }
      
      protected function onItemSelected(param1:ItemRendererEvent) : void
      {
         var _loc2_:InventoryWidgetItemRenderer = param1.itemRenderer as InventoryWidgetItemRenderer;
         var _loc3_:SceneObject = !!_loc2_.cell ? _loc2_.cell.item : null;
         if(!_loc3_)
         {
            return;
         }
         dispatchEvent(new InventoryWidgetEvent(InventoryWidgetEvent.SELECTED,InventoryWidgetItemRenderer(param1.itemRenderer).cell));
         this.updateSelectedItem();
      }
      
      public function get tabName() : String
      {
         return this.tName;
      }
      
      private function update() : void
      {
         this.repeater.chnageDataProveider(this.items);
         this.updatePageMenu();
         this.selectPage(int(this.pageMenu.repeater.selectedData[0]));
         this.updateSelectedItem();
      }
      
      protected function onItemDeselected(param1:ItemRendererEvent) : void
      {
         var _loc2_:InventoryWidgetItemRenderer = param1.itemRenderer as InventoryWidgetItemRenderer;
         var _loc3_:SceneObject = !!_loc2_.cell ? _loc2_.cell.item : null;
         if(!_loc3_)
         {
            return;
         }
         dispatchEvent(new InventoryWidgetEvent(InventoryWidgetEvent.UNSELECTED,InventoryWidgetItemRenderer(param1.itemRenderer).cell));
         this.updateSelectedItem();
      }
      
      public function dispose() : void
      {
         if(this.repeater)
         {
            if(this.repeater.repeater)
            {
               this.repeater.repeater.removeEventListener(ItemRendererEvent.ITEM_SELECTED,this.onItemSelected);
               this.repeater.repeater.removeEventListener(ItemRendererEvent.ITEM_DESELECTED,this.onItemDeselected);
            }
            this.repeater.dispose();
            this.repeater = null;
         }
         if(this.pageMenu)
         {
            if(this.pageMenu.repeater)
            {
               this.pageMenu.repeater.removeEventListener(ItemRendererEvent.ITEM_SELECTED,this.onPageSelected);
            }
            this.pageMenu.dispose();
            this.pageMenu = null;
         }
      }
      
      private function changePage(param1:int) : void
      {
         this.repeater.gotoPage(param1);
      }
      
      protected function getRepeaterConfig() : NavegableRepeaterConfig
      {
         var _loc1_:NavegableRepeaterConfig = new NavegableRepeaterConfig(PaginatorFactory.SIMPLE_TYPE,this.items,this,null,54);
         _loc1_.itemRendererFactory = new InventoryWidgetItemRendererFactory();
         _loc1_.columns = !!this.cols ? int(this.cols) : 6;
         _loc1_.selectable = Repeater.NOT_SELECTABLE;
         return _loc1_;
      }
      
      private function onAdded(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAdded);
         this.surfaceRef = parent.getChildByName("contentSurface") as Sprite;
         this.updatePageNavigationPosition();
      }
      
      private function setupPageNavigation() : void
      {
         api.roomView.unlockLoading();
         var _loc1_:RepeaterConfig = new RepeaterConfig(GaturroPaginatorFactory.INVENTORY_PAGE_MENU,this.getPageDataProvider(),this,10);
         _loc1_.rows = 1;
         _loc1_.itemRendererFactory = new InventoryPageItemRendererFactory();
         _loc1_.selectable = Repeater.SINGLE_SELECTABLE;
         this.pageMenu = new InventoryPageMenuRepeaterFacade(_loc1_);
         this.pageMenu.repeater.addEventListener(ItemRendererEvent.ITEM_SELECTED,this.onPageSelected);
         this.pageMenu.repeater.addEventListener(ArrowInventoryPageItemRenderer.ARROW_CLICK,this.onArrowClick);
      }
      
      public function set elements(param1:Array) : void
      {
         if(this.wantSort)
         {
            this.items = param1.sort(this.sortMethod);
         }
         else
         {
            this.items = param1;
         }
         if(!this.repeater)
         {
            this.setupRepeater();
            this.setupPageNavigation();
            this.updateSelectedItem();
         }
         else
         {
            this.update();
         }
      }
      
      private function getPageDataProvider() : IIterable
      {
         var _loc1_:Array = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < this.repeater.paginator.pagesAmount)
         {
            _loc1_.push(_loc2_ + 1);
            _loc2_++;
         }
         return IterableFactory.build(_loc1_);
      }
      
      protected function outerMarginY() : int
      {
         return 7;
      }
      
      private function updatePageNavigationPosition() : void
      {
         if(Boolean(stage) && Boolean(this.pageMenu))
         {
            this.pageMenu.repeater.x = (this.surfaceRef.width - this.pageMenu.repeater.width) / 2;
            this.pageMenu.repeater.y = this.surfaceRef.y + this.surfaceRef.height;
         }
      }
      
      protected function outerMarginX() : int
      {
         return 2;
      }
      
      private function updatePageMenu() : void
      {
         var _loc1_:IIterable = this.getPageDataProvider();
         this.pageMenu.changeDataProveider(_loc1_);
         this.updatePageNavigationPosition();
      }
   }
}

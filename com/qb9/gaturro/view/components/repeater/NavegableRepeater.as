package com.qb9.gaturro.view.components.repeater
{
   import com.qb9.gaturro.commons.event.PaginatorEvent;
   import com.qb9.gaturro.commons.event.RepeaterEvent;
   import com.qb9.gaturro.commons.iterator.iterable.IIterable;
   import com.qb9.gaturro.view.components.navigation.INavigationMenu;
   import com.qb9.gaturro.view.components.navigation.NavigationPaginatorMenu;
   import com.qb9.gaturro.view.components.repeater.config.NavegableRepeaterConfig;
   import com.qb9.gaturro.view.components.repeater.item.AbstractItemRenderer;
   import com.qb9.gaturro.view.components.repeater.item.IItemRendererFactory;
   import flash.display.DisplayObjectContainer;
   import flash.events.EventDispatcher;
   
   public class NavegableRepeater extends EventDispatcher implements IRepeater
   {
       
      
      private var _disposed:Boolean = false;
      
      private var _initialPage:int;
      
      private var _navigationMenu:INavigationMenu;
      
      private var config:NavegableRepeaterConfig;
      
      private var _repeaterFacade:com.qb9.gaturro.view.components.repeater.RepeaterPaginatedFacade;
      
      private var _menuContainer:DisplayObjectContainer;
      
      private var _itemRendererFactory:IItemRendererFactory;
      
      public function NavegableRepeater(param1:NavegableRepeaterConfig)
      {
         super();
         this.config = param1;
      }
      
      public function set itemRendererFactory(param1:IItemRendererFactory) : void
      {
         this._repeaterFacade.repeater.itemRendererFactory = param1;
      }
      
      public function build() : void
      {
         this._repeaterFacade.reset();
         this._navigationMenu.reset();
      }
      
      protected function getNavigationMenu() : INavigationMenu
      {
         if(!this._navigationMenu)
         {
            this._navigationMenu = new NavigationPaginatorMenu();
         }
         return this._navigationMenu;
      }
      
      public function changeDataProvider(param1:Object) : void
      {
         this._repeaterFacade.chnageDataProveider(param1);
         this._navigationMenu.reset();
      }
      
      public function addSelectedItem(param1:AbstractItemRenderer) : void
      {
         this._repeaterFacade.repeater.addSelectedItem(param1);
      }
      
      public function init() : void
      {
         trace("NavegableRepeater > init > setupNavigation = [" + this.setupNavigation + "]");
         this.setupFacade();
         this.setupNavigation();
      }
      
      public function gotoPage(param1:int) : void
      {
         this._repeaterFacade.gotoPage(param1);
      }
      
      public function get selectedIndex() : Array
      {
         return this._repeaterFacade.repeater.selectedIndex;
      }
      
      public function get disposed() : Boolean
      {
         return this._disposed;
      }
      
      public function dispose() : void
      {
         this._repeaterFacade.repeater.removeEventListener(RepeaterEvent.CREATION_COMPLETE,this.onCompleteRepeater);
         this._repeaterFacade.removeEventListener(PaginatorEvent.PAGE_CHANGED,this.onPageChanged);
         this._repeaterFacade.dispose();
         if(this._navigationMenu)
         {
            this._navigationMenu.dispose();
         }
         this._disposed = true;
      }
      
      public function get currentPage() : int
      {
         return this._repeaterFacade.paginator.currentPage;
      }
      
      public function set navigationMenu(param1:INavigationMenu) : void
      {
         this._navigationMenu = param1;
      }
      
      public function set columns(param1:int) : void
      {
         this._repeaterFacade.repeater.columns = param1;
      }
      
      public function get dataProvider() : IIterable
      {
         return this._repeaterFacade.paginator.dataProvider;
      }
      
      public function set rows(param1:int) : void
      {
         this._repeaterFacade.repeater.rows = param1;
      }
      
      public function set menuContainer(param1:DisplayObjectContainer) : void
      {
         this._menuContainer = param1;
      }
      
      public function get pageAmount() : int
      {
         return this._repeaterFacade.paginator.pagesAmount;
      }
      
      public function set dataSource(param1:Object) : void
      {
         this._repeaterFacade.chnageDataProveider(param1);
      }
      
      protected function onPageChanged(param1:PaginatorEvent) : void
      {
         dispatchEvent(param1);
      }
      
      public function get selectedItem() : Array
      {
         return this._repeaterFacade.repeater.selectedItem;
      }
      
      public function get itemList() : Array
      {
         return this._repeaterFacade.repeater.itemList;
      }
      
      public function set layout(param1:int) : void
      {
         this._repeaterFacade.repeater.layout = param1;
      }
      
      public function addSelectedIndex(param1:int) : void
      {
         this._repeaterFacade.repeater.addSelectedIndex(param1);
      }
      
      public function get repeaterFacade() : com.qb9.gaturro.view.components.repeater.RepeaterPaginatedFacade
      {
         return this._repeaterFacade;
      }
      
      public function set itemsPerPage(param1:uint) : void
      {
         this._repeaterFacade.paginator.itemsPerPage = param1;
      }
      
      private function onCompleteRepeater(param1:RepeaterEvent) : void
      {
         dispatchEvent(param1.clone());
      }
      
      public function refresh() : void
      {
         this._repeaterFacade.refresh();
      }
      
      public function get dataSource() : Object
      {
         return this.config.dataSource;
      }
      
      public function set initialPage(param1:int) : void
      {
         this.config.initialPage = param1;
      }
      
      public function get selectedData() : Array
      {
         return this._repeaterFacade.repeater.selectedData;
      }
      
      protected function setupNavigation() : void
      {
         if(this.config.menuContainer)
         {
            this.getNavigationMenu().setup(this.config.menuContainer,this._repeaterFacade);
         }
         else
         {
            trace("The asset hasn\'t a navigationMenu instance");
         }
      }
      
      public function get initialPage() : int
      {
         return this.config.initialPage;
      }
      
      public function get itemsPerPage() : uint
      {
         return this._repeaterFacade.paginator.itemsPerPage;
      }
      
      public function set dataProvider(param1:IIterable) : void
      {
         this._repeaterFacade.paginator.dataProvider = param1;
         this._repeaterFacade.reset();
      }
      
      protected function setupFacade() : void
      {
         this._repeaterFacade = new com.qb9.gaturro.view.components.repeater.RepeaterPaginatedFacade(this.config);
         this._repeaterFacade.addEventListener(PaginatorEvent.PAGE_CHANGED,this.onPageChanged);
         this._repeaterFacade.repeater.addEventListener(RepeaterEvent.CREATION_COMPLETE,this.onCompleteRepeater);
      }
   }
}

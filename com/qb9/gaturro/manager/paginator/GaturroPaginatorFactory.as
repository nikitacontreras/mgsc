package com.qb9.gaturro.manager.paginator
{
   import com.qb9.gaturro.commons.paginator.PaginatorFactory;
   import com.qb9.gaturro.view.gui.base.inventory.repeater.navigation.InventoryPageMenuPaginator;
   
   public class GaturroPaginatorFactory extends PaginatorFactory
   {
      
      public static const INVENTORY_PAGE_MENU:String = "inventoryPageMenu";
       
      
      public function GaturroPaginatorFactory()
      {
         super();
      }
      
      override protected function setup() : void
      {
         super.setup();
         paginatorClassMap[INVENTORY_PAGE_MENU] = InventoryPageMenuPaginator;
      }
   }
}

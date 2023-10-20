package com.qb9.gaturro.view.gui.base.itemList
{
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.gaturro.user.inventory.GaturroInventorySceneObject;
   import com.qb9.gaturro.user.inventory.InventoryUtil;
   import com.qb9.gaturro.view.gui.base.itemList.items.BaseItemListItemView;
   import com.qb9.mambo.net.manager.NetworkManager;
   
   public class BaseInventoryItemListGuiModal extends BaseItemListGuiModal
   {
       
      
      public function BaseInventoryItemListGuiModal(param1:Array, param2:TaskContainer, param3:NetworkManager)
      {
         super(param2,param3);
         this.items = InventoryUtil.removeQuestItems(param1);
      }
      
      override protected function createItemView(param1:Object) : BaseItemListItemView
      {
         return new BaseItemListItemView(param1);
      }
      
      override protected function createItem(param1:int) : BaseItemListItemView
      {
         var _loc2_:GaturroInventorySceneObject = items[param1][0] as GaturroInventorySceneObject;
         return this.createItemView(_loc2_);
      }
   }
}

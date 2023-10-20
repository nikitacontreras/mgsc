package com.qb9.gaturro.view.gui.sell
{
   import com.qb9.flashlib.tasks.TaskContainer;
   import com.qb9.flashlib.utils.ArrayUtil;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.globals.tracker;
   import com.qb9.gaturro.net.metrics.Telemetry;
   import com.qb9.gaturro.net.metrics.TrackActions;
   import com.qb9.gaturro.net.metrics.TrackCategories;
   import com.qb9.gaturro.user.inventory.GaturroInventorySceneObject;
   import com.qb9.gaturro.user.inventory.InventoryUtil;
   import com.qb9.gaturro.view.gui.base.itemList.BaseInventoryItemListGuiModal;
   import com.qb9.gaturro.view.gui.base.itemList.BaseItemListGuiModalConfirmation;
   import com.qb9.gaturro.view.gui.base.itemList.items.BaseItemListItemView;
   import com.qb9.mambo.net.manager.NetworkManager;
   
   public final class SellItemGuiModal extends BaseInventoryItemListGuiModal
   {
       
      
      public function SellItemGuiModal(param1:Array, param2:TaskContainer, param3:NetworkManager)
      {
         super(param1,param2,param3);
         this.exclude();
         init();
      }
      
      override protected function createConfirmation() : BaseItemListGuiModalConfirmation
      {
         return new SellItemGuiModalConfirmation();
      }
      
      override protected function createItemView(param1:Object) : BaseItemListItemView
      {
         return new SellItemGuiModalItemView(param1);
      }
      
      override protected function action(param1:BaseItemListItemView) : void
      {
         var _loc2_:GaturroInventorySceneObject = param1.item;
         InventoryUtil.sellObject(_loc2_.id.toString(),_loc2_.resellPrice);
         tracker.event(TrackCategories.MARKET,TrackActions.SELLS,_loc2_.name,_loc2_.resellPrice);
         var _loc3_:Array = _loc2_.name.split(".");
         var _loc4_:String = (_loc4_ = (_loc4_ = TrackActions.SELLS) + (_loc3_[0] != null ? ":" + _loc3_[0] : TrackActions.NO_PACK)) + (_loc3_[1] != null ? ":" + _loc3_[1] : TrackActions.NO_NAME);
         Telemetry.getInstance().trackEvent(TrackCategories.MARKET,_loc4_,"",_loc2_.resellPrice);
         close();
      }
      
      private function exclude() : void
      {
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         var _loc1_:Array = settings.items.sell.excludeList;
         for each(_loc2_ in this.items.slice())
         {
            _loc3_ = _loc2_[0];
            if(_loc3_ && _loc3_.attributes && Boolean(_loc3_.attributes.session))
            {
               ArrayUtil.removeElement(this.items,_loc2_);
            }
            else if(ArrayUtil.contains(_loc1_,_loc3_.name))
            {
               ArrayUtil.removeElement(this.items,_loc2_);
            }
         }
      }
      
      override public function dispose() : void
      {
         net = null;
         super.dispose();
      }
   }
}

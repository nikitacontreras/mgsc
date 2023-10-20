package com.qb9.gaturro.view.gui.closet
{
   import com.qb9.flashlib.events.QEvent;
   import com.qb9.flashlib.utils.ArrayUtil;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.user.inventory.GaturroInventorySceneObject;
   import com.qb9.gaturro.view.gui.base.inventory.InventoryWidgetEvent;
   import com.qb9.gaturro.world.core.GaturroRoom;
   
   public class ExchangeClosetGuiModal extends ClosetGuiModal
   {
      
      public static const SELECT_ITEM:String = "SELECT_ITEM";
       
      
      public function ExchangeClosetGuiModal(param1:GaturroRoom)
      {
         super(param1);
      }
      
      override protected function grabFromRoomEvent(param1:InventoryWidgetEvent) : void
      {
      }
      
      override protected function dropToRoomEvent(param1:InventoryWidgetEvent) : void
      {
         this.dispatchEvent(new QEvent(SELECT_ITEM,param1.item));
      }
      
      override protected function get allItems() : Array
      {
         var _loc4_:Array = null;
         var _loc5_:Boolean = false;
         var _loc6_:Object = null;
         var _loc1_:Array = settings.items.exchange.excludeList;
         var _loc2_:Array = inventoryItems.concat(roomItems);
         var _loc3_:Array = new Array();
         for each(_loc4_ in _loc2_)
         {
            _loc5_ = false;
            if((_loc6_ = _loc4_[0]) is GaturroInventorySceneObject && !ArrayUtil.contains(_loc1_,_loc6_.name))
            {
               _loc5_ = true;
            }
            if(Boolean(_loc6_.attributes) && Boolean(_loc6_.attributes.session))
            {
               _loc5_ = false;
            }
            if(_loc5_)
            {
               _loc3_.push([_loc6_]);
            }
         }
         return _loc3_;
      }
   }
}

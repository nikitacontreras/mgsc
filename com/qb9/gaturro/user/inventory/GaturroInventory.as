package com.qb9.gaturro.user.inventory
{
   import com.qb9.flashlib.utils.ArrayUtil;
   import com.qb9.gaturro.commons.context.Context;
   import com.qb9.gaturro.commons.event.ContextEvent;
   import com.qb9.gaturro.commons.manager.notificator.Notification;
   import com.qb9.gaturro.commons.manager.notificator.NotificationManager;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.notifier.GaturroNotificationType;
   import com.qb9.mambo.core.attributes.CustomAttributes;
   import com.qb9.mambo.geom.Coord;
   import com.qb9.mambo.net.manager.NetworkManager;
   import com.qb9.mambo.user.inventory.Inventory;
   import com.qb9.mambo.user.inventory.InventorySceneObject;
   import com.qb9.mines.mobject.Mobject;
   import config.ItemControl;
   
   public final class GaturroInventory extends Inventory
   {
      
      public static const HOUSE:String = "house";
      
      public static const BAG:String = Inventory.DEFAULT;
      
      public static const VISUALIZER:String = "visualizer";
       
      
      private var notificationManager:NotificationManager;
      
      public function GaturroInventory(param1:NetworkManager, param2:Number = Infinity)
      {
         super(param1,param2);
         this.setupNotificationManager();
      }
      
      public static function isPocketExclusive(param1:String) : Boolean
      {
         if(param1.substr(0,6) == "pocket")
         {
            return true;
         }
         if(param1.substr(0,14) == "gatoonsClothes" && param1.indexOf("_npc") >= 1)
         {
            return true;
         }
         if(param1.indexOf("_catalog") >= 1)
         {
            return true;
         }
         return false;
      }
      
      private static function get data() : Object
      {
         return settings.inventory;
      }
      
      private function onAddedNotificationManager(param1:ContextEvent) : void
      {
         if(param1.instanceType == NotificationManager)
         {
            Context.instance.removeEventListener(ContextEvent.ADDED,this.onAddedNotificationManager);
            this.notificationManager = Context.instance.getByType(NotificationManager) as NotificationManager;
         }
      }
      
      private function setupNotificationManager() : void
      {
         if(Context.instance.hasByType(NotificationManager))
         {
            this.notificationManager = Context.instance.getByType(NotificationManager) as NotificationManager;
         }
         else
         {
            Context.instance.addEventListener(ContextEvent.ADDED,this.onAddedNotificationManager);
         }
      }
      
      override public function remove(param1:Number) : void
      {
         var _loc3_:String = null;
         var _loc2_:InventorySceneObject = byId(param1);
         if(!_loc2_ || !_loc2_.attributes.session)
         {
            _loc3_ = InventoryUtil.compressItemId(_loc2_.id.toString());
            super.remove(Number(_loc3_));
         }
         else
         {
            ArrayUtil.removeElement(_items,_loc2_);
            notifyRemoved(_loc2_);
         }
      }
      
      public function get itemsStacked() : Array
      {
         var _loc3_:Array = null;
         var _loc4_:uint = 0;
         var _loc1_:Array = itemsGrouped;
         if(!data.stack)
         {
            return _loc1_;
         }
         var _loc2_:uint = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = _loc1_[_loc2_] as Array;
            _loc4_ = uint(_loc3_[0].stackBy);
            if(_loc3_.length > _loc4_)
            {
               _loc1_[_loc2_] = _loc3_.slice(0,_loc4_);
               _loc1_.splice(_loc2_ + 1,0,_loc3_.slice(_loc4_));
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      override protected function createObject(param1:CustomAttributes, param2:Mobject) : InventorySceneObject
      {
         return InventoryUtil.createInventoryObject(param1);
      }
      
      public function hasByType(param1:String) : Boolean
      {
         var _loc2_:InventorySceneObject = null;
         for each(_loc2_ in _items)
         {
            if(_loc2_.name === param1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function hasRoomFor(param1:String) : Boolean
      {
         var _loc3_:Array = null;
         var _loc4_:GaturroInventorySceneObject = null;
         if(!data.limit)
         {
            return true;
         }
         var _loc2_:Array = this.itemsStacked;
         if(_loc2_.length < size)
         {
            return true;
         }
         for each(_loc3_ in _loc2_)
         {
            if((_loc4_ = _loc3_[0]).name === param1 && _loc4_.stackBy > _loc3_.length)
            {
               return true;
            }
         }
         return false;
      }
      
      override protected function createItemList(param1:Mobject) : Array
      {
         var _loc4_:Mobject = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:InventorySceneObject = null;
         var _loc2_:Array = new Array();
         var _loc3_:Array = param1.getMobjectArray("sceneObjects");
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = String(_loc4_.getString("name"));
            if(!isPocketExclusive(_loc5_))
            {
               _loc6_ = _loc4_.getString("id");
               if((_loc7_ = (_loc7_ = _loc4_.getInteger("qty")) < 0 ? 0 : _loc7_) > 1000)
               {
                  _loc7_ = 1000;
               }
               _loc8_ = 0;
               while(_loc8_ < _loc7_)
               {
                  _loc4_.setString("id",InventoryUtil.explodeItemId(_loc6_,_loc8_));
                  _loc9_ = makeObject(_loc4_);
                  _loc2_.push(_loc9_);
                  _loc8_++;
               }
            }
         }
         return _loc2_;
      }
      
      override public function drop(param1:Number, param2:Coord) : void
      {
         super.drop(param1,param2);
         var _loc3_:InventorySceneObject = byId(param1);
         this.notificationManager.brodcast(new com.qb9.gaturro.commons.manager.notificator.Notification(GaturroNotificationType.DROP_OBJECT,_loc3_.name));
      }
      
      override protected function createItemAdded(param1:Mobject) : InventorySceneObject
      {
         var _loc7_:InventorySceneObject = null;
         var _loc8_:InventorySceneObject = null;
         var _loc2_:Mobject = param1.getMobject("sceneObject");
         var _loc3_:String = _loc2_.getString("id");
         var _loc4_:String = _loc2_.getString("name");
         var _loc5_:Array = byType(_loc4_);
         var _loc6_:int = 0;
         for each(_loc7_ in _loc5_)
         {
            if(InventoryUtil.compressItemId(_loc7_.id.toString()) == _loc3_)
            {
               _loc6_++;
            }
         }
         _loc2_.setString("id",InventoryUtil.explodeItemId(_loc3_,_loc6_));
         return makeObject(param1.getMobject("sceneObject"));
      }
      
      public function getQuantityByType(param1:String) : int
      {
         var _loc3_:InventorySceneObject = null;
         var _loc2_:int = 0;
         for each(_loc3_ in _items)
         {
            if(_loc3_.name === param1)
            {
               _loc2_++;
            }
         }
         return _loc2_;
      }
      
      public function byCompressId(param1:Number) : Array
      {
         var _loc3_:InventorySceneObject = null;
         var _loc2_:Array = [];
         for each(_loc3_ in _items)
         {
            if(InventoryUtil.compressItemId(_loc3_.id.toString()) === param1.toString())
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public function sessionAdd(param1:InventorySceneObject) : void
      {
         _items.push(param1);
         notifyAdded(param1);
      }
      
      override protected function destroyItemRemoved(param1:Number) : void
      {
         var _loc2_:Array = this.byCompressId(param1);
         if(_loc2_.length == 0)
         {
            return;
         }
         param1 = InventorySceneObject(_loc2_[_loc2_.length - 1]).id;
         super.destroyItemRemoved(param1);
      }
      
      override public function buildFromMobject(param1:Mobject) : void
      {
         super.buildFromMobject(param1);
         ItemControl.filterInventoryReceived(_items);
      }
      
      public function byTypeFast(param1:String) : Array
      {
         var _loc4_:Object = null;
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < _items.length)
         {
            if((_loc4_ = _items[_loc3_]).name == param1)
            {
               _loc2_.push(_loc4_);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      override protected function sendDropRequest(param1:Number, param2:Coord) : void
      {
         param1 = Number(InventoryUtil.compressItemId(param1.toString()));
         super.sendDropRequest(param1,param2);
      }
   }
}

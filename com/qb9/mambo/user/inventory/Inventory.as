package com.qb9.mambo.user.inventory
{
   import com.qb9.flashlib.lang.map;
   import com.qb9.flashlib.utils.ArrayUtil;
   import com.qb9.flashlib.utils.ObjectUtil;
   import com.qb9.mambo.core.attributes.CustomAttributes;
   import com.qb9.mambo.core.objects.MamboObject;
   import com.qb9.mambo.geom.Coord;
   import com.qb9.mambo.net.manager.NetworkManager;
   import com.qb9.mambo.net.manager.NetworkManagerEvent;
   import com.qb9.mambo.net.mobject.MobjectBuildable;
   import com.qb9.mambo.net.requests.inventory.DestroyInventoryObjectActionRequest;
   import com.qb9.mambo.net.requests.inventory.DropObjectActionRequest;
   import com.qb9.mambo.net.requests.inventory.GrabObjectActionRequest;
   import com.qb9.mambo.net.requests.inventory.SwapToInventoryActionRequest;
   import com.qb9.mambo.user.inventory.events.InventoryEvent;
   import com.qb9.mines.mobject.Mobject;
   
   public class Inventory extends MamboObject implements MobjectBuildable
   {
      
      public static const DEFAULT:String = "default";
      
      private static const DUMP_VARS:Array = ["name","size","items"];
       
      
      protected var _items:Array;
      
      private var net:NetworkManager;
      
      private var _size:Number;
      
      private var _name:String;
      
      public function Inventory(param1:NetworkManager, param2:Number = Infinity)
      {
         super();
         this.net = param1;
         this._size = param2;
         this.initEvents();
      }
      
      public function remove(param1:Number) : void
      {
         this.assertHasItem(param1);
         debug("Removing Item, id =",param1);
         this.net.sendAction(new DestroyInventoryObjectActionRequest(param1));
      }
      
      private function ownMobject(param1:Mobject) : Boolean
      {
         return this.normalizeName(param1.getString("inventoryName")) === this.name;
      }
      
      public function get items() : Array
      {
         return this._items.concat();
      }
      
      private function assertItemNotFound(param1:Number) : void
      {
         if(this.byId(param1))
         {
            warning("SceneObject already in inventory:" + param1);
         }
      }
      
      private function initEvents() : void
      {
         this.net.addEventListener(NetworkManagerEvent.ADDED_TO_INVENTORY,this.itemAdded);
         this.net.addEventListener(NetworkManagerEvent.REMOVED_FROM_INVENTORY,this.itemRemoved);
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function grab(param1:Number) : void
      {
         this.assertItemNotFound(param1);
         debug("Grabbing Item, id =",param1,"to inventory",this.name);
         this.sendGrabRequest(param1);
      }
      
      private function itemRemoved(param1:NetworkManagerEvent) : void
      {
         var _loc2_:Mobject = param1.mobject;
         var _loc3_:Number = Number(_loc2_.getString("sceneObjectId"));
         this.destroyItemRemoved(_loc3_);
      }
      
      override public function dispatch(param1:String, param2:* = null) : Boolean
      {
         return dispatchEvent(new InventoryEvent(param1,param2));
      }
      
      override protected function get dumpVars() : Array
      {
         return DUMP_VARS;
      }
      
      public function get size() : Number
      {
         return this._size;
      }
      
      protected function createItemAdded(param1:Mobject) : InventorySceneObject
      {
         var _loc2_:InventorySceneObject = this.makeObject(param1.getMobject("sceneObject"));
         this.assertItemNotFound(_loc2_.id);
         return _loc2_;
      }
      
      public function byId(param1:Number) : InventorySceneObject
      {
         var _loc2_:InventorySceneObject = null;
         for each(_loc2_ in this._items)
         {
            if(_loc2_.id === param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      protected function notifyRemoved(param1:InventorySceneObject) : void
      {
         info("Item removed from",this.name,param1);
         this.dispatch(InventoryEvent.ITEM_REMOVED,param1);
      }
      
      protected function createObject(param1:CustomAttributes, param2:Mobject) : InventorySceneObject
      {
         return new InventorySceneObject(param1);
      }
      
      override public function dispose() : void
      {
         this.net.removeEventListener(NetworkManagerEvent.ADDED_TO_INVENTORY,this.itemAdded);
         this.net.removeEventListener(NetworkManagerEvent.REMOVED_FROM_INVENTORY,this.itemRemoved);
         super.dispose();
      }
      
      public function add(param1:Number) : void
      {
         this.assertItemNotFound(param1);
         debug("Adding Item, id =",param1,"from another inventory");
         this.net.sendAction(new SwapToInventoryActionRequest(param1,this.name));
      }
      
      protected function makeObject(param1:Mobject) : InventorySceneObject
      {
         var _loc2_:CustomAttributes = new CustomAttributes();
         _loc2_.buildFromMobject(param1);
         var _loc3_:InventorySceneObject = this.createObject(_loc2_,param1);
         _loc2_.assignTo(_loc3_);
         _loc3_.buildFromMobject(param1);
         return _loc3_;
      }
      
      private function assertHasItem(param1:Number) : void
      {
         if(!this.byId(param1))
         {
            warning("The following sceneObject was not found:",param1);
         }
      }
      
      public function hasAnyOf(param1:String) : Boolean
      {
         return this.byType(param1).length > 0;
      }
      
      public function buildFromMobject(param1:Mobject) : void
      {
         this._items = this.createItemList(param1);
         this._name = this.normalizeName(param1.getString("name"));
      }
      
      private function itemAdded(param1:NetworkManagerEvent) : void
      {
         var _loc2_:Mobject = param1.mobject;
         if(!this.ownMobject(_loc2_))
         {
            return;
         }
         var _loc3_:InventorySceneObject = this.createItemAdded(_loc2_);
         this._items.push(_loc3_);
         this.notifyAdded(_loc3_);
      }
      
      public function drop(param1:Number, param2:Coord) : void
      {
         this.assertHasItem(param1);
         debug("Dropping Item, id =",param1,"coord =",param2);
         this.sendDropRequest(param1,param2);
      }
      
      public function byType(param1:String) : Array
      {
         var _loc3_:InventorySceneObject = null;
         var _loc2_:Array = [];
         for each(_loc3_ in this._items)
         {
            if(_loc3_.name === param1)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      protected function destroyItemRemoved(param1:Number) : void
      {
         if(!this.byId(param1))
         {
            return;
         }
         var _loc2_:InventorySceneObject = this.byId(param1);
         ArrayUtil.removeElement(this._items,_loc2_);
         this.notifyRemoved(_loc2_);
      }
      
      protected function createItemList(param1:Mobject) : Array
      {
         return map(param1.getMobjectArray("sceneObjects"),this.makeObject);
      }
      
      protected function notifyAdded(param1:InventorySceneObject) : void
      {
         info("Item added to",this.name,param1);
         this.dispatch(InventoryEvent.ITEM_ADDED,param1);
      }
      
      protected function normalizeName(param1:String) : String
      {
         return param1 || DEFAULT;
      }
      
      protected function sendGrabRequest(param1:Number) : void
      {
         this.net.sendAction(new GrabObjectActionRequest(param1,this.name));
      }
      
      public function get itemsGrouped() : Array
      {
         var _loc2_:InventorySceneObject = null;
         var _loc1_:Object = {};
         for each(_loc2_ in this._items)
         {
            if(_loc2_.name in _loc1_)
            {
               _loc1_[_loc2_.name].push(_loc2_);
            }
            else
            {
               _loc1_[_loc2_.name] = [_loc2_];
            }
         }
         return ObjectUtil.values(_loc1_);
      }
      
      protected function sendDropRequest(param1:Number, param2:Coord) : void
      {
         this.net.sendAction(new DropObjectActionRequest(param1,param2));
      }
   }
}

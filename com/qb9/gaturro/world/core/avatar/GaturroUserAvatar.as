package com.qb9.gaturro.world.core.avatar
{
   import com.qb9.flashlib.utils.ArrayUtil;
   import com.qb9.flashlib.utils.ObjectUtil;
   import com.qb9.gaturro.globals.settings;
   import com.qb9.gaturro.globals.tracker;
   import com.qb9.gaturro.net.metrics.Telemetry;
   import com.qb9.gaturro.user.GaturroUser;
   import com.qb9.gaturro.user.inventory.GaturroInventory;
   import com.qb9.gaturro.user.inventory.WearableInventorySceneObject;
   import com.qb9.gaturro.world.core.avatar.ownednpc.OwnedNpcFactory;
   import com.qb9.mambo.core.attributes.CustomAttributes;
   import com.qb9.mambo.user.User;
   import com.qb9.mambo.user.inventory.InventorySceneObject;
   import com.qb9.mambo.user.inventory.events.InventoryEvent;
   import com.qb9.mambo.world.avatars.UserAvatar;
   import com.qb9.mambo.world.tiling.TileGrid;
   import com.qb9.mines.mobject.Mobject;
   import flash.utils.setTimeout;
   
   public final class GaturroUserAvatar extends UserAvatar
   {
      
      private static var reset:Boolean = true;
       
      
      protected var _houses:Array;
      
      public function GaturroUserAvatar(param1:CustomAttributes, param2:TileGrid, param3:User)
      {
         this._houses = new Array();
         super(param1,param2,param3);
         this.init();
      }
      
      private function cleanAttributes() : void
      {
         reset = false;
         this.emptyAttributes(settings.avatar.resettableAttributes);
      }
      
      private function get inventoryHouse() : GaturroInventory
      {
         return GaturroUser(user).house;
      }
      
      private function get visualizer() : GaturroInventory
      {
         return GaturroUser(user).visualizer;
      }
      
      private function isWearing(param1:WearableInventorySceneObject) : Boolean
      {
         var _loc3_:String = null;
         var _loc2_:Object = param1.providedAttributes;
         for(_loc3_ in _loc2_)
         {
            if(attributes[_loc3_] !== _loc2_[_loc3_])
            {
               return false;
            }
         }
         return true;
      }
      
      override public function get isCitizen() : Boolean
      {
         return true;
      }
      
      private function init() : void
      {
         if(reset)
         {
            setTimeout(this.cleanAttributes,10);
         }
         this.visualizer.addEventListener(InventoryEvent.ITEM_REMOVED,this.checkRemovedClothes);
         this.inventoryHouse.addEventListener(InventoryEvent.ITEM_REMOVED,this.checkRemovedClothes);
      }
      
      private function checkRemovedClothes(param1:InventoryEvent) : void
      {
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:String = null;
         var _loc2_:InventorySceneObject = param1.object;
         var _loc3_:WearableInventorySceneObject = _loc2_ as WearableInventorySceneObject;
         if(OwnedNpcFactory.isThisOwnedNpcActive(this,_loc2_))
         {
            OwnedNpcFactory.emptyOwnedNpc();
            return;
         }
         if(!_loc3_ || this.visualizer.hasAnyOf(_loc2_.name) || !this.isWearing(_loc3_))
         {
            return;
         }
         var _loc5_:Array = ObjectUtil.keys(_loc3_.providedAttributes);
         for each(_loc6_ in this.visualizer.itemsGrouped)
         {
            _loc3_ = _loc6_[0] as WearableInventorySceneObject;
            if(!(!_loc3_ || !this.isWearing(_loc3_)))
            {
               _loc7_ = ObjectUtil.keys(_loc3_.providedAttributes);
               for each(_loc8_ in _loc5_)
               {
                  if(ArrayUtil.contains(_loc7_,_loc8_))
                  {
                     _loc5_ = _loc5_.concat(_loc7_);
                     break;
                  }
               }
            }
         }
         this.emptyAttributes(_loc5_);
      }
      
      public function get houseRooms() : Array
      {
         return this._houses;
      }
      
      private function get gUser() : GaturroUser
      {
         return user as GaturroUser;
      }
      
      override public function buildFromMobject(param1:Mobject) : void
      {
         super.buildFromMobject(param1);
         var _loc2_:String = param1.getMobject("avatar").getString("houses");
         if(Boolean(_loc2_) && _loc2_ != "")
         {
            this.loadHouseRooms(_loc2_);
         }
         if(reset)
         {
            tracker.custom(1,"Gender",!!attributes.gender_male ? "male" : "female");
            tracker.custom(2,"Passport",this.isCitizen ? "active" : "expired");
            Telemetry.getInstance().setCustomDimension(Telemetry.CUSTOM_DIMENSION_GENDER,!!attributes.gender_male ? "male" : "female");
            Telemetry.getInstance().setCustomDimension(Telemetry.CUSTOM_DIMENSION_PASSPORT,this.isCitizen ? "active" : "expired");
         }
      }
      
      private function emptyAttributes(param1:Array) : void
      {
         var _loc3_:String = null;
         var _loc2_:Object = {};
         for each(_loc3_ in param1)
         {
            if(attributes[_loc3_])
            {
               _loc2_[_loc3_] = "";
            }
         }
         attributes.mergeObject(_loc2_);
      }
      
      private function loadHouseRooms(param1:String) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         for each(_loc4_ in param1.split(";"))
         {
            _loc2_ = int(_loc4_.split(",")[0]);
            _loc3_ = int(_loc4_.split(",")[1]);
            this._houses.push({
               "roomNum":_loc2_,
               "roomId":_loc3_
            });
         }
      }
      
      override public function dispose() : void
      {
         this.visualizer.removeEventListener(InventoryEvent.ITEM_REMOVED,this.checkRemovedClothes);
         this.inventoryHouse.removeEventListener(InventoryEvent.ITEM_REMOVED,this.checkRemovedClothes);
         super.dispose();
      }
   }
}
